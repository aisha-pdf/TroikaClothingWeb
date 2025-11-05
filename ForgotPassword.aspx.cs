using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // ✅ Step 1: Validation
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phone) ||
                string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                lblMessage.Text = "All fields are required.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (newPassword != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (newPassword.Length < 8)
            {
                lblMessage.Text = "Password must be at least 8 characters.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // ✅ Step 2: Check if Email & Phone Exist (Using Select of SqlDataSource)
            DataView dv = (DataView)DSUpdateRPwd.Select(DataSourceSelectArguments.Empty);

            if (dv != null && dv.Count > 0) // ✅ Match Found
            {
                // ✅ Step 3: Update Password in Both Tables
                DSUpdateRPwd.UpdateParameters["Password"].DefaultValue = confirmPassword;
                DSUpdateRPwd.Update();

                DSUpdateLPwd.UpdateParameters["Password"].DefaultValue = confirmPassword;
                DSUpdateLPwd.Update();

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Password has been reset. Redirecting to login page...";

                // ✅ Step 4: Redirect after 2 seconds
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            else
            {
                // ❌ Email or Phone not found
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Email or phone number does not exist.";
            }
        }

        protected void chkShowPassword_CheckedChanged(object sender, EventArgs e)
        {
            if (chkShowPassword.Checked)
            {
                // Show password as plain text
                txtNewPassword.TextMode = TextBoxMode.SingleLine;
                txtConfirmPassword.TextMode = TextBoxMode.SingleLine;
            }
            else
            {
                // Hide password as dots
                txtNewPassword.TextMode = TextBoxMode.Password;
                txtConfirmPassword.TextMode = TextBoxMode.Password;
            }
        }
    }
}