from src.api.schemas.matching import MatchRequest, MatchResult
from src.ml.matching.rank import score_candidate


def rank_engineers(request: MatchRequest) -> list[MatchResult]:
    demo_candidates = [
        {"engineer_id": "eng-001", "engineer_name": "Jordan Lee", "skills": ["Python", "AWS", "SQL"]},
        {"engineer_id": "eng-002", "engineer_name": "Taylor Kim", "skills": ["Java", "Kubernetes", "Terraform"]},
    ]
    ranked = sorted(
        (
            MatchResult(
                engineer_id=candidate["engineer_id"],
                engineer_name=candidate["engineer_name"],
                score=score_candidate(request.required_skills, candidate["skills"]),
                explanation="Starter heuristic based on skill overlap.",
            )
            for candidate in demo_candidates
        ),
        key=lambda item: item.score,
        reverse=True,
    )
    return ranked
