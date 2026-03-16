from src.api.schemas.matching import MatchRequest
from src.api.services.matching_service import rank_engineers


def test_rank_engineers_returns_sorted_matches() -> None:
    request = MatchRequest(
        job_title="Data Engineer",
        required_skills=["Python", "SQL", "Data Modeling"],
        required_technologies=["AWS", "Snowflake"],
        preferred_domains=["healthcare"],
        client_industry="healthcare",
        minimum_seniority="senior",
        location="Detroit MI",
        max_rate=120,
    )
    matches = rank_engineers(request)
    assert matches[0].engineer_name == "Jordan Lee"
    assert matches[0].score >= matches[1].score
    assert matches[0].review_required is False
    assert "python" in matches[0].matched_skills
