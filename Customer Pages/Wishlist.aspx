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
