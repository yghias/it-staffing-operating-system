with placements as (
    select * from {{ ref('stg_placement_history') }}
)
select
    placement_id,
    engineer_id,
    recruiter_id,
    client_id,
    role_name,
    started_on,
    ended_on,
    bill_rate,
    margin_percent,
    outcome_status,
    assignment_days,
    iff(outcome_status in ('successful', 'completed'), 1, 0) as successful_flag
from placements;
