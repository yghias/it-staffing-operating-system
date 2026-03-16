from src.api.schemas.matching import MatchRequest
from src.api.services.matching_service import rank_engineers
from src.common.db.postgres import execute, postgres_available


def run_demo_job() -> dict[str, object]:
    request = MatchRequest(
        job_title="Senior Data Engineer",
        required_skills=["Python", "SQL", "Data Modeling"],
        required_technologies=["AWS", "Snowflake", "dbt"],
        preferred_domains=["healthcare", "data_platform"],
        client_industry="healthcare",
        minimum_seniority="senior",
        location="Detroit MI",
        max_rate=120,
    )
    matches = [match.model_dump() for match in rank_engineers(request)]
    review_queue = [match for match in matches if match["review_required"]]
    if postgres_available():
        execute("call refresh_graph_edges()")
    return {
        "request": request.model_dump(),
        "matches": matches,
        "review_queue_count": len(review_queue),
        "top_match_id": matches[0]["engineer_id"] if matches else None,
    }
