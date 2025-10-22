<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleHistory.aspx.cs" Inherits="TroikaClothingWeb.Sale_Pages.SaleHistory" %>

<asp:Content ID="Content0" ContentPlaceHolderID="WhiteNavbar" runat="server">
    <nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-troika">
        <div class="container">
            <%--toggle for navbar--%>
            <span class="navbar-toggler-icon"></span>
            <%--adding image to nav bar--%>
            <a class="navbar-brand" runat="server" href="~/">
                <img src="/Images/logo.png" alt="Troika Clothing CC" height="60" class="d-inline-block align-text-top">
            </a>
            <div class="collapse navbar-collapse d-sm-inline-flex justify-content-between">
                <ul class="navbar-nav flex-grow-1">
                    <li class="nav-item"><a class="nav-link" runat="server" href="~/Customer Pages/HomePage">Home</a></li>
                    <li class="nav-item"><a class="nav-link" runat="server" href="~/Public Pages/About">About Us</a></li>
                    <li class="nav-item"><a class="nav-link" runat="server" href="/~Public Pages/Contact">Contact</a></li>
                    <%-- <li class="nav-item"><a class="nav-link" runat="server" href="~/Help">FAQs/Help</a></li>--%>
                </ul>
            </div>
        </div>
        </nav>
</asp:Content>


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
