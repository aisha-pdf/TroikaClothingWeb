using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace TroikaClothingWeb.Admin_Pages
{
    public partial class ProductManagement : System.Web.UI.Page
    {
        private string ConnStr => System.Configuration.ConfigurationManager
                                    .ConnectionStrings["LoginConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Always show product list by default
                PanelList.Visible = true;
                PanelAdd.Visible = false;

                // Default filter value
                ddlStatusFilter.SelectedValue = "Active";
                ddlSort.SelectedValue = "ProductID ASC";

                // Get next product ID for add form
                txtProductID.Text = GetNextProductID();

                // Bind gridview to show all active products from DB
                GridViewProducts.DataBind();
            }
        }

        //Sidebar buttons
        protected void btnViewProducts_Click(object sender, EventArgs e)
        {
            ShowList();
            ddlStatusFilter.SelectedValue = "Active";
            ddlSort.SelectedValue = "ProductID ASC";
            GridViewProducts.DataBind();
        }

        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            ShowAdd();
            ClearAddForm();
            txtProductID.Text = GetNextProductID();
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            ShowList();
        }

        //Filtering/Sorting
        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewProducts.PageIndex = 0;
            GridViewProducts.DataBind();
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewProducts.PageIndex = 0;
            GridViewProducts.DataBind();
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            GridViewProducts.PageIndex = 0;
            GridViewProducts.DataBind();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlStatusFilter.SelectedValue = "Active";
            ddlSort.SelectedValue = "ProductID ASC";
            txtSearch.Text = string.Empty;
            GridViewProducts.DataBind();
        }



        protected void SqlDSProducts_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            string filter = ddlStatusFilter.SelectedValue;
            string baseQuery = "SELECT ProductID, ProductName, [Description], Category, ProductionTime, Price, Picture, Status FROM Product";

            string whereClause = "";
            if (filter == "Active" || filter == "Inactive")
                whereClause = " WHERE Status = @Status";
            else
                whereClause = " WHERE 1=1";

            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                whereClause += " AND (ProductName LIKE @Q OR [Description] LIKE @Q)";

            string orderBy = " ORDER BY " + ddlSort.SelectedValue;

            e.Command.CommandText = baseQuery + whereClause + orderBy;
            e.Command.Parameters.Clear();

            if (filter == "Active" || filter == "Inactive")
                e.Command.Parameters.Add(new SqlParameter("@Status", filter));

            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                e.Command.Parameters.Add(new SqlParameter("@Q", "%" + txtSearch.Text.Trim() + "%"));
        }


        //Grid: toggle status
        protected void GridViewProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                string productId = e.CommandArgument.ToString();
                SqlDSToggle.UpdateParameters["ProductID"].DefaultValue = productId;
                SqlDSToggle.Update();
                GridViewProducts.DataBind();
                return;
            }

            if (e.CommandName == "EditProduct")
            {
                string productId = e.CommandArgument.ToString();
                LoadProductForEdit(productId);
                return;
            }
        }


        protected void btnUpdateProduct_Click(object sender, EventArgs e)
        {
            string productId = hfEditProductID.Value;

            //Validate required fields
            string name = txtEditName.Text.Trim();
            string desc = txtEditDesc.Text.Trim();
            string category = txtEditCategory.Text.Trim();
            string productionTime = txtEditProductionTime.Text.Trim();
            string priceText = txtEditPrice.Text.Trim();
            string status = ddlEditStatus.SelectedValue;

            lblEditResult.ForeColor = System.Drawing.ColorTranslator.FromHtml("#d93025");

            //vadidation
            ResetEditValidationStyles();
            bool valid = true;

            // Product Name
            if (string.IsNullOrWhiteSpace(name))
            {
                MarkInvalid(txtEditName, lblEditNameError, "Name is required.");
                valid = false;
            }

            // Description
            if (string.IsNullOrWhiteSpace(desc))
            {
                MarkInvalid(txtEditDesc, lblEditDescError, "Description is required.");
                valid = false;
            }

            // Category
            if (string.IsNullOrWhiteSpace(category))
            {
                MarkInvalid(txtEditCategory, lblEditCategoryError, "Category is required.");
                valid = false;
            }

            // Production Time
            if (string.IsNullOrWhiteSpace(productionTime))
            {
                MarkInvalid(txtEditProductionTime, lblEditProductionTimeError, "Production time is required.");
                valid = false;
            }

            // Price
            if (!decimal.TryParse(priceText, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal price))
            {
                MarkInvalid(txtEditPrice, lblEditPriceError, "Enter a valid price (e.g., 199.99).");
                valid = false;
            }
            else if (price <= 0)
            {
                MarkInvalid(txtEditPrice, lblEditPriceError, "Price must be greater than zero.");
                valid = false;
            }

            if (!valid)
            {
                lblEditResult.Text = "Please correct the highlighted fields.";
                lblEditResult.ForeColor = System.Drawing.ColorTranslator.FromHtml("#d93025");
                ShowEdit();
                return;
            }



            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand(@"
            UPDATE Product
            SET ProductName=@ProductName,
                [Description]=@Description,
                Category=@Category,
                ProductionTime=@ProductionTime,
                Price=@Price,
                Status=@Status
            WHERE ProductID=@ProductID", conn))
                {
                    cmd.Parameters.AddWithValue("@ProductID", productId);
                    cmd.Parameters.AddWithValue("@ProductName", name);
                    cmd.Parameters.AddWithValue("@Description", desc);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@ProductionTime", productionTime);
                    cmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = price;
                    cmd.Parameters.AddWithValue("@Status", status);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                if (fuEditPicture.HasFile)
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE Product SET Picture=@Picture WHERE ProductID=@ProductID", conn))
                    {
                        cmd.Parameters.Add("@ProductID", SqlDbType.VarChar).Value = productId;
                        cmd.Parameters.Add("@Picture", SqlDbType.Image).Value = fuEditPicture.FileBytes;
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Success
                lblEditResult.Text = "Product updated successfully!";
                lblEditResult.ForeColor = System.Drawing.ColorTranslator.FromHtml("#1a7f37");

                // Refresh Grid and show list
                GridViewProducts.DataBind();
                ShowList();
            }
            catch (Exception ex)
            {
                lblEditResult.Text = "Error updating product: " + ex.Message;
                lblEditResult.ForeColor = System.Drawing.ColorTranslator.FromHtml("#d93025");
                ShowEdit();
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ShowList();
        }

        protected void GridViewProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Image img = e.Row.FindControl("imgProduct") as Image;
                if (img != null)
                {
                    // Force refetch
                    img.ImageUrl += "&v=" + DateTime.Now.Ticks.ToString();
                }
            }
        }

        //Grid: updating
        protected void SqlDSProducts_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
           
            GridViewRow row = GridViewProducts.Rows[GridViewProducts.EditIndex];
            if (row == null) return;

          
            FileUpload fu = (FileUpload)row.FindControl("fuEdit");

     
            if (e.Command.Parameters.Contains("@Picture"))
                e.Command.Parameters.RemoveAt("@Picture");

            SqlParameter picParam = new SqlParameter("@Picture", System.Data.SqlDbType.Image);

            if (fu != null && fu.HasFile)
            {
                using (BinaryReader br = new BinaryReader(fu.PostedFile.InputStream))
                {
                    byte[] bytes = br.ReadBytes(fu.PostedFile.ContentLength);
                    picParam.Value = bytes;
                }
            }
            else
            {
                // No new image uploaded
                picParam.Value = DBNull.Value;
            }

            e.Command.Parameters.Add(picParam);

            // Ensure Status is preserved correctly
            if (!e.Command.Parameters.Contains("@Status"))
            {
                DropDownList ddlStatus = (DropDownList)row.FindControl("ddlStatusEdit");
                string statusValue = ddlStatus != null ? ddlStatus.SelectedValue : "Active";
                e.Command.Parameters.Add(new SqlParameter("@Status", statusValue));
            }
        }

        protected void GridViewProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            e.Cancel = true;
            GridViewRow row = GridViewProducts.Rows[e.RowIndex];
            string productId = e.Keys["ProductID"].ToString();

            string name = (row.FindControl("txtProductNameEdit") as TextBox)?.Text.Trim();
            string desc = (row.FindControl("txtDescriptionEdit") as TextBox)?.Text.Trim();
            string category = (row.FindControl("txtCategoryEdit") as TextBox)?.Text.Trim();
            string productionTime = (row.FindControl("txtProductionTimeEdit") as TextBox)?.Text.Trim();
            string priceText = (row.FindControl("txtPriceEdit") as TextBox)?.Text.Trim();
            string status = (row.FindControl("ddlStatusEdit") as DropDownList)?.SelectedValue ?? "Active";

            if (string.IsNullOrEmpty(name)) name = "(Unnamed)";
            if (!decimal.TryParse(priceText, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal price))
                price = 0;

            // Perform the update
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE Product
                SET ProductName=@ProductName,
                    [Description]=@Description,
                    Category=@Category,
                    ProductionTime=@ProductionTime,
                    Price=@Price,
                    Status=@Status
                WHERE ProductID=@ProductID", conn))
            {
                cmd.Parameters.AddWithValue("@ProductID", productId);
                cmd.Parameters.AddWithValue("@ProductName", name);
                cmd.Parameters.AddWithValue("@Description", desc);
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@ProductionTime", productionTime);
                cmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = price;
                cmd.Parameters.AddWithValue("@Status", status);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            //Handle image upload 
            FileUpload fu = (FileUpload)row.FindControl("fuEdit");
            if (fu != null && fu.HasFile)
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE Product SET Picture=@Picture WHERE ProductID=@ProductID", conn))
                {
                    cmd.Parameters.Add("@ProductID", SqlDbType.VarChar).Value = productId;
                    cmd.Parameters.Add("@Picture", SqlDbType.Image).Value = fu.FileBytes;
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            GridViewProducts.EditIndex = -1;
            GridViewProducts.DataBind();
        }

        protected void GridViewProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            e.Cancel = true;
            GridViewProducts.EditIndex = e.NewEditIndex;
            GridViewProducts.DataBind();
        }

        protected void GridViewProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            e.Cancel = true;
            GridViewProducts.EditIndex = -1;
            GridViewProducts.DataBind();
        }



        // Add new product
        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            ResetValidationStyles();
            bool ok = true;

            if (string.IsNullOrWhiteSpace(txtName.Text)) { MarkInvalid(txtName, lblNameError, "Product name is required."); ok = false; }
            if (string.IsNullOrWhiteSpace(txtDesc.Text)) { MarkInvalid(txtDesc, lblDescError, "Description is required."); ok = false; }
            if (string.IsNullOrWhiteSpace(txtCategory.Text)) { MarkInvalid(txtCategory, lblCategoryError, "Category is required."); ok = false; }
            if (string.IsNullOrWhiteSpace(txtProductionTime.Text)) { MarkInvalid(txtProductionTime, lblProductionTimeError, "Production time is required."); ok = false; }

            decimal price;
            if (!decimal.TryParse(txtPrice.Text, out price))
            {
                MarkInvalid(txtPrice, lblPriceError, "Enter a valid price (e.g., 199.99).");
                ok = false;
            }
            else if (Convert.ToDecimal(txtPrice.Text) <= 0)
            {
                MarkInvalid(txtPrice, lblPriceError, "Price must be greater than zero.");
                ok = false;
            }

            if (!ok) return;

            byte[] imageBytes = null;
            if (fuPicture.HasFile)
            {
                using (BinaryReader br = new BinaryReader(fuPicture.PostedFile.InputStream))
                    imageBytes = br.ReadBytes(fuPicture.PostedFile.ContentLength);
            }

            string insertSql = @"INSERT INTO Product(ProductID, ProductName, [Description], Category, ProductionTime, Price, Picture, Status)
                         VALUES(@ProductID, @ProductName, @Description, @Category, @ProductionTime, @Price, @Picture, @Status)";

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(insertSql, conn))
            {
                cmd.Parameters.AddWithValue("@ProductID", txtProductID.Text.Trim());
                cmd.Parameters.AddWithValue("@ProductName", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Description", txtDesc.Text.Trim());
                cmd.Parameters.AddWithValue("@Category", txtCategory.Text.Trim());
                cmd.Parameters.AddWithValue("@ProductionTime", txtProductionTime.Text.Trim());
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.Add("@Picture", System.Data.SqlDbType.Image).Value = (object)imageBytes ?? DBNull.Value;
                cmd.Parameters.AddWithValue("@Status", ddlStatusAdd.SelectedValue);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            string tempID = txtProductID.Text;
            lblAddResult.Text = "Product added successfully with product ID: " + tempID;
            ClearAddForm();
            txtProductID.Text = GetNextProductID();
            GridViewProducts.DataBind();
        }


        private void ClearAddForm()
        {
            ResetValidationStyles();
            txtName.Text = "";
            txtDesc.Text = "";
            txtCategory.Text = "";
            txtProductionTime.Text = "";
            txtPrice.Text = "";
            ddlStatusAdd.SelectedValue = "Active";
            ddlSort.SelectedValue = "ProductID ASC";
        }

        private void ResetValidationStyles()
        {

            lblProductIDError.Text = lblNameError.Text = lblDescError.Text =
                lblCategoryError.Text = lblProductionTimeError.Text = lblPriceError.Text =
                lblPictureError.Text = lblStatusError.Text = "";

            txtProductID.CssClass = txtProductID.CssClass.Replace(" input-invalid", "");
            txtName.CssClass = txtName.CssClass.Replace(" input-invalid", "");
            txtDesc.CssClass = txtDesc.CssClass.Replace(" input-invalid", "");
            txtCategory.CssClass = txtCategory.CssClass.Replace(" input-invalid", "");
            txtProductionTime.CssClass = txtProductionTime.CssClass.Replace(" input-invalid", "");
            txtPrice.CssClass = txtPrice.CssClass.Replace(" input-invalid", "");
        }

        private void MarkInvalid(WebControl ctl, Label lbl, string message)
        {
            if (!ctl.CssClass.Contains("input-invalid"))
                ctl.CssClass += " input-invalid";
            lbl.Text = message;
        }

        //Next ID generator
        public string GetNextProductID()
        {
            DataView dv = (DataView)SqlDslastID.Select(DataSourceSelectArguments.Empty);

            if (dv != null && dv.Count > 0)
            {
                string lastID = dv[0]["ProductID"].ToString();
                int numberPart = 0;
                if (lastID.StartsWith("P", StringComparison.OrdinalIgnoreCase) && lastID.Length >= 2)
                    int.TryParse(lastID.Substring(1), out numberPart);
                numberPart++;
                string newID = "P" + numberPart.ToString("D3");
                return newID;
            }
            return "P000";
        }

        private void ShowList()
        {
            PanelList.Visible = true;
            PanelAdd.Visible = false;
            PanelEdit.Visible = false;
            GridViewProducts.EditIndex = -1;
        }

        private void ShowAdd()
        {
            PanelList.Visible = false;
            PanelAdd.Visible = true;
            PanelEdit.Visible = false;
        }

        private void ShowEdit()
        {
            PanelList.Visible = false;
            PanelAdd.Visible = false;
            PanelEdit.Visible = true;
        }

        private void LoadProductForEdit(string productId)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(
                @"SELECT ProductID, ProductName, [Description], Category, ProductionTime, Price, Status
          FROM Product WHERE ProductID=@id", conn))
            {
                cmd.Parameters.AddWithValue("@id", productId);
                conn.Open();
                using (SqlDataReader rd = cmd.ExecuteReader())
                {
                    if (rd.Read())
                    {
                        hfEditProductID.Value = rd["ProductID"].ToString();
                        txtEditProductID.Text = rd["ProductID"].ToString();
                        txtEditName.Text = rd["ProductName"].ToString();
                        txtEditDesc.Text = rd["Description"].ToString();
                        txtEditCategory.Text = rd["Category"].ToString();
                        txtEditProductionTime.Text = rd["ProductionTime"].ToString();
                        txtEditPrice.Text = Convert.ToDecimal(rd["Price"]).ToString(CultureInfo.InvariantCulture);
                        ddlEditStatus.SelectedValue = rd["Status"].ToString();
                    }
                }
            }

            // Load current image preview via handler
            imgEditCurrent.ImageUrl = ResolveUrl("~/Admin Pages/ProductImageHandler.ashx?id=" + productId + "&v=" + DateTime.Now.Ticks);

            ShowEdit();
        }

        private void ResetEditValidationStyles()
        {
            lblEditNameError.Text = lblEditDescError.Text = lblEditCategoryError.Text =
                lblEditProductionTimeError.Text = lblEditPriceError.Text = "";

            txtEditName.CssClass = txtEditName.CssClass.Replace(" input-invalid", "");
            txtEditDesc.CssClass = txtEditDesc.CssClass.Replace(" input-invalid", "");
            txtEditCategory.CssClass = txtEditCategory.CssClass.Replace(" input-invalid", "");
            txtEditProductionTime.CssClass = txtEditProductionTime.CssClass.Replace(" input-invalid", "");
            txtEditPrice.CssClass = txtEditPrice.CssClass.Replace(" input-invalid", "");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }


    }
}
