# Cloud Operations

## Managed Service Baseline

- `Amazon RDS for PostgreSQL` for canonical staffing entities, marts, and stored procedures
- `Amazon ECS Fargate` for API services and orchestration workers
- `AWS Step Functions` for intake, matching, review, and writeback workflows
- `Amazon EventBridge` for scheduled syncs and event fan-out
- `Amazon S3` for resumes, notes, payload retention, and model evaluation assets
- `Amazon OpenSearch` for vector and keyword retrieval
- `Amazon Bedrock` for recruiter-facing generation workflows
- `Amazon QuickSight` for staffing, recruiting, and leadership dashboards
- `Amazon CloudWatch` for logs, metrics, dashboards, and alarms
- `AWS Secrets Manager` for API tokens, database credentials, and model keys

## Cloud UI Workflows

- Staffing operations can inspect Step Functions executions to trace match runs and review delays.
- Recruiting leadership can use QuickSight dashboards to monitor desk productivity, shortlist conversion, and client demand.
- Platform operations can use CloudWatch dashboards and alarms to detect ingestion failures, stale source data, and match latency regressions.
- Support and delivery teams can review EventBridge schedules and CloudWatch logs without touching code.

## Database-First Design

The repository pushes deterministic matching logic into PostgreSQL where practical:

- role requirements are resolved in SQL
- candidate features are aggregated in SQL
- ranking scores and review-routing thresholds are computed in SQL
- graph-edge refresh jobs are handled in SQL procedures

Python remains the orchestration and API boundary for:

- external connector integration
- LLM-assisted drafting and semantic enrichment
- review-facing APIs
- fallback scoring when the warehouse is not available
