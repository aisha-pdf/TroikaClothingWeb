<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TroikaClothingWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .home-page {
            background: var(--troika-bg);
            color: var(--troika-text);
        }

        .products-grid-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            width: 100%;
            padding: 20px;
        }

        #<%= dlDresses.ClientID %> {
            display: contents;
        }

        .container-full {
            width: 100%;
            margin: 0;
            padding: 0;
        }

        .full-width-img {
            width: 100%;
            height: auto;
            display: block;
        }

        .container-full.text-center {
            text-align: center;
        }

        .home-feature-section {
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
        }

        .home-feature-card {
            border-radius: 20px;
            background-color: var(--troika-primary) !important;
            color: var(--troika-bg) !important;
            min-height: 420px;
            padding: 25px;
            border: 1px solid var(--troika-border);
            box-shadow: var(--troika-card-shadow);
        }

        body[data-theme="dark"] .home-feature-card {
            color: #121018 !important;
        }

        .home-feature-card h4,
        .home-feature-card p {
            color: inherit !important;
        }

        .home-feature-card .btn {
            background: var(--troika-surface) !important;
            color: var(--troika-primary) !important;
            border: 1px solid var(--troika-surface) !important;
        }

        .home-feature-card .btn:hover {
            background: var(--troika-primary-hover) !important;
            color: var(--troika-btn-text) !important;
        }

        .menu-btn {
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 14px;
        }

        .menu-btn:hover {
            background: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        @media (max-width: 1024px) {
            .products-grid-container {
                grid-template-columns: repeat(4, 1fr);
            }
        }

        @media (max-width: 768px) {
            .products-grid-container {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .product-image {
                height: 240px;
            }
        }

        @media (max-width: 480px) {
            .products-grid-container {
                grid-template-columns: 1fr;
            }

            .product-image {
                height: 280px;
            }
        }
    </style>

    <div class="home-page">
        <div class="container-full text-center">
            <img src="Images/banner.png" alt="Dress to Impress" class="full-width-img">
        </div>

        <div class="products-grid-container">
            <asp:DataList ID="dlDresses" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                OnItemCommand="dlDresses_ItemCommand">
                <ItemTemplate>
                    <div class="product-card">
                        <asp:LinkButton ID="lnkProductCard" runat="server" CommandName="ViewDetails"
                            CommandArgument='<%# Eval("ProductID") %>' CssClass="product-card-link">
                            <div class="product-image">
                                <asp:Image ID="imgProduct" runat="server"
                                    ImageUrl='<%# Eval("ImageUrl") %>'
                                    AlternateText='<%# Eval("ProductName") %>'
                                    CssClass="product-img" />
                            </div>
                            <div class="product-info">
                                <div class="product-name"><%# Eval("ProductName") %></div>
                                <div class="product-description"><%# Eval("Description") %></div>
                                <span class="product-category"><%# Eval("Category") %></span>
                                <div class="product-price">R<%# Convert.ToDecimal(Eval("Price")).ToString("F2") %></div>
                            </div>
                        </asp:LinkButton>

                        <asp:Button ID="btnAddToCart" runat="server"
                            CommandName="ViewDetails"
                            CommandArgument='<%# Eval("ProductID") %>'
                            Text="Add to Cart"
                            CssClass="add-to-cart-btn" />
                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>

        <br />

        <div class="text-center" style="max-width: 220px; margin: 0 auto;">
            <asp:Button ID="btnProducts" runat="server" Text="See More" CssClass="menu-btn" OnClick="btnProducts_Click" />
        </div>

        <div style="clear:both"></div>
        <hr />

        <section class="py-5 home-feature-section">
            <div class="container text-center">
                <div class="row justify-content-center gy-4">

                    <div class="col-12 col-md-4">
                        <div class="card h-100 text-center shadow-sm home-feature-card">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <img src="Images/1.png" alt="About Us" class="mb-4" style="width: 200px;">
                                    <h4 class="card-title fw-bold">ABOUT US</h4>
                                    <p class="card-text mt-3">
                                        Learn more about our journey, values, and the team dedicated to bringing you the best.
                                    </p>
                                </div>
                                <a href="Public Pages/About.aspx" class="btn btn-light mt-4">Learn More</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="card h-100 text-center shadow-sm home-feature-card">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <img src="Images/2.png" alt="Contact" class="mb-4" style="width: 200px;">
                                    <h4 class="card-title fw-bold">CONTACT</h4>
                                    <p class="card-text mt-3">
                                        Get in touch with us for inquiries, support, or just to say hello!
                                    </p>
                                </div>
                                <a href="Public Pages/Contact.aspx" class="btn btn-light mt-4">Contact Us</a>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="card h-100 text-center shadow-sm home-feature-card">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <img src="Images/3.png" alt="Products" class="mb-4" style="width: 200px;">
                                    <h4 class="card-title fw-bold">BROWSE OUR COLLECTION</h4>
                                    <p class="card-text mt-3">
                                        Explore our range of quality products designed to meet your needs and preferences.
                                    </p>
                                </div>
                                <a href="Public Pages/Products.aspx" class="btn btn-light mt-4">View Catalogue</a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>
    </div>
</asp:Content>