<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="TroikaClothingWeb.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="min-height: 90vh; display:flex; flex-direction:column; justify-content:center; align-items:center; background-color:#f8f8f8; padding:30px 10px;">

        <!-- Page heading -->
        <h1 style="color:#4B0082; text-align:center; margin-bottom:25px; font-weight:700;">Register</h1>

        <!-- Form Card -->
        <div style="width:380px; background:#fff; padding:30px; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.15);">

            <!-- First Name -->
            <div style="margin-bottom:12px;">
                <asp:Label ID="lblName" runat="server" Text="First Name:" AssociatedControlID="txtName" />
                <asp:TextBox ID="txtName" runat="server" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:5px;" />
            </div>

            <!-- Surname -->
            <div style="margin-bottom:12px;">
                <asp:Label ID="lblSurname" runat="server" Text="Surname:" AssociatedControlID="txtSurname" />
                <asp:TextBox ID="txtSurname" runat="server" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:5px;" />
            </div>

            <!-- Email -->
            <div style="margin-bottom:12px;">
                <asp:Label ID="lblEmail" runat="server" Text="Email:" AssociatedControlID="txtEmail" />
                <asp:TextBox ID="txtEmail" runat="server" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:5px;" />
            </div>

            <!-- Username -->
            <div style="margin-bottom:12px;">
                <asp:Label ID="lblUsername" runat="server" Text="Username (6 characters):" AssociatedControlID="txtUsername" />
                <asp:TextBox ID="txtUsername" runat="server" MaxLength="6" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:5px;" />
            </div>

            <!-- Password -->
            <div style="margin-bottom:8px;">
                <asp:Label ID="lblPassword" runat="server" Text="Password (8 digits):" AssociatedControlID="txtPassword" />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="8"
                             style="width:100%; padding:10px; border:1px solid #ccc; border-radius:5px;" />
            </div>

            <!-- Show password toggle (accessible checkbox) -->
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:18px;">
                <input type="checkbox" id="chkShowPwd" aria-label="Show password" />
                <label for="chkShowPwd" style="user-select:none; cursor:pointer;">Show password</label>
            </div>

            <!-- Register button -->
            <asp:Button ID="btnRegister" runat="server" Text="Register"
                        OnClick="btnRegister_Click"
                        style="width:100%; padding:10px; background:#4CAF50; color:white; border:none; border-radius:5px; cursor:pointer; font-size:16px;" />

            <br /><br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Green"
                       style="display:block; text-align:center; font-weight:bold;" />
            <asp:SqlDataSource ID="RegisterDataSource" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password" InsertCommand="INSERT INTO WebsiteRegister(Name, Surname, Email, Username, Password, Status) VALUES (@Name, @Surname, @Email, @Username, @Password, 'Active')" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [WebsiteRegister]" UpdateCommand="UPDATE [WebsiteRegister] SET [Name] = @Name, [Surname] = @Surname, [Email] = @Email, [Username] = @Username, [Password] = @Password WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password">
                <DeleteParameters>
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                    <asp:Parameter Name="original_Surname" Type="String" />
                    <asp:Parameter Name="original_Email" Type="String" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="txtName" Name="Name" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtSurname" Name="Surname" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtEmail" Name="Email" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtUsername" Name="Username" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtPassword" Name="Password" PropertyName="Text" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Surname" Type="String" />
                    <asp:Parameter Name="Email" Type="String" />
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                    <asp:Parameter Name="original_Surname" Type="String" />
                    <asp:Parameter Name="original_Email" Type="String" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteLogin] WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role" InsertCommand="INSERT INTO [WebsiteLogin] ([Username], [Password], [Role]) VALUES (@Username, @Password, @Role)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [WebsiteLogin]" UpdateCommand="UPDATE [WebsiteLogin] SET [Username] = @Username, [Password] = @Password, [Role] = @Role WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role">
                <DeleteParameters>
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                    <asp:Parameter Name="original_Role" Type="String" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:ControlParameter ControlID="txtUsername" Name="Username" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtPassword" Name="Password" PropertyName="Text" Type="String" />
                    <asp:Parameter DefaultValue="Customer" Name="Role" Type="String" />
                </InsertParameters>
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
        </div>
    </div>

    <!-- Script to toggle the ASP.NET password textbox visibility -->
    <script type="text/javascript">
        (function () {
            function togglePasswordElement(checked) {
                var pwd = document.getElementById('<%= txtPassword.ClientID %>');
                if (!pwd) return;
                // Toggle type safely
                try {
                    pwd.type = checked ? 'text' : 'password';
                } catch (e) {
                    // some older browsers may not allow changing type; replace input as fallback
                    var newInput = document.createElement('input');
                    newInput.type = checked ? 'text' : 'password';
                    newInput.id = pwd.id;
                    newInput.name = pwd.name;
                    newInput.className = pwd.className;
                    newInput.value = pwd.value;
                    pwd.parentNode.replaceChild(newInput, pwd);
                }
            }

            var chk = document.getElementById('chkShowPwd');
            chk.addEventListener('change', function (e) {
                togglePasswordElement(this.checked);
            });

            // Optional: allow toggling with Enter/Space on the label for accessibility
            var label = document.querySelector('label[for="chkShowPwd"]');
            if (label) {
                label.addEventListener('keydown', function (e) {
                    if (e.key === ' ' || e.key === 'Enter') {
                        e.preventDefault();
                        chk.checked = !chk.checked;
                        togglePasswordElement(chk.checked);
                    }
                });
            }
        })();
    </script>
</asp:Content>

