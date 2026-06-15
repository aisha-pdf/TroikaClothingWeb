using System.Collections.Generic;
using System.Linq;
using System.Web.SessionState;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class CartService
    {
        public IList<CartItem> GetItems(HttpSessionState session)
        {
            return ShoppingCart.Get(session);
        }

        public CartSummary GetSummary(HttpSessionState session, string estimatedDeliveryText)
        {
            IList<CartItem> items = GetItems(session);
            decimal subtotal = items.Sum(i => i.LineTotal);
            decimal delivery = DeliveryRates.CalculateFee(subtotal);

            return new CartSummary
            {
                Items = items,
                Subtotal = subtotal,
                DeliveryFee = delivery,
                GrandTotal = subtotal + delivery,
                FreeDeliveryThreshold = DeliveryRates.FreeDeliveryThreshold,
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

        public void UpdateVariant(HttpSessionState session, string productId, string oldColour, string oldSize, string newColour, string newSize, int quantity)
        {
            ShoppingCart.UpdateVariant(session, productId, oldColour, oldSize, newColour, newSize, quantity);
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
    }
}
