from src.api.schemas.matching import MatchRequest
from src.ml.matching.scoring import score_candidate as score_candidate_for_request
from src.ml.matching.talent_inventory import TALENT_INVENTORY


def score_candidate(required_skills: list[str], candidate_skills: list[str]) -> float:
    request = MatchRequest(job_title="generic", required_skills=required_skills)
    candidate = next(
        (candidate for candidate in TALENT_INVENTORY if set(skill.lower() for skill in candidate.skills) == set(skill.lower() for skill in candidate_skills)),
        None,
    )
    if candidate is None:
        overlap = len(set(skill.lower() for skill in required_skills) & set(skill.lower() for skill in candidate_skills))
        return 0.0 if not required_skills else overlap / len(required_skills)
    return float(score_candidate_for_request(request, candidate)["score"])
