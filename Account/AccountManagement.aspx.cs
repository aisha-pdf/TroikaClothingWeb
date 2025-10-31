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
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                foreach (GridViewRow row in gvUsers.Rows)
                {
                    if (row.Cells[4].Text == Session["Username"].ToString())
                    {
                        FirstName.Text = row.Cells[1].Text;
                        LastName.Text = row.Cells[2].Text;
                        Email.Text = row.Cells[3].Text;
                        Password.Text = row.Cells[5].Text;

                    }
                }
            }
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

        protected void CloseAccount_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/CloseAccount");
        }

        protected void SaveChanges_Click(object sender, EventArgs e)
        {

        }
    }
}