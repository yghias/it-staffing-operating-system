import networkx as nx


def neighbors_for(node_name: str, graph: nx.DiGraph) -> list[str]:
    return sorted(graph.successors(node_name))
