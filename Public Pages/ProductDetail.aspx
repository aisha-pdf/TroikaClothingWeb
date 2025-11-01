<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="TroikaClothingWeb.Public_Pages.ProductDetail" %>
<asp:Content ID="Content1" ContentPlaceHolderID="WhiteNavBar" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        /* Color variables from Site.css */
        :root {
            --troika-navy: #3D304C;
            --troika-white: #ffffff;
            --troika-light-accent: #644F7D;
            --troika-deep-green: #2C5F2D;
            --troika-cream: #F5F5DC;
        }

        .product-detail-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 30px;
            background: var(--troika-cream);
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        .main-product-image {
            width: 65%;
            height: 520px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }

        .product-info-section {
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            gap: 10px;
        }

        .product-category-badge {
            display: inline-block;
            background: rgba(61, 48, 76, 0.1);
            color: var(--troika-navy);
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 5px;
            width: fit-content;
        }

        .product-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--troika-navy);
            margin-bottom: 10px;
        }

        .product-price {
            font-size: 20px;
            font-weight: 700;
            color: #000000;
            margin-bottom: 15px;
        }

        .product-description {
            font-size: 16px;
            line-height: 1.7;
            color: #555;
            margin-bottom: 25px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 8px;
            border-left: 4px solid var(--troika-light-accent);
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }

        .dropdown-section {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .dropdown-label {
            font-size: 15px;
            font-weight: 500;
            color: var(--troika-navy);
        }

        .dropdown-select {
            width: 180px;
            padding: 8px;
            border: 2px solid var(--troika-light-accent);
            border-radius: 4px;
            font-size: 15px;
            background-color: #fff;
        }


        .quantity-section {
            margin: 30px 0;
        }

        .quantity-input {
            width: 100px;
            padding: 12px;
            border: 2px solid var(--troika-light-accent);
            border-radius: 4px;
            text-align: center;
            font-size: 16px;
            font-weight: 500;
        }

        .btn-add-to-cart {
            padding: 10px 20px;
            background: var(--troika-deep-green);
            color: var(--troika-white);
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            font-size: 15px;
            transition: background 0.3s ease, transform 0.2s ease;
            width: fit-content;
        }

        .btn-add-to-cart:hover {
            background: #234823;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .btn-back {
            padding: 8px 16px;
            background: var(--troika-navy);
            color: var(--troika-white);
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            transition: background 0.3s ease;
            font-size: 14px;
            display: inline-block;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background: var(--troika-light-accent);
        }

        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

<div class="product-detail-container">

        <asp:HyperLink ID="lnkBackToProducts" runat="server" NavigateUrl="~/Public Pages/Products.aspx"
            CssClass="btn-back" Text="← Back to Products" />

        <div class="product-detail">

            <!-- Left: Product Image -->
            <div class="product-image-section">
                <asp:Image ID="imgProduct" runat="server" CssClass="main-product-image" 
                    ImageUrl="~/images/image-placeholder.png" AlternateText="Product Image" />
            </div>

            <!-- Right: Product Info -->
            <div class="product-info-section">
                <asp:Label ID="lblCategory" runat="server" CssClass="product-category-badge" Text="Category"></asp:Label>
                <asp:Label ID="lblProductName" runat="server" CssClass="product-title" Text="Product Name"></asp:Label>
                <asp:Label ID="lblProductPrice" runat="server" CssClass="product-price" Text="R0.00"></asp:Label>
                <asp:Label ID="lblProductDescription" runat="server" CssClass="product-description"
                    Text="Product description will appear here."></asp:Label>


                 <!-- Color Section -->
                <div class="dropdown-section">
                    <asp:Label ID="lblColor" runat="server" CssClass="dropdown-label" Text="Colour:"></asp:Label>
                    <asp:DropDownList ID="ddlColor" runat="server" CssClass="dropdown-select"></asp:DropDownList>
                </div>

                <!-- Size Section -->
                <div class="dropdown-section">
                    <asp:Label ID="lblSize" runat="server" CssClass="dropdown-label" Text="Size:"></asp:Label>
                    <asp:DropDownList ID="ddlSize" runat="server" CssClass="dropdown-select"></asp:DropDownList>
                </div>

                 <!-- Quantity Section -->
                <div class="quantity-section">
                    <asp:Label ID="lblQuantity" runat="server" CssClass="quantity-label" Text="Quantity:"></asp:Label>
                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="quantity-input" Text="1" TextMode="Number" />
                    <asp:SqlDataSource ID="SqlDataSourceProduct" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT * FROM [Product] WHERE ([ProductID] = @ProductID)">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="ProductID" QueryStringField="id" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>

                <asp:Button ID="btnAddToCart" runat="server" CssClass="btn-add-to-cart" 
                    Text="Add to Cart" OnClick="btnAddToCart_Click" />
            </div>

        </div>
    </div>

</asp:Content>
