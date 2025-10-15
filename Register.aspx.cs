using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string surname = txtSurname.Text.Trim();
            string email = txtEmail.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // --- Validation logic ---
            if (string.IsNullOrEmpty(name) ||
                string.IsNullOrEmpty(surname) ||
                string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(password))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "All fields are required.";
                return;
            }

            // Validate email format
            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid email address.";
                return;
            }

            // Username must be exactly 6 characters
            if (username.Length != 6)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Username must be exactly 6 characters long.";
                return;
            }

            // Password must be exactly 8 digits (only numbers)
            if (password.Length != 8)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Password must be 8 digits.";
                return;
            }

            // --- Registration successful ---
            RegisterDataSource.Insert();
            SqlDataSource1.Insert();
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Registration successful!";
            Response.Redirect("Login.aspx");

        }
    }
}