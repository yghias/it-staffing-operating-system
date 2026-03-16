from src.api.schemas.matching import MatchRequest, MatchResult
from src.api.services.sql_matching_service import rank_engineers_in_sql
from src.common.db.postgres import postgres_available
from src.ml.matching.scoring import score_candidate
from src.ml.matching.talent_inventory import TALENT_INVENTORY


def rank_engineers(request: MatchRequest) -> list[MatchResult]:
    if postgres_available():
        return rank_engineers_in_sql(request)
    ranked = sorted(
        (
            _build_match_result(request, candidate)
            for candidate in TALENT_INVENTORY
        ),
        key=lambda item: item.score,
        reverse=True,
    )
    return ranked


def _build_match_result(request: MatchRequest, candidate) -> MatchResult:
    result = score_candidate(request, candidate)
    return MatchResult(
        engineer_id=candidate.engineer_id,
        engineer_name=candidate.engineer_name,
        score=result["score"],
        confidence=result["confidence"],
        review_required=result["review_required"],
        matched_skills=result["matched_skills"],
        matched_technologies=result["matched_technologies"],
        explanation=result["explanation"],
    )
