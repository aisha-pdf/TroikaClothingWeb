"""Shared data loading for the Troika BI Python tools.

Both the analysis notebook (``troika_bi_analysis.py``) and the report builder
(``build_reports.py``) import from here, so the connection details and the
line-level table are defined once.

Configuration (env vars; only the password must be set, the rest default to the
project's known values):

    TROIKA_DB_PASSWORD   required unless TROIKA_USE_CSV=1
    TROIKA_DB_SERVER     default 146.230.177.46
    TROIKA_DB_NAME       default WstGrp10
    TROIKA_DB_USER       default WstGrp10
    TROIKA_ODBC_DRIVER   default "ODBC Driver 17 for SQL Server"
    TROIKA_USE_CSV=1     load ./data/*.csv instead of the live database
    TROIKA_CSV_DIR       default "data"
"""
import os
import urllib.parse

import pandas as pd

DB_SERVER = os.getenv("TROIKA_DB_SERVER", "146.230.177.46")
DB_NAME = os.getenv("TROIKA_DB_NAME", "WstGrp10")
DB_USER = os.getenv("TROIKA_DB_USER", "WstGrp10")
DB_PASSWORD = os.getenv("TROIKA_DB_PASSWORD", "")
ODBC_DRIVER = os.getenv("TROIKA_ODBC_DRIVER", "ODBC Driver 17 for SQL Server")

USE_CSV = os.getenv("TROIKA_USE_CSV", "").lower() in ("1", "true", "yes")
CSV_DIR = os.getenv("TROIKA_CSV_DIR", "data")

TABLES = ["Sale", "ProductSold", "Product", "Customer"]


def load_tables():
    """Return (sale, sold, product, customer) DataFrames from CSV or SQL Server."""
    if USE_CSV:
        return tuple(pd.read_csv(os.path.join(CSV_DIR, f"{t}.csv")) for t in TABLES)

    from sqlalchemy import create_engine

    odbc = (
        f"DRIVER={{{ODBC_DRIVER}}};SERVER={DB_SERVER};DATABASE={DB_NAME};"
        f"UID={DB_USER};PWD={DB_PASSWORD};TrustServerCertificate=yes"
    )
    engine = create_engine("mssql+pyodbc:///?odbc_connect=" + urllib.parse.quote_plus(odbc))
    return tuple(pd.read_sql(f"SELECT * FROM dbo.{t}", engine) for t in TABLES)


def prepare(sale, sold, product, customer):
    """Parse dates and build the **line-level** table (one row per item sold).

    Returns ``(sale, lines)`` where ``sale`` gains calendar helper columns and
    ``lines`` joins each sold item to its product and order with
    ``LineRevenue = Price * quantity`` (gross product value, before delivery).
    """
    sale = sale.copy()
    sale["dateOfIssue"] = pd.to_datetime(sale["dateOfIssue"], errors="coerce")
    sale["YearMonth"] = sale["dateOfIssue"].dt.to_period("M").astype(str)
    sale["MonthName"] = sale["dateOfIssue"].dt.strftime("%b")
    sale["MonthNum"] = sale["dateOfIssue"].dt.month
    sale["Weekday"] = sale["dateOfIssue"].dt.day_name()
    sale["paymentTotal"] = pd.to_numeric(sale["paymentTotal"], errors="coerce").fillna(0)

    lines = (
        sold.merge(product[["ProductID", "ProductName", "Category", "Price"]], on="ProductID", how="left")
            .merge(
                sale[["receiptNum", "dateOfIssue", "YearMonth", "saleChannel", "salesStatus", "paymentMethod", "CustomerID"]],
                left_on="receiptID", right_on="receiptNum", how="left",
            )
    )
    lines["Price"] = pd.to_numeric(lines["Price"], errors="coerce").fillna(0)
    lines["quantity"] = pd.to_numeric(lines["quantity"], errors="coerce").fillna(0)
    lines["LineRevenue"] = lines["Price"] * lines["quantity"]
    return sale, lines
