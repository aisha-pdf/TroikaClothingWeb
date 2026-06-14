<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdminSidebar.ascx.cs" Inherits="TroikaClothingWeb.Controls.AdminSidebar" %>

<div class="troika-admin-sidebar">
    <asp:Button ID="btnUserList"
        runat="server"
        Text="User List"
        CssClass="troika-admin-nav-btn"
        OnClick="btnUserList_Click"
        CausesValidation="False" />

    <asp:Button ID="btnProducts"
        runat="server"
        Text="Products"
        CssClass="troika-admin-nav-btn"
        OnClick="btnProducts_Click"
        CausesValidation="False" />

    <asp:Button ID="btnReports"
        runat="server"
        Text="Reports"
        CssClass="troika-admin-nav-btn"
        OnClick="btnReports_Click"
        CausesValidation="False" />

    <asp:Button ID="btnProfile"
        runat="server"
        Text="Profile"
        CssClass="troika-admin-nav-btn"
        OnClick="btnProfile_Click"
        CausesValidation="False" />

    <asp:Button ID="btnLogout"
        runat="server"
        Text="Log Out"
        CssClass="troika-admin-nav-btn"
        OnClick="btnLogout_Click"
        CausesValidation="False" />
</div>
