using System;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Adminaspx : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AuthService.IsInRole(Session, "Administrator"))
                Response.Redirect("~/Login.aspx");
        }

        protected void btnUserList_Click(object sender, EventArgs e)
        {
            Response.Redirect("Admin.aspx");
        }

        protected void btnProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminProfile.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}
