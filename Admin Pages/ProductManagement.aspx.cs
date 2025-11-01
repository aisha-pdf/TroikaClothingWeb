using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TroikaClothingWeb.Admin_Pages
{
    public partial class ProductManagement : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Default to showing the product list
            if (!IsPostBack)
            {
                PanelAddProduct.Visible = false;
                GridViewProducts.Visible = true;
            }
        }

        protected void btnProductList_Click(object sender, EventArgs e)
        {
            GridViewProducts.Visible = true;
            PanelAddProduct.Visible = false;
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {

            GridViewProducts.Visible = false;
            PanelAddProduct.Visible = true;

            // Generate new ProductID and display it
            txtProductID.Text = GetNextProductID();

            // Clear other fields
            txtName.Text = "";
            txtDescription.Text = "";
            txtCategory.Text = "";
            txtProductionTime.Text = "";
            txtPrice.Text = "";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Example logout logic
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            PanelAddProduct.Visible = false;
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        { 
            ClearAllFields();

            ValidateAllFields();

            byte[] imageBytes = null;

            if (FileUploadImage.HasFile)
            {
                using (BinaryReader br = new BinaryReader(FileUploadImage.PostedFile.InputStream))
                {
                    imageBytes = br.ReadBytes(FileUploadImage.PostedFile.ContentLength);
                }
            }

            string newProductID = txtProductID.Text;

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "INSERT INTO Product (ProductID, ProductName, Description, Category, ProductionTime, Price, Picture) " +
                                   "VALUES (@ProductID, @ProductName, @Description, @Category, @ProductionTime, @Price, @Picture)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ProductID", newProductID);
                        cmd.Parameters.AddWithValue("@ProductName", txtName.Text);
                        cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                        cmd.Parameters.AddWithValue("@Category", txtCategory.Text);
                        cmd.Parameters.AddWithValue("@ProductionTime", txtProductionTime.Text);
                        cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtPrice.Text));

                        if (imageBytes != null)
                            cmd.Parameters.Add("@Picture", System.Data.SqlDbType.VarBinary).Value = imageBytes;
                        else
                            cmd.Parameters.Add("@Picture", System.Data.SqlDbType.VarBinary).Value = DBNull.Value;

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Refresh the grid and show success
                GridViewProducts.DataBind();

                // Show success message
                string TempNewProductID = newProductID;
                lblStatus.ForeColor = System.Drawing.Color.Green;
                lblStatus.Text = "Product added successfully with product ID: " + TempNewProductID;

                ClearAllFields();

                // Generate new ProductID and display it
                txtProductID.Text = GetNextProductID();



            }
            catch (Exception ex)
            {
                // Show error message
                lblStatus.ForeColor = System.Drawing.Color.Red;
                lblStatus.Text = "Failed to add product: " + ex.Message;
            }

        }

        protected void txtField_TextChanged(object sender, EventArgs e)
        {
            TextBox tb = sender as TextBox;

            // Clear border and error label
            tb.BorderColor = System.Drawing.Color.Empty;

            switch (tb.ID)
            {
                case "txtName":
                    lblNameError.Text = "";
                    break;
                case "txtDescription":
                    lblDescriptionError.Text = "";
                    break;
                case "txtCategory":
                    lblCategoryError.Text = "";
                    break;
                case "txtProductionTime":
                    lblProductionTimeError.Text = "";
                    break;
                case "txtPrice":
                    lblPriceError.Text = "";
                    break;
            }
        }





        public string GetNextProductID()
        {
            DataView dv = (DataView)SqlDslastID.Select(DataSourceSelectArguments.Empty);

            if (dv != null && dv.Count > 0)
            {
                string lastID = dv[0]["ProductID"].ToString();
                int numberPart = int.Parse(lastID.Substring(1));
                numberPart++;
                string newID = "P" + numberPart.ToString("D3"); 

                return newID;
            }

            return "P000";
        }

        public void ValidateAllFields()
        {
            bool hasError = false;

            // Validation: check required fields and highlight
            if (string.IsNullOrWhiteSpace(txtProductID.Text))
            {
                txtProductID.BorderColor = System.Drawing.Color.Red;
                lblProductIDError.Text += "Product ID cannot be blank.";
                hasError = true;
            }
            if (string.IsNullOrWhiteSpace(txtName.Text))
            {
                txtName.BorderColor = System.Drawing.Color.Red;
                lblNameError.Text = "Product Name cannot be blank.";
                hasError = true;
            }
            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                txtDescription.BorderColor = System.Drawing.Color.Red;
                lblDescriptionError.Text = "Description cannot be blank.";
                hasError = true;
            }
            if (string.IsNullOrWhiteSpace(txtCategory.Text))
            {
                txtCategory.BorderColor = System.Drawing.Color.Red;
                lblCategoryError.Text = "Category cannot be blank.";
                hasError = true;
            }
            if (string.IsNullOrWhiteSpace(txtProductionTime.Text))
            {
                txtProductionTime.BorderColor = System.Drawing.Color.Red;
                lblProductionTimeError.Text = "Production Time cannot be blank.";
                hasError = true;
            }

            if (string.IsNullOrWhiteSpace(txtPrice.Text))
            {
                txtPrice.BorderColor = System.Drawing.Color.Red;
                lblPriceError.Text = "Price cannot be blank.";
                hasError = true;
            }
            else if (!decimal.TryParse(txtPrice.Text, out decimal priceValue) || priceValue <= 0)
            {
                txtPrice.BorderColor = System.Drawing.Color.Red;
                lblPriceError.Text = "Price must be greater than 0.";
                hasError = true;
            }

            if (hasError)
            {
                lblStatus.ForeColor = System.Drawing.Color.Red;
                lblStatus.Text += "Please fill in all required fields correctly.";
                return;
            }
        }

        public void ClearAllFields()
        {
            // Clear fields
            lblStatus.Text = "";
            txtName.Text = "";
            txtDescription.Text = "";
            txtCategory.Text = "";
            txtProductionTime.Text = "";
            txtPrice.Text = "";
            FileUploadImage.Dispose();

            // Reset border colors
            txtProductID.BorderColor = System.Drawing.Color.Empty;
            txtName.BorderColor = System.Drawing.Color.Empty;
            txtDescription.BorderColor = System.Drawing.Color.Empty;
            txtCategory.BorderColor = System.Drawing.Color.Empty;
            txtProductionTime.BorderColor = System.Drawing.Color.Empty;
            txtPrice.BorderColor = System.Drawing.Color.Empty;

            // Clear all fields
            txtProductID.Text = "";
            txtName.Text = "";
            txtDescription.Text = "";
            txtCategory.Text = "";
            txtProductionTime.Text = "";
            txtPrice.Text = "";

        }

        protected void GridViewProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = GridViewProducts.Rows[e.RowIndex];
            FileUpload fileUpload = (FileUpload)row.FindControl("FileUploadEditImage");

            if (fileUpload != null && fileUpload.HasFile)
            {
                using (BinaryReader br = new BinaryReader(fileUpload.PostedFile.InputStream))
                {
                    byte[] imageBytes = br.ReadBytes(fileUpload.PostedFile.ContentLength);

                    // Replace existing Picture parameter value
                    SqlDSProduct.UpdateParameters["Picture"].DefaultValue = Convert.ToBase64String(imageBytes);
                }
            }
            else
            {
                // If no new image selected, keep the existing one
                SqlDSProduct.UpdateParameters["Picture"].ConvertEmptyStringToNull = false;
            }
        }

    }
}
