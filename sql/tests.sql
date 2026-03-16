select count(*) as missing_engineer_names
from engineer
where full_name is null
   or trim(full_name) = '';

select count(*) as invalid_job_openings
from job_opening
where client_id is null
   or role_id is null
   or status not in ('open', 'on_hold', 'closed', 'filled');

select count(*) as invalid_skill_proficiency_scores
from engineer_skill
where proficiency_score < 0
   or proficiency_score > 1;

select count(*) as invalid_matching_scores
from matching_result
where score < 0
   or score > 1
   or confidence < 0
   or confidence > 1;

select count(*) as unresolved_review_queue_items_with_resolution_time
from review_queue
where status = 'open'
  and resolved_at is not null;

select count(*) as invalid_role_skill_weights
from role_skill
where importance_weight < 0
   or importance_weight > 1;

select count(*) as invalid_role_technology_weights
from role_technology
where importance_weight < 0
   or importance_weight > 1;

select count(*) as duplicate_matching_ranks_within_run
from (
    select
        matching_run_id,
        rank_position,
        count(*) as row_count
    from matching_result
    group by matching_run_id, rank_position
    having count(*) > 1
) duplicates;

select count(*) as placements_without_positive_margin
from placement
where outcome_status in ('successful', 'completed')
  and coalesce(margin_percent, 0) <= 0;

select count(*) as stale_openings_without_recent_activity
from job_opening jo
left join matching_run mr on mr.job_opening_id = jo.job_opening_id
where jo.status = 'open'
group by jo.job_opening_id, jo.opened_at
having max(mr.created_at) is null
    or max(mr.created_at) < jo.opened_at;
