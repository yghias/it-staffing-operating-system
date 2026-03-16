from pydantic import BaseModel, Field


class CandidateProfile(BaseModel):
    engineer_id: str
    engineer_name: str
    location: str
    seniority: str
    availability_status: str
    rate_band: int
    skills: list[str] = Field(default_factory=list)
    technologies: list[str] = Field(default_factory=list)
    domains: list[str] = Field(default_factory=list)
    certifications: list[str] = Field(default_factory=list)
    recent_client_industries: list[str] = Field(default_factory=list)
    last_profile_refresh_days: int = 0
    placement_success_rate: float = 0.0
