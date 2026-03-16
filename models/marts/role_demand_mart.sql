select
    role_name,
    priority,
    status,
    count(*) as opening_count,
    avg(required_skill_count) as average_required_skill_count,
    avg(intake_quality_score) as average_intake_quality_score,
    avg(days_until_target_start) as average_days_until_target_start,
    avg(demand_priority_weight) as average_priority_weight
from {{ ref('int_role_demand_signals') }}
group by
    role_name,
    priority,
    status;
