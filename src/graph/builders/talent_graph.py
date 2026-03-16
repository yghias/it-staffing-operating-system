import networkx as nx


def build_demo_graph() -> nx.DiGraph:
    graph = nx.DiGraph()
    graph.add_edge("Engineer:Jordan Lee", "Skill:Python", relationship="ENGINEER_HAS_SKILL")
    graph.add_edge("Engineer:Jordan Lee", "Technology:AWS", relationship="ENGINEER_USED_TECH")
    graph.add_edge("Role:Data Engineer", "Skill:Python", relationship="ROLE_REQUIRES_SKILL")
    return graph
