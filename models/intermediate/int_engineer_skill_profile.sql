with engineers as (
    select * from {{ ref('stg_ats_candidate') }}
),
skills as (
    select
        engineer_source_id,
        trim(value::string) as skill_name
    from engineers,
    lateral flatten(input => skill_list)
),
technologies as (
    select
        engineer_source_id,
        trim(value::string) as technology_name
    from engineers,
    lateral flatten(input => technology_list)
)
select
    e.engineer_source_id,
    e.engineer_name,
    e.location_code,
    e.seniority,
    e.availability_status,
    e.target_rate,
    e.last_profile_refresh_at,
    array_agg(distinct s.skill_name) as normalized_skills,
    array_agg(distinct t.technology_name) as normalized_technologies
from engineers e
left join skills s on s.engineer_source_id = e.engineer_source_id
left join technologies t on t.engineer_source_id = e.engineer_source_id
group by
    e.engineer_source_id,
    e.engineer_name,
    e.location_code,
    e.seniority,
    e.availability_status,
    e.target_rate,
    e.last_profile_refresh_at;
