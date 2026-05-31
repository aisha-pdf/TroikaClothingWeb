using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class _Default : Page
    {
        private readonly ProductService _productService = new ProductService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDresses();
            }
        }

        private void LoadDresses()
        {
            dlDresses.DataSource = _productService.GetFeaturedProductsByCategory("Dress", 10);
            dlDresses.DataBind();
        }

        protected void dlDresses_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
                Response.Redirect("~/Public Pages/ProductDetail.aspx?id=" + e.CommandArgument);
        }

        protected void dlPyjamas_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
                Response.Redirect("~/Public Pages/ProductDetail.aspx?id=" + e.CommandArgument);
        }

        protected void btnProducts_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Public Pages/Products.aspx");
        }
    }
}
