using System;
using System.Web;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        private readonly ProductService _productService = new ProductService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductDetails();
                LoadRelatedProducts();
            }
        }

        private void LoadProductDetails()
        {
            string productId = Request.QueryString["id"];
            Product product = _productService.GetProductById(productId);

            if (product == null)
            {
                lblProductName.Text = "Product not found.";
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
                Quantity = int.TryParse(txtQuantity.Text, out var q) ? Math.Max(1, q) : 1,
                Colour = ddlColor.SelectedValue,
                ClothingSize = ddlSize.SelectedValue,
                ImageUrl = ResolveUrl(product.ImageUrl)
            };

            ShoppingCart.AddOrIncrease(Session, item);
            UpdateMasterPageCartCount();

            lblStatus.Text = HttpUtility.HtmlEncode(product.ProductName) + " added to cart successfully!";
            lblStatus.Visible = true;
        }

        private void UpdateMasterPageCartCount()
        {
            SiteMaster master = Page.Master as SiteMaster;
            if (master != null)
            {
                var cart = ShoppingCart.Get(Session);
                master.UpdateCartCount(cart != null ? cart.Count : 0);
            }
        }
    }
}
