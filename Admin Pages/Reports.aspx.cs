using TroikaClothingWeb.Common;

namespace TroikaClothingWeb
{
    /// <summary>
    /// Admin-only interactive BI dashboard. The page is static markup; all data is fetched
    /// client-side from ReportDataHandler.ashx. Inheriting AdminPage enforces the Administrator
    /// role in OnLoad (the handler re-checks the gate for its own JSON endpoint).
    /// </summary>
    public partial class Reports : AdminPage
    {
    }
}
