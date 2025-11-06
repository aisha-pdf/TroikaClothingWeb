using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

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
                        ID.Text = row.Cells[0].Text.ToString();
                        break;
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
            if (DSClose.UpdateParameters["ID"]!=null)
            {
                DSClose.UpdateParameters["ID"].DefaultValue = ID.Text;
                DSClose.Update();
                Response.Redirect("~/Login");
            }
        }

        protected void SaveChanges_Click(object sender, EventArgs e)
        {
            if (FirstName.Text.Length > 0)
            {
                if (LastName.Text.Length > 0)
                {
                    if ((Email.Text.Length > 0) && (Email.Text.Contains("@")))
                    {
                        if (Password.Text.Length == 8) 
                        {
                            if ((PhoneNumber.Text.Length <= 0)||(PhoneNumber.Text.Length ==10 && PhoneNumber.Text[0] == '0'))
                            {
                                if (DSClose.UpdateParameters["ID"] != null)
                                {
                                    DSUpdate.UpdateParameters["ID"].DefaultValue = ID.Text;
                                    DSUpdate.Update();
                                    LblMessage.Text = "Changes Saved Successfully";
                                    
                                }
                            }
                            else
                            {
                                LblMessage.Text = "Phone number must start with 0 and be 10 digits long.";
                            }
                        }
                        else
                        {
                            LblMessage.Text = "Password must be exactly 8 characters long.";
                        }
                    }
                    else
                    {
                        LblMessage.Text = "Please enter a valid email address.";
                    }

                }
                else
                {
                    LblMessage.Text = "Last name cannot be empty.";
                }

            }
            else
            {
                LblMessage.Text = "First name cannot be empty.";
            }
        }

        private string GetCustomerIDByUsername(string username)
        {
            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
            string customerID = null;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(@"
        SELECT c.customerID 
        FROM Customer c
        INNER JOIN WebsiteRegister r ON r.Email = c.email
        INNER JOIN WebsiteLogin l ON l.Username = r.Username
        WHERE l.Username = @u", con))
            {
                cmd.Parameters.AddWithValue("@u", username);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    customerID = result.ToString();
            }

            return customerID;
        }

        protected void DSClose_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
    }
}