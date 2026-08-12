"""Run the full local analytics pipeline: load raw data, transform with dbt, test."""

import os
import shutil
import subprocess
import sys
from pathlib import Path

from prefect import flow, task

PROJECT_DIR = Path(__file__).resolve().parent.parent
DB_PATH = PROJECT_DIR / "analytics.duckdb"
VENV_BIN = Path(sys.executable).parent
DBT = VENV_BIN / "dbt"
DUCKDB = Path(shutil.which("duckdb") or "/opt/homebrew/bin/duckdb")


def _env() -> dict[str, str]:
    env = os.environ.copy()
    env["PATH"] = f"{VENV_BIN}:{env.get('PATH', '')}"
    return env


@task(name="load-raw-data", retries=1)
def load_raw_data() -> None:
    init_sql = (PROJECT_DIR / "init.sql").read_text()
    subprocess.run(
        [str(DUCKDB), str(DB_PATH)],
        input=init_sql,
        text=True,
        check=True,
        cwd=PROJECT_DIR,
        env=_env(),
    )


@task(name="dbt-command")
def run_dbt(command: str) -> None:
    subprocess.run(
        [str(DBT), command],
        cwd=PROJECT_DIR,
        check=True,
        env=_env(),
    )


@flow(name="analytics-pipeline", log_prints=True)
def analytics_pipeline() -> None:
    print(f"Project: {PROJECT_DIR}")
    print(f"Database: {DB_PATH}")
    load_raw_data()
    run_dbt("run")
    run_dbt("test")
    print("Pipeline completed successfully.")


if __name__ == "__main__":
    os.environ.setdefault("PREFECT_LOGGING_TO_API_ENABLED", "false")
    try:
        analytics_pipeline()
    except subprocess.CalledProcessError as exc:
        print(f"Pipeline failed: {exc}", file=sys.stderr)
        sys.exit(exc.returncode)
