with source as (
    select
        activity_id,
        recruiter_id,
        activity_type,
        target_entity_type,
        target_entity_id,
        activity_timestamp,
        notes
    from {{ source('raw', 'recruiter_activity') }}
)
select
    activity_id,
    recruiter_id,
    lower(trim(activity_type)) as activity_type,
    lower(trim(target_entity_type)) as target_entity_type,
    target_entity_id,
    activity_timestamp,
    notes
from source;
