<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TroikaClothingWeb.ForgotPassword" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/ResetPassword.css") %>" rel="stylesheet" />

    <div class="reset-password-page">
        <div class="reset-password-card">

            <div class="reset-password-topbar">
                <a href="<%= ResolveUrl("~/Login.aspx") %>" class="reset-password-back">&#8592; Back</a>
            </div>

            <div class="reset-password-form-inner">

                <h2 class="reset-password-title">Reset Password</h2>
                <p class="reset-password-subtitle">
                    Confirm your account with the email and phone number on file, then choose a new password.
                </p>

                <asp:ValidationSummary ID="vsResetPassword"
                    runat="server"
                    CssClass="reset-password-validation-summary"
                    HeaderText="Please fix the following:"
                    DisplayMode="BulletList"
                    ValidationGroup="ResetPasswordGroup" />

                <asp:Label runat="server"
                    ID="lblMessage"
                    CssClass="reset-password-message"
                    EnableViewState="False" />

                <div class="reset-password-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtEmail"
                        Text="Email:"
                        CssClass="reset-password-label" />

                    <asp:TextBox ID="txtEmail"
                        runat="server"
                        TextMode="Email"
                        placeholder="you@example.com"
                        CssClass="reset-password-input" />

                    <asp:RequiredFieldValidator ID="rfvEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup" />

                    <asp:RegularExpressionValidator ID="revEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Enter a valid email address."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                </div>

                <div class="reset-password-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtPhone"
                        Text="Phone Number:"
                        CssClass="reset-password-label" />

                    <asp:TextBox ID="txtPhone"
                        runat="server"
                        TextMode="Phone"
                        placeholder="e.g. 0821234567"
                        CssClass="reset-password-input" />

                    <asp:RequiredFieldValidator ID="rfvPhone"
                        runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="Phone number is required."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup" />

                    <asp:RegularExpressionValidator ID="revPhone"
                        runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="Phone number must be 10 digits, for example 0821234567."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup"
                        ValidationExpression="^0[0-9]{9}$" />
                </div>

                <div class="reset-password-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtNewPassword"
                        Text="New Password:"
                        CssClass="reset-password-label" />

                    <asp:TextBox ID="txtNewPassword"
                        runat="server"
                        TextMode="Password"
                        MaxLength="8"
                        CssClass="reset-password-input reset-password-input--password" />

                    <small class="reset-password-help-text">
                        Password must be 6 to 8 characters and include an uppercase letter, lowercase letter, number, and special character.
                    </small>

                    <asp:RequiredFieldValidator ID="rfvNewPassword"
                        runat="server"
                        ControlToValidate="txtNewPassword"
                        ErrorMessage="New password is required."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup" />

                    <asp:RegularExpressionValidator ID="revNewPassword"
                        runat="server"
                        ControlToValidate="txtNewPassword"
                        ErrorMessage="Password must be 6 to 8 characters and include an uppercase letter, lowercase letter, number, and special character."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup"
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{6,8}$" />
                </div>

                <div class="reset-password-field">
                    <asp:Label runat="server"
                        AssociatedControlID="txtConfirmPassword"
                        Text="Confirm New Password:"
                        CssClass="reset-password-label" />

                    <asp:TextBox ID="txtConfirmPassword"
                        runat="server"
                        TextMode="Password"
                        MaxLength="8"
                        CssClass="reset-password-input reset-password-input--password" />

                    <asp:RequiredFieldValidator ID="rfvConfirmPassword"
                        runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your new password."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup" />

                    <asp:CompareValidator ID="cvConfirmPassword"
                        runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtNewPassword"
                        ErrorMessage="Passwords do not match."
                        CssClass="reset-password-validator"
                        Display="Dynamic"
                        ValidationGroup="ResetPasswordGroup" />
                </div>

                <label class="reset-password-toggle">
                    <input type="checkbox" onclick="troikaTogglePassword(this);" />
                    <span>Show password</span>
                </label>

                <asp:Button ID="btnResetPassword"
                    runat="server"
                    Text="Reset Password"
                    OnClick="btnResetPassword_Click"
                    CssClass="reset-password-btn"
                    ValidationGroup="ResetPasswordGroup" />

            </div>

        </div>
    </div>

    <script type="text/javascript">
        function troikaTogglePassword(cb) {
            var type = cb.checked ? "text" : "password";
            var ids = ["<%= txtNewPassword.ClientID %>", "<%= txtConfirmPassword.ClientID %>"];

            for (var i = 0; i < ids.length; i++) {
                var field = document.getElementById(ids[i]);
                if (field) {
                    field.type = type;
                }
            }
        }
    </script>

</asp:Content>