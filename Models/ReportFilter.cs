using System;

namespace TroikaClothingWeb.Models
{
    /// <summary>
    /// Optional filters applied uniformly across every dashboard query.
    /// All four are Sale-level so they can be ANDed onto any query identically.
    /// Null/empty means "no filter on this field".
    /// </summary>
    public class ReportFilter
    {
        public DateTime? From { get; set; }
        public DateTime? To { get; set; }
        public string Status { get; set; }
        public string Channel { get; set; }
    }
}
