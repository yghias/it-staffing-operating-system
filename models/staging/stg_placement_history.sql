with source as (
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
        outcome_status
    from {{ source('raw', 'placement_history') }}
)
select
    placement_id,
    engineer_id,
    recruiter_id,
    client_id,
    trim(role_name) as role_name,
    started_on,
    ended_on,
    bill_rate,
    margin_percent,
    lower(trim(outcome_status)) as outcome_status,
    datediff('day', started_on, coalesce(ended_on, current_date)) as assignment_days
from source;
