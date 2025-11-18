using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllCharts();
                
            }
        }

        private void LoadAllCharts()
        {
            var monthly = GetMonthlySales();
            var payment = GetPaymentMethodData();
            var channel = GetSalesChannelData();

            string monthlyJson = ToJson(monthly);
            string paymentJson = ToJson(payment);
            string channelJson = ToJson(channel);

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "loadCharts",
                $"loadSalesCharts({monthlyJson}, {paymentJson}, {channelJson});",
                true
            );
        }

        private DataTable GetMonthlySales()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ReportsConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT 
        CAST(YEAR(dateOfIssue) AS VARCHAR(4)) + '-' + RIGHT('0' + CAST(MONTH(dateOfIssue) AS VARCHAR(2)), 2) AS Month,
        SUM(paymentTotal) AS TotalSales
        FROM dbo.Sale
        WHERE salesStatus = 'Completed'
        GROUP BY YEAR(dateOfIssue), MONTH(dateOfIssue)
        ORDER BY YEAR(dateOfIssue), MONTH(dateOfIssue);
            ", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private DataTable GetPaymentMethodData()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ReportsConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT paymentMethod, COUNT(*) AS TotalCount
        FROM dbo.Sale
        WHERE salesStatus='Completed'
        GROUP BY paymentMethod;", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        private DataTable GetSalesChannelData()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ReportsConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT saleChannel, COUNT(*) AS TotalSales
        FROM dbo.Sale
        WHERE salesStatus='Completed'
        GROUP BY saleChannel;", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        public string ToJson(DataTable dt)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

    }
}