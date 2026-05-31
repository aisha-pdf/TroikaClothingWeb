<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TroikaClothingWeb.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <main class="troika-page auth-container login-container">
        <div class="login-page-wrapper">
            <div class="login-card troika-auth-card">

                <h2 class="auth-title login-title">Login</h2>

                <div class="login-field">
                    <asp:Label ID="lblUsername" runat="server" Text="Username:" AssociatedControlID="txtUsername" CssClass="form-label" />
                    <asp:TextBox ID="txtUsername" runat="server"
                        CssClass="form-control"
                        MaxLength="6" />
                </div>

                <div class="login-field">
                    <asp:Label ID="lblPassword" runat="server" Text="Password:" AssociatedControlID="txtPassword" CssClass="form-label" />
                    <asp:TextBox ID="txtPassword" runat="server"
                        TextMode="Password"
                        MaxLength="8"
                        CssClass="form-control" />
                </div>

                <div class="login-password-toggle">
                    <input type="checkbox" id="chkShowPwd" onclick="togglePassword()" />
                    <label for="chkShowPwd">Show password</label>
                </div>

                <asp:Button ID="btnLogin" runat="server"
                    Text="Login"
                    OnClick="btnLogin_Click"
                    CssClass="troika-btn login-btn" />

                <asp:Label ID="lblMessage" runat="server"
                    CssClass="login-message text-danger" />

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

                <div class="login-link-row">
                    <span>Don't have an account?</span>
                    <a href="Register.aspx">Register here</a>
                </div>

                <div class="login-link-row">
                    <span>Forgot Password?</span>
                    <a href="ForgotPassword.aspx">Reset Password</a>
                </div>

            </div>
        </div>
    </main>

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