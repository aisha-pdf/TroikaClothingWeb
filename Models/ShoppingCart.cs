using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Models
{
    public static class ShoppingCart
    {
        private const string CartKey = "CART";

        public static List<CartItem> Get(HttpSessionStateBase session) =>
            (session[CartKey] as List<CartItem>) ?? (session[CartKey] = new List<CartItem>()) as List<CartItem>;

        // For WebForms' HttpSessionState (no HttpSessionStateBase)
        public static List<CartItem> Get(System.Web.SessionState.HttpSessionState session)
        {
            var list = session[CartKey] as List<CartItem>;
            if (list == null)
            {
                list = new List<CartItem>();
                session[CartKey] = list;
            }
            return list;
        }

        public static void AddOrIncrease(System.Web.SessionState.HttpSessionState session, CartItem item)
        {
            var cart = Get(session);
            var existing = cart.FirstOrDefault(x =>
                x.ProductID == item.ProductID &&
                string.Equals(x.Colour ?? "", item.Colour ?? "", StringComparison.OrdinalIgnoreCase) &&
                string.Equals(x.ClothingSize ?? "", item.ClothingSize ?? "", StringComparison.OrdinalIgnoreCase));

            if (existing == null) cart.Add(item);
            else existing.Quantity += item.Quantity;
        }

        public static void UpdateQuantity(System.Web.SessionState.HttpSessionState session, string productId, string colour, string size, int qty)
        {
            var cart = Get(session);
            var row = cart.FirstOrDefault(x => x.ProductID == productId &&
                                               (x.Colour ?? "") == (colour ?? "") &&
                                               (x.ClothingSize ?? "") == (size ?? ""));
            if (row != null)
            {
                row.Quantity = Math.Max(1, qty);
            }
        }

        public static void Remove(System.Web.SessionState.HttpSessionState session, string productId, string colour, string size)
        {
            var cart = Get(session);
            cart.RemoveAll(x => x.ProductID == productId &&
                                (x.Colour ?? "") == (colour ?? "") &&
                                (x.ClothingSize ?? "") == (size ?? ""));
        }

        /// <summary>
        /// Updates a cart line's colour/size/quantity. If the new colour+size collides with a
        /// different existing line for the same product, the two are merged (quantities added).
        /// </summary>
        public static void UpdateVariant(System.Web.SessionState.HttpSessionState session, string productId,
            string oldColour, string oldSize, string newColour, string newSize, int qty)
        {
            var cart = Get(session);
            qty = Math.Max(1, qty);

            var line = cart.FirstOrDefault(x => x.ProductID == productId &&
                                                (x.Colour ?? "") == (oldColour ?? "") &&
                                                (x.ClothingSize ?? "") == (oldSize ?? ""));
            if (line == null) return;

            var collision = cart.FirstOrDefault(x => x != line &&
                x.ProductID == productId &&
                string.Equals(x.Colour ?? "", newColour ?? "", StringComparison.OrdinalIgnoreCase) &&
                string.Equals(x.ClothingSize ?? "", newSize ?? "", StringComparison.OrdinalIgnoreCase));

            if (collision != null)
            {
                collision.Quantity += qty;
                cart.Remove(line);
            }
            else
            {
                line.Colour = newColour;
                line.ClothingSize = newSize;
                line.Quantity = qty;
            }
        }

        public static decimal Total(System.Web.SessionState.HttpSessionState session) =>
            Get(session).Sum(i => i.LineTotal);

        public static void Clear(System.Web.SessionState.HttpSessionState session) => session[CartKey] = new List<CartItem>();
    }
}
