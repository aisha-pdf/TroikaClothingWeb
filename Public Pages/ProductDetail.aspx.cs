using System;
using System.Web;
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
