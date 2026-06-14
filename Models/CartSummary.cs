using System.Collections.Generic;
using System.Linq;

namespace TroikaClothingWeb.Models
{
    public class CartSummary
    {
        public IList<CartItem> Items { get; set; }
        public decimal Subtotal { get; set; }
        public decimal DeliveryFee { get; set; }
        public decimal GrandTotal { get; set; }
        public string EstimatedDeliveryText { get; set; }

        public CartSummary()
        {
            Items = new List<CartItem>();
        }

        public bool HasItems
        {
            get { return Items != null && Items.Count > 0; }
        }

        public int ItemCount
        {
            get { return Items == null ? 0 : Items.Sum(i => i.Quantity); }
        }

        public string DeliveryDisplayText
        {
            get { return DeliveryFee == 0m ? "Free" : string.Format("R{0:0.00}", DeliveryFee); }
        }
    }
}
