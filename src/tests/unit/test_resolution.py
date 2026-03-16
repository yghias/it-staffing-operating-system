from src.transforms.entity_resolution.resolve import entity_match_score


def test_entity_match_score_rewards_shared_tokens() -> None:
    assert entity_match_score("Acme Health Systems", "Acme Systems") > 0.3
