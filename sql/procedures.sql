create or replace function normalize_text_array(values text[])
returns text[]
language sql
immutable
as $$
    select coalesce(array_agg(lower(trim(value))) filter (where trim(value) <> ''), '{}')
    from unnest(coalesce(values, '{}')) as value;
$$;

create or replace function match_signal_overlap(required_values text[], candidate_values text[])
returns numeric
language sql
immutable
as $$
    with required_set as (
        select distinct lower(trim(value)) as value
        from unnest(coalesce(required_values, '{}')) as value
        where trim(value) <> ''
    ),
    candidate_set as (
        select distinct lower(trim(value)) as value
        from unnest(coalesce(candidate_values, '{}')) as value
        where trim(value) <> ''
    )
    select case
        when (select count(*) from required_set) = 0 then 1.0
        else coalesce(
            (
                select count(*)::numeric
                from required_set r
                join candidate_set c using (value)
            ) / nullif((select count(*)::numeric from required_set), 0),
            0.0
        )
    end;
$$;

create or replace function seniority_weight(required_seniority text, candidate_seniority text)
returns numeric
language plpgsql
immutable
as $$
declare
    required_rank integer;
    candidate_rank integer;
begin
    required_rank := case lower(coalesce(required_seniority, ''))
        when 'junior' then 1
        when 'mid' then 2
        when 'senior' then 3
        when 'lead' then 4
        when 'principal' then 5
        else 0
    end;

    candidate_rank := case lower(coalesce(candidate_seniority, ''))
        when 'junior' then 1
        when 'mid' then 2
        when 'senior' then 3
        when 'lead' then 4
        when 'principal' then 5
        else 0
    end;

    if required_rank = 0 then
        return 1.0;
    elsif candidate_rank >= required_rank then
        return 1.0;
    elsif candidate_rank = required_rank - 1 then
        return 0.60;
    else
        return 0.20;
    end if;
end;
$$;

create or replace function availability_weight(status text)
returns numeric
language sql
immutable
as $$
    select case lower(coalesce(status, ''))
        when 'available_now' then 1.0
        when 'available_in_2_weeks' then 0.85
        when 'available_in_30_days' then 0.60
        when 'interviewing' then 0.45
        else 0.40
    end;
$$;

create or replace function location_weight(request_location text, candidate_location text)
returns numeric
language sql
immutable
as $$
    select case
        when coalesce(trim(request_location), '') = '' then 1.0
        when lower(trim(request_location)) = lower(trim(candidate_location)) then 1.0
        when lower(trim(request_location)) = 'remote' or lower(trim(candidate_location)) = 'remote' then 0.85
        else 0.35
    end;
$$;

create or replace function profile_freshness_weight(refresh_days integer)
returns numeric
language sql
immutable
as $$
    select greatest(0.35, 1 - (coalesce(refresh_days, 120)::numeric / 120.0));
$$;

create or replace function enqueue_review_item(
    queue_name_param text,
    entity_type_param text,
    entity_id_param uuid,
    reason_code_param text
)
returns uuid
language plpgsql
as $$
declare
    created_id uuid;
begin
    insert into review_queue (
        queue_name,
        entity_type,
        entity_id,
        reason_code,
        status
    )
    values (
        queue_name_param,
        entity_type_param,
        entity_id_param,
        reason_code_param,
        'open'
    )
    returning review_queue_id into created_id;

    return created_id;
end;
$$;

create or replace procedure refresh_graph_edges()
language plpgsql
as $$
begin
    delete from graph_edge;

    insert into graph_edge (
        from_entity_type,
        from_entity_id,
        relationship_type,
        to_entity_type,
        to_entity_id,
        strength_score,
        evidence_count
    )
    select
        'Engineer',
        engineer_id,
        'ENGINEER_HAS_SKILL',
        'Skill',
        skill_id,
        proficiency_score,
        1
    from engineer_skill;

    insert into graph_edge (
        from_entity_type,
        from_entity_id,
        relationship_type,
        to_entity_type,
        to_entity_id,
        strength_score,
        evidence_count
    )
    select
        'Engineer',
        engineer_id,
        'ENGINEER_USED_TECH',
        'Technology',
        technology_id,
        depth_score,
        1
    from engineer_technology;

    insert into graph_edge (
        from_entity_type,
        from_entity_id,
        relationship_type,
        to_entity_type,
        to_entity_id,
        strength_score,
        evidence_count
    )
    select
        'Engineer',
        engineer_id,
        'ENGINEER_WORKED_ON_PROJECT',
        'Project',
        project_id,
        0.85,
        1
    from engineer_project;

    insert into graph_edge (
        from_entity_type,
        from_entity_id,
        relationship_type,
        to_entity_type,
        to_entity_id,
        strength_score,
        evidence_count
    )
    select
        'Role',
        role_id,
        'ROLE_REQUIRES_SKILL',
        'Skill',
        skill_id,
        importance_weight,
        1
    from role_skill;

    insert into graph_edge (
        from_entity_type,
        from_entity_id,
        relationship_type,
        to_entity_type,
        to_entity_id,
        strength_score,
        evidence_count
    )
    select
        'Role',
        role_id,
        'ROLE_REQUIRES_TECH',
        'Technology',
        technology_id,
        importance_weight,
        1
    from role_technology;
end;
$$;

create or replace procedure run_matching_workflow(
    in_job_opening_id uuid,
    in_requested_by_recruiter_id uuid,
    in_score_version text default 'sql_ranker_v1'
)
language plpgsql
as $$
declare
    run_id uuid;
    opening_record record;
