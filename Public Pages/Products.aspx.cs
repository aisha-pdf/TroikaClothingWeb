using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Products : BasePage
    {
        private readonly ProductService _productService = new ProductService();
        private readonly WishlistService _wishlistService = ServiceFactory.CreateWishlistService();
        private HashSet<string> _wishlistedIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        protected void Page_Load(object sender, EventArgs e)
        {
            // Loaded on every load (incl. postbacks) so GetHeartClass reflects the
            // current customer's wishlist when the product list is (re)bound.
            _wishlistedIds = _wishlistService.GetWishlistedProductIds(CurrentUsername);

            if (!IsPostBack)
            {
                BindCategories();
                BindProducts();
            }
        }

        protected string GetHeartClass(object productId)
        {
            string id = productId == null ? null : productId.ToString();
            return !string.IsNullOrEmpty(id) && _wishlistedIds.Contains(id) ? "is-wished" : string.Empty;
        }

        private void BindCategories()
        {
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("All Categories", "all"));

            foreach (string category in _productService.GetCategories())
            {
                ddlCategory.Items.Add(new ListItem(category, category));
            }
        }

        private void BindProducts()
        {
            ProductSearchCriteria criteria = new ProductSearchCriteria
            {
                Category = ddlCategory.SelectedValue,
                SearchText = txtSearch.Text.Trim()
            };

            var products = _productService.SearchProducts(criteria);
            dlProducts.DataSource = products;
            dlProducts.DataBind();
            lblNoProducts.Visible = products.Count == 0;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindProducts();
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindProducts();
        }

        protected void dlProducts_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string productId = e.CommandArgument.ToString();
                Response.Redirect("ProductDetail.aspx?id=" + Server.UrlEncode(productId));
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            ddlCategory.SelectedValue = "all";
            BindProducts();
        }
    }
}
