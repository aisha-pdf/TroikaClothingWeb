<%@ Page Title="Customer Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerProfile.aspx.cs" Inherits="TroikaClothingWeb.Customer_Pages.CustomerProfile" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/CustomerProfile.css") %>" rel="stylesheet" />

    <div class="troika-page customer-profile-page">
        <div class="troika-section customer-profile-section">

            <h2 class="customer-profile-title">MANAGE YOUR ACCOUNT</h2>

            <asp:Label ID="LblMessage"
                runat="server"
                CssClass="customer-profile-message"
                EnableViewState="False" />

            <div class="customer-profile-layout">

                <!-- ACCOUNT DETAILS -->
                <div class="troika-card customer-profile-card">
                    <h5 class="customer-profile-subtitle">Account Details</h5>

                    <asp:ValidationSummary ID="ProfileValidationSummary"
                        runat="server"
                        ValidationGroup="ProfileValidation"
                        CssClass="customer-validation-summary"
                        HeaderText="Please correct the following account details before saving:" />

                    <div class="customer-form-grid">

                        <!-- NAME -->
                        <div class="customer-form-group">
                            <label for="<%= txtName.ClientID %>">Name</label>

                            <asp:TextBox ID="txtName"
                                runat="server"
                                CssClass="customer-input"
                                MaxLength="50" />

                            <asp:RequiredFieldValidator ID="rfvName"
                                runat="server"
                                ControlToValidate="txtName"
                                ErrorMessage="Please enter your first name."
                                Text="Please enter your first name."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />

                            <asp:RegularExpressionValidator ID="revName"
                                runat="server"
                                ControlToValidate="txtName"
                                ValidationExpression="^[A-Za-z\s'-]{2,50}$"
                                ErrorMessage="First name must be 2 to 50 characters and may only contain letters, spaces, hyphens, or apostrophes."
                                Text="First name must be 2 to 50 characters and may only contain letters, spaces, hyphens, or apostrophes."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />
                        </div>

                        <!-- SURNAME -->
                        <div class="customer-form-group">
                            <label for="<%= txtSurname.ClientID %>">Surname</label>

                            <asp:TextBox ID="txtSurname"
                                runat="server"
                                CssClass="customer-input"
                                MaxLength="50" />

                            <asp:RequiredFieldValidator ID="rfvSurname"
                                runat="server"
                                ControlToValidate="txtSurname"
                                ErrorMessage="Please enter your surname."
                                Text="Please enter your surname."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />

                            <asp:RegularExpressionValidator ID="revSurname"
                                runat="server"
                                ControlToValidate="txtSurname"
                                ValidationExpression="^[A-Za-z\s'-]{2,50}$"
                                ErrorMessage="Surname must be 2 to 50 characters and may only contain letters, spaces, hyphens, or apostrophes."
                                Text="Surname must be 2 to 50 characters and may only contain letters, spaces, hyphens, or apostrophes."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />
                        </div>

                        <!-- EMAIL -->
                        <div class="customer-form-group">
                            <label for="<%= txtEmail.ClientID %>">Email</label>

                            <asp:TextBox ID="txtEmail"
                                runat="server"
                                CssClass="customer-input"
                                MaxLength="100"
                                TextMode="Email" />

                            <asp:RequiredFieldValidator ID="rfvEmail"
                                runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Please enter your email address."
                                Text="Please enter your email address."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />

                            <asp:RegularExpressionValidator ID="revEmail"
                                runat="server"
                                ControlToValidate="txtEmail"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Please enter a valid email address, for example name@example.com."
                                Text="Please enter a valid email address, for example name@example.com."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />
                        </div>

                        <!-- PHONE NUMBER -->
                        <div class="customer-form-group">
                            <label for="<%= txtPhoneNumber.ClientID %>">Phone Number</label>

                            <asp:TextBox ID="txtPhoneNumber"
                                runat="server"
                                CssClass="customer-input"
                                MaxLength="10" />

                            <asp:RequiredFieldValidator ID="rfvPhoneNumber"
                                runat="server"
                                ControlToValidate="txtPhoneNumber"
                                ErrorMessage="Please enter your phone number."
                                Text="Please enter your phone number."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />

                            <asp:RegularExpressionValidator ID="revPhoneNumber"
                                runat="server"
                                ControlToValidate="txtPhoneNumber"
                                ValidationExpression="^0[0-9]{9}$"
                                ErrorMessage="Phone number must be 10 digits and start with 0, for example 0821234567."
                                Text="Phone number must be 10 digits and start with 0, for example 0821234567."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="ProfileValidation" />
                        </div>

                        <!-- USERNAME -->
                        <div class="customer-form-group customer-form-group-full">
                            <label for="<%= txtUsername.ClientID %>">Username</label>

                            <asp:TextBox ID="txtUsername"
                                runat="server"
                                CssClass="customer-input"
                                ReadOnly="true" />

                            <small class="customer-help-text">Username cannot be changed.</small>
                        </div>

                        <!-- PASSWORD -->
                        <div class="customer-form-group customer-form-group-full">
                            <label for="<%= txtPassword.ClientID %>">Password</label>

                            <div class="customer-password-row">
                                <asp:TextBox ID="txtPassword"
                                    runat="server"
                                    CssClass="customer-input customer-password-input"
                                    TextMode="SingleLine"
                                    ReadOnly="true" />

                                <asp:Button ID="btnShowHide"
                                    runat="server"
                                    Text="Show Password"
                                    CssClass="menu-btn customer-secondary-btn customer-small-btn customer-password-toggle"
                                    CausesValidation="False"
                                    UseSubmitBehavior="False"
                                    OnClientClick="return toggleCustomerPassword();" />
                            </div>

                            <small class="customer-help-text">Use Change Password if you want to update your password.</small>
                        </div>

                    </div>

                    <div class="customer-button-row">
                        <asp:Button ID="btnSaveProfile"
                            runat="server"
                            Text="Save Account Details"
                            CssClass="menu-btn customer-save-btn"
                            ValidationGroup="ProfileValidation"
                            CausesValidation="True"
                            OnClick="btnSaveProfile_Click" />

                        <asp:Button ID="btnChangePassword"
                            runat="server"
                            Text="Change Password"
                            CssClass="menu-btn customer-secondary-btn"
                            CausesValidation="False"
                            OnClick="btnChangePassword_Click" />
                    </div>
                </div>

                <!-- ADDRESS DETAILS -->
                <div class="troika-card customer-profile-card">
                    <h5 class="customer-profile-subtitle">Address Details</h5>

                    <asp:ValidationSummary ID="AddressValidationSummary"
                        runat="server"
                        ValidationGroup="AddressValidation"
                        CssClass="customer-validation-summary"
                        HeaderText="Please correct the following address details before saving:" />

                    <div class="customer-form-grid">

                        <!-- STREET ADDRESS -->
                        <div class="customer-form-group customer-form-group-full">
                            <label for="<%= txtStreetAddress.ClientID %>">Street Address</label>

                            <asp:TextBox ID="txtStreetAddress"
                                runat="server"
                                CssClass="customer-input js-troika-street"
                                MaxLength="100" />

                            <asp:RequiredFieldValidator ID="rfvStreetAddress"
                                runat="server"
                                ControlToValidate="txtStreetAddress"
                                ErrorMessage="Please enter your street address."
                                Text="Please enter your street address."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="AddressValidation" />
                        </div>

                        <!-- SUBURB -->
                        <div class="customer-form-group">
                            <label for="<%= txtSuburb.ClientID %>">Suburb</label>

                            <asp:TextBox ID="txtSuburb"
                                runat="server"
                                CssClass="customer-input js-troika-suburb"
                                MaxLength="50" />

                            <asp:RequiredFieldValidator ID="rfvSuburb"
                                runat="server"
                                ControlToValidate="txtSuburb"
                                ErrorMessage="Please enter your suburb."
                                Text="Please enter your suburb."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="AddressValidation" />
                        </div>

                        <!-- POSTAL CODE -->
                        <div class="customer-form-group">
                            <label for="<%= txtPostCode.ClientID %>">Postal Code</label>

                            <asp:TextBox ID="txtPostCode"
                                runat="server"
                                CssClass="customer-input js-troika-postcode"
                                MaxLength="4" />

                            <asp:RequiredFieldValidator ID="rfvPostCode"
                                runat="server"
                                ControlToValidate="txtPostCode"
                                ErrorMessage="Please enter your postal code."
                                Text="Please enter your postal code."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="AddressValidation" />

                            <asp:RegularExpressionValidator ID="revPostCode"
                                runat="server"
                                ControlToValidate="txtPostCode"
                                ValidationExpression="^[0-9]{4}$"
                                ErrorMessage="Postal code must be exactly 4 digits, for example 4001."
                                Text="Postal code must be exactly 4 digits, for example 4001."
                                CssClass="customer-validation-error"
                                Display="Dynamic"
                                ValidationGroup="AddressValidation" />
                        </div>

                    </div>

                    <div class="customer-button-row">
                        <asp:Button ID="btnSaveAddress"
                            runat="server"
                            Text="Save Address"
                            CssClass="menu-btn customer-save-btn"
                            ValidationGroup="AddressValidation"
                            CausesValidation="True"
                            OnClick="btnSaveAddress_Click" />
                    </div>
                </div>

            </div>

            <!-- CLOSE ACCOUNT -->
            <div class="troika-card customer-close-card">
                <h5 class="customer-profile-subtitle">Close Account</h5>

                <p class="customer-warning-text">
                    Closing your account will stop access to your Troika Clothing account. You will be logged out after confirming this action.
                    To reactivate your account, you will need to contact support.
                </p>

                <asp:Button ID="btnCloseAccount"
                    runat="server"
                    Text="Close Account"
                    CssClass="menu-btn customer-close-btn"
                    CausesValidation="False"
                    OnClientClick="return confirm('Are you sure you want to close your account? You will be logged out after this action. To reactivate your account, you will need to contact support.');"
                    OnClick="btnCloseAccount_Click" />
            </div>

        </div>
    </div>

    <script type="text/javascript">
        function initialiseCustomerPasswordField() {
            var passwordInput = document.getElementById("<%= txtPassword.ClientID %>");
            var toggleButton = document.getElementById("<%= btnShowHide.ClientID %>");

            if (passwordInput) {
                passwordInput.type = "password";
            }

            if (toggleButton) {
                toggleButton.value = "Show Password";
                toggleButton.innerText = "Show Password";
            }
        }

        function toggleCustomerPassword() {
            var passwordInput = document.getElementById("<%= txtPassword.ClientID %>");
            var toggleButton = document.getElementById("<%= btnShowHide.ClientID %>");

            if (!passwordInput || !toggleButton) {
                return false;
            }

            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleButton.value = "Hide Password";
                toggleButton.innerText = "Hide Password";
            } else {
                passwordInput.type = "password";
                toggleButton.value = "Show Password";
                toggleButton.innerText = "Show Password";
            }

            return false;
        }

        document.addEventListener("DOMContentLoaded", initialiseCustomerPasswordField);

        if (typeof (Sys) !== "undefined" && Sys.Application) {
            Sys.Application.add_load(initialiseCustomerPasswordField);
        }
    </script>

    <!-- Google Places address autocomplete (defines the Maps callback first, then loads Maps). -->
    <script src="<%= ResolveUrl("~/Scripts/troika-address-autocomplete.js") %>"></script>
    <script
        src="https://maps.googleapis.com/maps/api/js?key=<%= System.Configuration.ConfigurationManager.AppSettings["GoogleMapsApiKey"] %>&libraries=places&loading=async&callback=initTroikaAddressAutocomplete"
        async defer></script>

</asp:Content>