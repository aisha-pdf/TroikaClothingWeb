using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class Adminaspx : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure only admin can access
            if (Session["Role"] == null || Session["Role"].ToString() != "Administrator")
            {
                Response.Redirect("~/Login.aspx");
            }
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