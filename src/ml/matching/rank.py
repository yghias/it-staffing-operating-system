def score_candidate(required_skills: list[str], candidate_skills: list[str]) -> float:
    if not required_skills:
        return 0.0
    overlap = len(set(skill.lower() for skill in required_skills) & set(skill.lower() for skill in candidate_skills))
    return overlap / len(required_skills)
