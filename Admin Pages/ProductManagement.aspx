<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs" Inherits="TroikaClothingWeb.Admin_Pages.ProductManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--navy blue navigation bar for admin--%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Admin Pages/Admin">User Management</a></li>
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Admin Pages/Product Management">Product Management</a> </li>
            </ul>
        </div>
    </nav>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
</asp:Content>
