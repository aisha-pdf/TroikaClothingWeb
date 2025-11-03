using System;

namespace TroikaClothingWeb.Models
{
    [Serializable]
    public class CartItem
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public string Colour { get; set; }
        public string ClothingSize { get; set; }
        public string ImageUrl { get; set; }

        public decimal LineTotal => UnitPrice * Quantity;
    }
}
