# Graph Model

## Node Types
- Engineer
- Skill
- Technology
- Company
- Project
- Role
- Certification
- Repository
- Placement
- Recruiter
- Client
- JobOpening

## Important Edge Types
- `ENGINEER_HAS_SKILL`
- `ENGINEER_USED_TECH`
- `ENGINEER_WORKED_ON_PROJECT`
- `PROJECT_USED_TECH`
- `PROJECT_REQUIRED_SKILL`
- `ROLE_REQUIRES_SKILL`
- `ROLE_REQUIRES_TECH`
- `COMPANY_HIRES_ROLE`
- `CLIENT_OPENED_JOB`
- `JOB_OPENING_FOR_ROLE`
- `RECRUITER_PLACED_ENGINEER`

## Mermaid Graph

```mermaid
graph TD
    Engineer -->|ENGINEER_HAS_SKILL| Skill
    Engineer -->|ENGINEER_USED_TECH| Technology
    Engineer -->|ENGINEER_WORKED_ON_PROJECT| Project
    Project -->|PROJECT_USED_TECH| Technology
    Project -->|PROJECT_REQUIRED_SKILL| Skill
    Role -->|ROLE_REQUIRES_SKILL| Skill
    Role -->|ROLE_REQUIRES_TECH| Technology
    Company -->|COMPANY_HIRES_ROLE| Role
    Client -->|CLIENT_OPENED_JOB| JobOpening
    JobOpening -->|JOB_OPENING_FOR_ROLE| Role
    Recruiter -->|RECRUITER_PLACED_ENGINEER| Placement
```
