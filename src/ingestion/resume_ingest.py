from pathlib import Path


def ingest_resumes(sample_root: str | Path = "sample_data/resumes") -> dict[str, object]:
    sample_path = Path(sample_root)
    files = sorted(path.name for path in sample_path.glob("*") if path.is_file())
    return {"source": "resumes", "records_loaded": len(files), "files": files}
