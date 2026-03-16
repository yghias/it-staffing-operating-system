def build_match_features(required_skills: list[str], candidate_skills: list[str]) -> dict[str, float]:
    overlap = len(set(required_skills) & set(candidate_skills))
    return {"skill_overlap": float(overlap)}
