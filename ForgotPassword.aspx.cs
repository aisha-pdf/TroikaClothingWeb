using System;
using System.Drawing;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private readonly PasswordResetService _passwordResetService = ServiceFactory.CreatePasswordResetService();

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            var request = new PasswordResetRequest
            {
                Email = txtEmail.Text.Trim(),
                PhoneNumber = txtPhone.Text.Trim(),
                NewPassword = txtNewPassword.Text,
                ConfirmPassword = txtConfirmPassword.Text
            };

            OperationResult result = _passwordResetService.ResetPassword(request);

            lblMessage.Text = result.Message;
            lblMessage.ForeColor = result.Success
                ? ColorTranslator.FromHtml("#14532d")
                : ColorTranslator.FromHtml("#b00020");

            if (result.Success)
            {
                Session.Clear();
                Response.Redirect("~/Login.aspx?reset=success", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        protected void chkShowPassword_CheckedChanged(object sender, EventArgs e)
        {
            txtNewPassword.TextMode = chkShowPassword.Checked
                ? System.Web.UI.WebControls.TextBoxMode.SingleLine
                : System.Web.UI.WebControls.TextBoxMode.Password;

            txtConfirmPassword.TextMode = chkShowPassword.Checked
                ? System.Web.UI.WebControls.TextBoxMode.SingleLine
                : System.Web.UI.WebControls.TextBoxMode.Password;
        }
    }
}