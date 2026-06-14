using System;
using System.Web.UI;

namespace TroikaClothingWeb.Controls
{
    public partial class AdminSidebar : UserControl
    {
        protected void btnUserList_Click(object sender, EventArgs e)
        {
            Response.Redirect(ResolveUrl("~/Admin Pages/Admin.aspx"));
        }

        protected void btnProducts_Click(object sender, EventArgs e)
        {
            Response.Redirect(ResolveUrl("~/Admin Pages/ProductManagement.aspx"));
        }

        protected void btnReports_Click(object sender, EventArgs e)
        {
            Response.Redirect(ResolveUrl("~/Admin Pages/Reports.aspx"));
        }

        protected void btnProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect(ResolveUrl("~/Admin Pages/AdminProfile.aspx"));
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect(ResolveUrl("~/Login.aspx"));
        }
    }
}
