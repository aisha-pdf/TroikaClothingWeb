using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Models;

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
                LoadRelatedProducts(); 
            }
        }

        private void LoadProductDetails()
        {
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
                cmd.Parameters.AddWithValue("@ProductID", productId);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblProductName.Text = reader["ProductName"].ToString();
                    lblProductDescription.Text = reader["Description"].ToString();
                    lblCategory.Text = reader["Category"].ToString();
                    lblProductPrice.Text = "R" + Convert.ToDecimal(reader["Price"]).ToString("0.00");

                    if (reader["Picture"] != DBNull.Value)
                        imgProduct.ImageUrl = $"~/Public Pages/ProductImageHandler.ashx?id={HttpUtility.UrlEncode(productId)}";
                    else
                        imgProduct.ImageUrl = "~/images/image-placeholder.png";
                }
                else
                {
                    lblProductName.Text = "Product not found.";
                }
            }
        }


        protected void btnSizeGuide_Click(object sender, EventArgs e)
        {
            pnlOverlay.Visible = true;
        }

        protected void btnClosePopup_Click(object sender, EventArgs e)
        {
            pnlOverlay.Visible = false;
        }


        private void LoadRelatedProducts() //shows similar products from the same category and reloads the page once clicked
        {
            string productId = Request.QueryString["id"];
            string category = lblCategory.Text;

            if (string.IsNullOrEmpty(productId) || string.IsNullOrEmpty(category)) return;

            //selects 4 products from the same category excluding the current product
            DataTable dtRelated = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(  
                "SELECT TOP 4 ProductID, ProductName, Price, Picture FROM Product WHERE Category = @Category AND ProductID <> @ProductID AND Status='Active'", con))
            {
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@ProductID", productId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtRelated);
            }

            // Add image path and detail URL for each related product
            dtRelated.Columns.Add("ImagePath", typeof(string));
            dtRelated.Columns.Add("DetailUrl", typeof(string));
            foreach (DataRow row in dtRelated.Rows)
            {
                string id = row["ProductID"].ToString();
                row["ImagePath"] = $"~/Public Pages/ProductImageHandler.ashx?id={HttpUtility.UrlEncode(id)}";
                row["DetailUrl"] = $"~/Public Pages/ProductDetail.aspx?id={HttpUtility.UrlEncode(id)}";
            }

            dlRelatedProducts.DataSource = dtRelated;
            dlRelatedProducts.DataBind();
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Session["ReturnUrl"] = Request.RawUrl;
                Response.Redirect("~/Login.aspx");
                return;
            }

            string productId = Request.QueryString["id"];
            if (string.IsNullOrWhiteSpace(productId)) return;

            string name = "", imageUrl = "";
            decimal price = 0;

            using (var con = new SqlConnection(connectionString))
            using (var cmd = new SqlCommand("SELECT ProductName, Price FROM Product WHERE ProductID = @id AND Status='Active'", con))
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
            Response.Redirect("~/Public Pages/Cart.aspx");
        }
    }
}
