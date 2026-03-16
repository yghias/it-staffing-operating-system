from collections.abc import Iterable

from src.api.schemas.domain import CandidateProfile
from src.api.schemas.matching import MatchRequest


SENIORITY_ORDER = {
    "junior": 1,
    "mid": 2,
    "senior": 3,
    "lead": 4,
    "principal": 5,
}


def _normalized(values: Iterable[str]) -> set[str]:
    return {value.strip().lower() for value in values if value.strip()}


def _overlap_ratio(required: set[str], actual: set[str]) -> float:
    if not required:
        return 1.0
    return len(required & actual) / len(required)


def _location_score(requested_location: str | None, candidate_location: str) -> float:
    if not requested_location:
        return 1.0
    requested = requested_location.strip().lower()
    actual = candidate_location.strip().lower()
    if requested == actual:
        return 1.0
    if requested == "remote" or actual == "remote":
        return 0.85
    return 0.35


def _availability_score(status: str) -> float:
    mapping = {
        "available_now": 1.0,
        "available_in_2_weeks": 0.85,
        "available_in_30_days": 0.60,
        "interviewing": 0.45,
    }
    return mapping.get(status, 0.40)


def _seniority_score(required_seniority: str | None, candidate_seniority: str) -> float:
    if not required_seniority:
        return 1.0
    required = SENIORITY_ORDER.get(required_seniority.lower(), 0)
    actual = SENIORITY_ORDER.get(candidate_seniority.lower(), 0)
    if actual >= required:
        return 1.0
    if actual == required - 1:
        return 0.60
    return 0.20


def score_candidate(request: MatchRequest, candidate: CandidateProfile) -> dict[str, object]:
    required_skills = _normalized(request.required_skills)
    required_technologies = _normalized(request.required_technologies)
    preferred_domains = _normalized(request.preferred_domains)
    candidate_skills = _normalized(candidate.skills)
    candidate_technologies = _normalized(candidate.technologies)
    candidate_domains = _normalized(candidate.domains)
    client_industries = _normalized(candidate.recent_client_industries)

    skill_score = _overlap_ratio(required_skills, candidate_skills)
    technology_score = _overlap_ratio(required_technologies, candidate_technologies)
    domain_score = _overlap_ratio(preferred_domains, candidate_domains)
    location_score = _location_score(request.location, candidate.location)
    availability_score = _availability_score(candidate.availability_status)
    seniority_score = _seniority_score(request.minimum_seniority, candidate.seniority)
    industry_score = 1.0 if request.client_industry and request.client_industry.lower() in client_industries else 0.60
    rate_score = 1.0 if request.max_rate is None or candidate.rate_band <= request.max_rate else 0.35
    freshness_score = max(0.35, 1 - (candidate.last_profile_refresh_days / 120))
    outcome_score = candidate.placement_success_rate

    score = (
        skill_score * 0.24
        + technology_score * 0.22
        + domain_score * 0.10
        + industry_score * 0.08
        + location_score * 0.08
        + availability_score * 0.10
        + seniority_score * 0.06
        + rate_score * 0.04
        + freshness_score * 0.03
        + outcome_score * 0.05
    )
    confidence = min(0.99, score * 0.85 + freshness_score * 0.10 + outcome_score * 0.05)
    review_required = confidence < 0.68 or skill_score < 0.50 or technology_score < 0.50

    matched_skills = sorted(required_skills & candidate_skills)
    matched_technologies = sorted(required_technologies & candidate_technologies)

    evidence_parts = [
        f"{len(matched_skills)}/{max(1, len(required_skills))} required skills matched",
        f"{len(matched_technologies)}/{max(1, len(required_technologies))} required technologies matched",
        f"availability {candidate.availability_status.replace('_', ' ')}",
        f"profile refreshed {candidate.last_profile_refresh_days} days ago",
    ]
    if request.client_industry and request.client_industry.lower() in client_industries:
        evidence_parts.append(f"recent {request.client_industry} delivery experience")
    if preferred_domains and preferred_domains & candidate_domains:
        evidence_parts.append("domain overlap present")

    explanation = "; ".join(evidence_parts)
    return {
        "score": round(score, 4),
        "confidence": round(confidence, 4),
        "review_required": review_required,
        "matched_skills": matched_skills,
        "matched_technologies": matched_technologies,
        "explanation": explanation,
    }
