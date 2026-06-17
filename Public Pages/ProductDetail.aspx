<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="ProductDetail.aspx.cs" Inherits="TroikaClothingWeb.Public_Pages.ProductDetail" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%= ResolveUrl("~/Content/wishlist.css") %>" rel="stylesheet" />

    <span id="troikaWishCfg" style="display: none;"
        data-toggle-url='<%= ResolveUrl("~/Public Pages/WishlistHandler.ashx") %>'
        data-login-url='<%= ResolveUrl("~/Login.aspx") %>'></span>

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

        /* Back arrow rendered in CSS so it is encoding-independent */
        .btn-back::before {
            content: "\2190"; /* left arrow */
            margin-right: 6px;
        }

        .status-message::before {
            content: "\2713"; /* check mark */
            margin-right: 6px;
            font-weight: bold;
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

        /* -------------------- ADD-TO-CART CONFIRMATION + QUICK VIEW -------------------- */

        .cart-added-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .btn-view-cart {
            background: transparent !important;
            color: var(--troika-primary) !important;
            border: 1px solid var(--troika-primary) !important;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            padding: 8px 16px !important;
            transition: background 0.3s ease, color 0.3s ease, transform 0.2s ease;
        }

        .btn-view-cart:hover {
            background: var(--troika-primary) !important;
            color: var(--troika-btn-text) !important;
            transform: translateY(-1px);
        }

        /* Quick-view popup window (reuses .popup-overlay backdrop) */
        .cart-quickview-window {
            width: 480px;
            max-width: 92vw;
            max-height: 80vh;
            overflow-y: auto;
            text-align: left;
            align-items: stretch;
            padding: 20px;
        }

        .qv-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .qv-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--troika-heading-text) !important;
        }

        .qv-close {
            background: transparent !important;
            color: var(--troika-text) !important;
            border: none !important;
            font-size: 22px;
            line-height: 1;
            cursor: pointer;
            padding: 0 6px !important;
            width: auto !important;
        }

        .qv-items {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .qv-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--troika-border);
        }

        .qv-img {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid var(--troika-border);
            flex-shrink: 0;
        }

        .qv-item-info {
            flex: 1;
            min-width: 0;
        }

        .qv-item-name {
            font-weight: 600;
            color: var(--troika-heading-text) !important;
            font-size: 14px;
        }

        .qv-item-meta {
            margin-top: 4px;
        }

        .qv-badge {
            display: inline-block;
            font-size: 11px;
            padding: 2px 8px;
            margin-right: 5px;
            border-radius: 999px;
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border);
        }

        .qv-line-total {
            font-weight: 700;
            color: var(--troika-primary) !important;
            white-space: nowrap;
        }

        .qv-summary {
            margin-top: 14px;
        }

        .qv-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            margin-bottom: 6px;
            color: var(--troika-text) !important;
        }

        .qv-total {
            font-size: 17px;
            font-weight: 800;
            color: var(--troika-heading-text) !important;
            margin-top: 4px;
        }

        .qv-actions {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .qv-btn {
            flex: 1;
            text-align: center;
            padding: 10px 14px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none !important;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .qv-btn-secondary {
            background: transparent !important;
            color: var(--troika-primary) !important;
            border: 1px solid var(--troika-primary) !important;
        }

        .qv-btn-secondary:hover {
            background: var(--troika-surface-alt) !important;
            transform: translateY(-1px);
        }

        .qv-btn-primary {
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
        }

        .qv-btn-primary:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            transform: translateY(-1px);
        }

        /* Checkout = green, matching the cart page */
        .qv-btn-success {
            background: var(--troika-success) !important;
            color: #fff !important;
            border: 1px solid var(--troika-success) !important;
        }

        body[data-theme="dark"] .qv-btn-success {
            color: #121018 !important; /* dark text on light-mint green */
        }

        .qv-btn-success:hover {
            filter: brightness(1.08);
            transform: translateY(-1px);
        }

        .qv-empty {
            padding: 24px 0;
            text-align: center;
            color: var(--troika-text) !important;
        }

        /* Quick-view free-delivery bar: green + a touch taller, matching the cart page */
        .qv-summary .delivery-tracker .dt-track {
            height: 14px;
        }

        .qv-summary .delivery-tracker .dt-fill {
            background: #2C5F2D !important;
        }

            .qv-summary .delivery-tracker .dt-fill.is-free {
                background: #34a853 !important;
            }
    </style>

    <div class="product-detail-page">

        <div class="product-detail-container">

            <asp:HyperLink ID="lnkBackToProducts" runat="server" NavigateUrl="~/Public Pages/Products.aspx"
                CssClass="btn-back" Text="Back to Products" />

            <div class="product-detail">

                <div class="product-image-section">
                    <% if (HasProduct) { %>
                    <button type="button" class="wish-heart wish-heart-detail <%= WishHeartClass %>"
                        data-productid="<%= Server.HtmlEncode(CurrentProductId) %>"
                        aria-label="Add to wishlist" onclick="troikaToggleWish(this); return false;">
                        <svg viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 1 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z" />
                        </svg>
                    </button>
                    <% } %>
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
                        </asp:DropDownList>
                    </div>

                    <div class="dropdown-section">
                        <div class="size-selector-container">
                            <asp:Label ID="lblSize" runat="server" CssClass="dropdown-label" Text="Size:"></asp:Label>
                            <div class="size-input-group">
                                <asp:DropDownList ID="ddlSize" runat="server" CssClass="dropdown-select" ToolTip="Please select a size" Width="80px">
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

                    <%-- Add to Cart and View Cart both run as partial (async) postbacks so the
                         page never reloads or bounces. The quick-view popup that View Cart opens
                         has its own UpdatePanel (further down) wired to btnViewCart. --%>
                    <asp:UpdatePanel ID="upAddToCart" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Button ID="btnAddToCart" runat="server" CssClass="btn-add-to-cart"
                                Text="Add to Cart" OnClick="btnAddToCart_Click" />

                            <div class="cart-added-bar">
                                <asp:Label ID="lblStatus" runat="server" CssClass="status-message" Visible="false" />
                                <asp:Button ID="btnViewCart" runat="server" CssClass="btn-view-cart" Text="View Cart"
                                    Visible="false" CausesValidation="false" OnClick="btnViewCart_Click" />
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
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

    <%-- Size guide popup in its own UpdatePanel so the Size Guide button is async
         (no full-page postback / scroll bounce). --%>
    <asp:UpdatePanel ID="upSizeGuide" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

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

        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSizeGuide" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <%-- Quick-view cart popup in its own UpdatePanel so "View Cart" is async (no full-page
         postback / scroll bounce). Triggered by btnViewCart, which lives in the panel above. --%>
    <asp:UpdatePanel ID="upCartPopup" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

    <asp:Panel ID="pnlCartPopup" runat="server" CssClass="popup-overlay" Visible="false">
        <div class="popup-window cart-quickview-window">
            <div class="qv-header">
                <span class="qv-title">Your Cart (<asp:Label ID="lblQvCount" runat="server" Text="0" />)</span>
                <asp:Button ID="btnCloseCartPopup" runat="server" Text="×" CssClass="qv-close"
                    CausesValidation="false" OnClick="btnCloseCartPopup_Click" />
            </div>

            <asp:PlaceHolder ID="phQvEmpty" runat="server" Visible="false">
                <div class="qv-empty">Your cart is empty.</div>
            </asp:PlaceHolder>

            <div class="qv-items">
                <asp:Repeater ID="rptQuickCart" runat="server">
                    <ItemTemplate>
                        <div class="qv-item">
                            <img class="qv-img" src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>' />
                            <div class="qv-item-info">
                                <div class="qv-item-name"><%# Eval("ProductName") %></div>
                                <div class="qv-item-meta">
                                    <span class="qv-badge">Colour: <%# Eval("Colour") %></span>
                                    <span class="qv-badge">Size: <%# Eval("ClothingSize") %></span>
                                    <span class="qv-badge">x<%# Eval("Quantity") %></span>
                                </div>
                            </div>
                            <div class="qv-line-total">R<%# string.Format("{0:0.00}", Eval("LineTotal")) %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="qv-summary">
                <div class="qv-row"><span>Subtotal</span><span>R<asp:Label ID="lblQvSubtotal" runat="server" /></span></div>
                <div class="qv-row"><span>Delivery</span><span><asp:Label ID="lblQvDelivery" runat="server" /></span></div>

                <div class="delivery-tracker">
                    <div class="dt-track">
                        <div id="dtFillPopup" runat="server" class="dt-fill"></div>
                    </div>
                    <asp:Label ID="lblQvTrackerMsg" runat="server" CssClass="dt-msg" />
                </div>

                <div class="qv-row qv-total"><span>Total</span><span>R<asp:Label ID="lblQvTotal" runat="server" /></span></div>
            </div>

            <div class="qv-actions">
                <a class="qv-btn qv-btn-secondary" href='<%= ResolveUrl("~/Public Pages/Cart.aspx") %>'>Go to Cart</a>
            </div>
        </div>
    </asp:Panel>

        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnViewCart" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <script src="<%= ResolveUrl("~/Scripts/delivery-tracker.js") %>"></script>
    <script src="<%= ResolveUrl("~/Scripts/wishlist.js") %>"></script>

</asp:Content>