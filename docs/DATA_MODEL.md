# Data Model

## Conceptual Model

- `Engineer`: identity, work history, availability, geography, compensation, and performance context.
- `Skill`: normalized business or technical capability.
- `Technology`: tool, framework, platform, or cloud service.
- `Company`: employer, staffing firm, or client-side organization.
- `Project`: project delivery unit with timeline, domain, and business outcome.
- `Role`: normalized role family and seniority pattern.
- `Certification`: credential held by an engineer.
- `Repository`: code asset linked to engineer activity or projects.
- `Placement`: staffed assignment connecting engineer, recruiter, client, role, and outcomes.
- `Recruiter`: internal user who manages sourcing and placements.
- `Client`: customer organization with staffing demand.
- `JobOpening`: live requisition tied to a role and client.

## Logical Model

- Engineers have many skills, technologies, certifications, repositories, and projects.
- Projects use technologies and require skills.
- Roles require skills and technologies.
- Clients own job openings.
- Companies hire roles and employ engineers.
- Recruiters place engineers into client roles through placements.

## Physical Model

- Warehouse tables for raw, staging, curated, and mart layers.
- Graph projection for traversing talent relationships.
- Vectorized text records for semantic retrieval.
- Audit tables for model runs, ranking explanations, and human review outcomes.

## Core Relationships

- `ENGINEER_HAS_SKILL`
- `ENGINEER_USED_TECH`
- `ENGINEER_WORKED_ON_PROJECT`
- `ROLE_REQUIRES_SKILL`
- `ROLE_REQUIRES_TECH`
- `COMPANY_HIRES_ROLE`
- `RECRUITER_PLACED_ENGINEER`
- `CLIENT_OPENED_JOB`
- `JOB_OPENING_FOR_ROLE`
