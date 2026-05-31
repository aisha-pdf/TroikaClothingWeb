using System.Data;
using TroikaClothingWeb.Data;

namespace TroikaClothingWeb.Repositories
{
    public class ReportRepository : IReportRepository
    {
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
    }
}
