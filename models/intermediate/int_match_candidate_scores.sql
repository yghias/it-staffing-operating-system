with openings as (
    select * from {{ ref('int_job_opening_requirements') }}
),
engineers as (
    select * from {{ ref('int_engineer_skill_profile') }}
),
scored as (
    select
        o.job_opening_source_id,
        e.engineer_source_id,
        e.engineer_name,
        array_size(array_intersection(o.required_skills, e.normalized_skills)) / nullif(array_size(o.required_skills), 0) as skill_coverage,
        array_size(array_intersection(o.required_technologies, e.normalized_technologies)) / nullif(array_size(o.required_technologies), 0) as technology_coverage,
        iff(o.location_code = e.location_code, 1.0, iff(e.location_code = 'REMOTE', 0.85, 0.35)) as location_score,
        iff(o.max_bill_rate is null or e.target_rate <= o.max_bill_rate, 1.0, 0.35) as rate_score,
        iff(e.availability_status = 'available_now', 1.0, iff(e.availability_status = 'available_in_2_weeks', 0.85, 0.55)) as availability_score,
        greatest(0.35, 1 - (datediff('day', e.last_profile_refresh_at, current_timestamp()) / 120.0)) as freshness_score
    from openings o
    join engineers e on 1 = 1
)
select
    job_opening_source_id,
    engineer_source_id,
    engineer_name,
    skill_coverage,
    technology_coverage,
    location_score,
    rate_score,
    availability_score,
    freshness_score,
    (
        coalesce(skill_coverage, 0) * 0.35
        + coalesce(technology_coverage, 0) * 0.30
        + location_score * 0.10
        + rate_score * 0.05
        + availability_score * 0.10
        + freshness_score * 0.10
    ) as match_score
from scored;
