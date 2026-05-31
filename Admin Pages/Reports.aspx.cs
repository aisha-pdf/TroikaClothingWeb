using System;
using System.Web.UI;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Reports : System.Web.UI.Page
    {
        private readonly ReportService _reportService = new ReportService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadAllCharts();
        }

        private void LoadAllCharts()
        {
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "loadCharts",
                string.Format(
                    "loadSalesCharts({0}, {1}, {2});",
                    _reportService.GetMonthlySalesJson(),
                    _reportService.GetPaymentMethodJson(),
                    _reportService.GetSalesChannelJson()),
                true);
        }
    }
}
