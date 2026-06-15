"""Generate the Python-backed BI reports as JSON for the in-app dashboard.
"""
import json
import os
from collections import Counter
from datetime import datetime
from itertools import combinations

import numpy as np
import pandas as pd

from troika_data import load_tables, prepare

OUT_DIR = os.getenv("TROIKA_REPORTS_DIR") or os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "App_Data", "reports"
)


def _today():
    return datetime.now().strftime("%Y-%m-%d")


def _num(x, n=2):
    try:
        return round(float(x), n)
    except (TypeError, ValueError):
        return 0.0


# ---------------------------------------------------------------------------
#  Customers — RFM segmentation, new vs returning, top customers, repeat rate
# ---------------------------------------------------------------------------
def build_customers(sale, customer):
    orders = sale.dropna(subset=["CustomerID"])
    empty = {"generatedAt": _today(), "rfm": {"segments": []}, "newVsReturning": [],
             "topCustomers": [], "repeatRate": 0.0}
    if orders.empty:
        return empty

    snapshot = orders["dateOfIssue"].max()
    g = (orders.groupby("CustomerID")
         .agg(Recency=("dateOfIssue", lambda s: (snapshot - s.max()).days),
              Frequency=("receiptNum", "nunique"),
              Monetary=("paymentTotal", "sum"))
         .reset_index())

    def score(series, reverse=False):
        # quartile score 1..4; rank first so duplicate values don't break qcut
        try:
            q = pd.qcut(series.rank(method="first"), 4, labels=[1, 2, 3, 4]).astype(int)
        except (ValueError, IndexError):
            q = pd.Series([2] * len(series), index=series.index)
        return (5 - q) if reverse else q

    g["R"] = score(g["Recency"], reverse=True)   # more recent -> higher
    g["F"] = score(g["Frequency"])
    g["M"] = score(g["Monetary"])

    def segment(row):
        r, f, m = row["R"], row["F"], row["M"]
        if r >= 3 and f >= 3 and m >= 3:
            return "Champions"
        if f >= 3 and r >= 2:
            return "Loyal"
        if m >= 4:
            return "Big spenders"
        if r >= 3 and f <= 2:
            return "New / promising"
        if r <= 2 and f >= 3:
            return "At risk"
        if r <= 2 and f <= 2:
            return "Hibernating"
        return "Others"

    g["Segment"] = g.apply(segment, axis=1)
    seg = (g.groupby("Segment")
           .agg(Customers=("CustomerID", "nunique"), Revenue=("Monetary", "sum"))
           .reset_index().sort_values("Customers", ascending=False))
    segments = [{"Label": s, "Customers": int(c), "Revenue": _num(rv)}
                for s, c, rv in zip(seg["Segment"], seg["Customers"], seg["Revenue"])]

    # new vs returning per month
    first_month = orders.groupby("CustomerID")["dateOfIssue"].min().dt.to_period("M").astype(str)
    new_per_month = first_month.value_counts()
    active = orders.groupby("YearMonth")["CustomerID"].nunique()
    nvr = []
    for m in sorted(active.index):
        n = int(new_per_month.get(m, 0))
        a = int(active.get(m, 0))
        nvr.append({"Label": m, "New": n, "Returning": max(a - n, 0)})

    # top customers (labelled by email when available, else id)
    label_map = {}
    id_col = "customerID" if "customerID" in customer.columns else customer.columns[0]
    if "email" in customer.columns:
        for _, row in customer.iterrows():
            email = row.get("email")
            label_map[str(row[id_col])] = str(email) if email not in (None, "") and not pd.isna(email) else f"Customer #{row[id_col]}"
    top = (orders.groupby("CustomerID")
           .agg(Orders=("receiptNum", "nunique"), Revenue=("paymentTotal", "sum"))
           .reset_index())
    top["AOV"] = top["Revenue"] / top["Orders"].clip(lower=1)
    top = top.sort_values("Revenue", ascending=False).head(10)
    top_customers = [{"Customer": label_map.get(str(cid), f"Customer #{cid}"),
                      "Orders": int(o), "Revenue": _num(r), "AOV": _num(a)}
                     for cid, o, r, a in zip(top["CustomerID"], top["Orders"], top["Revenue"], top["AOV"])]

    return {
        "generatedAt": _today(),
        "rfm": {"segments": segments},
        "newVsReturning": nvr,
        "topCustomers": top_customers,
        "repeatRate": _num((g["Frequency"] >= 2).mean(), 3),
    }


