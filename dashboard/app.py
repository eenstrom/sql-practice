"""Simple BI dashboard over dbt marts in DuckDB."""

from pathlib import Path

import duckdb
import pandas as pd
import streamlit as st

PROJECT_DIR = Path(__file__).resolve().parent.parent
DB_PATH = PROJECT_DIR / "analytics.duckdb"

st.set_page_config(page_title="SQL Practice Dashboard", layout="wide")
st.title("Analytics Dashboard")
st.caption("Built from dbt marts in DuckDB")


@st.cache_data
def query(sql: str) -> pd.DataFrame:
    con = duckdb.connect(str(DB_PATH), read_only=True)
    try:
        return con.execute(sql).df()
    finally:
        con.close()


if not DB_PATH.exists():
    st.error(
        "Database not found. Run the pipeline first:\n\n"
        "`python orchestration/pipeline.py`"
    )
    st.stop()

revenue = query(
    """
    select country, order_count, total_revenue, avg_order_value
    from main_marts.rpt_revenue_by_country
    order by total_revenue desc
    """
)
orders = query(
    """
    select order_date, customer_name, country, product, category, amount
    from main_marts.fct_orders
    order by order_date desc
    """
)

total_revenue = revenue["total_revenue"].sum()
total_orders = int(orders.shape[0])
avg_order = orders["amount"].mean()

col1, col2, col3 = st.columns(3)
col1.metric("Completed orders", f"{total_orders:,}")
col2.metric("Total revenue", f"€{total_revenue:,.2f}")
col3.metric("Avg order value", f"€{avg_order:,.2f}")

st.subheader("Revenue by country")
st.bar_chart(revenue.set_index("country")["total_revenue"])
st.dataframe(revenue, use_container_width=True, hide_index=True)

st.subheader("Recent completed orders")
st.dataframe(orders, use_container_width=True, hide_index=True)
