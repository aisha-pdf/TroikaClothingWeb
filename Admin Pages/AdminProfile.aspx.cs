using System;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Admin_Pages
{
    public partial class AdminProfile : AdminPage
    {
        private readonly AdminUserService _adminUserService = ServiceFactory.CreateAdminUserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindProfile();
        }

        private void BindProfile()
        {
            AdminUserRecord profile = _adminUserService.GetProfile(CurrentUsername);
            DetailsView1.DataSource = profile == null ? null : new[] { profile };
            DetailsView1.DataBind();
        }

        protected void DetailsView1_ModeChanging(object sender, DetailsViewModeEventArgs e)
        {
            DetailsView1.ChangeMode(e.NewMode);
            BindProfile();
        }

        protected void DetailsView1_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            Page.Validate("UpdateProfileValidation");
            if (!Page.IsValid)
                return;

            int id = Convert.ToInt32(DetailsView1.DataKey.Value);

            var user = new AdminUserRecord
            {
                ID = id,
                Name = FindTextBoxText(DetailsView1, "txtEditName"),
                Surname = FindTextBoxText(DetailsView1, "txtEditSurname"),
                Email = FindTextBoxText(DetailsView1, "txtEditEmail"),
                PhoneNumber = FindTextBoxText(DetailsView1, "txtEditPhoneNumber")
            };

            OperationResult result = _adminUserService.UpdateUser(user);
            if (!result.Success)
            {
                e.Cancel = true;
                ShowMessage(result.Message, false);
                return;
            }

            DetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
            BindProfile();
            ShowMessage(result.Message, true);
        }

        private static string FindTextBoxText(Control parent, string id)
        {
            TextBox box = FindControlRecursive(parent, id) as TextBox;
            return box == null ? string.Empty : box.Text.Trim();
        }

        private static Control FindControlRecursive(Control parent, string id)
        {
            if (parent == null)
                return null;

            Control control = parent.FindControl(id);
            if (control != null)
                return control;

            foreach (Control child in parent.Controls)
            {
                control = FindControlRecursive(child, id);
                if (control != null)
                    return control;
            }

            return null;
        }

        private void ShowMessage(string message, bool success)
        {
            lblProfileMessage.Text = message;
            lblProfileMessage.ForeColor = success
                ? ColorTranslator.FromHtml("#1a7f37")
                : ColorTranslator.FromHtml("#d60000");
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
