from src.graph.builders.talent_graph import build_talent_graph


def export_edges_for_loader() -> list[tuple[str, str, str]]:
    graph = build_talent_graph()
    return [
        (source, target, attributes["relationship"])
        for source, target, attributes in graph.edges(data=True)
    ]
