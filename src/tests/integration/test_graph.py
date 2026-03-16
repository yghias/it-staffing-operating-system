from src.graph.builders.talent_graph import build_talent_graph
from src.graph.queries.similarity import neighbors_for


def test_talent_graph_contains_expected_edges() -> None:
    graph = build_talent_graph()
    assert "Skill:Python" in neighbors_for("Engineer:eng-001", graph)
