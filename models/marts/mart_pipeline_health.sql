select
    o.client_id,
    o.priority,
    o.status,
    count(*) as opening_count,
    avg(o.intake_quality_score) as average_intake_quality_score,
    avg(ms.match_score) as average_top_match_score
from {{ ref('fct_job_opening') }} o
left join (
    select
        job_opening_id,
        max(match_score) as match_score
    from {{ ref('fct_match_score') }}
    group by job_opening_id
) ms on ms.job_opening_id = o.job_opening_id
group by
    o.client_id,
    o.priority,
    o.status;
