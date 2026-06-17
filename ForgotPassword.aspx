<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TroikaClothingWeb.ForgotPassword" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/ResetPassword.css") %>" rel="stylesheet" />

    <div class="reset-password-page">
        <div class="reset-password-card">

            <h2 class="reset-password-title">Reset Password</h2>
            <p class="reset-password-subtitle">
                Confirm your account with the email and phone number on file, then choose a new password.
            </p>

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
            </div>

            <%-- Show/hide password is handled entirely client-side by toggling the input
                 type. A server-side TextMode switch can't work here: ASP.NET never
                 re-renders a Password TextBox's value, so flipping back to Password wiped
                 whatever the user had typed. --%>
            <label class="reset-password-toggle">
                <input type="checkbox" onclick="troikaTogglePassword(this);" />
                <span>Show password</span>
            </label>

            <asp:Button ID="btnResetPassword"
                runat="server"
                Text="Reset Password"
                OnClick="btnResetPassword_Click"
                CssClass="reset-password-btn" />

            <a href="<%= ResolveUrl("~/Login.aspx") %>" class="reset-password-back">Back to login</a>

        </div>
    </div>

    <script type="text/javascript">
        function troikaTogglePassword(cb) {
            var type = cb.checked ? "text" : "password";
            var ids = ["<%= txtNewPassword.ClientID %>", "<%= txtConfirmPassword.ClientID %>"];
            for (var i = 0; i < ids.length; i++) {
                var field = document.getElementById(ids[i]);
                if (field) field.type = type;
            }
        }
    </script>

</asp:Content>