def run_warehouse_build() -> dict[str, object]:
    return {
        "tool": "dbt_or_snowflake_sql",
        "models_built": [
            "stg_ats_candidate",
            "stg_crm_job_opening",
            "stg_project_history",
            "int_engineer_skill_profile",
            "int_job_opening_requirements",
            "int_match_candidate_scores",
            "fct_match_score",
            "mart_supply_demand_gap",
        ],
    }
