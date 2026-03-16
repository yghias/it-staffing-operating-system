from src.graph.loaders.neo4j_loader import export_edges_for_loader


def refresh_graph_projection() -> dict[str, object]:
    edges = export_edges_for_loader()
    return {"edges_exported": len(edges)}
