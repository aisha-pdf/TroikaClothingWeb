using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb.Sale_Pages
{
    public partial class SaleHistory : System.Web.UI.Page
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

            string customerID = GetCustomerIDByUsername(username);

            //fil gvSale with customer's sales
            SaleOrderDS.SelectParameters["CusID"].DefaultValue=customerID;

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


        protected void gvSale_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            //string recID = gvSale.DataKeys[gvSale.SelectedIndex].Value.ToString();
            //ProductsSold.SelectParameters["recID"].DefaultValue = recID;
            //lvProductsSold.DataBind();
        }

        protected void gvSale_SelectedIndexChanged(object sender, EventArgs e)
        {
            string recID = gvSale.DataKeys[gvSale.SelectedIndex].Value.ToString();
            ProductsSold.SelectParameters["recID"].DefaultValue = recID;
            lvProductsSold.DataBind();
        }

        protected string GetImageUrl(object imageObj, object nameObj)
        {
            //default no image found string
            string defaultImage = "~/Images/Image_not_available.png";

            // if there's no image in db, show default
            if (imageObj == DBNull.Value || imageObj == null)
                return ResolveUrl(defaultImage);

            byte[] imageBytes = (byte[])imageObj;

            // converting files of different files types to jpeg
            string mimeType = "image/jpeg";
            if (nameObj != DBNull.Value && nameObj != null)
            {
                string name = nameObj.ToString().ToLower();
                if (name.EndsWith(".png")) mimeType = "image/png";
                else if (name.EndsWith(".gif")) mimeType = "image/gif";
                else if (name.EndsWith(".bmp")) mimeType = "image/bmp";
                else if (name.EndsWith(".webp")) mimeType = "image/webp";
                else mimeType = "image/jpeg";
            }

            // Convert to base64 string
            string base64String = Convert.ToBase64String(imageBytes);
            return $"data:{mimeType};base64,{base64String}";
        }

    }
}