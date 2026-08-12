<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TroikaClothingWeb.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/Login.css") %>" rel="stylesheet" />
<div class="login-original-wrapper">
        <div class="login-original-card">

            <h2 class="login-original-title">Login</h2>

            <div class="login-original-field">
                <asp:Label ID="lblUsername" runat="server" Text="Username:" AssociatedControlID="txtUsername" />
                <asp:TextBox ID="txtUsername" runat="server"
                    CssClass="login-original-input"
                    MaxLength="6" />
            </div>



            <div class="login-original-field" style="margin-bottom:8px;">
                <asp:Label ID="lblPassword" runat="server" Text="Password:" AssociatedControlID="txtPassword" />
                <asp:TextBox ID="txtPassword" runat="server"
                    TextMode="Password"
                    MaxLength="8"
                    CssClass="login-original-input" />
            </div>

            <div class="login-show-password">
                <input type="checkbox" id="chkShowPwd" onclick="togglePassword()" />
                <label for="chkShowPwd">Show password</label>
            </div>

            <asp:Button ID="btnLogin" runat="server"
                Text="Login"
                OnClick="btnLogin_Click"
                CssClass="login-original-button" />

            <asp:Label ID="lblMessage" runat="server"
                CssClass="login-original-message" />



            <div class="login-original-link-row">
                <span>Don't have an account?</span>
                <a href="Register.aspx">Register here</a>
            </div>

            <div class="login-original-link-row">
                <span>Forgot Password?</span>
                <a href="ForgotPassword.aspx">Reset Password</a>
            </div>

        </div>
    </div>

    <script type="text/javascript">
        function togglePassword() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            if (!pwd) return;
            pwd.type = (pwd.type === 'password') ? 'text' : 'password';
        }

        document.addEventListener('DOMContentLoaded', function () {
            var chk = document.getElementById('chkShowPwd');
            var lbl = document.querySelector('label[for="chkShowPwd"]');

            if (lbl && chk) {
                lbl.addEventListener('keydown', function (e) {
                    if (e.key === ' ' || e.key === 'Enter') {
                        e.preventDefault();
                        chk.checked = !chk.checked;
                        togglePassword();
                    }
                });
            }
        });
    </script>

</asp:Content>