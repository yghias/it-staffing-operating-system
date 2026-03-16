select
    job_opening_source_id as job_opening_id,
    engineer_source_id as engineer_id,
    engineer_name,
    skill_coverage,
    technology_coverage,
    location_score,
    rate_score,
    availability_score,
    freshness_score,
    match_score
from {{ ref('int_match_candidate_scores') }};
