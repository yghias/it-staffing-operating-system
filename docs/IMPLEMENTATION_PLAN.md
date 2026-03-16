# Implementation Plan

This plan defines the target end-state for refactoring `it-staffing-operating-system` into a Snowflake-first, Airflow-orchestrated enterprise data platform for technical staffing operations.

## 1. Repository Architecture

- `src/` contains ingestion, orchestration, APIs, graph loading, AI helpers, and ML support.
- `sql/` contains warehouse DDL, procedures, marts, reconciliation logic, and data quality checks.
- `models/` contains Snowflake/dbt-style `staging -> intermediate -> marts` transformations.
- `docs/`, `dashboards/`, `infrastructure/`, `airflow/`, and `sample_data/` hold operational support assets.
- Python stays thin and explicit; transformation, metrics, and reporting logic belong in SQL and warehouse models.

## 2. Environment Assumptions

### Platform choices
- cloud: AWS
- warehouse: Snowflake
- object storage: S3
- graph database: Neo4j
- orchestration: Airflow
- vector/search: pgvector if Postgres remains operational, otherwise OpenSearch vector or Pinecone
- runtime language: Python 3.11
- eventing: SQS/EventBridge first, Kafka only if needed later
- LLM layer: OpenAI for enrichment, summarization, and copilot workflows

### Environment separation
- `dev`: local Docker, sample or masked data, shared Snowflake dev database
- `staging`: production-like contracts, isolated schemas, release validation
- `prod`: restricted credentials, audited writes, monitored DAGs, controlled deploys

### Credential handling
- local development uses `.env`
- CI/CD uses GitHub Actions secrets
- runtime credentials come from AWS Secrets Manager, Airflow connections, and Snowflake key-pair auth

## 3. Warehouse, Graph, And Storage Choices

- Snowflake is the analytical system of record.
- Neo4j stores the talent graph for relationship traversal and explainable adjacency.
- S3 stores resumes, raw payloads, exports, and backfill snapshots.
- Python services read from Snowflake marts and publish graph projections to Neo4j.

## 4. API Data Shapes

### Ingestion APIs
- candidate payloads with source IDs, profile fields, skills, technologies, and timestamps
- job opening payloads with role requirements, client info, rate bands, and lifecycle status
- staffing activity payloads with event type, actor, timestamp, and target entity

### Internal service APIs
- `POST /matching/score` with role requirements and optional filters
- `POST /entity-resolution/candidates` with multi-source candidate records
- `POST /graph/load` with canonical entity snapshots or batch references
- `GET /health`, `GET /metrics`, `GET /review-queue`

### Response shapes
- candidate fit score
- matched skills and technologies
- confidence
- review required flag
- explanation and evidence references

## 5. Schema Design

### Canonical warehouse entities
- `engineers`
- `candidates`
- `candidate_profiles`
- `skills`
- `technologies`
- `projects`
- `roles`
- `companies`
- `clients`
- `job_openings`
- `recruiters`
- `placements`
- `certifications`

### Operational and analytical facts
- `candidate_skill_scores`
- `candidate_role_matches`
- `recruiter_activities`
- `pipeline_events`
- `interview_feedback`
- `talent_supply_signals`
- `market_demand_signals`

### Schema requirements
- surrogate keys
- source-system keys
- foreign keys
- effective timestamps
- freshness and lineage columns
- confidence columns for inferred and merged data

### Snowflake model pattern
- raw landing tables
- staging normalization
- intermediate canonical entities
- marts for business consumers

## 6. Pipeline Structure

- end-to-end flow: `raw -> staging -> intermediate -> marts -> graph projection -> AI/analytics consumers`
- SQL owns normalization, deduplication outputs, metric definitions, marts, reconciliation, and data quality tests
- Python owns ingestion, API wrappers, orchestration hooks, entity resolution services, graph loading, LLM enrichment, and ML helpers

## 7. Orchestration Approach

### Airflow DAG coverage
- ATS and CRM ingestion
- resume and profile ingestion
- canonical profile resolution
- Snowflake model builds
- graph projection refresh
- matching batch runs
- forecasting jobs
- data quality checks

