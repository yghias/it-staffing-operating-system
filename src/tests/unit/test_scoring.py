from src.api.schemas.matching import MatchRequest
from src.ml.matching.scoring import score_candidate
from src.ml.matching.talent_inventory import TALENT_INVENTORY


def test_score_candidate_rewards_domain_and_technology_fit() -> None:
    request = MatchRequest(
        job_title="Senior Data Engineer",
        required_skills=["Python", "SQL"],
        required_technologies=["AWS", "dbt"],
        preferred_domains=["healthcare"],
        client_industry="healthcare",
        minimum_seniority="senior",
        location="Detroit MI",
        max_rate=120,
    )
    result = score_candidate(request, TALENT_INVENTORY[0])
    assert result["score"] > 0.80
    assert result["review_required"] is False


def test_score_candidate_routes_weaker_fit_to_review() -> None:
    request = MatchRequest(
        job_title="Senior Data Engineer",
        required_skills=["Python", "SQL", "Data Modeling"],
        required_technologies=["AWS", "Snowflake", "dbt"],
        preferred_domains=["healthcare"],
        client_industry="healthcare",
        minimum_seniority="senior",
        location="Detroit MI",
        max_rate=110,
    )
    result = score_candidate(request, TALENT_INVENTORY[1])
    assert result["review_required"] is True
