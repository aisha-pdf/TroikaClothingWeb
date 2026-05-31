using System;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Sale_Pages
{
    public partial class SaleHistory : System.Web.UI.Page
    {
        private readonly UserService _userService = new UserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            string username = Session["Username"] == null ? null : Session["Username"].ToString();
            if (string.IsNullOrWhiteSpace(username))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string customerID = _userService.GetCustomerIdByUsername(username);
            SaleOrderDS.SelectParameters["CusID"].DefaultValue = customerID;
        }

        protected void gvSale_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
        }

        protected void gvSale_SelectedIndexChanged(object sender, EventArgs e)
        {
            string receiptId = gvSale.DataKeys[gvSale.SelectedIndex].Value.ToString();
            ProductsSold.SelectParameters["recID"].DefaultValue = receiptId;
            lvProductsSold.DataBind();
        }

        protected string GetImageUrl(object imageObj, object nameObj)
        {
            return ImageService.ToDataUrl(imageObj, nameObj, ResolveUrl("~/Images/Image_not_available.png"));
        }
    }
}
