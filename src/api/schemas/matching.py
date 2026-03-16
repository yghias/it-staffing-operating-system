from pydantic import BaseModel, Field


class MatchRequest(BaseModel):
    job_title: str
    required_skills: list[str] = Field(default_factory=list)
    required_technologies: list[str] = Field(default_factory=list)
    location: str | None = None
    preferred_domains: list[str] = Field(default_factory=list)
    client_industry: str | None = None
    minimum_seniority: str | None = None
    max_rate: int | None = None


class MatchResult(BaseModel):
    engineer_id: str
    engineer_name: str
    score: float
    confidence: float
    review_required: bool
    matched_skills: list[str] = Field(default_factory=list)
    matched_technologies: list[str] = Field(default_factory=list)
    explanation: str


class MatchResponse(BaseModel):
    matches: list[MatchResult]
