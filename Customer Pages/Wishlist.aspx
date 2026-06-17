<%@ Page Title="My Wishlist" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="Wishlist.aspx.cs" Inherits="TroikaClothingWeb.Customer_Pages.Wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .wishlist-page {
            padding: 40px 16px;
            min-height: 80vh;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
        }

        .wishlist-inner {
            max-width: 1000px;
            margin: 0 auto;
        }

        .wishlist-title {
            color: var(--troika-heading-text) !important;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .wishlist-subtitle {
            color: var(--troika-muted-text) !important;
            margin-bottom: 22px;
        }

        .wishlist-message {
            display: block;
            font-weight: 600;
            color: var(--troika-muted-text) !important;
            background: var(--troika-surface) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 10px;
            padding: 24px;
            text-align: center;
        }

        .wish-card {
            display: flex;
            gap: 16px;
            align-items: center;
            background: var(--troika-surface) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 12px;
            padding: 14px;
            margin-bottom: 14px;
        }

            .wish-card.is-inactive {
                opacity: 0.6;
            }

        .wish-thumb-link {
            flex-shrink: 0;
            display: block;
        }

        .wish-thumb {
            width: 96px;
            height: 96px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--troika-border);
        }

        .wish-info {
            flex: 1;
            min-width: 0;
        }

        .wish-name {
            font-weight: 700;
            font-size: 17px;
            color: var(--troika-heading-text) !important;
        }

        .wish-cat {
            font-size: 13px;
            color: var(--troika-muted-text) !important;
            margin: 2px 0 6px 0;
        }

        .wish-price {
            font-weight: 700;
            color: var(--troika-text) !important;
        }

        .wish-unavailable {
            margin-top: 6px;
            font-size: 13px;
            font-weight: 700;
            color: #d60000 !important;
        }

        .wish-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex-shrink: 0;
        }

        .wish-btn {
            display: inline-block;
            text-align: center;
            border-radius: 8px;
            padding: 8px 14px !important;
            font-weight: 700;
            font-size: 13px;
            text-decoration: none !important;
            cursor: pointer;
            border: 1px solid var(--troika-border) !important;
            background: var(--troika-surface-alt, #f1ecf7) !important;
            color: var(--troika-text) !important;
        }

            .wish-btn:hover {
                background: var(--troika-btn-hover-bg, #644F7D) !important;
                color: #ffffff !important;
            }

        .wish-btn-primary {
            background: var(--troika-btn-bg, #3D304C) !important;
            color: var(--troika-btn-text, #ffffff) !important;
            border-color: var(--troika-btn-bg, #3D304C) !important;
        }

            .wish-btn-primary:hover {
                background: var(--troika-btn-hover-bg, #644F7D) !important;
                color: #ffffff !important;
            }

        .wish-btn-danger {
            background: #a93226 !important;
            color: #ffffff !important;
            border-color: #a93226 !important;
        }

            .wish-btn-danger:hover {
                background: #c0392b !important;
                color: #ffffff !important;
            }

        .wish-toast {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%) translateY(-20px);
            background: #2C5F2D;
            color: #ffffff !important;
            padding: 12px 22px;
            border-radius: 8px;
            font-weight: 700;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.25s ease, transform 0.25s ease;
            z-index: 11000;
        }

            .wish-toast.is-show {
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }

        @media (max-width: 640px) {
            .wish-card {
                flex-direction: column;
                align-items: stretch;
                text-align: center;
            }

            .wish-thumb {
                width: 100%;
                height: 200px;
            }

            .wish-actions {
                flex-direction: row;
                justify-content: center;
                flex-wrap: wrap;
            }
        }

        /* -------------------- ADD-TO-CART MINI POPUP -------------------- */

        .atc-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 11000;
            padding: 20px;
            overflow: auto;
        }

        .atc-window {
            position: relative;
            width: 380px;
            max-width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            text-align: left;
            animation: atcZoomIn 0.25s ease-out;
        }

        @keyframes atcZoomIn {
            from {
                opacity: 0;
                transform: scale(0.94);
            }

            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .atc-close {
            position: absolute;
            top: 10px;
            right: 10px;
            width: 32px !important;
            height: 32px;
            background: transparent !important;
            color: var(--troika-text) !important;
            border: none !important;
            font-size: 22px;
            line-height: 32px;
            text-align: center;
            cursor: pointer;
            padding: 0 !important;
            border-radius: 6px;
        }

            .atc-close:hover {
                background: var(--troika-surface-alt, #f1ecf7) !important;
            }

        .atc-product {
            display: flex;
            gap: 12px;
            align-items: center;
            margin-bottom: 18px;
            padding-right: 20px;
        }

        .atc-thumb {
            width: 72px;
            height: 72px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid var(--troika-border);
            flex-shrink: 0;
        }

        .atc-name {
            font-weight: 700;
            font-size: 16px;
            color: var(--troika-heading-text) !important;
        }

        .atc-price {
            font-weight: 700;
            margin-top: 2px;
            color: var(--troika-primary) !important;
        }

        .atc-field {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-bottom: 14px;
        }

        .atc-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--troika-text) !important;
        }

        .atc-select {
            padding: 9px 10px !important;
            border-radius: 6px !important;
            font-size: 15px;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            border: 1px solid var(--troika-border) !important;
            width: 100%;
        }

        .atc-qty {
            width: 100px;
        }

        .atc-actions {
            display: flex;
            gap: 10px;
            margin-top: 6px;
        }

        .atc-btn {
            flex: 1;
            text-align: center;
            border-radius: 6px;
            padding: 10px 14px !important;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            border: 1px solid var(--troika-border) !important;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .atc-btn-secondary {
            background: #a93226 !important;
            color: #ffffff !important;
            border-color: #a93226 !important;
        }

            .atc-btn-secondary:hover {
                background: #c0392b !important;
                color: #ffffff !important;
                transform: translateY(-1px);
            }

        .atc-btn-primary {
            background: #2C5F2D !important;
            color: #ffffff !important;
            border-color: #2C5F2D !important;
        }

            .atc-btn-primary:hover {
                background: #34a853 !important;
                color: #ffffff !important;
                transform: translateY(-1px);
            }
    </style>

    <div class="wishlist-page">
        <div class="wishlist-inner">
            <h2 class="wishlist-title">MY WISHLIST</h2>
            <p class="wishlist-subtitle">Items you have saved. Tap the heart on any product to add or remove it.</p>

            <asp:Repeater ID="rptWishlist" runat="server" OnItemCommand="rptWishlist_ItemCommand">
                <ItemTemplate>
                    <div class='<%# (bool)Eval("IsActive") ? "wish-card" : "wish-card is-inactive" %>'>
                        <asp:HyperLink runat="server" CssClass="wish-thumb-link"
                            NavigateUrl='<%# (bool)Eval("IsActive") ? (string)Eval("DetailUrl") : "" %>'>
                            <asp:Image runat="server" CssClass="wish-thumb"
                                ImageUrl='<%# Eval("ImageUrl") %>'
                                AlternateText='<%# Eval("ProductName") %>' />
                        </asp:HyperLink>

                        <div class="wish-info">
                            <div class="wish-name"><%# Eval("ProductName") %></div>
                            <div class="wish-cat"><%# Eval("Category") %></div>
                            <div class="wish-price">R<%# Convert.ToDecimal(Eval("Price")).ToString("F2") %></div>
                            <div class="wish-unavailable" runat="server" Visible='<%# !(bool)Eval("IsActive") %>'>
                                This product is no longer available
                            </div>
                        </div>

                        <div class="wish-actions">
                            <asp:LinkButton runat="server" Visible='<%# (bool)Eval("IsActive") %>'
                                CssClass="wish-btn wish-btn-primary"
                                CommandName="addtocart" CommandArgument='<%# Eval("ProductID") %>'
                                CausesValidation="false">Add to cart</asp:LinkButton>

                            <asp:HyperLink runat="server" Visible='<%# (bool)Eval("IsActive") %>'
                                CssClass="wish-btn"
                                NavigateUrl='<%# Eval("DetailUrl") %>'>View product</asp:HyperLink>

                            <asp:LinkButton runat="server" CssClass="wish-btn wish-btn-danger"
                                CommandName="remove" CommandArgument='<%# Eval("ProductID") %>'
                                OnClientClick="return confirm('Remove this item from your wishlist?');">Remove</asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblMessage" runat="server" CssClass="wishlist-message" EnableViewState="False" Visible="false" />
        </div>
    </div>

    <%-- Mini product popup: opened by "Add to cart" so the customer can pick a colour,
         size and quantity (the wishlist row itself captures none of these). Adds to the
         cart and closes on confirm. Plain full-postback panel to match this page's
         structure; MaintainScrollPositionOnPostback keeps the scroll position. --%>
    <asp:Panel ID="pnlAddToCart" runat="server" CssClass="atc-overlay" Visible="false">
        <div class="atc-window">
            <asp:Button ID="btnAtcClose" runat="server" CssClass="atc-close" Text="×"
                CausesValidation="false" OnClick="btnAtcCancel_Click" ToolTip="Close" />

            <div class="atc-product">
                <asp:Image ID="imgAtc" runat="server" CssClass="atc-thumb" />
                <div>
                    <div class="atc-name"><asp:Label ID="lblAtcName" runat="server" /></div>
                    <div class="atc-price"><asp:Label ID="lblAtcPrice" runat="server" /></div>
                </div>
            </div>

            <div class="atc-field">
                <label class="atc-label">Colour</label>
                <asp:DropDownList ID="ddlAtcColour" runat="server" CssClass="atc-select" />
            </div>

            <div class="atc-field">
                <label class="atc-label">Size</label>
                <asp:DropDownList ID="ddlAtcSize" runat="server" CssClass="atc-select" />
            </div>

            <div class="atc-field">
                <label class="atc-label">Quantity</label>
                <asp:TextBox ID="txtAtcQuantity" runat="server" CssClass="atc-select atc-qty"
                    Text="1" TextMode="Number" min="1" />
            </div>

            <asp:HiddenField ID="hfAtcProductId" runat="server" />

            <div class="atc-actions">
                <asp:Button ID="btnAtcCancel" runat="server" CssClass="atc-btn atc-btn-secondary"
                    Text="Cancel" CausesValidation="false" OnClick="btnAtcCancel_Click" />
                <asp:Button ID="btnAtcAdd" runat="server" CssClass="atc-btn atc-btn-primary"
                    Text="Add to cart" OnClick="btnAtcAdd_Click" />
            </div>
        </div>
    </asp:Panel>

    <div id="wishToast" class="wish-toast" aria-live="polite"></div>

    <script type="text/javascript">
        // Shown after an "Add to cart" postback via ClientScript.RegisterStartupScript.
        function troikaShowWishToast(message) {
            var toast = document.getElementById("wishToast");
            if (!toast) return;
            toast.textContent = message;
            toast.classList.add("is-show");
            clearTimeout(toast._hideTimer);
            toast._hideTimer = setTimeout(function () {
                toast.classList.remove("is-show");
            }, 2600);
        }
    </script>

</asp:Content>
