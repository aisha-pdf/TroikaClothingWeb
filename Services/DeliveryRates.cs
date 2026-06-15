namespace TroikaClothingWeb.Services
{
    /// <summary>
    /// Single source of truth for delivery pricing so the cart display, the free-delivery
    /// tracker, and checkout can never drift apart.
    /// </summary>
    public static class DeliveryRates
    {
        public const decimal FreeDeliveryThreshold = 500m;
        public const decimal StandardDeliveryFee = 80m;

        public static decimal CalculateFee(decimal subtotal)
        {
            return subtotal >= FreeDeliveryThreshold ? 0m : StandardDeliveryFee;
        }
    }
}
