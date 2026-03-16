with openings as (
    select * from {{ ref('stg_crm_job_opening') }}
),
required_skills as (
    select
        job_opening_source_id,
        trim(value::string) as skill_name
    from openings,
    lateral flatten(input => required_skill_list)
),
required_technologies as (
    select
        job_opening_source_id,
        trim(value::string) as technology_name
    from openings,
    lateral flatten(input => required_technology_list)
)
select
    o.job_opening_source_id,
    o.client_id,
    o.role_name,
    o.opening_title,
    o.location_code,
    o.priority,
    o.status,
    o.target_start_date,
    o.max_bill_rate,
    o.intake_quality_score,
    array_agg(distinct rs.skill_name) as required_skills,
    array_agg(distinct rt.technology_name) as required_technologies
from openings o
left join required_skills rs on rs.job_opening_source_id = o.job_opening_source_id
left join required_technologies rt on rt.job_opening_source_id = o.job_opening_source_id
group by
    o.job_opening_source_id,
    o.client_id,
    o.role_name,
    o.opening_title,
    o.location_code,
    o.priority,
    o.status,
    o.target_start_date,
    o.max_bill_rate,
    o.intake_quality_score;
