def ingest_github_metadata() -> dict[str, object]:
    return {
        "source": "github_metadata",
        "records_loaded": 2,
        "records": [
            {"engineer_id": "eng-001", "repository_name": "claims-platform-etl", "primary_language": "Python"},
            {"engineer_id": "eng-002", "repository_name": "platform-cluster-modules", "primary_language": "HCL"},
        ],
    }
