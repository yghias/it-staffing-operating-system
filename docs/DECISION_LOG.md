# Decision Log

## Current Decisions

### SQL-first warehouse logic
- Transformations, metrics, marts, and data quality checks are owned by SQL models.
- Python is reserved for ingestion, orchestration, APIs, and ML-specific support.

### Snowflake as analytical system of record
- Curated operational analytics, score inputs, and marts are built for Snowflake execution patterns.
- Stored procedures remain available where procedural control adds value.

### Airflow as orchestration layer
- Batch syncs, warehouse builds, graph refresh jobs, and data quality checks are scheduled and monitored through Airflow.

### Review-gated automation
- Ranking output may assist operations, but outbound actions remain gated by policy and review queues.
