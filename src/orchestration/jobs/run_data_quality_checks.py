from pathlib import Path


def run_data_quality_checks(sql_root: str | Path = "sql") -> dict[str, object]:
    sql_files = ["schema.sql", "procedures.sql", "marts.sql", "tests.sql"]
    available = [name for name in sql_files if (Path(sql_root) / name).exists()]
    return {"checks_defined": len(available), "sql_files": available}
