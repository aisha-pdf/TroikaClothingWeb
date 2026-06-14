using System;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Adminaspx : AdminPage
    {
        private readonly AdminUserService _adminUserService = ServiceFactory.CreateAdminUserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindUsers();
        }

        private void BindUsers()
        {
            GridView1.DataSource = _adminUserService.GetUsers();
            GridView1.DataBind();
        }

        protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            BindUsers();
        }

        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            BindUsers();
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            GridView1.EditIndex = -1;
            BindUsers();
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Selection is retained for visual feedback only.
        }

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            Page.Validate("UpdateUserValidation");
            if (!Page.IsValid)
                return;

            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
            GridViewRow row = GridView1.Rows[e.RowIndex];

            var user = new AdminUserRecord
            {
                ID = id,
                Name = GetTextBoxValue(row, "txtEditName"),
                Surname = GetTextBoxValue(row, "txtEditSurname"),
                Email = GetTextBoxValue(row, "txtEditEmail"),
                PhoneNumber = GetTextBoxValue(row, "txtEditPhoneNumber")
            };

            OperationResult result = _adminUserService.UpdateUser(user);
            if (!result.Success)
            {
                AddUpdateValidationError(result.Message);
                return;
            }

            GridView1.EditIndex = -1;
            BindUsers();
        }

        private static string GetTextBoxValue(GridViewRow row, string controlId)
        {
            TextBox textBox = row.FindControl(controlId) as TextBox;
            return textBox == null ? string.Empty : textBox.Text.Trim();
        }

        private void AddUpdateValidationError(string message)
        {
            CustomValidator validator = new CustomValidator
            {
                IsValid = false,
                ErrorMessage = message,
                Text = message,
                ValidationGroup = "UpdateUserValidation",
                Display = ValidatorDisplay.Dynamic,
                CssClass = "admin-validation-error"
            };

            Page.Validators.Add(validator);
        }

        protected void btnUserList_Click(object sender, EventArgs e)
        {
            Response.Redirect(ResolveUrl("~/Admin Pages/Admin.aspx"));
        }

        protected void btnProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect(ResolveUrl("~/Admin Pages/AdminProfile.aspx"));
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect(ResolveUrl("~/Login.aspx"));
        }
    }
}
