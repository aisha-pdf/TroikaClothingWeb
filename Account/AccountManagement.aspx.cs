using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb.Account
{
    public partial class AccountManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Password_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/ResetPassword");
        }

        protected void Name_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/UpdateFirstName");
        }

        protected void LastName_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/UpdateLastName");
        }

        protected void Email_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/UpdateEmail");
        }

        protected void PhoneNumber_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/UpdateEmail");
        }
    }
}