### Design principles
- idempotent tasks
- partition-aware or sync-window-aware reruns
- explicit retries and failure routing
- environment-specific schedules
- backfill DAGs separate from steady-state DAGs

## 8. Governance Strategy

- define canonical entities and system owners in docs
- add source contracts for ATS, CRM, resumes, GitHub, and activity feeds
- track lineage from source payloads to marts to graph to API outputs
- apply role-based access rules for PII, compensation, and client-sensitive data
- document schema evolution handling for new fields and taxonomy changes

## 9. Observability Strategy

### Metrics
- source freshness
- row-count changes
- entity-resolution confidence
- matching freshness
- review queue SLA
- DAG success and failure

### Logs
- structured ingestion logs
- run IDs and correlation IDs
- graph sync outcomes

### Dashboards
- staffing pipeline health
- supply-demand gap
- match quality
- desk productivity

### Alerts
- stale source feeds
- failed model builds
- graph sync drift
- anomalous scoring distributions

## 10. Data Quality Strategy

- SQL-first tests live in `sql/tests.sql` and model tests
- checks include duplicates, null critical fields, invalid enums, broken foreign keys, role taxonomy mismatches, scoring bounds, and activity anomalies
- notebooks and docs support investigation, not enforcement
- DQ failures block downstream marts and graph refresh

## 11. Backfill Strategy

- support historical candidate reprocessing, canonical profile rebuilds, role rematch backfills, and graph rebuilds
- use source snapshot manifests in S3, Airflow backfill DAGs, idempotent merge logic, and partition-aware reruns in Snowflake
- document replay order and rollback expectations

## 12. Cost And Performance Controls

### Snowflake
- incremental models
- clustering and search optimization only for heavy marts
- warehouse sizing by workload class
- suspend and resume policies

### Graph
- batch edge loads
- project only canonical entities, not raw records

### AI
- cache enrichment outputs
- separate expensive LLM steps from deterministic scoring

### Orchestration
- avoid full refresh except for controlled backfills

## 13. Entity Resolution Strategy

- deterministic keys first: email, GitHub handle, source IDs
- probabilistic scoring on name, title, location, work history, and skill overlap
- survivorship rules create canonical profiles
- conflict flags route ambiguous cases to review

### Outputs
- canonical profile
- contributing sources
- confidence score
- merge rationale
- unresolved conflicts

## 14. AI Matching And Ranking Strategy

### SQL-first feature generation in Snowflake
- skill overlap
- technology overlap
- seniority alignment
- location and rate fit
- recency and supply signals
- prior placement outcomes

### Python and ML layer
- ranker wrapper
- optional learned reranker
- explanation synthesis

### Outputs
- candidate-role score
- explanation
- confidence
- review-required routing

## 15. Human-In-The-Loop Workflow Design

### Review queues
- low-confidence entity merges
- low-confidence candidate-role matches
- policy-gated outbound actions

### Users
- staffing operations
- account and delivery leads
- hiring managers where applicable

### Workflow
- system recommends
- reviewer approves, rejects, or edits
- decision is stored as a feedback signal
- audit trail is preserved

## 16. Implementation Sequence

1. Normalize the repo structure to the target tree.
2. Replace hiring- or portfolio-toned docs with internal platform docs.
3. Build Snowflake schema, dbt-style models, and SQL tests.
4. Expand sample data to support deduplication, scoring, and forecasting.
5. Refactor Python so ingestion and orchestration stay thin while SQL becomes primary.
6. Add Neo4j graph projection and loader logic.
7. Add Airflow DAGs and local/runtime config.
8. Strengthen CI/CD, observability, governance, and runbooks.
9. Validate that no empty folders remain and all pipelines reference real schemas.
10. Push the completed implementation to GitHub.

## 17. Build-Step Assumption

- The exact requested file structure will be generated even where some filenames are awkward for the tone goal.
- If filenames such as `RESUME_BULLETS.md`, `LINKEDIN_SUMMARY.md`, or `PORTFOLIO_ENTRY.md` are required by the requested tree, their contents will be rewritten to read like internal communications or operating notes rather than hiring material.
