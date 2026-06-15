using System;
using System.Globalization;
using System.IO;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Admin_Pages
{
    public partial class ProductManagement : AdminPage
    {
        private readonly ProductManagementService _productManagementService = ServiceFactory.CreateProductManagementService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ShowList();
                ddlStatusFilter.SelectedValue = "Active";
                ddlSort.SelectedValue = "ProductID ASC";
                txtProductID.Text = _productManagementService.GetNextProductId();
                BindProductGrid();
            }
        }

        private void BindProductGrid()
        {
            GridViewProducts.DataSource = _productManagementService.GetProductsForAdmin(
                ddlStatusFilter.SelectedValue,
                txtSearch.Text,
                ddlSort.SelectedValue);
            GridViewProducts.DataBind();
        }

        protected void GridViewProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewProducts.PageIndex = e.NewPageIndex;
            BindProductGrid();
        }

        protected void btnViewProducts_Click(object sender, EventArgs e)
        {
            ShowList();
            ddlStatusFilter.SelectedValue = "Active";
            ddlSort.SelectedValue = "ProductID ASC";
            BindProductGrid();
        }

        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            ShowAdd();
            ClearAddForm();
            txtProductID.Text = _productManagementService.GetNextProductId();
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            ShowList();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            GridViewProducts.PageIndex = 0;
            BindProductGrid();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlStatusFilter.SelectedValue = "Active";
            ddlSort.SelectedValue = "ProductID ASC";
            txtSearch.Text = string.Empty;
            BindProductGrid();
        }

        protected void GridViewProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                OperationResult result = _productManagementService.ToggleProductStatus(e.CommandArgument.ToString());
                lblAddResult.Text = result.Message;
                BindProductGrid();
                ShowList();
                return;
            }

            if (e.CommandName == "EditProduct")
            {
                LoadProductForEdit(e.CommandArgument.ToString());
                return;
            }
        }

        protected void btnUpdateProduct_Click(object sender, EventArgs e)
        {
            ResetEditValidationStyles();

            ProductSaveRequest request = BuildEditRequest();
            OperationResult result = _productManagementService.UpdateProduct(request);

            if (!result.Success)
            {
                ShowProductErrors(result, true);
                lblEditResult.Text = result.Message;
                lblEditResult.ForeColor = System.Drawing.ColorTranslator.FromHtml("#d93025");
                ShowEdit();
                return;
            }

            lblEditResult.Text = result.Message;
            lblEditResult.ForeColor = System.Drawing.ColorTranslator.FromHtml("#1a7f37");
            BindProductGrid();
            ShowList();
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            ShowList();
        }

        protected void GridViewProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            e.Cancel = true;
            GridViewProducts.EditIndex = e.NewEditIndex;
            BindProductGrid();
        }

        protected void GridViewProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            e.Cancel = true;
            GridViewProducts.EditIndex = -1;
            BindProductGrid();
        }

        protected void GridViewProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            e.Cancel = true;

            GridViewRow row = GridViewProducts.Rows[e.RowIndex];
            string productId = e.Keys["ProductID"].ToString();

            ProductSaveRequest request = new ProductSaveRequest
            {
                ProductID = productId,
                ProductName = GetTextBoxValue(row, "txtProductNameEdit"),
                Description = GetTextBoxValue(row, "txtDescriptionEdit"),
                Category = GetTextBoxValue(row, "txtCategoryEdit"),
                ProductionTimeText = GetTextBoxValue(row, "txtProductionTimeEdit"),
                PriceText = GetTextBoxValue(row, "txtPriceEdit"),
                Status = GetDropDownValue(row, "ddlStatusEdit", "Active"),
                PictureBytes = GetFileBytes(row, "fuEdit")
            };

            OperationResult result = _productManagementService.UpdateProduct(request);

            if (!result.Success)
            {
                lblAddResult.Text = result.Message;
                return;
            }

            GridViewProducts.EditIndex = -1;
            BindProductGrid();
        }

        protected void btnSaveProduct_Click(object sender, EventArgs e)
        {
            ResetValidationStyles();

            ProductSaveRequest request = BuildAddRequest();
            OperationResult result = _productManagementService.AddProduct(request);

            if (!result.Success)
            {
                ShowProductErrors(result, false);
                lblAddResult.Text = result.Message;
                return;
            }

            lblAddResult.Text = result.Message;
            ClearAddForm();
            txtProductID.Text = _productManagementService.GetNextProductId();
            BindProductGrid();
        }

        private ProductSaveRequest BuildAddRequest()
        {
            return new ProductSaveRequest
            {
                ProductID = txtProductID.Text.Trim(),
                ProductName = txtName.Text.Trim(),
                Description = txtDesc.Text.Trim(),
                Category = txtCategory.Text.Trim(),
                ProductionTimeText = txtProductionTime.Text.Trim(),
                PriceText = txtPrice.Text.Trim(),
                Status = ddlStatusAdd.SelectedValue,
                PictureBytes = fuPicture.HasFile ? ReadFileBytes(fuPicture) : null
            };
        }

        private ProductSaveRequest BuildEditRequest()
        {
            return new ProductSaveRequest
            {
                ProductID = hfEditProductID.Value,
                ProductName = txtEditName.Text.Trim(),
                Description = txtEditDesc.Text.Trim(),
                Category = txtEditCategory.Text.Trim(),
                ProductionTimeText = txtEditProductionTime.Text.Trim(),
                PriceText = txtEditPrice.Text.Trim(),
                Status = ddlEditStatus.SelectedValue,
                PictureBytes = fuEditPicture.HasFile ? ReadFileBytes(fuEditPicture) : null
            };
        }

        private static byte[] ReadFileBytes(FileUpload upload)
        {
            if (upload == null || !upload.HasFile)
                return null;

            using (BinaryReader reader = new BinaryReader(upload.PostedFile.InputStream))
            {
                return reader.ReadBytes(upload.PostedFile.ContentLength);
            }
        }

        private static byte[] GetFileBytes(GridViewRow row, string controlId)
        {
            FileUpload upload = row.FindControl(controlId) as FileUpload;
            return ReadFileBytes(upload);
        }

        private static string GetTextBoxValue(GridViewRow row, string controlId)
        {
            TextBox textBox = row.FindControl(controlId) as TextBox;
            return textBox == null ? string.Empty : textBox.Text.Trim();
        }

        private static string GetDropDownValue(GridViewRow row, string controlId, string defaultValue)
        {
            DropDownList dropDown = row.FindControl(controlId) as DropDownList;
            return dropDown == null ? defaultValue : dropDown.SelectedValue;
        }

        private void LoadProductForEdit(string productId)
        {
            Product product = _productManagementService.GetProductForAdmin(productId);

            if (product == null)
            {
                lblAddResult.Text = "Product could not be found.";
                ShowList();
                return;
            }

            hfEditProductID.Value = product.ProductID;
            txtEditProductID.Text = product.ProductID;
            txtEditName.Text = product.ProductName;
            txtEditDesc.Text = product.Description;
            txtEditCategory.Text = product.Category;
            txtEditProductionTime.Text = product.ProductionTime.ToString(CultureInfo.InvariantCulture);
            txtEditPrice.Text = product.Price.ToString(CultureInfo.InvariantCulture);
            ddlEditStatus.SelectedValue = product.Status;

            imgEditCurrent.ImageUrl = ResolveUrl("~/Admin Pages/ProductImageHandler.ashx?id=" + productId + "&v=" + product.ImageVersion);
            ShowEdit();
        }

        private void ClearAddForm()
        {
            ResetValidationStyles();
            txtName.Text = string.Empty;
            txtDesc.Text = string.Empty;
            txtCategory.Text = string.Empty;
            txtProductionTime.Text = string.Empty;
            txtPrice.Text = string.Empty;
            ddlStatusAdd.SelectedValue = "Active";
            ddlSort.SelectedValue = "ProductID ASC";
        }

        private void ShowProductErrors(OperationResult result, bool editMode)
        {
            ProductValidationResult validationResult = result as ProductValidationResult;
            if (validationResult == null)
                return;

            foreach (var error in validationResult.FieldErrors)
            {
                if (editMode)
                    MarkEditFieldInvalid(error.Key, error.Value);
                else
                    MarkAddFieldInvalid(error.Key, error.Value);
            }
        }

        private void MarkAddFieldInvalid(string fieldName, string message)
        {
            if (fieldName == "ProductID") MarkInvalid(txtProductID, lblProductIDError, message);
            if (fieldName == "ProductName") MarkInvalid(txtName, lblNameError, message);
            if (fieldName == "Description") MarkInvalid(txtDesc, lblDescError, message);
            if (fieldName == "Category") MarkInvalid(txtCategory, lblCategoryError, message);
            if (fieldName == "ProductionTime") MarkInvalid(txtProductionTime, lblProductionTimeError, message);
            if (fieldName == "Price") MarkInvalid(txtPrice, lblPriceError, message);
            if (fieldName == "Status") lblStatusError.Text = message;
        }

        private void MarkEditFieldInvalid(string fieldName, string message)
        {
            if (fieldName == "ProductName") MarkInvalid(txtEditName, lblEditNameError, message);
            if (fieldName == "Description") MarkInvalid(txtEditDesc, lblEditDescError, message);
            if (fieldName == "Category") MarkInvalid(txtEditCategory, lblEditCategoryError, message);
            if (fieldName == "ProductionTime") MarkInvalid(txtEditProductionTime, lblEditProductionTimeError, message);
            if (fieldName == "Price") MarkInvalid(txtEditPrice, lblEditPriceError, message);
        }

        private void ResetValidationStyles()
        {
            lblProductIDError.Text = lblNameError.Text = lblDescError.Text =
                lblCategoryError.Text = lblProductionTimeError.Text = lblPriceError.Text =
                lblPictureError.Text = lblStatusError.Text = string.Empty;

            RemoveInvalidClass(txtProductID);
            RemoveInvalidClass(txtName);
            RemoveInvalidClass(txtDesc);
            RemoveInvalidClass(txtCategory);
            RemoveInvalidClass(txtProductionTime);
            RemoveInvalidClass(txtPrice);
        }

        private void ResetEditValidationStyles()
        {
            lblEditNameError.Text = lblEditDescError.Text = lblEditCategoryError.Text =
                lblEditProductionTimeError.Text = lblEditPriceError.Text = string.Empty;

            RemoveInvalidClass(txtEditName);
            RemoveInvalidClass(txtEditDesc);
            RemoveInvalidClass(txtEditCategory);
            RemoveInvalidClass(txtEditProductionTime);
            RemoveInvalidClass(txtEditPrice);
        }

        private static void MarkInvalid(WebControl control, Label label, string message)
        {
            if (!control.CssClass.Contains("input-invalid"))
                control.CssClass += " input-invalid";

            label.Text = message;
        }

        private static void RemoveInvalidClass(WebControl control)
        {
            control.CssClass = control.CssClass.Replace(" input-invalid", string.Empty).Replace("input-invalid", string.Empty).Trim();
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

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}
