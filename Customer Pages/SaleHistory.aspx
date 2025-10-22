<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleHistory.aspx.cs" Inherits="TroikaClothingWeb.Sale_Pages.SaleHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--navy blue navigation bar for admin--%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Public Pages/Products">Products</a> </li>
                <%--profile
                cart--%>
            </ul>
        </div>
    </nav>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
</asp:Content>
