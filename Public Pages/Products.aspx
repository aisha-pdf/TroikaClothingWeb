<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="TroikaClothingWeb.Products" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="products-container">
        <h1>Women's Clothing Collection</h1>

        <!-- Search and Filter Section -->
        <div class="search-filter-section">
            <div class="search-bar">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search products..." CssClass="search-input" />
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="search-button" OnClick="btnSearch_Click" /> &nbsp
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="search-button" OnClick="btnClear_Click" />
            </div>

            <div class="filter-section">
                <label for="ddlCategory">Filter by Category:</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="category-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"  OnDataBound="ddlCategory_DataBound"  DataSourceID="SqlDataSourceCategories"  DataTextField="Category" DataValueField="Category">
                    
                </asp:DropDownList>
            </div>

            <asp:SqlDataSource ID="SqlDataSourceCategories" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT DISTINCT Category FROM Product WHERE (Category IS NOT NULL) ORDER BY Category"></asp:SqlDataSource>

        </div>

        <asp:Label ID="lblNoProducts" runat="server" Text="No products found." Visible="false" CssClass="no-products" />

        <!-- Products Grid -->
        
        <div class="products-grid-container">
            <asp:DataList ID="dlProducts" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" 
                CssClass="products-grid" OnItemCommand="dlProducts_ItemCommand">
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
    </div>

    <style>
        /* Color variables from Site.css */
        :root {
            --troika-navy: #3D304C;
            --troika-white: #ffffff;
            --troika-light-accent: #644F7D;
            --troika-deep-green: #2C5F2D;
            --troika-cream: #F5F5DC;
        }

        /* Styles for the product page */
        .products-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .products-container h1 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--troika-navy);
            font-weight: 600;
        }

        /* Search and filter section styling */
        .search-filter-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .search-bar {
            display: flex;
            align-items: center;
        }

        .search-input {
            padding: 10px 15px;
            border: 1px solid var(--troika-light-accent);
            border-radius: 4px 0 0 4px;
            width: 300px;
            font-size: 16px;
            height: 40px;
            box-sizing: border-box;
        }

        .search-button {
            padding: 0 15px;
            background: var(--troika-navy);
            color: var(--troika-white);
            border: 1px solid var(--troika-navy);
            border-radius: 0 4px 4px 0;
            cursor: pointer;
            transition: background 0.3s ease;
            font-weight: 500;
            height: 40px;
            line-height: 40px;
            margin-left: -1px;
        }

        .search-button:hover {
            background: var(--troika-light-accent);
        }

        .filter-section {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-left: auto;
        }

        .filter-section label {
            font-weight: 500;
            color: var(--troika-navy);
        }

        .category-dropdown {
            padding: 10px;
            border: 1px solid var(--troika-light-accent);
            border-radius: 4px;
            background: var(--troika-white);
            color: var(--troika-navy);
            height: 40px;
        }

        /* Products grid */
        .products-grid-container {
            width: 100%;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            width: 100%;
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

        /* Add to Cart button styling */
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

        /* No products message styling */
        .no-products {
            text-align: center;
            padding: 40px;
            font-size: 18px;
            color: var(--troika-light-accent);
            grid-column: 1 / -1;
        }

        /* Responsive design */
        @media (max-width: 1200px) {
            .products-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }

        @media (max-width: 992px) {
            .products-grid {
                grid-template-columns: repeat(3, 1fr);
            }

            .product-image {
                height: 280px;
            }

            .search-filter-section {
                flex-direction: column;
                align-items: stretch;
            }

            .search-bar {
                width: 100%;
            }

            .search-input {
                width: 100%;
            }

            .filter-section {
                margin-left: 0;
                justify-content: flex-start;
            }
        }

        @media (max-width: 768px) {
            .products-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .product-image {
                height: 240px;
            }
        }

        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
            }

            .product-image {
                height: 280px;
            }
        }
    </style>
</asp:Content>