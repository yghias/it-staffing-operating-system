import networkx as nx

from src.ml.matching.talent_inventory import TALENT_INVENTORY
from src.graph.builders.projections import graph_edges_for_candidate


def build_demo_graph() -> nx.DiGraph:
    graph = nx.DiGraph()
    for candidate in TALENT_INVENTORY:
        graph.add_node(f"Engineer:{candidate.engineer_id}", label=candidate.engineer_name, type="Engineer")
        for edge in graph_edges_for_candidate(candidate):
            graph.add_edge(
                edge["from_node"],
                edge["to_node"],
                relationship=edge["relationship"],
                strength_score=edge["strength_score"],
            )
    graph.add_edge("Role:Data Engineer", "Skill:Python", relationship="ROLE_REQUIRES_SKILL")
    graph.add_edge("Role:Data Engineer", "Technology:AWS", relationship="ROLE_REQUIRES_TECH")
    return graph
