from src.graph.builders.talent_graph import build_demo_graph
from src.graph.queries.similarity import neighbors_for


def test_demo_graph_contains_expected_edges() -> None:
    graph = build_demo_graph()
    assert "Skill:Python" in neighbors_for("Engineer:Jordan Lee", graph)
