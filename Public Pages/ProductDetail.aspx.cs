using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductDetails();
            }
        }

        private void LoadProductDetails()
        {
            // Get ProductID from query string
            string productId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(productId))
            {
                lblProductName.Text = "Product not found.";
                return;
            }

            string query = "SELECT ProductName, Description, Category, Price, Picture FROM Product WHERE ProductID = @ProductID";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                // ProductID is a string (e.g. 'P001')
                cmd.Parameters.AddWithValue("@ProductID", productId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblProductName.Text = reader["ProductName"].ToString();
                    lblProductDescription.Text = reader["Description"].ToString();
                    lblCategory.Text = reader["Category"].ToString();
                    lblProductPrice.Text = "R" + Convert.ToDecimal(reader["Price"]).ToString("0.00");

                    // Handle image
                    // Use handler to serve the image
                    if (reader["Picture"] != DBNull.Value)
                    {
                        // Stream via handler (faster and avoids large page payloads)
                        imgProduct.ImageUrl = $"~/Public Pages/ProductImageHandler.ashx?id={HttpUtility.UrlEncode(productId)}";
                    }
                    else
                    {
                        imgProduct.ImageUrl = "~/images/image-placeholder.png";
                    }
                }
                else
                {
                    lblProductName.Text = "Product not found.";
                }
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            // Optional: implement Add to Cart logic later
        }
    }
}
