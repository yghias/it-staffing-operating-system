# Airflow

This directory mirrors the Airflow deployment boundary used by the platform team.

- `dags/` contains deployable DAG entrypoints
- shared orchestration code lives in `src/orchestration/`
- production Airflow connections are expected for Snowflake, Neo4j, and source APIs
