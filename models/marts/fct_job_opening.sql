select
    job_opening_source_id as job_opening_id,
    client_id,
    role_name,
    opening_title,
    location_code,
    priority,
    status,
    target_start_date,
    max_bill_rate,
    intake_quality_score,
    required_skills,
    required_technologies
from {{ ref('int_job_opening_requirements') }};
