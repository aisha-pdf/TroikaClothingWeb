using System;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        private readonly ProductService _productService = ServiceFactory.CreateProductService();
        private readonly CartService _cartService = ServiceFactory.CreateCartService();
        private readonly WishlistService _wishlistService = ServiceFactory.CreateWishlistService();

        // The product for the current ?id=, fetched once per request and shared by the
        // heart-state, details and add-to-cart logic.
        private Product _currentProduct;
        private bool _currentProductLoaded;

        // Surfaced to the markup so the wishlist heart can render with the right product
        // id and pre-filled state. Recomputed on every load (incl. postbacks).
        protected bool HasProduct { get; private set; }
        protected string CurrentProductId { get; private set; }
        protected string WishHeartClass { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            SetWishlistHeartState();

            if (!IsPostBack)
            {
                BindOptionLists();
                LoadProductDetails();
                LoadRelatedProducts();
            }
        }

        private Product GetCurrentProduct()
        {
            if (!_currentProductLoaded)
            {
                _currentProduct = _productService.GetProductById(Request.QueryString["id"]);
                _currentProductLoaded = true;
            }
            return _currentProduct;
        }

        private void SetWishlistHeartState()
        {
            Product product = GetCurrentProduct();
            HasProduct = product != null;
            CurrentProductId = product != null ? product.ProductID : string.Empty;

            string username = Session["Username"] as string;
            bool wished = HasProduct && _wishlistService.GetWishlistedProductIds(username).Contains(product.ProductID);
            WishHeartClass = wished ? "is-wished" : string.Empty;
        }

        private void BindOptionLists()
        {
            ddlColor.DataSource = ProductOptions.Colours;
            ddlColor.DataBind();

            ddlSize.DataSource = ProductOptions.Sizes;
            ddlSize.DataBind();
        }

        private void LoadProductDetails()
        {
            Product product = GetCurrentProduct();

            if (product == null)
            {
                lblProductName.Text = "Product not found.";
                btnAddToCart.Enabled = false;
                return;
            }

            lblProductName.Text = product.ProductName;
            lblProductDescription.Text = product.Description;
            lblCategory.Text = product.Category;
            lblProductPrice.Text = "R" + product.Price.ToString("0.00");
            imgProduct.ImageUrl = product.ImageUrl;
        }

        private void LoadRelatedProducts()
        {
            string productId = Request.QueryString["id"];
            string category = lblCategory.Text;

            if (string.IsNullOrWhiteSpace(productId) || string.IsNullOrWhiteSpace(category)) return;

            dlRelatedProducts.DataSource = _productService.GetRelatedProducts(category, productId, 4);
            dlRelatedProducts.DataBind();
        }

        protected void btnSizeGuide_Click(object sender, EventArgs e)
        {
            pnlOverlay.Visible = true;
        }

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            pnlOverlay.Visible = false;
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (!AuthService.IsInRole(Session, "Customer"))
            {
                // Admins are logged in but cannot purchase: show a notice rather than
                // sending them to login (mirrors the wishlist heart's admin handling).
                if (AuthService.IsInRole(Session, "Administrator"))
                {
                    ShowAdminPurchaseNotice();
                    return;
                }

                Session["ReturnUrl"] = Request.RawUrl;
                Response.Redirect("~/Login.aspx");
                return;
            }

            Product product = GetCurrentProduct();
            if (product == null) return;

            var item = new CartItem
            {
                ProductID = product.ProductID,
                ProductName = product.ProductName,
                UnitPrice = product.Price,
                Quantity = ParseQuantity(txtQuantity.Text),
                Colour = ddlColor.SelectedValue,
                ClothingSize = ddlSize.SelectedValue,
                ImageUrl = ResolveUrl(product.ImageUrl)
            };

            _cartService.AddOrIncrease(Session, item);
            UpdateMasterPageCartCount();

            lblStatus.Text = HttpUtility.HtmlEncode(product.ProductName) + " added to cart successfully!";
            lblStatus.Visible = true;
            btnViewCart.Visible = true;

            // Add to Cart is now an async (UpdatePanel) postback, so the master page — and
            // its cart-count badge — is not re-rendered. Push the new count to the badge
            // in the browser so it stays in sync without a full reload.
            SyncCartBadgeClientSide();
        }

        // Pops the shared notice modal (defined in wishlist.js, which this page loads).
        // Registered against the Add-to-Cart UpdatePanel so it runs after the async postback.
        private void ShowAdminPurchaseNotice()
        {
            const string message = "Administrators are not allowed to make purchases. Please create or log in to a customer account.";
            string script =
                "if(window.troikaNotice){window.troikaNotice('" +
                HttpUtility.JavaScriptStringEncode(message) +
                "','Action not allowed');}";
            ScriptManager.RegisterStartupScript(btnAddToCart, typeof(ProductDetail), "adminPurchaseNotice", script, true);
        }

        private void SyncCartBadgeClientSide()
        {
            string count = _cartService.GetCartCount(Session).ToString();
            var script = new StringBuilder();

            foreach (string id in new[] { "lblCartCount", "Label2" })
            {
                var label = FindControlRecursive(Master, id) as Label;
                if (label != null)
                    script.AppendFormat(
                        "var e=document.getElementById('{0}');if(e){{e.textContent='{1}';}}",
                        label.ClientID, count);
            }

            if (script.Length > 0)
                ScriptManager.RegisterStartupScript(btnAddToCart, typeof(ProductDetail), "syncCartBadge", script.ToString(), true);
        }

        private static Control FindControlRecursive(Control root, string id)
        {
            if (root == null) return null;
            if (string.Equals(root.ID, id, StringComparison.Ordinal)) return root;

            foreach (Control child in root.Controls)
            {
                Control found = FindControlRecursive(child, id);
                if (found != null) return found;
            }
            return null;
        }

        protected void btnViewCart_Click(object sender, EventArgs e)
        {
            BindCartPopup();
            pnlCartPopup.Visible = true;
        }

        protected void btnCloseCartPopup_Click(object sender, EventArgs e)
        {
            pnlCartPopup.Visible = false;
        }

        private void BindCartPopup()
        {
            CartSummary summary = _cartService.GetSummary(Session, null);

            phQvEmpty.Visible = !summary.HasItems;

            rptQuickCart.DataSource = summary.Items;
            rptQuickCart.DataBind();

            lblQvCount.Text = summary.ItemCount.ToString();
            lblQvSubtotal.Text = summary.Subtotal.ToString("0.00");
            lblQvDelivery.Text = summary.DeliveryDisplayText;
            lblQvTotal.Text = summary.GrandTotal.ToString("0.00");

            dtFillPopup.Attributes["data-target"] = summary.FreeDeliveryProgressPercent.ToString();
            dtFillPopup.Style["width"] = "0%";
            dtFillPopup.Attributes["class"] = "dt-fill" + (summary.QualifiesForFreeDelivery ? " is-free" : string.Empty);
            lblQvTrackerMsg.Text = summary.FreeDeliveryMessage;

            // The popup is shown via an async UpdatePanel, so page-load JS has already run and
            // won't fill the bar. Emit the fill as part of the partial response so it animates
            // every time the popup opens (independent of any cached delivery-tracker.js).
            const string fillBar =
                "(function(){var f=document.querySelectorAll('.dt-fill[data-target]');" +
                "requestAnimationFrame(function(){requestAnimationFrame(function(){" +
                "for(var i=0;i<f.length;i++){f[i].style.width=(f[i].getAttribute('data-target')||'0')+'%';}" +
                "});});})();";
            ScriptManager.RegisterStartupScript(pnlCartPopup, typeof(ProductDetail), "qvFillBar", fillBar, true);
        }

        private int ParseQuantity(string quantityText)
        {
            int quantity;
            return int.TryParse(quantityText, out quantity) ? Math.Max(1, quantity) : 1;
        }

        private void UpdateMasterPageCartCount()
        {
            SiteMaster master = Page.Master as SiteMaster;
            if (master != null)
            {
                master.UpdateCartCount(_cartService.GetCartCount(Session));
            }
        }
    }
}
