namespace TroikaClothingWeb.Models
{
    public class ProductSaveRequest
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public string Category { get; set; }
        public string ProductionTimeText { get; set; }
        public string PriceText { get; set; }
        public string Status { get; set; }
        public byte[] PictureBytes { get; set; }

        public bool HasNewPicture
        {
            get { return PictureBytes != null && PictureBytes.Length > 0; }
        }
    }
}
