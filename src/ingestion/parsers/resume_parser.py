def extract_resume_signals(text: str) -> dict[str, list[str]]:
    words = {token.strip(",.") for token in text.split()}
    return {
        "skills": sorted(word for word in words if word.lower() in {"python", "aws", "sql", "terraform"}),
        "technologies": sorted(word for word in words if word.lower() in {"python", "aws", "sql", "terraform"}),
    }
