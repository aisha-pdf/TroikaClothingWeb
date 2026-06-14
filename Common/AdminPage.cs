using System;

namespace TroikaClothingWeb.Common
{
    public abstract class AdminPage : BasePage
    {
        protected override void OnLoad(EventArgs e)
        {
            if (!IsLoggedIn() || !IsInRole("Administrator"))
            {
                RedirectToLogin(Request.RawUrl);
                return;
            }

            base.OnLoad(e);
        }
    }
}
