using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using TroikaClothingWeb.Data;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public class ReportRepository : IReportRepository
    {
        // ---------------------------------------------------------------------
        //  Original (unfiltered) methods - retained for backward compatibility
        // ---------------------------------------------------------------------
        public DataTable GetMonthlySales()
        {
            const string sql = @"
                SELECT CAST(YEAR(dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(dateOfIssue) AS VARCHAR(2)), 2) AS Month,
                       SUM(paymentTotal) AS TotalSales
                FROM dbo.Sale
                WHERE salesStatus = 'Completed'
                GROUP BY YEAR(dateOfIssue), MONTH(dateOfIssue)
                ORDER BY YEAR(dateOfIssue), MONTH(dateOfIssue);";

            return Db.ExecuteDataTable(sql, connectionName: Db.ReportsConnectionName);
        }

        public DataTable GetPaymentMethodBreakdown()
        {
            const string sql = @"
                SELECT paymentMethod, COUNT(*) AS TotalCount
                FROM dbo.Sale
                WHERE salesStatus = 'Completed'
                GROUP BY paymentMethod;";

            return Db.ExecuteDataTable(sql, connectionName: Db.ReportsConnectionName);
        }

        public DataTable GetSalesChannelBreakdown()
        {
            const string sql = @"
                SELECT saleChannel, COUNT(*) AS TotalSales
                FROM dbo.Sale
                WHERE salesStatus = 'Completed'
                GROUP BY saleChannel;";

            return Db.ExecuteDataTable(sql, connectionName: Db.ReportsConnectionName);
        }

        // ---------------------------------------------------------------------
        //  Interactive dashboard queries
        // ---------------------------------------------------------------------
        public DashboardKpis GetKpis(ReportFilter filter)
        {
            var kpis = new DashboardKpis();

            var saleSql = new StringBuilder(@"
                SELECT ISNULL(SUM(s.paymentTotal), 0)                                AS Revenue,
                       COUNT(*)                                                      AS Orders,
                       COUNT(DISTINCT s.CustomerID)                                  AS Customers,
                       SUM(CASE WHEN s.salesStatus = 'Completed' THEN 1 ELSE 0 END)  AS CompletedOrders
                FROM dbo.Sale s
                WHERE 1 = 1");

            using (SqlConnection con = Db.CreateConnection(Db.ReportsConnectionName))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;
                ApplyFilter(filter, "s", saleSql, cmd);
                cmd.CommandText = saleSql.ToString();
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        kpis.Revenue = ToDecimal(reader["Revenue"]);
                        kpis.Orders = ToInt(reader["Orders"]);
                        kpis.Customers = ToInt(reader["Customers"]);
                        kpis.CompletedOrders = ToInt(reader["CompletedOrders"]);
                    }
                }
            }

            var unitsSql = new StringBuilder(@"
                SELECT ISNULL(SUM(ps.quantity), 0) AS Units
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s ON s.receiptNum = ps.receiptID
                WHERE 1 = 1");

            using (SqlConnection con = Db.CreateConnection(Db.ReportsConnectionName))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;
                ApplyFilter(filter, "s", unitsSql, cmd);
                cmd.CommandText = unitsSql.ToString();
                con.Open();
                object value = cmd.ExecuteScalar();
                kpis.Units = value == null || value == DBNull.Value ? 0 : Convert.ToInt64(value);
            }

            kpis.AverageOrderValue = kpis.Orders > 0 ? Math.Round(kpis.Revenue / kpis.Orders, 2) : 0m;
            kpis.CompletionRate = kpis.Orders > 0 ? (double)kpis.CompletedOrders / kpis.Orders : 0d;
            return kpis;
        }

        public DataTable GetSalesTrend(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT CAST(YEAR(s.dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(s.dateOfIssue) AS VARCHAR(2)), 2) AS Label,
                       CAST(ISNULL(SUM(s.paymentTotal), 0) AS DECIMAL(18, 2)) AS Revenue,
                       COUNT(*) AS Orders
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)
                   ORDER BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)");
        }

        public DataTable GetRevenueByCategory(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT p.Category AS Label,
                       CAST(ISNULL(SUM(p.Price * ps.quantity), 0) AS DECIMAL(18, 2)) AS Revenue,
                       ISNULL(SUM(ps.quantity), 0) AS Units
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s    ON s.receiptNum = ps.receiptID
                INNER JOIN dbo.Product p ON p.ProductID = ps.ProductID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY p.Category ORDER BY Revenue DESC");
        }

        public DataTable GetTopProducts(ReportFilter filter, int top)
        {
            var sql = new StringBuilder(@"
                SELECT TOP (@Top) p.ProductName AS Label,
                       ISNULL(SUM(ps.quantity), 0) AS Units,
                       CAST(ISNULL(SUM(p.Price * ps.quantity), 0) AS DECIMAL(18, 2)) AS Revenue
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s    ON s.receiptNum = ps.receiptID
                INNER JOIN dbo.Product p ON p.ProductID = ps.ProductID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY p.ProductName ORDER BY Units DESC",
                cmd => cmd.Parameters.AddWithValue("@Top", Math.Max(1, top)));
        }

        public DataTable GetPaymentBreakdown(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT ISNULL(s.paymentMethod, 'Unknown') AS Label, COUNT(*) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY s.paymentMethod ORDER BY Value DESC");
        }

        public DataTable GetChannelBreakdown(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT ISNULL(s.saleChannel, 'Unknown') AS Label,
                       COUNT(*) AS Value,
                       CAST(ISNULL(SUM(s.paymentTotal), 0) AS DECIMAL(18, 2)) AS Revenue
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY s.saleChannel ORDER BY Value DESC");
        }

        public DataTable GetStatusBreakdown(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT ISNULL(s.salesStatus, 'Unknown') AS Label, COUNT(*) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY s.salesStatus ORDER BY Value DESC");
        }

        public DataTable GetSalesByRegion(ReportFilter filter, int top)
        {
            var sql = new StringBuilder(@"
                SELECT TOP (@Top) ISNULL(NULLIF(LTRIM(RTRIM(c.suburb)), ''), 'Unknown') AS Label,
                       CAST(ISNULL(SUM(s.paymentTotal), 0) AS DECIMAL(18, 2)) AS Revenue,
                       COUNT(*) AS Orders
                FROM dbo.Sale s
                LEFT JOIN dbo.Customer c ON c.customerID = s.CustomerID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(c.suburb)), ''), 'Unknown') ORDER BY Revenue DESC",
                cmd => cmd.Parameters.AddWithValue("@Top", Math.Max(1, top)));
        }

        public DataTable GetSizeBreakdown(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT ISNULL(NULLIF(LTRIM(RTRIM(ps.clothingSize)), ''), 'N/A') AS Label,
                       ISNULL(SUM(ps.quantity), 0) AS Value
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s ON s.receiptNum = ps.receiptID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(ps.clothingSize)), ''), 'N/A') ORDER BY Value DESC");
        }

        public DataTable GetColourBreakdown(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT ISNULL(NULLIF(LTRIM(RTRIM(ps.colour)), ''), 'N/A') AS Label,
                       ISNULL(SUM(ps.quantity), 0) AS Value
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s ON s.receiptNum = ps.receiptID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(ps.colour)), ''), 'N/A') ORDER BY Value DESC");
        }

        // ---------------------------------------------------------------------
        //  Grouped-report queries (added for the report picker)
        // ---------------------------------------------------------------------
        public DataTable GetSalesTrendDaily(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT CONVERT(VARCHAR(10), s.dateOfIssue, 23) AS Label,
                       CAST(ISNULL(SUM(s.paymentTotal), 0) AS DECIMAL(18, 2)) AS Revenue,
                       COUNT(*) AS Orders
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY CONVERT(VARCHAR(10), s.dateOfIssue, 23)
                   ORDER BY CONVERT(VARCHAR(10), s.dateOfIssue, 23)");
        }

        public DataTable GetAovTrend(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT CAST(YEAR(s.dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(s.dateOfIssue) AS VARCHAR(2)), 2) AS Label,
                       CAST(CASE WHEN COUNT(*) = 0 THEN 0 ELSE SUM(s.paymentTotal) / COUNT(*) END AS DECIMAL(18, 2)) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)
                   ORDER BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)");
        }

        public DataTable GetCategoryMixOverTime(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT CAST(YEAR(s.dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(s.dateOfIssue) AS VARCHAR(2)), 2) AS Label,
                       ISNULL(NULLIF(LTRIM(RTRIM(p.Category)), ''), 'Uncategorised') AS Category,
                       CAST(ISNULL(SUM(p.Price * ps.quantity), 0) AS DECIMAL(18, 2)) AS Revenue
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s    ON s.receiptNum = ps.receiptID
                INNER JOIN dbo.Product p ON p.ProductID = ps.ProductID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue), ISNULL(NULLIF(LTRIM(RTRIM(p.Category)), ''), 'Uncategorised')
                   ORDER BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)");
        }

        public DataTable GetStatusTrend(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT CAST(YEAR(s.dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(s.dateOfIssue) AS VARCHAR(2)), 2) AS Label,
                       ISNULL(s.salesStatus, 'Unknown') AS Status,
                       COUNT(*) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue), s.salesStatus
                   ORDER BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)");
        }

        public DataTable GetCompletionTrend(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT CAST(YEAR(s.dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(s.dateOfIssue) AS VARCHAR(2)), 2) AS Label,
                       CAST(CASE WHEN COUNT(*) = 0 THEN 0
                                 ELSE 100.0 * SUM(CASE WHEN s.salesStatus = 'Completed' THEN 1 ELSE 0 END) / COUNT(*)
                            END AS DECIMAL(5, 1)) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)
                   ORDER BY YEAR(s.dateOfIssue), MONTH(s.dateOfIssue)");
        }

        public DataTable GetLeadTimeByCategory(ReportFilter filter)
        {
            // ProductionTime may be stored as text; TRY_CONVERT keeps non-numeric values from erroring.
            var sql = new StringBuilder(@"
                SELECT ISNULL(NULLIF(LTRIM(RTRIM(p.Category)), ''), 'Uncategorised') AS Label,
                       CAST(ISNULL(AVG(CAST(TRY_CONVERT(INT, p.ProductionTime) AS FLOAT)), 0) AS DECIMAL(10, 1)) AS Value
                FROM dbo.ProductSold ps
                INNER JOIN dbo.Sale s    ON s.receiptNum = ps.receiptID
                INNER JOIN dbo.Product p ON p.ProductID = ps.ProductID
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY ISNULL(NULLIF(LTRIM(RTRIM(p.Category)), ''), 'Uncategorised')
                   ORDER BY Value DESC");
        }

        public DataTable GetDeliverySplit(ReportFilter filter)
        {
            // Per receipt: delivery = paymentTotal - sum(line value). > 0 => paid delivery, else free.
            var sql = new StringBuilder(@"
                SELECT CASE WHEN (s.paymentTotal - ISNULL(ld.LineTotal, 0)) > 0 THEN 'Paid delivery' ELSE 'Free delivery' END AS Label,
                       COUNT(*) AS Value,
                       CAST(ISNULL(SUM(CASE WHEN (s.paymentTotal - ISNULL(ld.LineTotal, 0)) > 0
                                            THEN (s.paymentTotal - ISNULL(ld.LineTotal, 0)) ELSE 0 END), 0) AS DECIMAL(18, 2)) AS Revenue
                FROM dbo.Sale s
                LEFT JOIN (
                    SELECT ps.receiptID, SUM(p.Price * ps.quantity) AS LineTotal
                    FROM dbo.ProductSold ps
                    INNER JOIN dbo.Product p ON p.ProductID = ps.ProductID
                    GROUP BY ps.receiptID
                ) ld ON ld.receiptID = s.receiptNum
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY CASE WHEN (s.paymentTotal - ISNULL(ld.LineTotal, 0)) > 0 THEN 'Paid delivery' ELSE 'Free delivery' END");
        }

        public DataTable GetSeasonByMonth(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT DATENAME(MONTH, s.dateOfIssue) AS Label,
                       CAST(ISNULL(SUM(s.paymentTotal), 0) AS DECIMAL(18, 2)) AS Revenue
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                @" GROUP BY DATENAME(MONTH, s.dateOfIssue), MONTH(s.dateOfIssue)
                   ORDER BY MONTH(s.dateOfIssue)");
        }

        public DataTable GetSeasonByWeekday(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT DATENAME(WEEKDAY, s.dateOfIssue) AS Label,
                       COUNT(*) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            // Day-of-week order is applied client-side (avoids @@DATEFIRST dependence).
            return FilteredQuery(filter, "s", sql,
                " GROUP BY DATENAME(WEEKDAY, s.dateOfIssue)");
        }

        public DataTable GetSeasonByHour(ReportFilter filter)
        {
            var sql = new StringBuilder(@"
                SELECT RIGHT('0' + CAST(DATEPART(HOUR, s.dateOfIssue) AS VARCHAR(2)), 2) + ':00' AS Label,
                       COUNT(*) AS Value
                FROM dbo.Sale s
                WHERE 1 = 1");

            return FilteredQuery(filter, "s", sql,
                " GROUP BY DATEPART(HOUR, s.dateOfIssue) ORDER BY DATEPART(HOUR, s.dateOfIssue)");
        }

        public IList<string> GetDistinctStatuses()
        {
            return DistinctValues("salesStatus");
        }

        public IList<string> GetDistinctChannels()
        {
            return DistinctValues("saleChannel");
        }

        // ---------------------------------------------------------------------
        //  Helpers
        // ---------------------------------------------------------------------

        /// <summary>
        /// Runs a SELECT whose body ends at "WHERE 1 = 1", appends the shared
        /// ReportFilter predicates (parameterised) and the supplied GROUP/ORDER
        /// tail, then returns the result as a DataTable. <paramref name="extra"/>
        /// lets a caller add additional parameters (e.g. @Top) before execution.
        /// </summary>
        private static DataTable FilteredQuery(ReportFilter filter, string saleAlias, StringBuilder sql, string tail, Action<SqlCommand> extra = null)
        {
            using (SqlConnection con = Db.CreateConnection(Db.ReportsConnectionName))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = con;
                extra?.Invoke(cmd);
                ApplyFilter(filter, saleAlias, sql, cmd);
                if (!string.IsNullOrEmpty(tail)) sql.Append(tail);
                cmd.CommandText = sql.ToString();

                con.Open();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    var table = new DataTable();
                    adapter.Fill(table);
                    return table;
                }
            }
        }

        /// <summary>Appends Sale-level filter predicates and their parameters (added once per command).</summary>
        private static void ApplyFilter(ReportFilter filter, string alias, StringBuilder sql, SqlCommand cmd)
        {
            if (filter == null) return;

            if (filter.From.HasValue)
            {
                sql.Append(" AND ").Append(alias).Append(".dateOfIssue >= @From");
                cmd.Parameters.AddWithValue("@From", filter.From.Value.Date);
            }

            if (filter.To.HasValue)
            {
                // Exclusive upper bound so the whole "To" day is included.
                sql.Append(" AND ").Append(alias).Append(".dateOfIssue < @ToExclusive");
                cmd.Parameters.AddWithValue("@ToExclusive", filter.To.Value.Date.AddDays(1));
            }

            if (!string.IsNullOrWhiteSpace(filter.Status))
            {
                sql.Append(" AND ").Append(alias).Append(".salesStatus = @Status");
                cmd.Parameters.AddWithValue("@Status", filter.Status.Trim());
            }

            if (!string.IsNullOrWhiteSpace(filter.Channel))
            {
                sql.Append(" AND ").Append(alias).Append(".saleChannel = @Channel");
                cmd.Parameters.AddWithValue("@Channel", filter.Channel.Trim());
            }
        }

        private static IList<string> DistinctValues(string column)
        {
            var values = new List<string>();
            string sql = "SELECT DISTINCT " + column + " AS V FROM dbo.Sale WHERE " + column +
                         " IS NOT NULL AND LTRIM(RTRIM(" + column + ")) <> '' ORDER BY " + column;

            DataTable table = Db.ExecuteDataTable(sql, connectionName: Db.ReportsConnectionName);
            foreach (DataRow row in table.Rows) values.Add(row["V"].ToString());
            return values;
        }

        private static decimal ToDecimal(object value)
        {
            return value == null || value == DBNull.Value ? 0m : Convert.ToDecimal(value);
        }

        private static int ToInt(object value)
        {
            return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
        }
    }
}
