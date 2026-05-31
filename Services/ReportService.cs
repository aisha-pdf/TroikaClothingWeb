using System.Data;
using Newtonsoft.Json;
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
    }
}
