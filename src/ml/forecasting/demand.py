def naive_demand_forecast(open_roles_last_period: int, growth_rate: float) -> int:
    return max(0, round(open_roles_last_period * (1 + growth_rate)))
