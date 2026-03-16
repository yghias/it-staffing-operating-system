# Cloud Operations

## Managed Service Baseline

- `Snowflake` for warehouse transformations, marts, and semantic datasets
- `Amazon RDS for PostgreSQL` for operational workflow state and serving-side procedures
- `Amazon ECS Fargate` for API services and orchestration workers
- `Airflow` for ingestion, warehouse builds, graph refresh, and data quality scheduling
- `Amazon EventBridge` for scheduled syncs and event fan-out
- `Amazon S3` for resumes, notes, payload retention, and evaluation records
- `Amazon OpenSearch` for vector and keyword retrieval
- `Amazon Bedrock` for workflow summarization and drafting
- `Amazon QuickSight` for staffing and leadership dashboards
- `Amazon CloudWatch` for logs, metrics, dashboards, and alarms
- `AWS Secrets Manager` for API tokens, database credentials, and model keys

## Cloud UI Workflows

- Staffing operations can inspect Step Functions executions to trace match runs and review delays.
- Recruiting leadership can use QuickSight dashboards to monitor desk productivity, shortlist conversion, and client demand.
- Platform operations can use CloudWatch dashboards and alarms to detect ingestion failures, stale source data, and match latency regressions.
- Support and delivery teams can review EventBridge schedules and CloudWatch logs without touching code.

## Data Platform Design

The repository splits responsibilities between Snowflake and PostgreSQL:

- Snowflake owns normalization, intermediate entities, marts, and reporting logic
- PostgreSQL owns operational match-state persistence and procedural serving controls
- graph projection inputs are built from curated warehouse outputs

Python remains the orchestration and API boundary for:

- external connector integration
- LLM-assisted drafting and semantic enrichment
- review-facing APIs
- graph loading and warehouse-adjacent workflow control
