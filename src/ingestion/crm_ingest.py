from pathlib import Path

from src.ingestion.file_loader import read_csv_records


def ingest_crm_job_openings(sample_root: str | Path = "sample_data/raw") -> dict[str, object]:
    records = read_csv_records(Path(sample_root) / "crm_job_opening.csv")
    return {"source": "crm_job_opening", "records_loaded": len(records), "records": records}
