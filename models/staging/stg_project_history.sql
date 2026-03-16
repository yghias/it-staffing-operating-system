with source as (
    select
        project_id,
        engineer_id,
        company_name,
        project_name,
        domain,
        business_outcome,
        started_on,
        ended_on,
        technologies_used
    from {{ source('raw', 'project_history') }}
)
select
    project_id,
    engineer_id,
    trim(company_name) as company_name,
    trim(project_name) as project_name,
    lower(trim(domain)) as domain,
    trim(business_outcome) as business_outcome,
    started_on,
    ended_on,
    split(technologies_used, ',') as technologies_used
from source;
