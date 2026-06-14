using System;
using System.Drawing;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Customer_Pages
{
    public partial class CustomerProfile : CustomerPage
    {
        private readonly CustomerProfileService _customerProfileService = ServiceFactory.CreateCustomerProfileService();

        protected void Page_Load(object sender, EventArgs e)
        {
            ConfigurePasswordToggle();

            if (!IsPostBack)
            {
                LoadCustomerProfile();
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            Page.Validate("ProfileValidation");

            if (!Page.IsValid)
                return;

            var request = new CustomerProfileUpdateRequest
            {
                Username = CurrentUsername,
                Name = txtName.Text,
                Surname = txtSurname.Text,
                Email = txtEmail.Text,
                PhoneNumber = txtPhoneNumber.Text
            };

            try
            {
                OperationResult result = _customerProfileService.UpdateProfile(request);
                ShowMessage(result.Message, result.Success);

                if (result.Success)
                    LoadCustomerProfile();
            }
            catch (Exception ex)
            {
                ShowMessage("Your account details could not be updated: " + ex.Message, false);
            }
        }

        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            Page.Validate("AddressValidation");

            if (!Page.IsValid)
                return;

            var request = new CustomerAddressUpdateRequest
            {
                Username = CurrentUsername,
                StreetAddress = txtStreetAddress.Text,
                Suburb = txtSuburb.Text,
                PostCode = txtPostCode.Text
            };

            try
            {
                OperationResult result = _customerProfileService.UpdateAddress(request);
                ShowMessage(result.Message, result.Success);

                if (result.Success)
                    LoadCustomerProfile();
            }
            catch (Exception ex)
            {
                ShowMessage("Your address could not be updated: " + ex.Message, false);
            }
        }


        private void ConfigurePasswordToggle()
        {
            btnShowHide.OnClientClick = "return toggleCustomerPassword('"
                + txtPassword.ClientID
                + "', '"
                + btnShowHide.ClientID
                + "');";
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ForgotPassword.aspx");
        }

        protected void btnCloseAccount_Click(object sender, EventArgs e)
        {
            try
            {
                OperationResult result = _customerProfileService.CloseAccount(CurrentUsername);

                if (result.Success)
                {
                    Session.Clear();
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                ShowMessage(result.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("We could not close your account right now: " + ex.Message, false);
            }
        }

        private void LoadCustomerProfile()
        {
            CustomerProfileDetails profile = _customerProfileService.GetProfile(CurrentUsername);

            if (profile == null)
            {
                ShowMessage("Your customer profile could not be found. Please contact support.", false);
                SetFormEnabled(false);
                return;
            }

            txtName.Text = profile.Name;
            txtSurname.Text = profile.Surname;
            txtEmail.Text = profile.Email;
            txtPhoneNumber.Text = profile.PhoneNumber;
            txtUsername.Text = profile.Username;
            txtPassword.Text = profile.Password;
            txtPassword.Attributes["value"] = profile.Password;
            txtStreetAddress.Text = profile.StreetAddress;
            txtSuburb.Text = profile.Suburb;
            txtPostCode.Text = profile.PostCode;

            SetFormEnabled(true);
        }

        private void SetFormEnabled(bool enabled)
        {
            txtName.Enabled = enabled;
            txtSurname.Enabled = enabled;
            txtEmail.Enabled = enabled;
            txtPhoneNumber.Enabled = enabled;
            txtPassword.Enabled = enabled;
            btnShowHide.Enabled = enabled;
            txtStreetAddress.Enabled = enabled;
            txtSuburb.Enabled = enabled;
            txtPostCode.Enabled = enabled;
            btnSaveProfile.Enabled = enabled;
            btnSaveAddress.Enabled = enabled;
            btnCloseAccount.Enabled = enabled;
        }

        private void ShowMessage(string message, bool success)
        {
            LblMessage.Text = message;
            LblMessage.ForeColor = success
                ? ColorTranslator.FromHtml("#1a7f37")
                : ColorTranslator.FromHtml("#d60000");
        }
    }
}
