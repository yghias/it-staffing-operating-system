from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator

from src.ingestion.ats_ingest import ingest_ats_candidates
from src.ingestion.crm_ingest import ingest_crm_job_openings
from src.ingestion.github_ingest import ingest_github_metadata
from src.ingestion.job_order_ingest import ingest_job_orders
from src.orchestration.jobs.build_warehouse_models import run_warehouse_build
from src.orchestration.jobs.refresh_graph_projection import refresh_graph_projection
from src.orchestration.jobs.run_data_quality_checks import run_data_quality_checks
from src.orchestration.jobs.run_match_scoring import run_matching_job


with DAG(
    dag_id="staffing_platform_daily",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["staffing", "warehouse", "matching"],
) as dag:
    ingest_ats = PythonOperator(task_id="ingest_ats_candidates", python_callable=ingest_ats_candidates)
    ingest_crm = PythonOperator(task_id="ingest_crm_openings", python_callable=ingest_crm_job_openings)
    ingest_job_orders_task = PythonOperator(task_id="ingest_job_orders", python_callable=ingest_job_orders)
    ingest_github = PythonOperator(task_id="ingest_github_metadata", python_callable=ingest_github_metadata)
    transform = PythonOperator(task_id="build_snowflake_models", python_callable=run_warehouse_build)
    matching = PythonOperator(task_id="run_matching_job", python_callable=run_matching_job)
    refresh_graph = PythonOperator(task_id="refresh_graph_projection", python_callable=refresh_graph_projection)
    data_quality = PythonOperator(task_id="run_data_quality_checks", python_callable=run_data_quality_checks)

    [ingest_ats, ingest_crm, ingest_job_orders_task, ingest_github] >> transform >> matching >> refresh_graph >> data_quality
