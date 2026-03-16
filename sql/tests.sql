select count(*) as missing_engineer_names
from engineer
where full_name is null;

select count(*) as invalid_job_openings
from job_opening
where client_id is null
   or role_id is null;
