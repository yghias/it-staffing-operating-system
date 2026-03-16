from collections.abc import Sequence

from src.common.config.settings import get_settings

try:
    import psycopg
    from psycopg.rows import dict_row
except ImportError:  # pragma: no cover
    psycopg = None
    dict_row = None


def postgres_available() -> bool:
    settings = get_settings()
    return psycopg is not None and bool(settings.warehouse_dsn)


def fetch_all(query: str, params: Sequence | None = None) -> list[dict]:
    settings = get_settings()
    if psycopg is None or dict_row is None:
        raise RuntimeError("psycopg is not installed")
    with psycopg.connect(settings.warehouse_dsn, row_factory=dict_row) as conn:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
            return list(cur.fetchall())


def execute(query: str, params: Sequence | None = None) -> None:
    settings = get_settings()
    if psycopg is None:
        raise RuntimeError("psycopg is not installed")
    with psycopg.connect(settings.warehouse_dsn) as conn:
        with conn.cursor() as cur:
            cur.execute(query, params or ())
        conn.commit()
