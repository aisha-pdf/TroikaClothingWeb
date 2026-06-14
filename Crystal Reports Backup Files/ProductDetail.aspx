<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="TroikaClothingWeb.Public_Pages.ProductDetail" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* -------------------- PRODUCT DETAIL LIGHT/DARK MODE FIX -------------------- */

        .product-detail-page {
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            min-height: 80vh;
            padding: 40px 15px;
        }

        .product-detail-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 30px;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 10px;
            box-shadow: var(--troika-card-shadow);
        }

        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        .product-image-section {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .main-product-image {
            width: 65%;
            height: 520px;
            object-fit: cover;
            border-radius: 8px;
            background: var(--troika-surface-alt) !important;
            box-shadow: var(--troika-card-shadow);
        }

        .product-info-section {
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            gap: 10px;
            color: var(--troika-text) !important;
        }

        .product-category-badge {
            display: inline-block;
            background: var(--troika-secondary) !important;
            color: var(--troika-primary) !important;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 5px;
            width: fit-content;
        }

        .product-title {
            font-size: 24px;
            font-weight: 700;
            color: var(--troika-heading-text) !important;
            margin-bottom: 10px;
        }

        .product-price {
            font-size: 20px;
            font-weight: 700;
            color: var(--troika-primary) !important;
            margin-bottom: 15px;
        }

        .product-description {
            font-size: 16px;
            line-height: 1.7;
            color: var(--troika-text) !important;
            margin-bottom: 25px;
            padding: 20px;
            background: var(--troika-surface-alt) !important;
            border-radius: 8px;
            border-left: 4px solid var(--troika-primary-hover);
            box-shadow: var(--troika-card-shadow);
        }

        .dropdown-section {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .dropdown-label {
            font-size: 15px;
            font-weight: 600;
            color: var(--troika-text) !important;
        }

        .dropdown-select {
            padding: 10px !important;
            border-radius: 6px !important;
            font-size: 15px;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            border: 1px solid var(--troika-border) !important;
        }

        .quantity-input {
            width: 80px;
            text-align: center;
        }

        .btn-add-to-cart {
            padding: 10px 20px !important;
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            transition: background 0.3s ease, transform 0.2s ease;
            width: fit-content;
            margin-top: 10px;
        }

        .btn-add-to-cart:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
            transform: translateY(-2px);
            box-shadow: var(--troika-card-shadow-hover);
        }

        .btn-back {
            padding: 8px 16px;
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.3s ease;
            font-size: 14px;
            display: inline-block;
            margin-bottom: 20px;
        }

        .btn-back:hover {
            background: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
            text-decoration: none;
        }

        .status-message {
            color: var(--troika-success) !important;
            font-weight: bold;
            font-size: 14px;
            margin-top: 10px;
            padding: 8px 12px;
            background: rgba(44, 95, 45, 0.12);
            border-radius: 4px;
            border-left: 3px solid var(--troika-success);
            display: inline-block;
        }

        .size-guide-link {
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            border-radius: 6px !important;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            padding: 10px 16px !important;
            width: auto !important;
            display: inline-block;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .size-guide-link:hover {
            background: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
            transform: translateY(-1px);
            box-shadow: var(--troika-card-shadow);
        }

        .size-selector-container {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .size-input-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .related-heading {
            margin-top: 40px;
            text-align: center;
            color: var(--troika-heading-text) !important;
        }

        .related-product-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 15px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            width: 200px;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 10px;
            padding: 12px;
            box-shadow: var(--troika-card-shadow);
        }

        .related-product-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--troika-card-shadow-hover);
        }

        .related-product-link {
            text-decoration: none;
            color: inherit !important;
            text-align: center;
        }

        .related-product-name {
            font-weight: bold;
            margin-top: 5px;
            display: block;
            color: var(--troika-heading-text) !important;
        }

        .related-product-price {
            font-weight: 600;
            color: var(--troika-success) !important;
            margin-top: 2px;
        }

        #dlRelatedProducts {
            margin: 0 auto;
        }

        /* -------------------- DARK MODE STRONG OVERRIDES -------------------- */

        body[data-theme="dark"] .product-detail-container {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .product-title,
        body[data-theme="dark"] .related-heading,
        body[data-theme="dark"] .related-product-name {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .product-description {
            background: #251f2f !important;
            color: #f5f3f7 !important;
            border-left-color: #b99cdd !important;
        }

        body[data-theme="dark"] .dropdown-label {
            color: #f5f3f7 !important;
        }

        body[data-theme="dark"] .dropdown-select,
        body[data-theme="dark"] .quantity-input {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .product-category-badge {
            background: #2b2433 !important;
            color: #d9c8f0 !important;
        }

        body[data-theme="dark"] .product-price {
            color: #d9c8f0 !important;
        }

        body[data-theme="dark"] .related-product-item {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        /* -------------------- POPUP -------------------- */

        .popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.85);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            overflow: auto;
            padding: 20px;
        }

        .popup-window {
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border) !important;
            padding: 25px;
            border-radius: 12px;
            max-width: fit-content;
            width: auto;
            max-height: 90vh;
            box-shadow: 0 20px 50px rgba(0,0,0,0.6);
            text-align: center;
            position: relative;
            overflow-y: auto;
            margin: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            animation: popupZoomIn 0.3s ease-out;
        }

        .popup-image-container {
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 0;
        }

        .popup-image {
            width: auto;
            max-width: 85vw;
            height: auto;
            max-height: 75vh;
            object-fit: contain;
            border-radius: 8px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }

        .popup-close-btn {
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: 20px;
            width: 100px;
            box-shadow: var(--troika-card-shadow);
        }

        .popup-close-btn:hover {
            background: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
            transform: translateY(-2px);
            box-shadow: var(--troika-card-shadow-hover);
        }

        @keyframes popupZoomIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @media (max-width: 1024px) {
            #dlRelatedProducts {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
            }

            .related-product-item {
                width: 180px;
            }
        }

        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
            }

            .main-product-image {
                width: 100%;
                height: auto;
                max-height: 520px;
            }

            .related-product-item {
                width: 45%;
                margin: 10px;
            }

            .size-input-group {
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }

            .popup-window {
                padding: 20px;
            }

            .popup-image {
                max-width: 85vw;
                max-height: 70vh;
            }

            .popup-close-btn {
                padding: 8px 16px;
                font-size: 13px;
                width: 90px;
            }
        }

        @media (max-width: 480px) {
            .product-detail-container {
                padding: 20px;
            }

            .related-product-item {
                width: 90%;
                margin: 8px 0;
            }

            .popup-window {
                padding: 15px;
            }

            .popup-image {
                max-width: 90vw;
                max-height: 65vh;
            }

            .popup-close-btn {
                padding: 8px 14px;
                font-size: 12px;
                width: 80px;
            }
        }
    </style>

    <div class="product-detail-page">

        <div class="product-detail-container">

            <asp:HyperLink ID="lnkBackToProducts" runat="server" NavigateUrl="~/Public Pages/Products.aspx"
                CssClass="btn-back" Text="← Back to Products" />

            <div class="product-detail">

                <div class="product-image-section">
                    <asp:Image ID="imgProduct" runat="server" CssClass="main-product-image"
                        ImageUrl="~/images/image-placeholder.png" AlternateText="Product Image" />
                </div>

                <div class="product-info-section">
                    <asp:Label ID="lblCategory" runat="server" CssClass="product-category-badge" Text="Category"></asp:Label>
                    <asp:Label ID="lblProductName" runat="server" CssClass="product-title" Text="Product Name"></asp:Label>
                    <asp:Label ID="lblProductPrice" runat="server" CssClass="product-price" Text="R0.00"></asp:Label>
                    <asp:Label ID="lblProductDescription" runat="server" CssClass="product-description"
                        Text="Product description will appear here."></asp:Label>

                    <div class="dropdown-section">
                        <asp:Label ID="lblColor" runat="server" CssClass="dropdown-label" Text="Colour:"></asp:Label>
                        <asp:DropDownList ID="ddlColor" runat="server" CssClass="dropdown-select" ToolTip="Please select a colour" Width="126px">
                            <asp:ListItem>Black</asp:ListItem>
                            <asp:ListItem>White</asp:ListItem>
                            <asp:ListItem>Grey</asp:ListItem>
                            <asp:ListItem>Navy</asp:ListItem>
                            <asp:ListItem>Beige</asp:ListItem>
                            <asp:ListItem>Brown</asp:ListItem>
                            <asp:ListItem>Red</asp:ListItem>
                            <asp:ListItem>Maroon</asp:ListItem>
                            <asp:ListItem>Pink</asp:ListItem>
                            <asp:ListItem>Blush</asp:ListItem>
                            <asp:ListItem>Orange</asp:ListItem>
                            <asp:ListItem>Mustard</asp:ListItem>
                            <asp:ListItem>Yellow</asp:ListItem>
                            <asp:ListItem>Green</asp:ListItem>
                            <asp:ListItem>Olive</asp:ListItem>
                            <asp:ListItem>Mint</asp:ListItem>
                            <asp:ListItem>Teal</asp:ListItem>
                            <asp:ListItem>Turquoise</asp:ListItem>
                            <asp:ListItem>Blue</asp:ListItem>
                            <asp:ListItem>Sky Blue</asp:ListItem>
                            <asp:ListItem>Royal Blue</asp:ListItem>
                            <asp:ListItem>Purple</asp:ListItem>
                            <asp:ListItem>Lavender</asp:ListItem>
                            <asp:ListItem>Lilac</asp:ListItem>
                            <asp:ListItem>Burgundy</asp:ListItem>
                            <asp:ListItem>Cream</asp:ListItem>
                            <asp:ListItem>Khaki</asp:ListItem>
                            <asp:ListItem>Coral</asp:ListItem>
                            <asp:ListItem>Charcoal</asp:ListItem>
                            <asp:ListItem>Sage</asp:ListItem>
                            <asp:ListItem>Mocha</asp:ListItem>
                            <asp:ListItem>Peach</asp:ListItem>
                            <asp:ListItem>Tan</asp:ListItem>
                            <asp:ListItem>Ivory</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown-section">
                        <div class="size-selector-container">
                            <asp:Label ID="lblSize" runat="server" CssClass="dropdown-label" Text="Size:"></asp:Label>
                            <div class="size-input-group">
                                <asp:DropDownList ID="ddlSize" runat="server" CssClass="dropdown-select" ToolTip="Please select a size" Width="80px">
                                    <asp:ListItem>XS</asp:ListItem>
                                    <asp:ListItem>S</asp:ListItem>
                                    <asp:ListItem>M</asp:ListItem>
                                    <asp:ListItem>L</asp:ListItem>
                                    <asp:ListItem>XL</asp:ListItem>
                                    <asp:ListItem></asp:ListItem>
                                </asp:DropDownList>
                                <asp:Button ID="btnSizeGuide" runat="server" Text="Size Guide"
                                    CssClass="size-guide-link" OnClick="btnSizeGuide_Click" />
                            </div>
                        </div>
                    </div>

                    <div class="dropdown-section">
                        <asp:Label ID="lblQuantity" runat="server" CssClass="dropdown-label" Text="Quantity:"></asp:Label>
                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="dropdown-select quantity-input"
                            Text="1" TextMode="Number" Width="80px" />
                    </div>

                    <asp:Button ID="btnAddToCart" runat="server" CssClass="btn-add-to-cart"
                        Text="Add to Cart" OnClick="btnAddToCart_Click" />

                    <asp:Label ID="lblStatus" runat="server" CssClass="status-message" Visible="false" />
                </div>

            </div>
        </div>

        <h3 class="related-heading">You May Also Like</h3>

        <asp:DataList ID="dlRelatedProducts" runat="server" RepeatColumns="4" CellPadding="15"
            HorizontalAlign="Center">
            <ItemTemplate>
                <div class="related-product-item">
                    <asp:HyperLink ID="hlRelatedProduct" runat="server" NavigateUrl='<%# Eval("DetailUrl") %>' CssClass="related-product-link">
                        <asp:Image ID="imgRelated" runat="server" ImageUrl='<%# Eval("ImagePath") %>' Width="170px" Height="200px" Style="border-radius: 8px; box-shadow: 0 3px 6px rgba(0,0,0,0.1);" />
                        <br />
                        <asp:Label ID="lblRelatedName" runat="server" Text='<%# Eval("ProductName") %>' CssClass="related-product-name"></asp:Label>
                        <br />
                        <asp:Label ID="lblRelatedPrice" runat="server" Text='<%# "R" + Eval("Price") %>' CssClass="related-product-price"></asp:Label>
                    </asp:HyperLink>
                </div>
            </ItemTemplate>
        </asp:DataList>

    </div>

    <asp:Panel ID="pnlOverlay" runat="server" CssClass="popup-overlay" Visible="false">
        <div class="popup-window">
            <div class="popup-image-container">
                <asp:Image ID="imgSizeGuide" runat="server" ImageUrl="~/Images/size guide.jpg"
                    CssClass="popup-image" />
            </div>
            <asp:Button ID="btnClosePopup" runat="server" Text="Close" CssClass="popup-close-btn"
                OnClick="btnClosePopup_Click" />
        </div>
    </asp:Panel>

</asp:Content>