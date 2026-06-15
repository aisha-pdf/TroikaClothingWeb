using System.Collections.Generic;
using System.Data;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public interface IReportRepository
    {
        // --- Original methods (still used by any legacy callers) ---
        DataTable GetMonthlySales();
        DataTable GetPaymentMethodBreakdown();
        DataTable GetSalesChannelBreakdown();

        // --- Interactive dashboard (all honour ReportFilter) ---
        DashboardKpis GetKpis(ReportFilter filter);
        DataTable GetSalesTrend(ReportFilter filter);
        DataTable GetRevenueByCategory(ReportFilter filter);
        DataTable GetTopProducts(ReportFilter filter, int top);
        DataTable GetPaymentBreakdown(ReportFilter filter);
        DataTable GetChannelBreakdown(ReportFilter filter);
        DataTable GetStatusBreakdown(ReportFilter filter);
        DataTable GetSalesByRegion(ReportFilter filter, int top);
        DataTable GetSizeBreakdown(ReportFilter filter);
        DataTable GetColourBreakdown(ReportFilter filter);
        IList<string> GetDistinctStatuses();
        IList<string> GetDistinctChannels();

        // --- Grouped reports (added for the report picker) ---
        DataTable GetSalesTrendDaily(ReportFilter filter);   // Sales: revenue/orders by day
        DataTable GetAovTrend(ReportFilter filter);          // Sales: avg order value by month
        DataTable GetCategoryMixOverTime(ReportFilter filter); // Products: month x category revenue (long form)
        DataTable GetStatusTrend(ReportFilter filter);       // Operations: month x status counts (long form)
        DataTable GetCompletionTrend(ReportFilter filter);   // Operations: completion-rate % by month
        DataTable GetLeadTimeByCategory(ReportFilter filter);// Operations: avg production lead time by category
        DataTable GetDeliverySplit(ReportFilter filter);     // Operations: free vs paid delivery
        DataTable GetSeasonByMonth(ReportFilter filter);     // Seasonality: revenue by calendar month
        DataTable GetSeasonByWeekday(ReportFilter filter);   // Seasonality: orders by weekday
        DataTable GetSeasonByHour(ReportFilter filter);      // Seasonality: orders by hour of day
    }
}
