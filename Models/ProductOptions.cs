namespace TroikaClothingWeb.Models
{
    /// <summary>
    /// Canonical colour and size option lists shared by the product detail page and the
    /// editable cart, so the two never drift apart.
    /// </summary>
    public static class ProductOptions
    {
        public static readonly string[] Colours =
        {
            "Black", "White", "Grey", "Navy", "Beige", "Brown", "Red", "Maroon", "Pink", "Blush",
            "Orange", "Mustard", "Yellow", "Green", "Olive", "Mint", "Teal", "Turquoise", "Blue",
            "Sky Blue", "Royal Blue", "Purple", "Lavender", "Lilac", "Burgundy", "Cream", "Khaki",
            "Coral", "Charcoal", "Sage", "Mocha", "Peach", "Tan", "Ivory"
        };

        public static readonly string[] Sizes = { "XS", "S", "M", "L", "XL" };
    }
}
