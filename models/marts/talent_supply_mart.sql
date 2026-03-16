with skill_supply as (
    select
        trim(skill.value::string) as skill_name,
        count(distinct d.engineer_id) as available_engineer_count,
        avg(d.target_rate) as average_target_rate
    from {{ ref('dim_engineer') }} d,
    lateral flatten(input => d.normalized_skills) skill
    where d.availability_status in ('available_now', 'available_in_2_weeks')
    group by trim(skill.value::string)
)
select
    skill_name,
    available_engineer_count,
    average_target_rate,
    iff(available_engineer_count >= 5, 'deep', iff(available_engineer_count >= 2, 'moderate', 'thin')) as supply_band
from skill_supply;
