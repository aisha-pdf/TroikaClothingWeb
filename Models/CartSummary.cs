using System;
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
        public decimal FreeDeliveryThreshold { get; set; }
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

        public bool QualifiesForFreeDelivery
        {
            get { return DeliveryFee == 0m; }
        }

        public decimal AmountToFreeDelivery
        {
            get { return Math.Max(0m, FreeDeliveryThreshold - Subtotal); }
        }

        public int FreeDeliveryProgressPercent
        {
            get
            {
                if (FreeDeliveryThreshold <= 0m) return 100;
                decimal percent = Subtotal / FreeDeliveryThreshold * 100m;
                if (percent < 0m) percent = 0m;
                if (percent > 100m) percent = 100m;
                return (int)Math.Round(percent);
            }
        }

        public string FreeDeliveryMessage
        {
            get
            {
                return QualifiesForFreeDelivery
                    ? "🎉 You've earned FREE delivery!"
                    : string.Format("Add R{0:0.00} more for FREE delivery", AmountToFreeDelivery);
            }
        }
    }
}
