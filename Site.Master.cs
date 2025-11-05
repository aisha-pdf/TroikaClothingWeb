using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb
{
    public partial class SiteMaster : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;

        protected void Page_Init(object sender, EventArgs e)
        {
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;


        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                bool loggedIn = (Session != null && Session["Username"] != null && Session["Role"] != null);

                //if custmer is logged in show customer navbar
                if (loggedIn && Session["Role"].ToString() == "Customer")
                {
                    phCustLoggedIn.Visible = true;
                    phLoggedOut.Visible = false;
                    phAdmin.Visible= false;

                    //set welcome label
                    if (loggedIn && lblWelcome != null)
                    {
                        lblWelcome.Text = Session["Username"].ToString();
                    }

                    //Handle cart count safely
                    if (lblCartCount != null)
                    {
                        var cart = ShoppingCart.Get(Session);
                        lblCartCount.Text = (cart != null ? cart.Count : 0).ToString();
                    }
                }

                //if no one is logged in show logged out navbar
                if (!loggedIn)
                {
                    phLoggedOut.Visible = true;
                    phAdmin.Visible = false;
                    phCustLoggedIn.Visible = false;

                    //Handle cart count safely
                    if (lblCartCount != null)
                    {
                        var cart = ShoppingCart.Get(Session);
                        lblCartCount.Text = (cart != null ? cart.Count : 0).ToString();
                    }
                }
                
                //if admin logged in show admin nav bar
                if (loggedIn && Session["Role"].ToString() == "Administrator")
                {
                    phAdmin.Visible = true;
                    phCustLoggedIn.Visible = false;
                    phLoggedOut.Visible = false;
                    lblAdmin.Text = Session["Username"].ToString();
                }
            }
            catch 
            {
                // Fail silently — we don’t want layout to crash
                if (lblCartCount != null) lblCartCount.Text = "0";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session and go to home
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/");
           // Response.Redirect("~/Public Pages/Products.aspx");
        }

        protected void Unnamed_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
        }

        protected void Welcome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Customer Page/CustomerProfile");
        }
    }

}