<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TroikaClothingWeb.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<div style="display:flex; justify-content:center; align-items:center; height:80vh;">
        <div style="width:350px; background:#fff; padding:30px; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.15);">
            
            <h2 style="text-align:center; margin-bottom:20px; color:#333;">Login</h2>

            <div style="margin-bottom:15px;">
                <asp:Label ID="lblUsername" runat="server" Text="Username:" AssociatedControlID="txtUsername" />
                <asp:TextBox ID="txtUsername" runat="server" 
                             style="width:100%; padding:10px; margin-top:5px; border:1px solid #ccc; border-radius:5px;" MaxLength="6" />
            </div>

            <div style="margin-bottom:8px;">
                <asp:Label ID="lblPassword" runat="server" Text="Password:" AssociatedControlID="txtPassword" />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="8"
                             style="width:100%; padding:10px; margin-top:5px; border:1px solid #ccc; border-radius:5px;" />
            </div>

            <!-- Show password toggle -->
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:18px;">
                <input type="checkbox" id="chkShowPwd" onclick="togglePassword()" />
                <label for="chkShowPwd" style="user-select:none; cursor:pointer;">Show password</label>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login"
                        OnClick="btnLogin_Click"
                        style="width:100%; padding:10px; background:#4CAF50; color:white; border:none; border-radius:5px; cursor:pointer;" />

            <br /><br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" 
                       style="display:block; text-align:center; font-weight:bold;" />

            <asp:SqlDataSource ID="LoginDatasource" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteLogin] WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role" InsertCommand="INSERT INTO [WebsiteLogin] ([Username], [Password], [Role]) VALUES (@Username, @Password, @Role)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT ID, Username, Password, Role FROM WebsiteLogin WHERE (Password = @Password) AND (Username COLLATE SQL_Latin1_General_CP1_CS_AS = @Username)" UpdateCommand="UPDATE [WebsiteLogin] SET [Username] = @Username, [Password] = @Password, [Role] = @Role WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role">
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

            <!-- Register link -->
            <div style="text-align:center; margin-top:15px;">
                <span>Don't have an account?</span>
                <a href="Register.aspx" style="color:#4CAF50; text-decoration:none; font-weight:bold;">Register here</a>
            </div>
        </div>
    </div>

    <!-- Show/hide password script -->
    <script type="text/javascript">
        function togglePassword() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            if (!pwd) return;
            pwd.type = (pwd.type === 'password') ? 'text' : 'password';
        }

        document.addEventListener('DOMContentLoaded', function () {
            var chk = document.getElementById('chkShowPwd');
            var lbl = document.querySelector('label[for="chkShowPwd"]');
            if (lbl) {
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
