using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb
{
    public partial class _Default : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDresses();
                
            }
        }

        protected void dlDresses_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string productId = e.CommandArgument.ToString();
                // Navigate to product detail page
                Response.Redirect($"~/Public Pages/ProductDetail.aspx?id={productId}");
            }
        }


        // Loading products into dlDresses
        private void LoadDresses()
        {
            string query = "SELECT TOP 10 ProductID, ProductName, Description, Category, Price, Picture FROM Product WHERE Status = 'Active' AND Category = 'Dress'";

            //basically making a datasource for the datalist
            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            //loading pics onto the db -- if there's no image show image not found
            dt.Columns.Add("ImageUrl",typeof(string));

            foreach (DataRow dr in dt.Rows)
            {
                if (dr["Picture"] != DBNull.Value)
                {
                    dr["ImageUrl"] = $"~/Public Pages/ProductImageHandler.ashx?id={dr["ProductID"]}";
                }
                else
                {
                    dr["ImageUrl"] = "~/images/no-image.png";
                }
            }

            //binding data source to dlDresses
            dlDresses.DataSource = dt;
            dlDresses.DataBind();

        }

        protected void dlPyjamas_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                string productId = e.CommandArgument.ToString();
                // Navigate to product detail page
                Response.Redirect($"~/Public Pages/ProductDetail.aspx?id={productId}");
            }
        }

        protected void btnProducts_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Public Pages/Products.aspx");
        }
    }
}