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
        string phoneNo = "";

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

            if (CustomerForm.CurrentMode == FormViewMode.Edit)
            {
                // Try to get the phone number textbox from the FormView
                TextBox phoneNum = (TextBox)CustomerForm.FindControl("PhoneNumber");

                if (phoneNum != null)
                {
                    string phoneNo = phoneNum.Text.Trim();

                    // Try to get the label from the DetailsView
                    Label lblPhone = (Label)DetailsView1.FindControl("lblPhoneNum");
                    if (lblPhone != null)
                    {
                        lblPhone.Text = phoneNo;
                    }
                }
            }

            //TextBox phoneNum = (TextBox)CustomerForm.FindControl("PhoneNumber");
            //if (phoneNum == null && CustomerForm.CurrentMode == FormViewMode.Edit)
            //{
            //    phoneNum = (TextBox)CustomerForm.Row.FindControl("PhoneNumber");
            //    phoneNo = phoneNum.Text;
            //    Label lblPhone = (Label)DetailsView1.FindControl("lblPhoneNumber");


            //    if (lblPhone == null)
            //    {
            //        lblPhone = (Label)DetailsView1.Rows[0].FindControl("lblPhoneNumber");
            //        lblPhone.Text = phoneNo;
            //    }

            //}


            string customerID = GetCustomerIDByUsername(username);
            DSAddress.SelectParameters["CusID"].DefaultValue = customerID;
            DSAddress.UpdateParameters["CusID"].DefaultValue = customerID;
           
        }

        //protected void Page_PreRender(object sender, EventArgs e)
        //{
        //    if (CustomerForm.CurrentMode == FormViewMode.Edit)
        //    {
        //        // Try to get the phone number textbox from the FormView
        //        TextBox phoneNum = (TextBox)CustomerForm.FindControl("PhoneNumber");

        //        if (phoneNum != null)
        //        {
        //            string phoneNo = phoneNum.Text.Trim();

        //            // Try to get the label from the DetailsView
        //            Label lblPhone = (Label)DetailsView1.FindControl("lblPhoneNum");
        //            if (lblPhone != null)
        //            {
        //                lblPhone.Text = phoneNo;
        //            }
        //        }
        //    }
        //}


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
                // 1️⃣ Get the phone number textbox from the FormView
                TextBox txtPhone = (TextBox)CustomerForm.FindControl("PhoneNumber");
                string newPhone = txtPhone != null ? txtPhone.Text.Trim() : "";

                // 2️⃣ Update the FormView data
                CustomerForm.UpdateItem(true);

                // 3️⃣ Try to find the phone number label inside DetailsView
                Label lblPhone = (Label)DetailsView1.FindControl("lblPhoneNumber");
                if (lblPhone != null)
                {
                    lblPhone.Text = newPhone;  // update it manually
                }
                else
                {
                    // For debugging: helps if the label can’t be found
                    LblMessage.ForeColor = System.Drawing.Color.Red;
                    LblMessage.Text = "Warning: Phone label not found in DetailsView.";
                }

                // 4️⃣ Display success message
                LblMessage.ForeColor = System.Drawing.Color.Green;
                LblMessage.Text = "Your details have been updated successfully.";
            }
            catch (Exception ex)
            {
                // 5️⃣ Show error if something fails
                LblMessage.ForeColor = System.Drawing.Color.Red;
                LblMessage.Text = "Error updating record: " + ex.Message;
                e.Cancel = true;
            }
        }

        //protected void CustomerForm_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        //{
        //    try
        //    {
        //        // perform update and display a success message
        //        CustomerForm.UpdateItem(true);

        //        //updating phonenumber label 
        //        TextBox phoneNum = (TextBox)CustomerForm.FindControl("PhoneNumber");
        //        phoneNo = phoneNum.Text;
        //        Label lblPhone = (Label)DetailsView1.FindControl("lblPhoneNumber");
        //        lblPhone.Text = phoneNo;

        //        //show success message
        //        LblMessage.ForeColor = System.Drawing.Color.Green;
        //        LblMessage.Text = "Your details have been updated";
        //    }
        //    catch (Exception ex)
        //    {
        //        // show error message
        //        LblMessage.ForeColor = System.Drawing.Color.Red;
        //        LblMessage.Text = "Error updating record: " + ex.Message;

        //        // cancel changes made
        //        e.Cancel = true;
        //    }
        //}

        protected void DetailsView1_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "CancelChanges")
            {
                DetailsView1.ChangeMode(DetailsViewMode.Edit);
                DetailsView1.DataBind();
            }
        }

        protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            try
            {
                // if update is successful
                LblMessage.ForeColor = System.Drawing.Color.Green;
                LblMessage.Text = "Address has been updated";
            }
            catch (Exception ex)
            {
                // show error message
                LblMessage.ForeColor = System.Drawing.Color.Red;
                LblMessage.Text = "Error updating record: " + ex.Message;
            }
        }

        protected void DetailsView1_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            try
            {
                // getting data from text boxes
                DetailsView dv = (DetailsView)sender;
                TextBox txtStreet = (TextBox)dv.FindControl("txtStreetAddress");
                TextBox txtSuburb = (TextBox)dv.FindControl("txtSuburb");
                TextBox txtPostCode = (TextBox)dv.FindControl("txtPostCode");

                // validating street address
                if (string.IsNullOrWhiteSpace(txtStreet.Text))
                {
                    e.Cancel = true;
                    LblMessage.ForeColor = System.Drawing.Color.Red;
                    LblMessage.Text = "Please fill in your street address";
                    return;
                }

                // validating suburb
                if (string.IsNullOrWhiteSpace(txtSuburb.Text))
                {
                    e.Cancel = true;
                    LblMessage.ForeColor = System.Drawing.Color.Red;
                    LblMessage.Text = "Please fill in your suburb";
                    return;
                }


                // validating postal code
                if (string.IsNullOrWhiteSpace(txtPostCode.Text) || txtPostCode.Text.Length != 4)
                {
                    e.Cancel = true;
                    LblMessage.ForeColor = System.Drawing.Color.Red;
                    LblMessage.Text = "Please fill in your postal code";
                    return;
                }


                // Optional success message before update
                LblMessage.ForeColor = System.Drawing.Color.Green;
                LblMessage.Text = "Updating your address...";
            }
            catch (Exception ex)
            {
                e.Cancel = true; // Stop the update if something fails
                LblMessage.ForeColor = System.Drawing.Color.Red;
                LblMessage.Text = "Error while updating: " + ex.Message;
            }
        }

        protected void btnCloseAccount_Click(object sender, EventArgs e)
        {
            try
            {
                TextBox txtUsername = (TextBox)CustomerForm.FindControl("Username");
                TextBox txtEmail = (TextBox)CustomerForm.FindControl("Email");

                if (txtUsername == null)
                {
                    LblMessage.ForeColor = System.Drawing.Color.Red;
                    LblMessage.Text = "Username not found.";
                    return;
                }
            
                DSCloseLogin.UpdateParameters["Username"].DefaultValue = txtUsername.Text;
                DSCloseRegister.UpdateParameters["Username"].DefaultValue = txtUsername.Text;
               
                Boolean find = false;

                foreach (GridViewRow row in gvCustomer.Rows)
                {
                    if(row.Cells[1].Text == txtEmail.Text)
                    {
                        DSCloseCustomer.UpdateParameters["customerID"].DefaultValue = row.Cells[0].Text;
                        find = true;
                        break;
                    }

                }

                if (find == true)
                {
                    DSCloseCustomer.Update();
                    DSCloseLogin.Update();
                    DSCloseRegister.Update();
                    Response.Redirect("~/Login.aspx");
                }

            }
            catch (Exception ex)
            {
                LblMessage.ForeColor = System.Drawing.Color.Red;
                LblMessage.Text = "Error while updating: " + ex.Message;
            }

            if (!IsPostBack)
            {
                CustomerForm.DataBind();
            }
        }
    }
}
