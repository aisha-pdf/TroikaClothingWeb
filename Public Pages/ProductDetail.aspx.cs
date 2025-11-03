using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Models;
using static System.Collections.Specialized.BitVector32;

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
                // ProductID is a string
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
                        // Stream via image handler
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
                // Require login as Customer
                if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
                {
                    // send them to login, then back here
                    Session["ReturnUrl"] = Request.RawUrl;
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                string productId = Request.QueryString["id"];
                if (string.IsNullOrWhiteSpace(productId)) return;

                // Load the product’s name and price from DB 
                string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;
                string name = "", imageUrl = "", category = "";
                decimal price = 0;

                using (var con = new SqlConnection(cs))
                using (var cmd = new SqlCommand(
                    "SELECT ProductName, Price FROM Product WHERE ProductID = @id AND Status='Active'", con))
                {
                    cmd.Parameters.AddWithValue("@id", productId);
                    con.Open();
                    using (var r = cmd.ExecuteReader())
                    {
                        if (!r.Read()) return;
                        name = r["ProductName"].ToString();
                        price = Convert.ToDecimal(r["Price"]);
                    }
                }

            // Use the same handler you already have for images
            // ImageUrl = '<%# ResolveUrl("~/Admin Pages/ProductImageHandler.ashx?id=" + Eval("ProductID") + "&v=" + DateTime.Now.Ticks) %>'
            imageUrl = ResolveUrl($"~/Public Pages/ProductImageHandler.ashx?id={HttpUtility.UrlEncode(productId)}");

            var item = new CartItem
                {
                    ProductID = productId,
                    ProductName = name,
                    UnitPrice = price,
                    Quantity = int.TryParse(txtQuantity.Text, out var q) ? Math.Max(1, q) : 1,
                    Colour = ddlColor.SelectedValue,
                    ClothingSize = ddlSize.SelectedValue,
                    ImageUrl = imageUrl
                };

                ShoppingCart.AddOrIncrease(Session, item);

                // Redirect to Cart
                Response.Redirect("~/Public Pages/Cart.aspx");
            }


}
}
