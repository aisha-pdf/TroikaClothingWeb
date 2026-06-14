using System;

namespace TroikaClothingWeb.Common
{
    public abstract class CustomerPage : BasePage
    {
        protected override void OnLoad(EventArgs e)
        {
            if (!IsLoggedIn() || !IsInRole("Customer"))
            {
                RedirectToLogin(Request.RawUrl);
                return;
            }

            base.OnLoad(e);
        }
    }
}
