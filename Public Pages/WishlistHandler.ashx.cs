using System;
using System.Web;
using System.Web.SessionState;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Public_Pages
{
    /// <summary>
    /// Lightweight JSON endpoint that toggles a product on the logged-in customer's
    /// wishlist. Called by the heart icon on the Products page so the heart animation
    /// can play without a full page postback. Still routes through ServiceFactory ->
    /// WishlistService -> repository, keeping the layered architecture intact.
    /// Responses: {"login":true} | {"ok":true,"added":true|false} | {"ok":false}
    /// </summary>
    public class WishlistHandler : IHttpHandler, IRequiresSessionState
    {
        private readonly WishlistService _wishlistService = ServiceFactory.CreateWishlistService();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string username = context.Session["Username"] as string;
            string role = context.Session["Role"] as string;

            bool isCustomer = !string.IsNullOrWhiteSpace(username) &&
                              string.Equals(role, "Customer", StringComparison.OrdinalIgnoreCase);

            if (!isCustomer)
            {
                // Admins are logged in but cannot wishlist: tell the page to show a notice
                // (handled client-side) rather than bouncing them to the login page.
                bool isAdmin = string.Equals(role, "Administrator", StringComparison.OrdinalIgnoreCase);
                if (isAdmin)
                {
                    context.Response.Write("{\"admin\":true}");
                    return;
                }

                // Send the customer back to the page they came from after they log in,
                // matching the login-return behaviour used elsewhere (e.g. add-to-cart).
                if (context.Request.UrlReferrer != null)
                    context.Session["ReturnUrl"] = context.Request.UrlReferrer.PathAndQuery;

                context.Response.Write("{\"login\":true}");
                return;
            }

            string productId = context.Request.Form["productId"];

            try
            {
                WishlistToggleResult result = _wishlistService.ToggleForUsername(username, productId);

                if (result.RequiresLogin)
                {
                    context.Response.Write("{\"login\":true}");
                    return;
                }

                if (!result.Success)
                {
                    context.Response.Write("{\"ok\":false}");
                    return;
                }

                context.Response.Write("{\"ok\":true,\"added\":" + (result.Added ? "true" : "false") + "}");
            }
            catch
            {
                context.Response.StatusCode = 500;
                context.Response.Write("{\"ok\":false}");
            }
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
