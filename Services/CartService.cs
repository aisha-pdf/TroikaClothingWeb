using System.Collections.Generic;
using System.Linq;
using System.Web.SessionState;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class CartService
    {
        private const decimal FreeDeliveryThreshold = 500m;
        private const decimal StandardDeliveryFee = 80m;

        public IList<CartItem> GetItems(HttpSessionState session)
        {
            return ShoppingCart.Get(session);
        }

        public CartSummary GetSummary(HttpSessionState session, string estimatedDeliveryText)
        {
            IList<CartItem> items = GetItems(session);
            decimal subtotal = items.Sum(i => i.LineTotal);
            decimal delivery = CalculateDeliveryFee(subtotal);

            return new CartSummary
            {
                Items = items,
                Subtotal = subtotal,
                DeliveryFee = delivery,
                GrandTotal = subtotal + delivery,
                EstimatedDeliveryText = estimatedDeliveryText
            };
        }

        public void AddOrIncrease(HttpSessionState session, CartItem item)
        {
            ShoppingCart.AddOrIncrease(session, item);
        }

        public void UpdateQuantity(HttpSessionState session, string productId, string colour, string size, int quantity)
        {
            ShoppingCart.UpdateQuantity(session, productId, colour, size, quantity);
        }

        public void Remove(HttpSessionState session, string productId, string colour, string size)
        {
            ShoppingCart.Remove(session, productId, colour, size);
        }

        public void Clear(HttpSessionState session)
        {
            ShoppingCart.Clear(session);
        }

        public int GetCartCount(HttpSessionState session)
        {
            return GetItems(session).Count;
        }

        private decimal CalculateDeliveryFee(decimal subtotal)
        {
            return subtotal > FreeDeliveryThreshold ? 0m : StandardDeliveryFee;
        }
    }
}
