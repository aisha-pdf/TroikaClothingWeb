using System.Data;
using Newtonsoft.Json;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class ReportService
    {
        private readonly IReportRepository _reportRepository;

        public ReportService() : this(new ReportRepository()) { }

        public ReportService(IReportRepository reportRepository)
        {
            _reportRepository = reportRepository;
        }

        // --- Legacy single-chart helpers (still available) ---
        public string GetMonthlySalesJson()
        {
            return ToJson(_reportRepository.GetMonthlySales());
        }

        public string GetPaymentMethodJson()
        {
            return ToJson(_reportRepository.GetPaymentMethodBreakdown());
        }

        public string GetSalesChannelJson()
        {
            return ToJson(_reportRepository.GetSalesChannelBreakdown());
        }

        public string ToJson(DataTable table)
        {
            return JsonConvert.SerializeObject(table);
        }

        /// <summary>
        /// Builds the entire interactive-dashboard payload (KPIs + every chart +
        /// filter option lists) for the given filter and serialises it to JSON.
        /// Consumed by Admin Pages/ReportDataHandler.ashx.
        /// </summary>
        public string GetDashboardJson(ReportFilter filter)
        {
            var payload = new
            {
                report = "overview",
                kpis = _reportRepository.GetKpis(filter),
                trend = _reportRepository.GetSalesTrend(filter),
                category = _reportRepository.GetRevenueByCategory(filter),
                topProducts = _reportRepository.GetTopProducts(filter, 10),
                payment = _reportRepository.GetPaymentBreakdown(filter),
                channel = _reportRepository.GetChannelBreakdown(filter),
                status = _reportRepository.GetStatusBreakdown(filter),
                region = _reportRepository.GetSalesByRegion(filter, 8),
                size = _reportRepository.GetSizeBreakdown(filter),
                colour = _reportRepository.GetColourBreakdown(filter),
                filterOptions = FilterOptions()
            };

            return JsonConvert.SerializeObject(payload);
        }

        /// <summary>
        /// Builds the payload for a single, focused report (the report-picker dropdown).
        /// SQL-backed reports honour <paramref name="filter"/> live; the analytical reports
        /// (customers, basket, seasonality-forecast) embed the latest Python snapshot from
        /// App_Data/reports/*.json (null when it hasn't been generated yet). Unknown report
        /// keys fall back to the full overview payload.
        /// </summary>
        public string GetReportJson(string report, ReportFilter filter)
        {
            report = (report ?? "overview").Trim().ToLowerInvariant();
            object payload;

            switch (report)
            {
                case "sales":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        trend = _reportRepository.GetSalesTrend(filter),
                        trendDaily = _reportRepository.GetSalesTrendDaily(filter),
                        aov = _reportRepository.GetAovTrend(filter),
                        payment = _reportRepository.GetPaymentBreakdown(filter),
                        channel = _reportRepository.GetChannelBreakdown(filter),
                        status = _reportRepository.GetStatusBreakdown(filter),
                        filterOptions = FilterOptions()
                    };
                    break;

                case "products":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        category = _reportRepository.GetRevenueByCategory(filter),
                        topProducts = _reportRepository.GetTopProducts(filter, 10),
                        size = _reportRepository.GetSizeBreakdown(filter),
                        colour = _reportRepository.GetColourBreakdown(filter),
                        categoryMix = _reportRepository.GetCategoryMixOverTime(filter),
                        filterOptions = FilterOptions()
                    };
                    break;

                case "operations":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        statusTrend = _reportRepository.GetStatusTrend(filter),
                        completion = _reportRepository.GetCompletionTrend(filter),
                        leadTime = _reportRepository.GetLeadTimeByCategory(filter),
                        delivery = _reportRepository.GetDeliverySplit(filter),
                        status = _reportRepository.GetStatusBreakdown(filter),
                        filterOptions = FilterOptions()
                    };
                    break;

                case "seasonality":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        byMonth = _reportRepository.GetSeasonByMonth(filter),
                        byWeekday = _reportRepository.GetSeasonByWeekday(filter),
                        byHour = _reportRepository.GetSeasonByHour(filter),
                        python = ReadPythonReport("forecast"),
                        filterOptions = FilterOptions()
                    };
                    break;

                case "geography":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        region = _reportRepository.GetSalesByRegion(filter, 12),
                        filterOptions = FilterOptions()
                    };
                    break;

                case "customers":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        python = ReadPythonReport("customers"),
                        filterOptions = FilterOptions()
                    };
                    break;

                case "basket":
                    payload = new
                    {
                        report,
                        kpis = _reportRepository.GetKpis(filter),
                        python = ReadPythonReport("basket"),
                        filterOptions = FilterOptions()
                    };
                    break;

                default:
                    return GetDashboardJson(filter);
            }

            return JsonConvert.SerializeObject(payload);
        }

        private object FilterOptions()
        {
            return new
            {
                statuses = _reportRepository.GetDistinctStatuses(),
                channels = _reportRepository.GetDistinctChannels()
            };
        }

        /// <summary>
        /// Returns the parsed contents of App_Data/reports/{name}.json (written by the offline
        /// Python report-builder), or null if it hasn't been generated / can't be read. The
        /// front-end shows a "run the Python builder" note when this is null.
        /// </summary>
        private static object ReadPythonReport(string name)
        {
            try
            {
                string path = System.Web.Hosting.HostingEnvironment.MapPath("~/App_Data/reports/" + name + ".json");
                if (string.IsNullOrEmpty(path) || !System.IO.File.Exists(path)) return null;

                string json = System.IO.File.ReadAllText(path);
                return string.IsNullOrWhiteSpace(json) ? null : JsonConvert.DeserializeObject(json);
            }
            catch
            {
                return null;
            }
        }
    }
}
