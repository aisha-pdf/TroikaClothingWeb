<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="TroikaClothingWeb.Customer_Pages.HomePage" %>

<asp:Content ID="Content0" ContentPlaceHolderID="WhiteNavBar" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%-- displays the category list and products side-by-side --%>
    <div class="row mt-4">
        <!-- Categories bar - Left Column -->
        <div class="col-md-3">
            <div class="card">
                <div class="card-header text-white">
                    <h5>Categories</h5>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled">
                        <li class="py-1">Just Dropped</li>
                        <li class="py-1">Hot Trends</li>
                        <li class="py-1">Winter Newness</li>
                        <li class="py-1">Sweat Tops</li>
                        <li class="py-1">Dresses</li>
                        <li class="py-1">Pants</li>
                        <li class="py-1">Sleepwear</li>
                        <li class="py-1">View All</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Featured Products section - Right Column -->
        <div class="col-md-9">
            <h3>Featured Products</h3>
            <div class="row">
                <!-- Product 1 -->
                <div class="col-md-4 mb-3">
                    <div class="card h-100 product-card">
                        <img src="/Images/evening silk gown.jpeg" class="card-img-top fixed-img" alt="Product 1">
                        <div class="card-body">
                            <h5 class="card-title">Evening Silk Gown Green</h5>
                            <p class="card-text">R1099.99</p>
                        </div>
                    </div>
                </div>

                <!-- Product 2 -->
                <div class="col-md-4 mb-3">
                    <div class="card h-100 product-card">
                        <img src="/Images/formal linen blazer.jpeg" class="card-img-top fixed-img" alt="Product 2">
                        <div class="card-body">
                            <h5 class="card-title">Formal Linen Blazer</h5>
                            <p class="card-text">R399.99</p>
                        </div>
                    </div>
                </div>

                <!-- Product 3 -->
                <div class="col-md-4 mb-3">
                    <div class="card h-100 product-card">
                        <img src="/Images/light blue maxi dress.jpeg" class="card-img-top fixed-img" alt="Product 2">
                        <div class="card-body">
                            <h5 class="card-title">Light Blue Maxi Dress</h5>
                            <p class="card-text">R549.99</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>
