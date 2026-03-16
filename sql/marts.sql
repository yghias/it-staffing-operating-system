create or replace view mart_engineer_readiness as
select
    e.engineer_id,
    e.full_name,
    e.location,
    e.seniority,
    e.availability_status,
    coalesce(avg(es.proficiency_score), 0) as average_skill_proficiency,
    count(distinct es.skill_id) as tracked_skill_count,
    count(distinct ep.project_id) as project_count,
    max(e.last_profile_refresh_at) as last_profile_refresh_at
from engineer e
left join engineer_skill es on es.engineer_id = e.engineer_id
left join engineer_project ep on ep.engineer_id = e.engineer_id
group by
    e.engineer_id,
    e.full_name,
    e.location,
    e.seniority,
    e.availability_status;

create or replace view mart_open_roles as
select
    jo.job_opening_id,
    c.client_name,
    c.strategic_tier,
    r.role_name,
    jo.title,
    jo.location,
    jo.priority,
    jo.status,
    jo.target_start_date,
    jo.intake_quality_score,
    count(distinct rs.skill_id) filter (where rs.required_flag) as required_skill_count,
    count(distinct rt.technology_id) filter (where rt.required_flag) as required_technology_count
from job_opening jo
join client c on c.client_id = jo.client_id
join role r on r.role_id = jo.role_id
left join role_skill rs on rs.role_id = jo.role_id
left join role_technology rt on rt.role_id = jo.role_id
group by
    jo.job_opening_id,
    c.client_name,
    c.strategic_tier,
    r.role_name,
    jo.title,
    jo.location,
    jo.priority,
    jo.status,
    jo.target_start_date,
    jo.intake_quality_score;

create or replace view mart_matching_effectiveness as
select
    mr.matching_run_id,
    mr.engineer_id,
    mr.rank_position,
    mr.score,
    mr.confidence,
    mr.review_required,
    mrun.job_opening_id,
    mrun.score_version,
    mrun.degraded_mode,
    mrun.created_at as matched_at
from matching_result mr
join matching_run mrun on mrun.matching_run_id = mr.matching_run_id;

create or replace view mart_recruiter_book as
select
    r.recruiter_id,
    r.full_name,
    r.team_name,
    count(distinct p.placement_id) as placements_count,
    avg(p.margin_percent) as average_margin_percent,
    count(distinct jo.job_opening_id) filter (where jo.status = 'open') as active_openings
from recruiter r
left join placement p on p.recruiter_id = r.recruiter_id
left join job_opening jo on jo.client_id = p.client_id
group by
    r.recruiter_id,
    r.full_name,
    r.team_name;
