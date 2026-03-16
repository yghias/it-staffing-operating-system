from src.common.utils.text import normalize_token


def normalize_title(title: str) -> str:
    return normalize_token(title).title()
