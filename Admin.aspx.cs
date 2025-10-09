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
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnUserList_Click(object sender, EventArgs e)
        {
            // TODO: Navigate to User List
        }

        protected void btnCreateUser_Click(object sender, EventArgs e)
        {
            // TODO: Open Create User page
        }

        protected void btnProfile_Click(object sender, EventArgs e)
        {
            // TODO: Open Profile page
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            // TODO: Open Settings page
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}