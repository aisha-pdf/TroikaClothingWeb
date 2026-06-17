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
                OpenAddToCartPopup(productId);
            }
        }

        // "Add to cart" no longer adds directly - the wishlist row captures no colour/size/
        // quantity, so it opens a mini product popup where the customer picks those first.
        private void OpenAddToCartPopup(string productId)
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

            hfAtcProductId.Value = product.ProductID;
            imgAtc.ImageUrl = product.ImageUrl;
            imgAtc.AlternateText = product.ProductName;
            lblAtcName.Text = product.ProductName;
            lblAtcPrice.Text = "R" + product.Price.ToString("F2");

            BindPopupOptions();
            txtAtcQuantity.Text = "1";

            pnlAddToCart.Visible = true;
        }

        // Confirms the popup: adds the product to the cart with the chosen colour, size and
        // quantity (keeping it on the wishlist), then closes the popup.
        protected void btnAtcAdd_Click(object sender, EventArgs e)
        {
            Product product = _productService.GetProductById(hfAtcProductId.Value);

            if (product == null)
            {
                // Deactivated while the popup was open - refresh and tell the customer.
                pnlAddToCart.Visible = false;
                BindWishlist();
                ShowToast("This product is no longer available.");
                return;
            }

            var item = new CartItem
            {
                ProductID = product.ProductID,
                ProductName = product.ProductName,
                UnitPrice = product.Price,
                Quantity = ParseQuantity(txtAtcQuantity.Text),
                Colour = ddlAtcColour.SelectedValue,
                ClothingSize = ddlAtcSize.SelectedValue,
                ImageUrl = ResolveUrl(product.ImageUrl)
            };

            _cartService.AddOrIncrease(Session, item);
            UpdateMasterCartCount();

            pnlAddToCart.Visible = false;
            ShowToast(product.ProductName + " added to your cart");
        }

        protected void btnAtcCancel_Click(object sender, EventArgs e)
        {
            pnlAddToCart.Visible = false;
        }

        private void BindPopupOptions()
        {
            ddlAtcColour.DataSource = ProductOptions.Colours;
            ddlAtcColour.DataBind();

            ddlAtcSize.DataSource = ProductOptions.Sizes;
            ddlAtcSize.DataBind();
        }

        private int ParseQuantity(string quantityText)
        {
            int quantity;
            return int.TryParse(quantityText, out quantity) ? Math.Max(1, quantity) : 1;
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
