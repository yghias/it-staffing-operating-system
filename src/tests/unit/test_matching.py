from src.api.schemas.matching import MatchRequest
from src.api.services.matching_service import rank_engineers


def test_rank_engineers_returns_sorted_matches() -> None:
    request = MatchRequest(job_title="Data Engineer", required_skills=["Python", "SQL"])
    matches = rank_engineers(request)
    assert matches[0].engineer_name == "Jordan Lee"
    assert matches[0].score >= matches[1].score
