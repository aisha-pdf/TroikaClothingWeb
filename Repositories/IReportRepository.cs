using System.Data;

namespace TroikaClothingWeb.Repositories
{
    public interface IReportRepository
    {
        DataTable GetMonthlySales();
        DataTable GetPaymentMethodBreakdown();
        DataTable GetSalesChannelBreakdown();
    }
}
