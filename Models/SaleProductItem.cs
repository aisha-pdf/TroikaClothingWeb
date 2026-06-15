namespace TroikaClothingWeb.Models
{
    public class SaleProductItem
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string Category { get; set; }
        public int Quantity { get; set; }
        public string ClothingSize { get; set; }
        public string Colour { get; set; }
        public long ImageVersion { get; set; }
        public string ImageUrl { get; set; }

        public decimal LineTotal
        {
            get { return Price * Quantity; }
        }
    }
}
