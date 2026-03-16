with openings as (
    select * from {{ ref('fct_job_opening') }}
),
top_match as (
    select
        job_opening_id,
        max(match_score) as top_match_score
    from {{ ref('fct_match_score') }}
    group by job_opening_id
),
activity as (
    select
        target_entity_id as job_opening_id,
        count(*) as activity_count,
        max(activity_timestamp) as last_activity_at
    from {{ ref('stg_recruiter_activity') }}
    where target_entity_type = 'job_opening'
    group by target_entity_id
)
select
    o.job_opening_id,
    o.client_id,
    o.role_name,
    o.priority,
    o.status,
    o.target_start_date,
    o.intake_quality_score,
    coalesce(tm.top_match_score, 0) as top_match_score,
    coalesce(a.activity_count, 0) as activity_count,
    a.last_activity_at,
    datediff('day', current_date, o.target_start_date) as days_to_target_start
from openings o
left join top_match tm on tm.job_opening_id = o.job_opening_id
left join activity a on a.job_opening_id = o.job_opening_id;
