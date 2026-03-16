def infer_domain(project_name: str) -> str:
    name = project_name.lower()
    if "health" in name:
        return "healthcare"
    if "bank" in name or "payment" in name:
        return "financial_services"
    return "general"
