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
            }
        }

        // Load all products, or filter by category and search term
        private void LoadProducts(string category = "all", string search = "")
        {
            string query = "SELECT ProductID, ProductName, Description, Category, Price, Picture FROM Product";
            bool hasCondition = false;

            if (category != "all" || !string.IsNullOrEmpty(search))
            {
                query += " WHERE ";
                if (category != "all")
                {
                    query += "Category = @Category";
                    hasCondition = true;
                }
                if (!string.IsNullOrEmpty(search))
                {
                    if (hasCondition) query += " AND ";
                    query += "(ProductName LIKE @Search OR Description LIKE @Search)";
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

            // Compute and attach ImageUrl for display
            dt.Columns.Add("ImageUrl", typeof(string));
            foreach (DataRow row in dt.Rows)
            {
                if (row["Picture"] != DBNull.Value)
                {
                    byte[] imgBytes = (byte[])row["Picture"];
                    row["ImageUrl"] = "data:image/jpeg;base64," + Convert.ToBase64String(imgBytes);
                }
                else
                {
                    row["ImageUrl"] = "~/images/no-image.png"; // fallback image
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
    }
}
