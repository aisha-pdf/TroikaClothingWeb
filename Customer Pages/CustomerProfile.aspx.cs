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
            if (string.IsNullOrEmpty(username))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            else
            {
                WebProfileDS.SelectParameters["username"].DefaultValue = username;
            }

            string customerID = GetCustomerIDByUsername(username);
            ProfileDS.SelectParameters["custID"].DefaultValue = customerID;

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

        protected void dvWebProfile_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
        {

        }
    }
}