begin
    select
        jo.job_opening_id,
        jo.location,
        jo.max_bill_rate,
        c.industry as client_industry,
        r.seniority as role_seniority
    into opening_record
    from job_opening jo
    join client c on c.client_id = jo.client_id
    join role r on r.role_id = jo.role_id
    where jo.job_opening_id = in_job_opening_id;

    if opening_record.job_opening_id is null then
        raise exception 'job opening % not found', in_job_opening_id;
    end if;

    insert into matching_run (
        job_opening_id,
        requested_by_recruiter_id,
        score_version,
        degraded_mode
    )
    values (
        in_job_opening_id,
        in_requested_by_recruiter_id,
        in_score_version,
        false
    )
    returning matching_run_id into run_id;

    with role_requirements as (
        select
            rs.role_id,
            array_agg(distinct s.skill_name) filter (where rs.required_flag) as required_skills,
            array_agg(distinct t.technology_name) filter (where rt.required_flag) as required_technologies
        from role_skill rs
        join skill s on s.skill_id = rs.skill_id
        left join role_technology rt on rt.role_id = rs.role_id
        left join technology t on t.technology_id = rt.technology_id
        where rs.role_id = (
            select role_id from job_opening where job_opening_id = in_job_opening_id
        )
        group by rs.role_id
    ),
    candidate_features as (
        select
            e.engineer_id,
            e.full_name,
            e.location,
            e.seniority,
            e.availability_status,
            e.target_rate,
            coalesce((current_date - e.last_profile_refresh_at::date), 120) as refresh_days,
            coalesce(
                (
                    select count(*) filter (where p.outcome_status = 'successful')::numeric
                    / nullif(count(*)::numeric, 0)
                    from placement p
                    where p.engineer_id = e.engineer_id
                ),
                0.60
            ) as placement_success_rate,
            array_agg(distinct s.skill_name) filter (where s.skill_name is not null) as candidate_skills,
            array_agg(distinct t.technology_name) filter (where t.technology_name is not null) as candidate_technologies,
            array_agg(distinct p.domain) filter (where p.domain is not null) as candidate_domains,
            array_agg(distinct c2.industry) filter (where c2.industry is not null) as recent_client_industries
        from engineer e
        left join engineer_skill es on es.engineer_id = e.engineer_id
        left join skill s on s.skill_id = es.skill_id
        left join engineer_technology et on et.engineer_id = e.engineer_id
        left join technology t on t.technology_id = et.technology_id
        left join engineer_project ep on ep.engineer_id = e.engineer_id
        left join project p on p.project_id = ep.project_id
        left join placement plc on plc.engineer_id = e.engineer_id
        left join client c2 on c2.client_id = plc.client_id
        group by
            e.engineer_id,
            e.full_name,
            e.location,
            e.seniority,
            e.availability_status,
            e.target_rate,
            e.last_profile_refresh_at
    ),
    scored as (
        select
            cf.engineer_id,
            (
                match_signal_overlap(rr.required_skills, cf.candidate_skills) * 0.24
                + match_signal_overlap(rr.required_technologies, cf.candidate_technologies) * 0.22
                + match_signal_overlap(array[opening_record.client_industry], cf.recent_client_industries) * 0.08
                + location_weight(opening_record.location, cf.location) * 0.08
                + availability_weight(cf.availability_status) * 0.10
                + seniority_weight(opening_record.role_seniority, cf.seniority) * 0.06
                + case
                    when opening_record.max_bill_rate is null or cf.target_rate is null or cf.target_rate <= opening_record.max_bill_rate then 1.0
                    else 0.35
                  end * 0.04
                + profile_freshness_weight(cf.refresh_days) * 0.03
                + cf.placement_success_rate * 0.05
                + match_signal_overlap(array[opening_record.client_industry], cf.candidate_domains) * 0.10
            )::numeric(5,4) as score,
            cf.full_name,
            cf.candidate_skills,
            cf.candidate_technologies,
            cf.refresh_days,
            cf.availability_status,
            cf.placement_success_rate,
            match_signal_overlap(rr.required_skills, cf.candidate_skills) as skill_score,
            match_signal_overlap(rr.required_technologies, cf.candidate_technologies) as technology_score
        from candidate_features cf
        cross join role_requirements rr
    ),
    ranked as (
        select
            row_number() over (order by score desc, placement_success_rate desc, refresh_days asc) as rank_position,
            engineer_id,
            score,
            least(0.99, score * 0.85 + (1 - least(refresh_days, 120) / 120.0) * 0.10 + placement_success_rate * 0.05)::numeric(5,4) as confidence,
            (score < 0.68 or skill_score < 0.50 or technology_score < 0.50) as review_required,
            format(
                '%s skill coverage, %s technology coverage, %s, profile refreshed %s days ago',
                round(skill_score * 100),
                round(technology_score * 100),
                replace(availability_status, '_', ' '),
                refresh_days
            ) as explanation
        from scored
    )
    insert into matching_result (
        matching_run_id,
        engineer_id,
        rank_position,
        score,
        confidence,
        review_required,
        explanation
    )
    select
        run_id,
        engineer_id,
        rank_position,
        score,
        confidence,
        review_required,
        explanation
    from ranked;

    insert into review_queue (
        queue_name,
        entity_type,
        entity_id,
        reason_code,
        status
    )
    select
        'low_confidence_shortlist',
        'matching_result',
        gen_random_uuid(),
        'matching_confidence_below_threshold',
        'open'
    from matching_result
    where matching_run_id = run_id
      and review_required = true;
end;
$$;
