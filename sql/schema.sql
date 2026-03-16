create extension if not exists pgcrypto;

create table if not exists company (
    company_id uuid primary key default gen_random_uuid(),
    company_name text not null,
    company_type text not null,
    industry text,
    normalized_name text generated always as (lower(company_name)) stored,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    unique (normalized_name, company_type)
);

create table if not exists client (
    client_id uuid primary key default gen_random_uuid(),
    company_id uuid not null references company(company_id),
    client_name text not null,
    industry text,
    strategic_tier text not null default 'standard',
    created_at timestamptz not null default now()
);

create table if not exists recruiter (
    recruiter_id uuid primary key default gen_random_uuid(),
    full_name text not null,
    team_name text,
    region text,
    active_flag boolean not null default true,
    created_at timestamptz not null default now()
);

create table if not exists engineer (
    engineer_id uuid primary key default gen_random_uuid(),
    full_name text not null,
    primary_email text unique,
    location text,
    seniority text,
    current_title text,
    availability_status text not null,
    work_authorization text,
    target_rate numeric(10,2),
    last_profile_refresh_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists skill (
    skill_id uuid primary key default gen_random_uuid(),
    skill_name text not null unique,
    skill_family text not null,
    is_certifiable boolean not null default false
);

create table if not exists technology (
    technology_id uuid primary key default gen_random_uuid(),
    technology_name text not null unique,
    category text not null,
    vendor text
);

create table if not exists role (
    role_id uuid primary key default gen_random_uuid(),
    role_name text not null unique,
    seniority text not null,
    role_family text not null
);

create table if not exists certification (
    certification_id uuid primary key default gen_random_uuid(),
    certification_name text not null,
    issuer text not null,
    certification_code text,
    unique (certification_name, issuer)
);

create table if not exists repository (
    repository_id uuid primary key default gen_random_uuid(),
    repository_name text not null,
    provider text not null,
    url text,
    primary_language text,
    created_at timestamptz not null default now()
);

create table if not exists project (
    project_id uuid primary key default gen_random_uuid(),
    company_id uuid references company(company_id),
    project_name text not null,
    domain text,
    business_outcome text,
    started_on date,
    ended_on date,
    created_at timestamptz not null default now()
);

create table if not exists job_opening (
    job_opening_id uuid primary key default gen_random_uuid(),
    client_id uuid not null references client(client_id),
    role_id uuid not null references role(role_id),
    title text not null,
    location text,
    employment_type text not null default 'contract',
    priority text not null default 'standard',
    target_start_date date,
    max_bill_rate numeric(10,2),
    opened_at timestamptz not null default now(),
    closed_at timestamptz,
    status text not null,
    intake_quality_score numeric(4,3) not null default 0.700
);

create table if not exists placement (
    placement_id uuid primary key default gen_random_uuid(),
    engineer_id uuid not null references engineer(engineer_id),
    recruiter_id uuid not null references recruiter(recruiter_id),
    client_id uuid not null references client(client_id),
    role_id uuid not null references role(role_id),
    job_opening_id uuid references job_opening(job_opening_id),
    started_on date,
    ended_on date,
    bill_rate numeric(10,2),
    margin_percent numeric(5,2),
    outcome_status text not null,
    created_at timestamptz not null default now()
);

create table if not exists engineer_skill (
    engineer_id uuid not null references engineer(engineer_id),
    skill_id uuid not null references skill(skill_id),
    proficiency_score numeric(4,3) not null,
    last_used_at date,
    evidence_source text not null,
    primary key (engineer_id, skill_id)
);

create table if not exists engineer_technology (
    engineer_id uuid not null references engineer(engineer_id),
    technology_id uuid not null references technology(technology_id),
    depth_score numeric(4,3) not null,
    years_experience numeric(4,1),
    last_used_at date,
    evidence_source text not null,
    primary key (engineer_id, technology_id)
);

create table if not exists engineer_project (
    engineer_id uuid not null references engineer(engineer_id),
    project_id uuid not null references project(project_id),
    role_summary text,
    impact_summary text,
    primary key (engineer_id, project_id)
);

create table if not exists project_technology (
    project_id uuid not null references project(project_id),
    technology_id uuid not null references technology(technology_id),
    primary key (project_id, technology_id)
);

create table if not exists project_skill (
    project_id uuid not null references project(project_id),
    skill_id uuid not null references skill(skill_id),
    primary key (project_id, skill_id)
);

create table if not exists role_skill (
    role_id uuid not null references role(role_id),
    skill_id uuid not null references skill(skill_id),
    importance_weight numeric(4,3) not null default 0.500,
    required_flag boolean not null default true,
    primary key (role_id, skill_id)
);

create table if not exists role_technology (
    role_id uuid not null references role(role_id),
    technology_id uuid not null references technology(technology_id),
    importance_weight numeric(4,3) not null default 0.500,
    required_flag boolean not null default true,
    primary key (role_id, technology_id)
);

create table if not exists engineer_certification (
    engineer_id uuid not null references engineer(engineer_id),
    certification_id uuid not null references certification(certification_id),
    awarded_on date,
    expires_on date,
    primary key (engineer_id, certification_id)
);

create table if not exists engineer_repository (
    engineer_id uuid not null references engineer(engineer_id),
    repository_id uuid not null references repository(repository_id),
    contribution_level text not null default 'contributor',
    primary key (engineer_id, repository_id)
);

create table if not exists graph_edge (
    edge_id uuid primary key default gen_random_uuid(),
    from_entity_type text not null,
    from_entity_id uuid not null,
    relationship_type text not null,
    to_entity_type text not null,
    to_entity_id uuid not null,
    strength_score numeric(4,3) not null default 0.500,
    evidence_count integer not null default 1,
    created_at timestamptz not null default now()
);

create table if not exists matching_run (
    matching_run_id uuid primary key default gen_random_uuid(),
    job_opening_id uuid references job_opening(job_opening_id),
    requested_by_recruiter_id uuid references recruiter(recruiter_id),
    score_version text not null,
    degraded_mode boolean not null default false,
    created_at timestamptz not null default now()
);

create table if not exists matching_result (
    matching_run_id uuid not null references matching_run(matching_run_id),
    engineer_id uuid not null references engineer(engineer_id),
    rank_position integer not null,
    score numeric(5,4) not null,
    confidence numeric(5,4) not null,
    review_required boolean not null default false,
    explanation text not null,
    primary key (matching_run_id, engineer_id)
);

create table if not exists review_queue (
    review_queue_id uuid primary key default gen_random_uuid(),
    queue_name text not null,
    entity_type text not null,
    entity_id uuid not null,
    reason_code text not null,
    status text not null default 'open',
    assigned_reviewer_id uuid references recruiter(recruiter_id),
    created_at timestamptz not null default now(),
    resolved_at timestamptz
);
