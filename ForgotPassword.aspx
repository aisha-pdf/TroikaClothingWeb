<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TroikaClothingWeb.ForgotPassword" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    
    <div style="display:flex; justify-content:center; align-items:center; height:80vh;">
        <div style="width:363px; background:#fff; padding:30px; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.15);">
            
            <h2 style="text-align:center; margin-bottom:20px; color:#333;">Reset Password</h2>

            <asp:Label runat="server" ID="lblMessage" ForeColor="Red"></asp:Label><br />

            <asp:Label runat="server" Text="Email:" /><br />
            <asp:TextBox ID="txtEmail" runat="server" style="width:100%; padding:8px; margin-bottom:10px;"></asp:TextBox><br />

            <asp:Label runat="server" Text="Phone Number:" /><br />
            <asp:TextBox ID="txtPhone" runat="server" style="width:100%; padding:8px; margin-bottom:10px;"></asp:TextBox><br />

            <asp:Label runat="server" Text="New Password:" /><br />
            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="8" style="width:100%; padding:8px; margin-bottom:10px;"></asp:TextBox><br />

            <asp:Label runat="server" Text="Confirm New Password:" /><br />
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="8" style="width:100%; padding:8px; margin-bottom:10px;"></asp:TextBox><br />

            <asp:CheckBox ID="chkShowPassword" runat="server" Text=" Show Password" AutoPostBack="true" OnCheckedChanged="chkShowPassword_CheckedChanged" />

            <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" OnClick="btnResetPassword_Click"
                        style="width:100%; padding:10px; background:#4CAF50; color:white; border:none; border-radius:5px; cursor:pointer;" />

            <asp:SqlDataSource ID="DSUpdateRPwd" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT Email, PhoneNumber FROM WebsiteRegister WHERE (Email = @Email) AND (PhoneNumber = @PhoneNumber)" UpdateCommand="UPDATE WebsiteRegister SET Password = @Password WHERE (Email = @Email) AND (PhoneNumber = @PhoneNumber)">
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
            <asp:SqlDataSource ID="DSUpdateLPwd" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT WebsiteLogin.* FROM WebsiteLogin" UpdateCommand="UPDATE WebsiteLogin SET Password = @Password FROM WebsiteLogin INNER JOIN WebsiteRegister ON WebsiteLogin.Username = WebsiteRegister.Username WHERE (WebsiteRegister.Email = @Email)">
                <UpdateParameters>
                    <asp:ControlParameter ControlID="txtConfirmPassword" Name="Password" PropertyName="Text" />
                    <asp:ControlParameter ControlID="txtEmail" Name="Email" PropertyName="Text" />
                </UpdateParameters>
            </asp:SqlDataSource>

        </div>
    </div>

 
       
</asp:Content>
