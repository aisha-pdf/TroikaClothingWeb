<%@ Page Title="Your Cart" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Cart.aspx.cs"
    Inherits="TroikaClothingWeb.Public_Pages.Cart" %>


<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --cart-main-bg: #3D304C;
            --cart-main-bg-dark: #3D304C;
            --cart-page-bg: #ffffff;
            --cart-panel-bg: #f8f8f8;
            --cart-item-bg: #ffffff;
            --cart-text-dark: #1f1f1f;
            --cart-text-purple: #3D304C;
            --cart-muted: #6b7280;
            --cart-border: #3D304C;
            --cart-light-purple: #D8CDEB;
            --cart-light-purple-2: #eadcff;
            --cart-danger: #a93226;
        }

        body[data-theme="dark"] {
            --cart-page-bg: #121018;
            --cart-panel-bg: #1c1724;
            --cart-item-bg: #f8f8f8;
            --cart-text-dark: #1f1f1f;
            --cart-text-purple: #3D304C;
            --cart-muted: #6b7280;
            --cart-border: #3b3048;
            --cart-light-purple: #D8CDEB;
            --cart-light-purple-2: #eadcff;
        }

        .cart-shell {
            padding: 40px 16px;
            background: var(--cart-page-bg) !important;
            min-height: 80vh;
        }

        .cart {
            max-width: 1120px;
            margin: 0 auto;
            background: var(--cart-main-bg) !important;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.35);
            border: 2px solid var(--cart-border);
            color: #ffffff !important;
        }

            .cart .title {
                color: #ffffff !important;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 22px;
                text-align: left;
            }

        .grid {
            display: grid;
            grid-template-columns: minmax(0, 2fr) 360px;
            gap: 24px;
            align-items: start;
        }

        .item {
            display: flex;
            gap: 14px;
            padding: 14px;
            border-radius: 10px;
            background: var(--cart-item-bg) !important;
            border: 1px solid #ddd;
            align-items: center;
            color: var(--cart-text-dark) !important;
            margin-bottom: 14px;
            min-height: 120px;
        }

            .item *,
            .item span,
            .item div {
                color: var(--cart-text-dark) !important;
            }

            .item img {
                width: 86px;
                height: 86px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid rgba(0,0,0,0.08);
                flex-shrink: 0;
            }

        .item-name {
            color: var(--cart-text-purple) !important;
            font-weight: 700;
            font-size: 16px;
        }

        .muted {
            color: var(--cart-muted) !important;
            font-size: 14px;
        }

        .badge {
            display: inline-block;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: 12px;
            margin-right: 6px;
            margin-bottom: 4px;
            background: #ececf0 !important;
            color: var(--cart-text-purple) !important;
            border: 1px solid #d8d8df;
            font-weight: 600;
        }

        .qtybox {
            width: 64px !important;
            height: 44px;
            text-align: center;
            padding: 6px 8px !important;
            background: #ffffff !important;
            color: var(--cart-text-dark) !important;
            border: 1px solid #d1d5db !important;
            border-radius: 6px !important;
        }

        .cart .total {
            font-size: 18px;
            color: var(--cart-text-purple) !important;
            font-weight: 700;
        }

        .cart .btn,
        .cart input[type="submit"],
        .cart input[type="button"],
        .cart a.btn {
            border: none !important;
            border-radius: 8px !important;
            padding: 9px 14px !important;
            cursor: pointer;
            font-weight: 700 !important;
            font-size: 14px;
            text-decoration: none !important;
            display: inline-block;
        }

        .cart .btn-ghost {
            background: #3D304C !important;
            color: #ffffff !important;
            border: 1px solid #3D304C !important;
        }

            .cart .btn-ghost:hover {
                background: #644F7D !important;
                color: #ffffff !important;
            }

        .cart .btn-danger {
            background: var(--cart-danger) !important;
            color: #ffffff !important;
        }

            .cart .btn-danger:hover {
                background: #c0392b !important;
                color: #ffffff !important;
            }

        .cart .btn-primary {
            background: var(--cart-light-purple-2) !important;
            color: #121018 !important;
            border: 1px solid var(--cart-light-purple-2) !important;
        }

            .cart .btn-primary:hover {
                background: #d9c8f0 !important;
                color: #121018 !important;
            }

        .panel {
            background: var(--cart-panel-bg) !important;
            border-radius: 10px;
            padding: 18px;
            border: 1px solid var(--cart-border);
            color: var(--troika-text) !important;
            width: 100%;
            box-sizing: border-box;
        }

            .panel *,
            .panel span,
            .panel div,
            .panel label {
                color: var(--troika-text) !important;
            }

        body[data-theme="light"] .panel,
        body[data-theme="light"] .panel *,
        body[data-theme="light"] .panel span,
        body[data-theme="light"] .panel div,
        body[data-theme="light"] .panel label {
            color: #1f1f1f !important;
        }

        .panel .total {
            color: var(--troika-text) !important;
            font-weight: 800;
        }

        body[data-theme="light"] .panel .total {
            color: #3D304C !important;
        }

        .select,
        .form-control {
            padding: 10px !important;
            border-radius: 6px !important;
            border: 1px solid #d1d5db !important;
            background: #ffffff !important;
            color: #1f1f1f !important;
            width: 100% !important;
            box-sizing: border-box;
        }

        body[data-theme="dark"] .select,
        body[data-theme="dark"] .form-control {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
        }

        .address-card {
            background: var(--cart-light-purple) !important;
            border-radius: 10px;
            padding: 14px;
            color: #1f1f1f !important;
            border: 1px solid rgba(61,48,76,0.18);
            margin-top: 14px;
        }

            .address-card *,
            .address-card span,
            .address-card label,
            .address-card strong,
            .address-card div {
                color: #1f1f1f !important;
            }

            .address-card .btn-ghost,
            .address-card input[type="submit"] {
                background: #3D304C !important;
                color: #ffffff !important;
                border: 1px solid #3D304C !important;
            }

        .checkout-center {
            text-align: center;
            margin-top: 18px;
        }

        .panel-bottom {
            margin-top: 14px;
            display: flex;
            gap: 12px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
        }

        .btn-clear {
            background: var(--cart-light-purple-2) !important;
            color: #121018 !important;
            border: 1px solid var(--cart-light-purple-2) !important;
            border-radius: 8px !important;
            padding: 10px 16px !important;
            font-weight: 700 !important;
        }

            .btn-clear:hover {
                background: #d9c8f0 !important;
                color: #121018 !important;
            }

        .btn-back {
            background: var(--cart-light-purple-2) !important;
            color: #121018 !important;
            border: 1px solid var(--cart-light-purple-2) !important;
            border-radius: 8px !important;
            padding: 10px 16px !important;
            font-weight: 700 !important;
        }

            .btn-back:hover {
                background: #d9c8f0 !important;
                color: #121018 !important;
                transform: translateY(-1px);
            }

        #MainContent_lblMessage {
            display: block;
            margin-top: 12px;
            text-align: center;
            font-weight: 700;
        }

        @media (max-width: 1000px) {
            .grid {
                grid-template-columns: 1fr;
            }

            .panel {
                max-width: 100%;
            }
        }

        @media (max-width: 650px) {
            .cart {
                padding: 18px;
            }

            .item {
                flex-direction: column;
                align-items: flex-start;
            }

                .item img {
                    width: 100%;
                    height: 180px;
                }

            .panel-bottom {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-clear,
            .btn-back,
            .cart .btn-primary {
                width: 100% !important;
            }
        }

        body[data-theme="light"] .cart .panel-bottom .btn-clear,
        body[data-theme="light"] .cart .panel-bottom .btn-back,
        body[data-theme="light"] .cart .panel-bottom input.btn-clear,
        body[data-theme="light"] .cart .panel-bottom input.btn-back {
            background: #3D304C !important;
            color: #ffffff !important;
            border: 1px solid #3D304C !important;
        }

            body[data-theme="light"] .cart .panel-bottom .btn-clear:hover,
            body[data-theme="light"] .cart .panel-bottom .btn-back:hover,
            body[data-theme="light"] .cart .panel-bottom input.btn-clear:hover,
            body[data-theme="light"] .cart .panel-bottom input.btn-back:hover {
                background: #644F7D !important;
                color: #ffffff !important;
                border-color: #644F7D !important;
            }
    </style>

    <div class="cart-shell">
        <div class="cart">
            <div class="title">Your Cart</div>

            <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                <div class="muted" style="text-align: center; margin-top: 40px;">
                    <p>Your cart is empty.</p>
                    <a href="<%= ResolveUrl("~/Public Pages/Products.aspx") %>"
                        class="btn-back">← Back to Shopping</a>
                </div>
            </asp:PlaceHolder>


            <asp:PlaceHolder ID="phCart" runat="server">
                <div class="grid">
                    <!-- LEFT: Items -->
                    <div>
                        <asp:Repeater ID="rptCart" runat="server">
                            <ItemTemplate>
                                <div class="item">
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>' />
                                    <div style="flex: 1">
                                        <div class="item-name"><%# Eval("ProductName") %></div>
                                        <div class="muted" style="margin-top: 6px;">
                                            <span class="badge">ID: <%# Eval("ProductID") %></span>
                                            <span class="badge">Colour: <%# Eval("Colour") %></span>
                                            <span class="badge">Size: <%# Eval("ClothingSize") %></span>
                                        </div>
                                        <div class="muted" style="margin-top: 8px;">Unit Price: R<%# string.Format("{0:0.00}", Eval("UnitPrice")) %></div>

                                        <div style="display: flex; gap: 8px; align-items: center; margin-top: 10px;">
                                            <asp:TextBox ID="txtQty" runat="server" CssClass="qtybox" Text='<%# Eval("Quantity") %>' />
                                            <asp:LinkButton runat="server" CommandName="update" CssClass="btn btn-ghost"
                                                CommandArgument='<%# Eval("ProductID") + "|" + Eval("Colour") + "|" + Eval("ClothingSize") %>'>Update</asp:LinkButton>
                                            <asp:LinkButton runat="server" CommandName="remove" CssClass="btn btn-danger"
                                                CommandArgument='<%# Eval("ProductID") + "|" + Eval("Colour") + "|" + Eval("ClothingSize") %>'>Remove</asp:LinkButton>
                                        </div>
                                    </div>

                                    <div style="min-width: 110px; text-align: right;">
                                        <div class="total">R<%# string.Format("{0:0.00}", Eval("LineTotal")) %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <!-- RIGHT: Summary -->
                    <div class="panel">
                        <div class="total">
                            Subtotal: R<asp:Label ID="lblSubtotal" runat="server" />

                        </div>
                        <div class="muted">VAT Included</div>

                        <div class="muted" style="margin-bottom: 6px;">
                            Delivery:
                            <asp:Label ID="lblDelivery" runat="server" />
                        </div>
                        <div class="total">Total: R<asp:Label ID="lblTotal" runat="server" /></div>
                        <div class="muted" style="margin-bottom: 10px;">
                            Estimated Delivery:
                            <asp:Label ID="lblEstDelivery" runat="server" />
                        </div>

                        <div style="margin-top: 8px;">
                            <div class="muted" style="margin-bottom: 6px;">Payment method</div>
                            <asp:DropDownList ID="ddlPayment" runat="server" CssClass="select">
                                <asp:ListItem Text="EFT" />
                                <asp:ListItem Text="Cash on delivery" />
                                <asp:ListItem Text="Credit card" />
                            </asp:DropDownList>
                        </div>

                        <!-- Current Address (light purple card) -->
                        <asp:Panel ID="PanelCurrentAddress" runat="server" Visible="false" CssClass="address-card">
                            <strong>Current Address</strong><br />
                            <asp:Label ID="lblCurrentAddress" runat="server" />
                            <br />
                            <br />
                            <asp:Button ID="btnToggleAddress" runat="server" Text="Edit Address" CssClass="btn btn-ghost"
                                OnClick="btnToggleAddress_Click" />
                        </asp:Panel>

                        <!-- Address form (lighter purple card) -->
                        <asp:Panel ID="PanelAddress" runat="server" Visible="false" CssClass="address-card">
                            <h4 style="margin: 0 0 8px 0; color: var(--troika-navy);">Delivery Address</h4>
                            <p class="muted" style="margin-top: 0;">You can add or update your delivery address below.</p>

                            <div style="margin-bottom: 10px;">
                                <asp:Label ID="lblStreet" runat="server" Text="Street Address:" AssociatedControlID="txtStreet" />
                                <asp:TextBox ID="txtStreet" runat="server" CssClass="form-control" />
                            </div>

                            <div style="margin-bottom: 10px;">
                                <asp:Label ID="lblSuburb" runat="server" Text="Suburb:" AssociatedControlID="txtSuburb" />
                                <asp:TextBox ID="txtSuburb" runat="server" CssClass="form-control" />
                            </div>

                            <div style="margin-bottom: 10px;">
                                <asp:Label ID="lblPostCode" runat="server" Text="Post Code:" AssociatedControlID="txtPostCode" />
                                <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control" MaxLength="4" />
                            </div>

                            <div style="display: flex; gap: 8px; justify-content: flex-start;">
                                <asp:Button ID="btnSaveAddress" runat="server" Text="Save Address" CssClass="btn btn-primary"
                                    OnClick="btnSaveAddress_Click" />
                                <asp:Button ID="btnCancelAddress" runat="server" Text="Cancel" CssClass="btn btn-ghost"
                                    OnClick="btnCancelAddress_Click" />
                            </div>
                        </asp:Panel>

                        <!-- Checkout centered -->
                        <div class="checkout-center">
                            <asp:Button ID="btnCheckout" runat="server" Text="Checkout" CssClass="btn btn-primary"
                                OnClick="btnCheckout_Click" />
                        </div>

                        <asp:Label ID="lblMessage" runat="server" CssClass="muted" />

                        <div class="panel-bottom">
                            <asp:Button ID="btnClear" runat="server" Text="Clear cart" CssClass="btn-clear" OnClick="btnClear_Click" />
                            <asp:Button ID="btnBack" runat="server" Text="← Back to Shopping" CssClass="btn-back" PostBackUrl="~/Public Pages/Products.aspx" />
                        </div>
                    </div>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>
