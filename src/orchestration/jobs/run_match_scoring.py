from src.api.schemas.matching import MatchRequest
from src.api.services.matching_service import rank_engineers


def run_demo_job() -> list[dict[str, str | float]]:
    request = MatchRequest(job_title="Data Engineer", required_skills=["Python", "SQL"])
    return [match.model_dump() for match in rank_engineers(request)]
