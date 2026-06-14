using System;
using System.Drawing;
using System.Web.UI;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb
{
    public partial class Register : Page
    {
        private readonly RegistrationService _registrationService = new RegistrationService();

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            RegisterRequest request = BuildRegisterRequestFromForm();

            try
            {
                OperationResult result = _registrationService.RegisterCustomer(request);

                if (!result.Success)
                {
                    ShowMessage(result.Message, false);
                    return;
                }

                ShowMessage(result.Message, true);
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowMessage("Registration failed: " + ex.Message, false);
            }
        }

        private RegisterRequest BuildRegisterRequestFromForm()
        {
            return new RegisterRequest
            {
                Name = txtName.Text,
                Surname = txtSurname.Text,
                Email = txtEmail.Text,
                PhoneNumber = txtPhoneNum.Text,
                Username = txtUsername.Text,
                Password = txtPassword.Text,
                StreetAddress = txtStreet.Text,
                Suburb = txtSuburb.Text,
                PostCode = txtPostCode.Text
            };
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.ForeColor = success ? Color.Green : Color.Red;
            lblMessage.Text = message;
        }
    }
}
