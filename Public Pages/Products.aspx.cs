using System;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Products : System.Web.UI.Page
    {
        private readonly ProductService _productService = new ProductService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
                BindProducts();
            }
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
