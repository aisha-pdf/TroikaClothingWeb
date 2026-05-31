namespace TroikaClothingWeb.Models
{
    public class ProductSearchCriteria
    {
        public string Category { get; set; } = "all";
        public string SearchText { get; set; } = string.Empty;

        public bool HasCategoryFilter => !string.IsNullOrWhiteSpace(Category) && Category != "all";
        public bool HasSearchFilter => !string.IsNullOrWhiteSpace(SearchText);
    }
}
