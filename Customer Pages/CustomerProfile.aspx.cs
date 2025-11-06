using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb.Customer_Pages
{
    public partial class CustomerProfile : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            //getting username and customer ID of Customer
            string username = Session["Username"]?.ToString();
            if (!IsPostBack)
            {
                if (Session["Username"] != null)
                {
                    DSWebDetails.DataBind();
                    this.DataBind(); // fills textboxes with data
                }
                else
                {
                    Response.Redirect("~/Login.aspx"); // if not logged in
                }
            }

            string customerID = GetCustomerIDByUsername(username);
            //lblCusID.Text = customerID;
            DSAddress.SelectParameters["CusID"].DefaultValue = customerID;
            DSAddress.UpdateParameters["CusID"].DefaultValue = customerID;
            //fvAddress.DataBind();

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

        protected void SaveChanges_Click(object sender, EventArgs e)
        {

        }

        protected void CloseAccount_Click(object sender, EventArgs e)
        {

        }

        protected void CustomerForm_ItemCommand(object sender, FormViewCommandEventArgs e)
        {
            //if cancelled button is clicked reload data
            if (e.CommandName == "Cancel")
            {
                CustomerForm.ChangeMode(FormViewMode.Edit);
                CustomerForm.DataBind();
            }
        }

        protected void CustomerForm_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            try
            {
                // perform update and display a success message
                CustomerForm.UpdateItem(true); 
                LblMessage.ForeColor = System.Drawing.Color.Green;
                LblMessage.Text = "Update successful!";
            }
            catch (Exception ex)
            {
                // show error message
                LblMessage.ForeColor = System.Drawing.Color.Red;
                LblMessage.Text = "Error updating record: " + ex.Message;

                // cancel changes made
                e.Cancel = true;
            }
        }

        protected void DetailsView1_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DetailsView1.ChangeMode(DetailsViewMode.Edit);
                DetailsView1.DataBind();
            }
        }

        //protected void fvAddress_ItemCommand(object sender, FormViewCommandEventArgs e)
        //{
        //    //if cancelled button is clicked reload data
        //    if (e.CommandName == "Cancel")
        //    {
        //        CustomerForm.ChangeMode(FormViewMode.Edit);
        //        CustomerForm.DataBind();
        //    }
        //}

        //protected void fvAddress_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        //{
        //    string username = Session["Username"]?.ToString();
        //    string customerID = GetCustomerIDByUsername(username);
        //    DSAddress.UpdateParameters["CusID"].DefaultValue = customerID;
        //}

        //protected void fvAddress_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        //{
        //    if (e.Exception != null)
        //    {
        //        LblMessage.ForeColor = System.Drawing.Color.Red;
        //        LblMessage.Text = "Error updating address: " + e.Exception.Message;
        //        e.ExceptionHandled = true;
        //    }
        //    else
        //    {
        //        LblMessage.ForeColor = System.Drawing.Color.Green;
        //        LblMessage.Text = "Address updated successfully!";
        //    }
        //}
    }
}