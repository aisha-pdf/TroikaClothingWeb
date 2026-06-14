using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class ReportDashboardService
    {
        private readonly ReportService _reportService;

        public ReportDashboardService()
            : this(new ReportService())
        {
        }

        public ReportDashboardService(ReportService reportService)
        {
            _reportService = reportService;
        }

        public ReportDashboardPayload GetDashboardPayload()
        {
            return new ReportDashboardPayload
            {
                MonthlySalesJson = _reportService.GetMonthlySalesJson(),
                PaymentMethodJson = _reportService.GetPaymentMethodJson(),
                SalesChannelJson = _reportService.GetSalesChannelJson()
            };
        }
    }
}
