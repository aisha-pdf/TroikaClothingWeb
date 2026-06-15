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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindOptionLists();
                LoadProductDetails();
                LoadRelatedProducts();
            }
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
            string productId = Request.QueryString["id"];
            Product product = _productService.GetProductById(productId);

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
                Session["ReturnUrl"] = Request.RawUrl;
                Response.Redirect("~/Login.aspx");
                return;
            }

            string productId = Request.QueryString["id"];
            Product product = _productService.GetProductById(productId);
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
