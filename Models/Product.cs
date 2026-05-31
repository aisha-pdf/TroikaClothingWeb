using System;

namespace TroikaClothingWeb.Models
{
    [Serializable]
    public class Product
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public decimal Price { get; set; }
        public int ProductionTime { get; set; }
        public string Status { get; set; }
        public bool HasPicture { get; set; }
        public string ImageUrl { get; set; }
        public string ImagePath { get; set; }
        public string DetailUrl { get; set; }
    }
}
