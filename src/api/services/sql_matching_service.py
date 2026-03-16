from src.api.schemas.matching import MatchRequest, MatchResult
from src.common.db.postgres import fetch_all


SQL_RANKING_QUERY = """
with request_input as (
    select
        %(location)s::text as request_location,
        %(minimum_seniority)s::text as required_seniority,
        %(client_industry)s::text as client_industry,
        %(max_rate)s::integer as max_rate,
        %(required_skills)s::text[] as required_skills,
        %(required_technologies)s::text[] as required_technologies,
        %(preferred_domains)s::text[] as preferred_domains
),
candidate_features as (
    select
        e.engineer_id::text as engineer_id,
        e.full_name as engineer_name,
        e.location,
        e.seniority,
        e.availability_status,
        coalesce(e.target_rate, 999999) as target_rate,
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
        array_agg(distinct s.skill_name) filter (where s.skill_name is not null) as skills,
        array_agg(distinct t.technology_name) filter (where t.technology_name is not null) as technologies,
        array_agg(distinct pr.domain) filter (where pr.domain is not null) as domains,
        array_agg(distinct c.industry) filter (where c.industry is not null) as industries
    from engineer e
    left join engineer_skill es on es.engineer_id = e.engineer_id
    left join skill s on s.skill_id = es.skill_id
    left join engineer_technology et on et.engineer_id = e.engineer_id
    left join technology t on t.technology_id = et.technology_id
    left join engineer_project ep on ep.engineer_id = e.engineer_id
    left join project pr on pr.project_id = ep.project_id
    left join placement plc on plc.engineer_id = e.engineer_id
    left join client c on c.client_id = plc.client_id
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
        cf.engineer_name,
        match_signal_overlap(ri.required_skills, cf.skills) as skill_score,
        match_signal_overlap(ri.required_technologies, cf.technologies) as technology_score,
        match_signal_overlap(ri.preferred_domains, cf.domains) as domain_score,
        match_signal_overlap(array[ri.client_industry], cf.industries) as industry_score,
        location_weight(ri.request_location, cf.location) as location_score,
        availability_weight(cf.availability_status) as availability_score,
        seniority_weight(ri.required_seniority, cf.seniority) as seniority_score,
        case when ri.max_rate is null or cf.target_rate <= ri.max_rate then 1.0 else 0.35 end as rate_score,
        profile_freshness_weight(cf.refresh_days) as freshness_score,
        cf.placement_success_rate,
        cf.skills,
        cf.technologies,
        (
            match_signal_overlap(ri.required_skills, cf.skills) * 0.24
            + match_signal_overlap(ri.required_technologies, cf.technologies) * 0.22
            + match_signal_overlap(ri.preferred_domains, cf.domains) * 0.10
            + match_signal_overlap(array[ri.client_industry], cf.industries) * 0.08
            + location_weight(ri.request_location, cf.location) * 0.08
            + availability_weight(cf.availability_status) * 0.10
            + seniority_weight(ri.required_seniority, cf.seniority) * 0.06
            + case when ri.max_rate is null or cf.target_rate <= ri.max_rate then 1.0 else 0.35 end * 0.04
            + profile_freshness_weight(cf.refresh_days) * 0.03
            + cf.placement_success_rate * 0.05
        )::numeric(5,4) as score
    from candidate_features cf
    cross join request_input ri
)
select
    engineer_id,
    engineer_name,
    score,
    least(0.99, score * 0.85 + freshness_score * 0.10 + placement_success_rate * 0.05)::numeric(5,4) as confidence,
    (score < 0.68 or skill_score < 0.50 or technology_score < 0.50) as review_required,
    coalesce(
        (
            select array_agg(lower(value))
            from unnest(coalesce(skills, '{}')) as value
            where lower(value) = any(%(required_skills)s::text[])
        ),
        '{}'
    ) as matched_skills,
    coalesce(
        (
            select array_agg(lower(value))
            from unnest(coalesce(technologies, '{}')) as value
            where lower(value) = any(%(required_technologies)s::text[])
        ),
        '{}'
    ) as matched_technologies,
    format(
        '%s skill coverage, %s technology coverage, availability weighted in score',
        round(skill_score * 100),
        round(technology_score * 100)
    ) as explanation
from scored
order by score desc, confidence desc, engineer_name asc;
"""


def rank_engineers_in_sql(request: MatchRequest) -> list[MatchResult]:
    params = {
        "location": request.location,
        "minimum_seniority": request.minimum_seniority,
        "client_industry": request.client_industry,
        "max_rate": request.max_rate,
        "required_skills": [value.lower() for value in request.required_skills],
        "required_technologies": [value.lower() for value in request.required_technologies],
        "preferred_domains": [value.lower() for value in request.preferred_domains],
    }
    rows = fetch_all(SQL_RANKING_QUERY, params)
    return [
        MatchResult(
            engineer_id=row["engineer_id"],
            engineer_name=row["engineer_name"],
            score=float(row["score"]),
            confidence=float(row["confidence"]),
            review_required=bool(row["review_required"]),
            matched_skills=list(row["matched_skills"] or []),
            matched_technologies=list(row["matched_technologies"] or []),
            explanation=row["explanation"],
        )
        for row in rows
    ]
