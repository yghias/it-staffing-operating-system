from src.ingestion.ats_ingest import ingest_ats_candidates
from src.ingestion.crm_ingest import ingest_crm_job_openings


def test_ats_sample_loads_expected_rows() -> None:
    result = ingest_ats_candidates()
    assert result["records_loaded"] == 5


def test_crm_openings_sample_loads_expected_rows() -> None:
    result = ingest_crm_job_openings()
    assert result["records_loaded"] == 3
