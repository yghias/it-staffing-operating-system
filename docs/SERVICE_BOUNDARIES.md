# Service Boundaries

## Ingestion Services
- pull ATS, CRM, repository, and project-delivery data
- validate contracts and persist raw landing records
- emit source freshness and sync outcome metrics

## Warehouse Layer
- standardize raw inputs into stable staging models
- publish intermediate entities and mart views in Snowflake
- own business definitions for supply, demand, match quality, and staffing throughput

## Matching Services
- request ranked candidates from warehouse-first scoring models
- coordinate graph lookups and semantic retrieval only where needed
- write run metadata and review routing decisions

## Review Services
- manage low-confidence and policy-gated decisions
- persist approvals, rejections, and override reasons
- publish operational queue metrics
