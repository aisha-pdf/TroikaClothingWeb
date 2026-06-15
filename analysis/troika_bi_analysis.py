import numpy as np
import pandas as pd
import plotly.express as px
import plotly.io as pio

from troika_data import load_tables, prepare

pio.templates.default = "plotly_white"
pd.options.display.float_format = lambda v: f"{v:,.2f}"

sale, sold, product, customer = load_tables()
print("Rows loaded:",
      {"Sale": len(sale), "ProductSold": len(sold), "Product": len(product), "Customer": len(customer)})


sale, lines = prepare(sale, sold, product, customer)
lines.head()

kpis = {
    "Total Revenue (R)": sale["paymentTotal"].sum(),
    "Orders": sale["receiptNum"].nunique(),
    "Avg Order Value (R)": sale["paymentTotal"].sum() / max(sale["receiptNum"].nunique(), 1),
    "Units Sold": int(lines["quantity"].sum()),
    "Unique Customers": sale["CustomerID"].nunique(),
    "Completion Rate": (sale["salesStatus"].eq("Completed").mean() if len(sale) else 0),
}
pd.Series(kpis).to_frame("Value")


monthly = (
    sale.groupby("YearMonth", as_index=False)
        .agg(Revenue=("paymentTotal", "sum"), Orders=("receiptNum", "nunique"))
        .sort_values("YearMonth")
)
monthly["MovingAvg3"] = monthly["Revenue"].rolling(3, min_periods=1).mean()

fig = px.line(monthly, x="YearMonth", y=["Revenue", "MovingAvg3"], markers=True,
              title="Monthly Revenue & 3-Month Average",
              labels={"value": "Revenue (R)", "YearMonth": "Month", "variable": ""})
fig.show()


by_category = (
    lines.groupby("Category", as_index=False)
         .agg(Revenue=("LineRevenue", "sum"), Units=("quantity", "sum"))
         .sort_values("Revenue", ascending=False)
)
px.bar(by_category, x="Category", y="Revenue", title="Revenue by Category",
       labels={"Revenue": "Revenue (R)"}).show()

top_products = (
    lines.groupby("ProductName", as_index=False)
         .agg(Units=("quantity", "sum"), Revenue=("LineRevenue", "sum"))
         .sort_values("Units", ascending=False)
         .head(10)
)
px.bar(top_products.sort_values("Units"), x="Units", y="ProductName", orientation="h",
       title="Top 10 Products by Units Sold").show()


payment = sale.groupby("paymentMethod", as_index=False).agg(Orders=("receiptNum", "nunique"))
px.pie(payment, names="paymentMethod", values="Orders", hole=0.45,
       title="Orders by Payment Method").show()

channel = sale.groupby("saleChannel", as_index=False).agg(Revenue=("paymentTotal", "sum"))
px.pie(channel, names="saleChannel", values="Revenue", hole=0.45,
       title="Revenue by Sales Channel").show()

status = (
    sale.groupby("salesStatus", as_index=False)
        .agg(Orders=("receiptNum", "nunique"))
        .sort_values("Orders", ascending=False)
)
px.funnel(status, x="Orders", y="salesStatus", title="Order Status Funnel").show()


sale_geo = sale.merge(customer[["customerID", "suburb"]], left_on="CustomerID",
                      right_on="customerID", how="left")
sale_geo["suburb"] = sale_geo["suburb"].fillna("Unknown").replace("", "Unknown")
region = (
    sale_geo.groupby("suburb", as_index=False)
            .agg(Revenue=("paymentTotal", "sum"), Orders=("receiptNum", "nunique"))
            .sort_values("Revenue", ascending=False)
            .head(10)
)
px.bar(region.sort_values("Revenue"), x="Revenue", y="suburb", orientation="h",
       title="Top Suburbs by Revenue", labels={"Revenue": "Revenue (R)"}).show()


size = lines.assign(clothingSize=lines["clothingSize"].fillna("N/A").replace("", "N/A"))
size = size.groupby("clothingSize", as_index=False).agg(Units=("quantity", "sum"))
px.bar(size.sort_values("Units", ascending=False), x="clothingSize", y="Units",
       title="Units Sold by Size").show()

colour = lines.assign(colour=lines["colour"].fillna("N/A").replace("", "N/A"))
colour = colour.groupby("colour", as_index=False).agg(Units=("quantity", "sum"))
px.bar(colour.sort_values("Units", ascending=False), x="colour", y="Units",
       title="Units Sold by Colour").show()


month_order = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
by_month = sale.groupby("MonthName", as_index=False).agg(Revenue=("paymentTotal", "sum"))
by_month["MonthName"] = pd.Categorical(by_month["MonthName"], categories=month_order, ordered=True)
px.bar(by_month.sort_values("MonthName"), x="MonthName", y="Revenue",
       title="Revenue by Calendar Month (seasonality)", labels={"Revenue": "Revenue (R)"}).show()

weekday_order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
by_weekday = sale.groupby("Weekday", as_index=False).agg(Orders=("receiptNum", "nunique"))
by_weekday["Weekday"] = pd.Categorical(by_weekday["Weekday"], categories=weekday_order, ordered=True)
px.bar(by_weekday.sort_values("Weekday"), x="Weekday", y="Orders",
       title="Orders by Day of Week").show()


hist = monthly.reset_index(drop=True).copy()
x = np.arange(len(hist))
forecast_df = None

if len(hist) >= 2:
    slope, intercept = np.polyfit(x, hist["Revenue"].values, 1)
    future_idx = np.arange(len(hist), len(hist) + 3)
    future_labels = [f"F+{i + 1}" for i in range(3)]
    linear_forecast = slope * future_idx + intercept

    forecast_df = pd.DataFrame({
        "Period": list(hist["YearMonth"]) + future_labels,
        "Revenue": list(hist["Revenue"]) + [np.nan] * 3,
        "LinearForecast": list(slope * x + intercept) + list(linear_forecast),
    })

    try:
        from statsmodels.tsa.holtwinters import ExponentialSmoothing

        if len(hist) >= 6:
            model = ExponentialSmoothing(hist["Revenue"], trend="add").fit()
            hw = model.forecast(3)
            forecast_df["HoltWinters"] = list(model.fittedvalues) + list(hw)
    except Exception as exc:  # statsmodels missing or model failed — linear is enough
        print("Holt-Winters skipped:", exc)

    ycols = [c for c in ["Revenue", "LinearForecast", "HoltWinters"] if c in forecast_df.columns]
    px.line(forecast_df, x="Period", y=ycols, markers=True,
            title="Revenue Forecast (next 3 months)",
            labels={"value": "Revenue (R)", "variable": ""}).show()
else:
    print("Not enough monthly history to forecast.")

forecast_df

top_customers = (
    sale.groupby("CustomerID", as_index=False)
        .agg(TotalSpend=("paymentTotal", "sum"), Orders=("receiptNum", "nunique"))
        .assign(AvgOrderValue=lambda d: d["TotalSpend"] / d["Orders"].clip(lower=1))
        .sort_values("TotalSpend", ascending=False)
        .head(10)
)
top_customers


