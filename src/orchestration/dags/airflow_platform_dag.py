from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator


with DAG(
    dag_id="staffing_platform_daily",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["staffing", "warehouse", "matching"],
) as dag:
    ingest = EmptyOperator(task_id="ingest_sources")
    transform = EmptyOperator(task_id="build_snowflake_models")
    refresh_graph = EmptyOperator(task_id="refresh_graph_projection")
    publish = EmptyOperator(task_id="publish_operating_marts")

    ingest >> transform >> refresh_graph >> publish
