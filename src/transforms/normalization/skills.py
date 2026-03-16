SKILL_ALIASES = {
    "py": "Python",
    "postgres": "PostgreSQL",
    "k8s": "Kubernetes",
}


def normalize_skill(skill: str) -> str:
    return SKILL_ALIASES.get(skill.strip().lower(), skill.strip())
