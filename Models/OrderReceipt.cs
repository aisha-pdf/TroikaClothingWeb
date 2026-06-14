using System;
using System.Collections.Generic;
using System.Linq;

namespace TroikaClothingWeb.Models
{
    public class OrderReceipt
    {
        public string ReceiptNumber { get; set; }
        public DateTime DateOfIssue { get; set; }
        public string PaymentMethod { get; set; }
        public decimal PaymentTotal { get; set; }
        public string SaleChannel { get; set; }
        public string CustomerID { get; set; }
        public string CustomerEmail { get; set; }
        public string CustomerName { get; set; }
        public string CustomerSurname { get; set; }
        public string StreetAddress { get; set; }
        public string Suburb { get; set; }
        public string PostCode { get; set; }
        public IList<ReceiptLineItem> Items { get; set; }

        public OrderReceipt()
        {
            Items = new List<ReceiptLineItem>();
        }

        public string ShippingName
        {
            get { return ((CustomerName ?? string.Empty) + " " + (CustomerSurname ?? string.Empty)).Trim(); }
        }

        public decimal Subtotal
        {
            get { return Items == null ? 0m : Items.Sum(i => i.LineTotal); }
        }

        public decimal DeliveryFee
        {
            get
            {
                decimal delivery = PaymentTotal - Subtotal;
                return delivery < 0 ? 0m : delivery;
            }
        }

        public int EstimatedDeliveryDays
        {
            get
            {
                int maxProductionDays = Items == null || Items.Count == 0
                    ? 0
                    : Items.Max(i => i.ProductionTime);

                return maxProductionDays + 7;
            }
        }
    }
}
