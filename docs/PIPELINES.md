# Pipelines

## Ingestion
- Pull engineer, account, opening, and placement records from ATS and CRM systems.
- Ingest resumes, notes, certifications, repositories, and project signals.
- Store raw payloads with source metadata, sync windows, and idempotency keys.
- Persist source freshness and extraction outcomes for operations reporting.

## Transformations
- Standardize titles, locations, technologies, skills, and company names in Snowflake staging models.
- Publish intermediate entities for engineer supply, opening requirements, and project history.
- Resolve deterministic and probabilistic identity matches before marts are published.
- Keep business logic in SQL models so marts, dashboards, and review routing use the same definitions.

## Operational Serving
- Persist matching runs, review queues, and graph-edge refresh state in PostgreSQL.
- Use curated Snowflake outputs as the source for graph projections and serving-side ranking inputs.

## Publishing
- Build Snowflake marts for pipeline health, supply-demand gaps, match scores, and staffing capacity.
- Refresh graph projections after curated warehouse models complete.
- Publish ranking outputs and review queues for downstream operational workflows.

## Human Review
- Route low-confidence entity resolution cases to reviewer queues.
- Store approval and rejection feedback for model improvement.

## Orchestration
- Airflow coordinates source ingestion, warehouse builds, graph refresh, and reporting publication.
- Warehouse runs must be idempotent at the partition or sync-window level.
- Downstream publish steps do not run if data quality gates fail.
