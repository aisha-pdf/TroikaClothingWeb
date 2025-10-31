using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class Login : System.Web.UI.Page

    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Validate password length (8 digits)
            if (password.Length != 8 || username.Length != 6)
            {
                lblMessage.Text = "Password and/or Username is incorrect";
                return;
            }

            // Make sure SqlDataSource exists
            if (LoginDatasource == null)
            {
                lblMessage.Text = "Login data source not found.";
                return;
            }

            // Execute the query
            DataView dv = (DataView)LoginDatasource.Select(DataSourceSelectArguments.Empty);

            // Check if record exists
            if (dv != null && dv.Count > 0)
            {
                // Get stored username (for case-sensitive check)
                string dbUsername = dv[0]["Username"].ToString();

                // Compare case-sensitive
                if (dbUsername == username)
                {
                    string role = dv[0]["Role"].ToString(); // "Administrator" or "Customer"
                    
                    Session["Username"] = username;
                    Session["Role"] = role;

                    // Redirect based on role
                    if (role.Equals("Customer"))
                        Response.Redirect("~/Customer Pages/HomePage");
                    else if (role.Equals("Administrator"))
                        Response.Redirect("Admin Pages/Admin.aspx");
                }
                else
                {
                    lblMessage.Text = "Invalid username or password (case-sensitive).";
                }
            }
            else
            {
                lblMessage.Text = "Invalid username or password.";
            }
        }
    }
}