select
    recruiter_id,
    cast(activity_timestamp as date) as activity_date,
    count(*) as activity_count,
    count_if(activity_type = 'opening_intake') as intake_count,
    count_if(activity_type = 'shortlist_review') as shortlist_review_count,
    count_if(activity_type = 'candidate_outreach') as outreach_count,
    count_if(activity_type = 'client_update') as client_update_count
from {{ ref('stg_recruiter_activity') }}
group by
    recruiter_id,
    cast(activity_timestamp as date);
