with source as (
    select
        candidate_id,
        full_name,
        primary_email,
        location,
        current_title,
        seniority,
        availability_status,
        target_rate,
        work_authorization,
        profile_last_updated_at,
        skills,
        technologies
    from {{ source('raw', 'ats_candidate') }}
),
standardized as (
    select
        candidate_id as engineer_source_id,
        trim(full_name) as engineer_name,
        lower(primary_email) as primary_email,
        upper(trim(location)) as location_code,
        trim(current_title) as current_title,
        lower(trim(seniority)) as seniority,
        lower(trim(availability_status)) as availability_status,
        target_rate,
        trim(work_authorization) as work_authorization,
        profile_last_updated_at as last_profile_refresh_at,
        split(skills, ',') as skill_list,
        split(technologies, ',') as technology_list
    from source
)
select * from standardized;
