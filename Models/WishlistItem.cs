using System;

namespace TroikaClothingWeb.Models
{
    /// <summary>
    /// A single wishlist entry joined with its product details, used to render the
    /// customer's wishlist page. Inactive products are still returned so they can be
    /// shown greyed-out as "no longer available".
    /// </summary>
    public class WishlistItem
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public string Category { get; set; }
        public decimal Price { get; set; }
        public string Status { get; set; }
        public DateTime DateAdded { get; set; }
        public bool HasPicture { get; set; }
        public long ImageVersion { get; set; }
        public string ImageUrl { get; set; }
        public string DetailUrl { get; set; }

        public bool IsActive
        {
            get { return string.Equals(Status, "Active", StringComparison.OrdinalIgnoreCase); }
        }
    }
}
