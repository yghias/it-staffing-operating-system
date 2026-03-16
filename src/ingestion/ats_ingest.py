from pathlib import Path

from src.ingestion.file_loader import read_csv_records


def ingest_ats_candidates(sample_root: str | Path = "sample_data/raw") -> dict[str, object]:
    records = read_csv_records(Path(sample_root) / "ats_candidate.csv")
    return {"source": "ats_candidate", "records_loaded": len(records), "records": records}
