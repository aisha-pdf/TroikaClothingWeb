<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TroikaClothingWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

     <style>
     /* Color variables from Site.css */
     :root {
        --troika-navy: #3D304C;
        --troika-white: #ffffff;
        --troika-light-accent: #644F7D;
        --troika-deep-green: #2C5F2D;
        --troika-cream: #F5F5DC;
     }

    .products-grid-container {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: 20px;
        width: 100%;
    }

    /* Make DataList render its items as grid children */
    #<%= dlDresses.ClientID %> {
        display: contents;
    }

    /* Responsive adjustments */
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

    /* Product card styling */
    .product-card { 
        background: var(--troika-white);
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        display: flex;
        flex-direction: column;
        height: 100%;
        border: 1px solid #e2e8f0;
    }

    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        border-color: var(--troika-light-accent);
    }

    .product-card-link {
        text-decoration: none;
        color: inherit;
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        cursor: pointer;
    }

    .product-image {
        height: 320px;
        background: linear-gradient(135deg, #f5f7fa 0%, #e2e8f0 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        position: relative;
    }

    .product-img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .product-info {
        padding: 20px;
        display: flex;
        flex-direction: column;
        flex-grow: 1;
    }

    .product-name {
        font-weight: 600;
        font-size: 18px;
        margin-bottom: 8px;
        color: var(--troika-navy);
    }

    .product-description {
        color: #718096;
        font-size: 14px;
        margin-bottom: 15px;
        flex-grow: 1;
        line-height: 1.4;
    }

    .product-category {
        display: inline-block;
        background: rgba(61, 48, 76, 0.1);
        color: var(--troika-navy);
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 12px;
        margin-bottom: 15px;
        font-weight: 500;
        text-transform: uppercase;
    }

    .product-price {
        font-weight: 700;
        font-size: 20px;
        color: #000000;
        margin-bottom: 15px;
    }

    .add-to-cart-btn {
        width: 100%;
        padding: 10px;
        background: var(--troika-deep-green);
        color: var(--troika-white);
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 500;
        transition: background 0.3s ease;
        font-size: 14px;
        margin-top: auto;
    }

    .add-to-cart-btn:hover {
        background: #234823;
    }

     /* Make container take full width */
    .container-full {
        width: 100%;
        margin: 0;       /* remove any default margins */
        padding: 0;      /* remove default padding */
    }

    /* Make image take full width and scale properly */
    .full-width-img {
        width: 100%;     /* image fills the container width */
        height: auto;    /* maintain aspect ratio */
        display: block;  /* removes inline spacing */
    }

    /* Optional: remove text centering if not needed */
    .container-full.text-center {
        text-align: center;
    }

    .menu-btn {
    background: #3D304C;
    color: white;
    border: none;
    padding: 10px;
    text-align: center;
    border-radius: 5px;
    cursor: pointer;
    width: 100%;
    font-size: 14px;
    }

    .menu-btn:hover {
        background: #7D5C99;
    }

</style>


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
    <div style="text-align:center">
       <asp:Button ID="btnProducts" runat="server" Text="See More" CssClass="menu-btn" OnClick="btnProducts_Click" />
    </div>
    <div style="clear:both"></div>
    <hr />
    <!-- Homepage Main Section -->
    <section class="py-5" style="background-color: #ffffff;">
        <div class="container text-center">
            <div class="row justify-content-center gy-4">

                <!-- About Us Card -->
                <div class="col-12 col-md-4">
                    <div class="card h-100 text-center shadow-sm"
                        style="border-radius: 20px; background-color: #3D304C; color: white; min-height: 420px; padding: 25px;">
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

                <!-- Contact Card -->
                <div class="col-12 col-md-4">
                    <div class="card h-100 text-center shadow-sm"
                        style="border-radius: 20px; background-color: #3D304C; color: white; min-height: 420px; padding: 25px;">
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

                <!-- Browse Collection Card -->
                <div class="col-12 col-md-4">
                    <div class="card h-100 text-center shadow-sm"
                        style="border-radius: 20px; background-color: #3D304C; color: white; min-height: 420px; padding: 25px;">
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

</asp:Content>
