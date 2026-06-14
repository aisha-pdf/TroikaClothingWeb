using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using TroikaClothingWeb.Services;
using System.Text.RegularExpressions;

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
                        if (IsValidPassword(Password.Text))
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
                            LblMessage.Text = "Password must be 6 to 8 characters long and include an uppercase letter, lowercase letter, number, and special character.";
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
        private bool IsValidPassword(string password)
        {
            if (string.IsNullOrWhiteSpace(password))
            {
                return false;
            }

            return password.Length >= 6 &&
                   password.Length <= 8 &&
                   Regex.IsMatch(password, @"[A-Z]") &&
                   Regex.IsMatch(password, @"[a-z]") &&
                   Regex.IsMatch(password, @"[0-9]") &&
                   Regex.IsMatch(password, @"[!@#$%^&*(),.?""{}|<>]");
        }

        private string GetCustomerIDByUsername(string username)
        {
            return new UserService().GetCustomerIdByUsername(username);
        }

        protected void DSClose_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
    }
}