with supply as (
    select
        skill_name,
        count(distinct engineer_id) as engineer_count
    from {{ ref('dim_engineer') }},
    lateral flatten(input => normalized_skills) s,
    lateral (select trim(s.value::string) as skill_name)
    group by skill_name
),
demand as (
    select
        skill_name,
        count(distinct job_opening_id) as opening_count
    from {{ ref('fct_job_opening') }},
    lateral flatten(input => required_skills) rs,
    lateral (select trim(rs.value::string) as skill_name)
    group by skill_name
)
select
    coalesce(d.skill_name, s.skill_name) as skill_name,
    coalesce(s.engineer_count, 0) as engineer_count,
    coalesce(d.opening_count, 0) as opening_count,
    coalesce(d.opening_count, 0) - coalesce(s.engineer_count, 0) as supply_gap
from demand d
full outer join supply s on s.skill_name = d.skill_name;
