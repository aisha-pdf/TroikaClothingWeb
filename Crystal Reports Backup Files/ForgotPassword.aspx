<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TroikaClothingWeb.ForgotPassword" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* -------------------- RESET PASSWORD PAGE DARK/LIGHT MODE FIX -------------------- */

        .reset-password-page {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            padding: 30px 15px;
            box-sizing: border-box;
        }

        .reset-password-card {
            width: 363px;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 30px;
            border-radius: 10px;
            border: 1px solid var(--troika-border) !important;
            box-shadow: var(--troika-card-shadow);
            box-sizing: border-box;
        }

        .reset-password-title {
            text-align: center;
            margin-bottom: 20px;
            color: var(--troika-heading-text) !important;
            font-weight: 700;
        }

        .reset-password-label,
        .reset-password-card label,
        .reset-password-card span {
            color: var(--troika-text) !important;
            font-weight: 500;
        }

        .reset-password-input {
            width: 100% !important;
            padding: 8px !important;
            margin-bottom: 10px !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 6px !important;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            box-sizing: border-box !important;
        }

        .reset-password-input:focus {
            outline: none !important;
            border-color: var(--troika-primary) !important;
            box-shadow: 0 0 0 2px rgba(217, 200, 240, 0.25) !important;
        }

        .reset-password-checkbox {
            display: block;
            margin-bottom: 15px;
            color: var(--troika-text) !important;
        }

        .reset-password-checkbox label {
            color: var(--troika-text) !important;
            cursor: pointer;
        }

        .reset-password-btn {
            width: 100% !important;
            padding: 10px !important;
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            border-radius: 5px !important;
            cursor: pointer !important;
            font-weight: 600 !important;
        }

        .reset-password-btn:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        .reset-password-message {
            color: var(--troika-danger) !important;
            display: block;
            text-align: center;
            font-weight: bold;
            margin-bottom: 10px;
        }

        body[data-theme="dark"] .reset-password-card {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .reset-password-title,
        body[data-theme="dark"] .reset-password-label,
        body[data-theme="dark"] .reset-password-card label,
        body[data-theme="dark"] .reset-password-card span,
        body[data-theme="dark"] .reset-password-checkbox,
        body[data-theme="dark"] .reset-password-checkbox label {
            color: #f5f3f7 !important;
        }

        body[data-theme="dark"] .reset-password-input {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .reset-password-input::placeholder {
            color: #c9c3d4 !important;
        }

        body[data-theme="dark"] .reset-password-message {
            color: #ff9a90 !important;
        }
    </style>

    <div class="reset-password-page">
        <div class="reset-password-card">

            <h2 class="reset-password-title">Reset Password</h2>

            <asp:Label runat="server" ID="lblMessage" CssClass="reset-password-message"></asp:Label>

            <asp:Label runat="server" Text="Email:" CssClass="reset-password-label" /><br />
            <asp:TextBox ID="txtEmail" runat="server" CssClass="reset-password-input"></asp:TextBox><br />

            <asp:Label runat="server" Text="Phone Number:" CssClass="reset-password-label" /><br />
            <asp:TextBox ID="txtPhone" runat="server" CssClass="reset-password-input"></asp:TextBox><br />

            <asp:Label runat="server" Text="New Password:" CssClass="reset-password-label" /><br />
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" MaxLength="8" CssClass="reset-password-input"></asp:TextBox><br />

            <asp:Label runat="server" Text="Confirm New Password:" CssClass="reset-password-label" /><br />
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" MaxLength="8" CssClass="reset-password-input"></asp:TextBox><br />

            <asp:CheckBox ID="chkShowPassword" runat="server"
                Text=" Show Password"
                AutoPostBack="true"
                OnCheckedChanged="chkShowPassword_CheckedChanged"
                CssClass="reset-password-checkbox" />

            <asp:Button ID="btnResetPassword" runat="server"
                Text="Reset Password"
                OnClick="btnResetPassword_Click"
                CssClass="reset-password-btn" />

            <asp:SqlDataSource ID="DSUpdateRPwd" runat="server"
                ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                SelectCommand="SELECT Email, PhoneNumber FROM WebsiteRegister WHERE (Email = @Email) AND (PhoneNumber = @PhoneNumber)"
                UpdateCommand="UPDATE WebsiteRegister SET Password = @Password WHERE (Email = @Email) AND (PhoneNumber = @PhoneNumber)">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtEmail" Name="Email" PropertyName="Text" />
                    <asp:ControlParameter ControlID="txtPhone" Name="PhoneNumber" PropertyName="Text" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:ControlParameter ControlID="txtEmail" Name="Email" PropertyName="Text" />
                    <asp:ControlParameter ControlID="txtPhone" Name="PhoneNumber" PropertyName="Text" />
                    <asp:Parameter Name="Password" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="DSUpdateLPwd" runat="server"
                ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                SelectCommand="SELECT WebsiteLogin.* FROM WebsiteLogin"
                UpdateCommand="UPDATE WebsiteLogin SET Password = @Password FROM WebsiteLogin INNER JOIN WebsiteRegister ON WebsiteLogin.Username = WebsiteRegister.Username WHERE (WebsiteRegister.Email = @Email)">
                <UpdateParameters>
                    <asp:ControlParameter ControlID="txtConfirmPassword" Name="Password" PropertyName="Text" />
                    <asp:ControlParameter ControlID="txtEmail" Name="Email" PropertyName="Text" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </div>
    </div>

</asp:Content>