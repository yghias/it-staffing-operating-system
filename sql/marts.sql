create view mart_match_readiness as
select
    e.engineer_id,
    e.full_name,
    e.location,
    e.seniority,
    e.availability_status
from engineer e;

create view mart_open_roles as
select
    jo.job_opening_id,
    c.client_name,
    r.role_name,
    jo.title,
    jo.location,
    jo.status
from job_opening jo
join client c on c.client_id = jo.client_id
join role r on r.role_id = jo.role_id;
