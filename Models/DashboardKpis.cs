namespace TroikaClothingWeb.Models
{
    /// <summary>Headline numbers shown as KPI cards at the top of the dashboard.</summary>
    public class DashboardKpis
    {
        public decimal Revenue { get; set; }
        public int Orders { get; set; }
        public decimal AverageOrderValue { get; set; }
        public long Units { get; set; }
        public int Customers { get; set; }
        public int CompletedOrders { get; set; }
        public double CompletionRate { get; set; }
    }
}
