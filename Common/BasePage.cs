using System;
using System.Web.UI;

namespace TroikaClothingWeb.Common
{
    public abstract class BasePage : Page
    {
        protected string CurrentUsername
        {
            get { return Session["Username"] == null ? null : Session["Username"].ToString(); }
        }

        protected string CurrentRole
        {
            get { return Session["Role"] == null ? null : Session["Role"].ToString(); }
        }

        protected bool IsLoggedIn()
        {
            return !string.IsNullOrWhiteSpace(CurrentUsername);
        }

        protected bool IsInRole(string role)
        {
            return string.Equals(CurrentRole, role, StringComparison.OrdinalIgnoreCase);
        }

        protected void RedirectToLogin(string returnUrl)
        {
            Session["ReturnUrl"] = returnUrl;
            Response.Redirect("~/Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
