from src.common.utils.text import normalize_token


def entity_match_score(left: str, right: str) -> float:
    left_tokens = set(normalize_token(left).split())
    right_tokens = set(normalize_token(right).split())
    if not left_tokens or not right_tokens:
        return 0.0
    return len(left_tokens & right_tokens) / len(left_tokens | right_tokens)
