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
