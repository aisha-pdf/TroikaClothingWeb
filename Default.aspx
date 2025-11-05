<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TroikaClothingWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
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
                        3
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
