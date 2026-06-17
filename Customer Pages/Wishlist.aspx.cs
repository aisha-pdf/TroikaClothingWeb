using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Customer_Pages
{
    public partial class Wishlist : CustomerPage
    {
        private readonly WishlistService _wishlistService = ServiceFactory.CreateWishlistService();
        private readonly ProductService _productService = ServiceFactory.CreateProductService();
        private readonly CartService _cartService = ServiceFactory.CreateCartService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindWishlist();
            }
        }

        protected void rptWishlist_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string productId = Convert.ToString(e.CommandArgument);

            if (e.CommandName == "remove")
            {
                _wishlistService.RemoveForUsername(CurrentUsername, productId);
                BindWishlist();
            }
            else if (e.CommandName == "addtocart")
            {
                AddToCart(productId);
            }
        }

        // Adds the product to the cart directly (keeping it on the wishlist). The cart
        // requires a colour/size, which the wishlist doesn't capture, so a default
        // colour/size is used; the customer can change them in the cart's inline editor.
        private void AddToCart(string productId)
        {
            Product product = _productService.GetProductById(productId);

            if (product == null)
            {
                // Product was deactivated since the list was loaded - refresh so it
                // shows greyed out, and tell the customer.
                BindWishlist();
                ShowToast("This product is no longer available.");
                return;
            }

            var item = new CartItem
            {
                ProductID = product.ProductID,
                ProductName = product.ProductName,
                UnitPrice = product.Price,
                Quantity = 1,
                Colour = ProductOptions.Colours[0],
                ClothingSize = ProductOptions.Sizes[0],
                ImageUrl = ResolveUrl(product.ImageUrl)
            };

            _cartService.AddOrIncrease(Session, item);
            UpdateMasterCartCount();

            ShowToast(product.ProductName + " added to your cart");
        }

        private void ShowToast(string message)
        {
            string encoded = HttpUtility.JavaScriptStringEncode(message);
            ClientScript.RegisterStartupScript(GetType(), "wishToast",
                "troikaShowWishToast('" + encoded + "');", true);
        }

        private void UpdateMasterCartCount()
        {
            SiteMaster master = Page.Master as SiteMaster;
            if (master != null)
                master.UpdateCartCount(_cartService.GetCartCount(Session));
        }

        private void BindWishlist()
        {
            IList<WishlistItem> items = _wishlistService.GetWishlistForUsername(CurrentUsername);

            rptWishlist.DataSource = items;
            rptWishlist.DataBind();
            rptWishlist.Visible = items.Count > 0;

            lblMessage.Visible = items.Count == 0;
            lblMessage.Text = items.Count == 0
                ? "Your wishlist is empty. Browse the shop and tap the heart on a product to save it here."
                : string.Empty;
        }
    }
}
