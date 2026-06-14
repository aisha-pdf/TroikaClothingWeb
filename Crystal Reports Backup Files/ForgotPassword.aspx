<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TroikaClothingWeb.ForgotPassword" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/ResetPassword.css") %>" rel="stylesheet" />

    <div class="reset-password-page">
        <div class="reset-password-card">

            <h2 class="reset-password-title">Reset Password</h2>

            <asp:Label runat="server"
                ID="lblMessage"
                CssClass="reset-password-message"
                EnableViewState="False" />

            <asp:Label runat="server"
                Text="Email:"
                CssClass="reset-password-label" /><br />

            <asp:TextBox ID="txtEmail"
                runat="server"
                CssClass="reset-password-input" /><br />

            <asp:Label runat="server"
                Text="Phone Number:"
                CssClass="reset-password-label" /><br />

            <asp:TextBox ID="txtPhone"
                runat="server"
                CssClass="reset-password-input" /><br />

            <asp:Label runat="server"
                Text="New Password:"
                CssClass="reset-password-label" /><br />

            <asp:TextBox ID="txtNewPassword"
                runat="server"
                TextMode="Password"
                MaxLength="8"
                CssClass="reset-password-input" />

            <small class="reset-password-help-text">
                Password must be 6 to 8 characters and include an uppercase letter, lowercase letter, number, and special character.
            </small>

            <asp:Label runat="server"
                Text="Confirm New Password:"
                CssClass="reset-password-label" /><br />

            <asp:TextBox ID="txtConfirmPassword"
                runat="server"
                TextMode="Password"
                MaxLength="8"
                CssClass="reset-password-input" /><br />

            <asp:CheckBox ID="chkShowPassword"
                runat="server"
                Text=" Show Password"
                AutoPostBack="true"
                OnCheckedChanged="chkShowPassword_CheckedChanged"
                CssClass="reset-password-checkbox" />

            <asp:Button ID="btnResetPassword"
                runat="server"
                Text="Reset Password"
                OnClick="btnResetPassword_Click"
                CssClass="reset-password-btn" />

        </div>
    </div>

</asp:Content>