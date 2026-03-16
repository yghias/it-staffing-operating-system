from src.api.schemas.domain import CandidateProfile
from src.common.constants.graph import GRAPH_RELATIONSHIPS


def graph_edges_for_candidate(candidate: CandidateProfile) -> list[dict[str, str | float]]:
    edges: list[dict[str, str | float]] = []
    for skill in candidate.skills:
        edges.append(
            {
                "from_node": f"Engineer:{candidate.engineer_id}",
                "relationship": GRAPH_RELATIONSHIPS["engineer_has_skill"],
                "to_node": f"Skill:{skill}",
                "strength_score": 0.90,
            }
        )
    for technology in candidate.technologies:
        edges.append(
            {
                "from_node": f"Engineer:{candidate.engineer_id}",
                "relationship": GRAPH_RELATIONSHIPS["engineer_used_tech"],
                "to_node": f"Technology:{technology}",
                "strength_score": 0.88,
            }
        )
    return edges
