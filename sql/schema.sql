create table if not exists engineer (
    engineer_id uuid primary key,
    full_name text not null,
    primary_email text,
    location text,
    seniority text,
    availability_status text,
    created_at timestamptz not null default now()
);

create table if not exists skill (
    skill_id uuid primary key,
    skill_name text not null unique,
    skill_type text not null
);

create table if not exists technology (
    technology_id uuid primary key,
    technology_name text not null unique,
    category text
);

create table if not exists company (
    company_id uuid primary key,
    company_name text not null,
    company_type text not null
);

create table if not exists project (
    project_id uuid primary key,
    company_id uuid references company(company_id),
    project_name text not null,
    domain text,
    started_on date,
    ended_on date
);

create table if not exists role (
    role_id uuid primary key,
    role_name text not null,
    seniority text
);

create table if not exists certification (
    certification_id uuid primary key,
    certification_name text not null,
    issuer text
);

create table if not exists repository (
    repository_id uuid primary key,
    repository_name text not null,
    provider text,
    url text
);

create table if not exists recruiter (
    recruiter_id uuid primary key,
    full_name text not null,
    team_name text
);

create table if not exists client (
    client_id uuid primary key,
    client_name text not null,
    industry text
);

create table if not exists job_opening (
    job_opening_id uuid primary key,
    client_id uuid references client(client_id),
    role_id uuid references role(role_id),
    title text not null,
    location text,
    opened_at timestamptz not null default now(),
    status text not null
);

create table if not exists placement (
    placement_id uuid primary key,
    engineer_id uuid references engineer(engineer_id),
    recruiter_id uuid references recruiter(recruiter_id),
    client_id uuid references client(client_id),
    role_id uuid references role(role_id),
    started_on date,
    ended_on date,
    outcome_status text
);
