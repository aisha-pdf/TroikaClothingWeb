using System;
using System.Globalization;
using System.Web;
using System.Web.SessionState;
using Newtonsoft.Json;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Admin_Pages
{
    /// <summary>
    /// Admin-only JSON endpoint that feeds the interactive BI dashboard on
    /// Reports.aspx. Accepts optional query params: report (overview|sales|products|
    /// customers|operations|seasonality|basket|geography), from, to (yyyy-MM-dd),
    /// status, channel. Requires session state so it can enforce the admin role.
    /// </summary>
    public class ReportDataHandler : IHttpHandler, IRequiresSessionState
    {
        private readonly ReportService _reportService = ServiceFactory.CreateReportService();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);

            // Same gate as the page itself - never expose business data to non-admins.
            if (!AuthService.IsInRole(context.Session, "Administrator"))
            {
                context.Response.StatusCode = 403;
                context.Response.Write("{\"error\":\"Forbidden\"}");
                return;
            }

            try
            {
                ReportFilter filter = ParseFilter(context.Request);
                string report = context.Request.QueryString["report"];
                context.Response.Write(_reportService.GetReportJson(report, filter));
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = 500;
                context.Response.Write("{\"error\":" + JsonConvert.SerializeObject(ex.Message) + "}");
            }
        }

        private static ReportFilter ParseFilter(HttpRequest request)
        {
            var filter = new ReportFilter();
            DateTime parsed;

            string from = request.QueryString["from"];
            if (!string.IsNullOrWhiteSpace(from) &&
                DateTime.TryParse(from, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed))
                filter.From = parsed;

            string to = request.QueryString["to"];
            if (!string.IsNullOrWhiteSpace(to) &&
                DateTime.TryParse(to, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed))
                filter.To = parsed;

            string status = request.QueryString["status"];
            if (!string.IsNullOrWhiteSpace(status) && status != "All")
                filter.Status = status;

            string channel = request.QueryString["channel"];
            if (!string.IsNullOrWhiteSpace(channel) && channel != "All")
                filter.Channel = channel;

            return filter;
        }

        public bool IsReusable => false;
    }
}
