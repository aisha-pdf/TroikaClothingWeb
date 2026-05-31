<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TroikaClothingWeb.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .login-original-wrapper {
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            min-height: 80vh !important;
            width: 100% !important;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
        }

        .login-original-card {
            width: 350px !important;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 30px !important;
            border-radius: 10px !important;
            border: 1px solid var(--troika-border) !important;
            box-shadow: var(--troika-card-shadow) !important;
            box-sizing: border-box !important;
        }

        .login-original-title {
            text-align: center !important;
            margin-bottom: 20px !important;
            color: var(--troika-heading-text) !important;
            font-weight: 700 !important;
        }

        .login-original-field {
            margin-bottom: 15px !important;
        }

        .login-original-field label {
            display: block !important;
            color: var(--troika-text) !important;
            margin-bottom: 5px !important;
            font-weight: 500 !important;
        }

        .login-original-input {
            width: 100% !important;
            padding: 10px !important;
            margin-top: 5px !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 5px !important;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            box-sizing: border-box !important;
        }

        .login-original-input:focus {
            outline: none !important;
            border-color: var(--troika-primary) !important;
            box-shadow: 0 0 0 2px rgba(217, 200, 240, 0.25) !important;
        }

        .login-show-password {
            display: flex !important;
            align-items: center !important;
            gap: 8px !important;
            margin-bottom: 18px !important;
            color: var(--troika-text) !important;
        }

        .login-show-password label {
            color: var(--troika-text) !important;
            user-select: none !important;
            cursor: pointer !important;
        }

        .login-original-button {
            width: 100% !important;
            padding: 10px !important;
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: none !important;
            border-radius: 5px !important;
            cursor: pointer !important;
            font-weight: 600 !important;
            text-align: center !important;
        }

        .login-original-button:hover {
            background: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        .login-original-message {
            display: block !important;
            text-align: center !important;
            font-weight: bold !important;
            margin-top: 18px !important;
            color: var(--troika-danger) !important;
        }

        .login-original-link-row {
            text-align: center !important;
            margin-top: 15px !important;
            color: var(--troika-text) !important;
        }

        .login-original-link-row span {
            color: var(--troika-text) !important;
        }

        .login-original-link-row a {
            color: var(--troika-success) !important;
            text-decoration: none !important;
            font-weight: bold !important;
        }

        .login-original-link-row a:hover {
            color: var(--troika-primary-hover) !important;
        }

        body[data-theme="dark"] .login-original-card {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .login-original-title,
        body[data-theme="dark"] .login-original-field label,
        body[data-theme="dark"] .login-show-password,
        body[data-theme="dark"] .login-show-password label,
        body[data-theme="dark"] .login-original-link-row,
        body[data-theme="dark"] .login-original-link-row span {
            color: #f5f3f7 !important;
        }

        body[data-theme="dark"] .login-original-input {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .login-original-link-row a {
            color: #79c783 !important;
        }
    </style>

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

            <asp:SqlDataSource ID="LoginDatasource" runat="server"
                ConflictDetection="CompareAllValues"
                ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                DeleteCommand="DELETE FROM [WebsiteLogin] WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role"
                InsertCommand="INSERT INTO [WebsiteLogin] ([Username], [Password], [Role]) VALUES (@Username, @Password, @Role)"
                OldValuesParameterFormatString="original_{0}"
                SelectCommand="SELECT ID, Username, Password, Role, Status FROM WebsiteLogin WHERE (Password COLLATE SQL_Latin1_General_CP1_CS_AS = @Password) AND (Username COLLATE SQL_Latin1_General_CP1_CS_AS = @Username)"
                UpdateCommand="UPDATE [WebsiteLogin] SET [Username] = @Username, [Password] = @Password, [Role] = @Role WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role">

                <DeleteParameters>
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                    <asp:Parameter Name="original_Role" Type="String" />
                </DeleteParameters>

                <InsertParameters>
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                    <asp:Parameter Name="Role" Type="String" />
                </InsertParameters>

                <SelectParameters>
                    <asp:ControlParameter ControlID="txtPassword" Name="Password" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtUsername" Name="Username" PropertyName="Text" Type="String" />
                </SelectParameters>

                <UpdateParameters>
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                    <asp:Parameter Name="Role" Type="String" />
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                    <asp:Parameter Name="original_Role" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

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