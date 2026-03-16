def precision_at_k(relevant_positions: list[int], k: int) -> float:
    if k <= 0:
        return 0.0
    hits = sum(1 for position in relevant_positions if position <= k)
    return hits / k
