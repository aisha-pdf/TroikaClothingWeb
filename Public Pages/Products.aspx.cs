using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class Products : System.Web.UI.Page
    {
        
        string connectionString = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
               // ddlCategory.SelectedValue = "all";
            }
        }

        // Load all products, or filter by category and search term
        private void LoadProducts(string category = "all", string search = "")
        {
            string query = "SELECT ProductID, ProductName, Description, Category, Price, Picture FROM Product WHERE Status = 'Active'";
            bool hasCondition = false;

            if (category != "all" || !string.IsNullOrEmpty(search))
            {
                if (category != "all")
                {
                    query += " AND Category = @Category";
                }
                if (!string.IsNullOrEmpty(search))
                {
                    query += " AND (ProductName LIKE @Search OR Description LIKE @Search)";
                }
            }

            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (category != "all")
                    cmd.Parameters.AddWithValue("@Category", category);
                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            // Compute and attach ImageUrl for display — use the handler to stream images
            dt.Columns.Add("ImageUrl", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                // Use handler for database-stored images to avoid large base64 inline blocks
                if (row["Picture"] != DBNull.Value)
                {
                    row["ImageUrl"] = $"~/Public Pages/ProductImageHandler.ashx?id={row["ProductID"]}";
                }
                else
                {
                    row["ImageUrl"] = "~/images/no-image.png"; // fallback image file on disk
                }
            }

            // Bind results to DataList
            if (dt.Rows.Count > 0)
            {
                dlProducts.DataSource = dt;
                dlProducts.DataBind();
                lblNoProducts.Visible = false;
            }
            else
            {
                dlProducts.DataSource = null;
                dlProducts.DataBind();
                lblNoProducts.Visible = true;
            }
        }

        // Handles Search button click
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts(ddlCategory.SelectedValue, txtSearch.Text.Trim());
        }

        // Handles category filter change
        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts(ddlCategory.SelectedValue, txtSearch.Text.Trim());

           
        }

        // Handles "View Details" button click inside DataList
        protected void dlProducts_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string productId = e.CommandArgument.ToString();
                // Navigate to product detail page
                Response.Redirect($"ProductDetail.aspx?id={productId}");
            }
        }

        protected void ddlCategory_DataBound(object sender, EventArgs e)
        {
            // Insert "All Categories" as the first item AFTER data is bound
            ddlCategory.Items.Insert(0, new ListItem("All Categories", "all"));
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            // Clear both the search text and the category filter
            txtSearch.Text = string.Empty;
            ddlCategory.SelectedValue = "all";

            // Reload all products
            LoadProducts("all", "");
        }
    }
}
