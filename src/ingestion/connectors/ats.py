from dataclasses import dataclass


@dataclass
class ATSConnector:
    source_name: str = "example_ats"

    def fetch_candidates(self) -> list[dict[str, str]]:
        return [{"candidate_id": "cand-001", "name": "Jordan Lee"}]
