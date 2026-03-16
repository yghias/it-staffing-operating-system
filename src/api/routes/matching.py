from fastapi import APIRouter

from src.api.schemas.matching import MatchRequest, MatchResponse
from src.api.services.matching_service import rank_engineers

router = APIRouter(prefix="/matching", tags=["matching"])


@router.post("/score", response_model=MatchResponse)
def score_opening(request: MatchRequest) -> MatchResponse:
    return MatchResponse(matches=rank_engineers(request))
