using System;

namespace TroikaClothingWeb.Models
{
    public class SaleHistoryItem
    {
        public string ReceiptNum { get; set; }
        public decimal PaymentTotal { get; set; }
        public string PaymentMethod { get; set; }
        public DateTime PaymentDate { get; set; }
        public string SalesStatus { get; set; }
    }
}
