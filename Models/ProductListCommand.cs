namespace TroikaClothingWeb.Models
{
    public class ProductListCommand
    {
        public string CommandText { get; set; }
        public bool HasStatusParameter { get; set; }
        public string Status { get; set; }
        public bool HasSearchParameter { get; set; }
        public string SearchPattern { get; set; }
    }
}
