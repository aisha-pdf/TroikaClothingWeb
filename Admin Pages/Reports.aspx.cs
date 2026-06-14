using System;
using System.Globalization;
using System.Web.UI;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Reports : AdminPage
    {
        private readonly ReportDashboardService _reportDashboardService = ServiceFactory.CreateReportDashboardService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllCharts();
            }
        }

        private void LoadAllCharts()
        {
            ReportDashboardPayload payload = _reportDashboardService.GetDashboardPayload();

            string script = string.Format(
                CultureInfo.InvariantCulture,
                "loadSalesCharts({0}, {1}, {2});",
                payload.MonthlySalesJson,
                payload.PaymentMethodJson,
                payload.SalesChannelJson);

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "loadCharts",
                script,
                true);
        }
    }
}
