with daily_activity as (
    select * from {{ ref('int_recruiter_activity_daily') }}
),
placement_summary as (
    select
        recruiter_id,
        count(*) as placements_count,
        avg(margin_percent) as average_margin_percent,
        avg(assignment_days) as average_assignment_days,
        sum(successful_flag) as successful_placements
    from {{ ref('int_placement_performance') }}
    group by recruiter_id
)
select
    da.recruiter_id,
    min(da.activity_date) as first_activity_date,
    max(da.activity_date) as last_activity_date,
    sum(da.activity_count) as total_activity_count,
    sum(da.intake_count) as total_intake_count,
    sum(da.shortlist_review_count) as total_shortlist_reviews,
    sum(da.outreach_count) as total_outreach_count,
    sum(da.client_update_count) as total_client_updates,
    coalesce(ps.placements_count, 0) as placements_count,
    coalesce(ps.successful_placements, 0) as successful_placements,
    coalesce(ps.average_margin_percent, 0) as average_margin_percent,
    coalesce(ps.average_assignment_days, 0) as average_assignment_days
from daily_activity da
left join placement_summary ps on ps.recruiter_id = da.recruiter_id
group by
    da.recruiter_id,
    ps.placements_count,
    ps.successful_placements,
    ps.average_margin_percent,
    ps.average_assignment_days;
