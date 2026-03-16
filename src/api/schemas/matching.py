from pydantic import BaseModel, Field


class MatchRequest(BaseModel):
    job_title: str
    required_skills: list[str] = Field(default_factory=list)
    required_technologies: list[str] = Field(default_factory=list)
    location: str | None = None


class MatchResult(BaseModel):
    engineer_id: str
    engineer_name: str
    score: float
    explanation: str


class MatchResponse(BaseModel):
    matches: list[MatchResult]
