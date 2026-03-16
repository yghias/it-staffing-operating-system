select
    client_id,
    role_name,
    count(*) as placement_count,
    avg(margin_percent) as average_margin_percent,
    avg(assignment_days) as average_assignment_days,
    sum(successful_flag) as successful_placements
from {{ ref('int_placement_performance') }}
group by
    client_id,
    role_name;
