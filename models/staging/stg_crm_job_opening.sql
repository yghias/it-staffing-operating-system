with source as (
    select
        opening_id,
        client_id,
        role_name,
        title,
        location,
        priority,
        status,
        required_skills,
        required_technologies,
        target_start_date,
        max_bill_rate,
        intake_quality_score,
        created_at
    from {{ source('raw', 'crm_job_opening') }}
)
select
    opening_id as job_opening_source_id,
    client_id,
    trim(role_name) as role_name,
    trim(title) as opening_title,
    upper(trim(location)) as location_code,
    lower(trim(priority)) as priority,
    lower(trim(status)) as status,
    split(required_skills, ',') as required_skill_list,
    split(required_technologies, ',') as required_technology_list,
    target_start_date,
    max_bill_rate,
    intake_quality_score,
    created_at as opened_at
from source;
