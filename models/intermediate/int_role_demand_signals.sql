with openings as (
    select * from {{ ref('fct_job_opening') }}
),
required_skill_rollup as (
    select
        job_opening_id,
        count(*) as required_skill_count
    from openings,
    lateral flatten(input => required_skills)
    group by job_opening_id
)
select
    o.job_opening_id,
    o.client_id,
    o.role_name,
    o.priority,
    o.status,
    o.target_start_date,
    o.intake_quality_score,
    coalesce(r.required_skill_count, 0) as required_skill_count,
    datediff('day', current_date, o.target_start_date) as days_until_target_start,
    iff(o.priority = 'critical', 1.20, iff(o.priority = 'high', 1.0, 0.75)) as demand_priority_weight
from openings o
left join required_skill_rollup r on r.job_opening_id = o.job_opening_id;
