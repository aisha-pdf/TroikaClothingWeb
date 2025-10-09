using System;
using System.Collections.Generic;
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

            // Check if password is 6 digits
            if (password.Length != 6 || !int.TryParse(password, out _))
            {
                lblMessage.Text = "Password must be exactly 6 digits.";
                return;
            }

            // Example hardcoded credentials
            if (username == "admin" && password == "123456") 
            {
                // Save the username in session so user stays logged in
                Session["Username"] = username;
                Session["Role"] = "Admin";

                // Redirect to admin homepage
                Response.Redirect("Admin.aspx");
            }
            else if (username == "user1" && password == "654321")
            {
                Session["Username"] = username;
                Session["Role"] = "User";

                //Redirected to homepage 
                Response.Redirect("Default.aspx");
            }
            else
            {
                lblMessage.Text = "Invalid username or password.";
            }
        }
    }
}