# ---------------------------------------------------------------------------
#  Basket — per-order stats, items distribution, frequently bought together
# ---------------------------------------------------------------------------
def build_basket(sale, lines):
    li = lines.dropna(subset=["receiptID"])
    empty = {"generatedAt": _today(), "perOrder": {"avgItems": 0, "avgValue": 0, "avgLines": 0},
             "unitsDistribution": [], "affinity": []}
    if li.empty:
        return empty

    items_per_order = li.groupby("receiptID")["quantity"].sum()
    lines_per_order = li.groupby("receiptID").size()

    def bucket(n):
        n = int(n)
        if n <= 0:
            return "0"
        return "5+" if n >= 5 else str(n)

    dist = items_per_order.apply(bucket).value_counts()
    units_distribution = [{"Label": k, "Value": int(dist.get(k, 0))} for k in ["1", "2", "3", "4", "5+"]]

    # co-purchase pairs
    baskets = li.dropna(subset=["ProductName"]).groupby("receiptID")["ProductName"].apply(lambda s: sorted(set(s)))
    total = len(baskets)
    singles, pairs = Counter(), Counter()
    for items in baskets:
        for it in items:
            singles[it] += 1
        for a, b in combinations(items, 2):
            pairs[(a, b)] += 1

    def affinity_rows(min_count):
        rows = []
        for (a, b), cnt in pairs.items():
            if cnt < min_count or total == 0 or not singles[a] or not singles[b]:
                continue
            support = cnt / total
            confidence = cnt / singles[a]
            lift = support / ((singles[a] / total) * (singles[b] / total))
            rows.append({"A": a, "B": b, "Support": round(support, 4),
                         "Confidence": round(confidence, 4), "Lift": round(lift, 2), "_c": cnt})
        rows.sort(key=lambda r: (r["Lift"], r["_c"]), reverse=True)
        return rows

    rows = affinity_rows(2) or affinity_rows(1)   # relax for very small datasets
    for r in rows:
        r.pop("_c", None)

    return {
        "generatedAt": _today(),
        "perOrder": {
            "avgItems": _num(items_per_order.mean(), 2),
            "avgValue": _num(sale["paymentTotal"].mean(), 2) if len(sale) else 0,
            "avgLines": _num(lines_per_order.mean(), 2),
        },
        "unitsDistribution": units_distribution,
        "affinity": rows[:12],
    }


# ---------------------------------------------------------------------------
#  Forecast — monthly revenue history + 3-month projection
# ---------------------------------------------------------------------------
def build_forecast(sale):
    monthly = (sale.groupby("YearMonth", as_index=False)
               .agg(Revenue=("paymentTotal", "sum")).sort_values("YearMonth"))
    history = [{"Label": ym, "Revenue": _num(rv)} for ym, rv in zip(monthly["YearMonth"], monthly["Revenue"])]
    forecast = []

    if len(monthly) >= 2:
        y = monthly["Revenue"].values.astype(float)
        x = np.arange(len(y))
        slope, intercept = np.polyfit(x, y, 1)
        lin = slope * np.arange(len(y), len(y) + 3) + intercept

        hw_vals = [None, None, None]
        try:
            from statsmodels.tsa.holtwinters import ExponentialSmoothing
            if len(y) >= 6:
                hw = ExponentialSmoothing(y, trend="add").fit().forecast(3)
                hw_vals = [_num(v) for v in hw]
        except Exception:
            pass

        last = pd.Period(str(monthly["YearMonth"].iloc[-1]), freq="M")
        for i in range(3):
            row = {"Label": str(last + i + 1), "Linear": _num(max(lin[i], 0))}
            if hw_vals[i] is not None:
                row["HoltWinters"] = _num(max(hw_vals[i], 0))
            forecast.append(row)

    return {"generatedAt": _today(), "history": history, "forecast": forecast}


def _write(name, obj):
    path = os.path.join(OUT_DIR, name)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(obj, fh, ensure_ascii=False, indent=2)
    print("wrote", os.path.relpath(path))


def main():
    sale, sold, product, customer = load_tables()
    sale, lines = prepare(sale, sold, product, customer)
    os.makedirs(OUT_DIR, exist_ok=True)

    _write("customers.json", build_customers(sale, customer))
    _write("basket.json", build_basket(sale, lines))
    _write("forecast.json", build_forecast(sale))
    print("Done. Reports written to", os.path.abspath(OUT_DIR))


if __name__ == "__main__":
    main()
