namespace TroikaClothingWeb.Models
{
    public class ReceiptLineItem
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public string ClothingSize { get; set; }
        public string Colour { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal LineTotal { get; set; }
        public int ProductionTime { get; set; }

        // These aliases keep the existing OrderConfirmation.aspx Repeater bindings working.
        public string clothingSize { get { return ClothingSize; } }
        public string colour { get { return Colour; } }
        public int quantity { get { return Quantity; } }
    }
}
