select
    engineer_source_id as engineer_id,
    engineer_name,
    seniority,
    location_code,
    availability_status,
    target_rate,
    last_profile_refresh_at,
    normalized_skills,
    normalized_technologies
from {{ ref('int_engineer_skill_profile') }};
