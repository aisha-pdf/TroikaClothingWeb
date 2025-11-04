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

            // Basic username and password length validation
            if (username.Length != 6 || password.Length != 8)
            {
                lblMessage.Text = "Username or Password is incorrect.";
                return;
            }

            // Ensure the datasource exists
            if (LoginDatasource == null)
            {
                lblMessage.Text = "Login data source not found.";
                return;
            }

            // Get result from database
            DataView dv = (DataView)LoginDatasource.Select(DataSourceSelectArguments.Empty);

            if (dv != null && dv.Count > 0)
            {
                string dbUsername = dv[0]["Username"].ToString();
                string status = dv[0]["Status"].ToString(); // ✅ Account Status from DB

                // Case-sensitive username match
                if (dbUsername == username)
                {
                    // ✅ Check if account is active
                    if (!status.Equals("Active", StringComparison.OrdinalIgnoreCase))
                    {
                        lblMessage.Text = "Your account is not active. Please contact the administrator.";
                        return;
                    }

                    string role = dv[0]["Role"].ToString(); // Administrator or Customer

                    // Set session values
                    Session["Username"] = username;
                    Session["Role"] = role;

                    // ✅ If user was redirected to login from a restricted page
                    if (Session["ReturnUrl"] != null)
                    {
                        string returnUrl = Session["ReturnUrl"].ToString();
                        Session["ReturnUrl"] = null;
                        Response.Redirect(returnUrl);
                        return;
                    }

                    // ✅ Role-based redirect
                    if (role.Equals("Customer", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Public Pages/Products.aspx");
                    }
                    else if (role.Equals("Administrator", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("~/Admin Pages/Admin.aspx");
                    }
                    else
                    {
                        Response.Redirect("~/Public Pages/Products.aspx");
                    }
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