using System;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly AuthService _authService = new AuthService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && string.Equals(Request.QueryString["reset"], "success", StringComparison.OrdinalIgnoreCase))
            {
                lblMessage.Text = "Password reset successfully. You can now log in with your new password.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
        }



        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            var result = _authService.Login(Session, username, password);
            if (!result.Success)
            {
                lblMessage.Text = result.Message;
                return;
            }

            if (Session["ReturnUrl"] != null)
            {
                string returnUrl = Session["ReturnUrl"].ToString();
                Session["ReturnUrl"] = null;
                Response.Redirect(returnUrl);
                return;
            }

            string role = Session["Role"].ToString();
            if (role.Equals("Administrator", StringComparison.OrdinalIgnoreCase))
                Response.Redirect("~/Admin Pages/Admin.aspx");
            else
                Response.Redirect("~/Public Pages/Products.aspx");
        }
    }
}
