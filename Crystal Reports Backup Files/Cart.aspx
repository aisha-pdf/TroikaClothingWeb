<%@ Page Title="Your Cart" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Cart.aspx.cs"
    Inherits="TroikaClothingWeb.Public_Pages.Cart" %>


<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Colour variables */
        :root {
            --troika-navy: #3D304C; /* dark purple background */
            --troika-white: #ffffff;
            --troika-cream: #f8f8f8; ; /* main cream for cards */
            --troika-cream-2: #f3f3f3; /* slightly different cream if needed */
            --troika-light-accent: #644F7D; /* purple accent */
            --troika-deep-green: #2C5F2D;
            --troika-light-address: #D8CDEB; /* lighter purple for address container */
            --card-border: #3D304C; /* dark purple border for cards */
            --muted-text: #6b7280;
        }

        /* Page background (overall) */
        body {
            background: var(--troika-navy);
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Outer shell spacing */
        .cart-shell {
            padding: 40px 16px;
        }

        /* Main cart card (cream) */
        .cart {
            max-width: 1100px;
            margin: 0 auto;
            background: var(--troika-navy); /* dark purple main card */
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.35);
            border: 2px solid var(--card-border); /* dark purple border */
            color: var(--troika-navy);
        }

        .title {
            color: var(--troika-cream);
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 18px;
            text-align: left;
        }

        /* Grid layout */
        .grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 22px;
        }

        @media(max-width:900px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }

        /* Individual product item card (light cream with border) */
        .item {
            display: flex;
            gap: 14px;
            padding: 14px;
            border-radius: 10px;
            background: var(--troika-cream-2); /* slightly different cream for inner cards */
            border: 1px solid var(--card-border);
            align-items: center;
        }

            .item img {
                width: 86px;
                height: 86px;
                object-fit: cover;
                border-radius: 8px;
                border: 1px solid rgba(0,0,0,0.06);
            }

        .item-name {
            color: var(--troika-navy);
            font-weight: 600;
            font-size: 16px;
        }

        .muted {
            color: var(--muted-text);
            font-size: 14px;
        }

        .badge {
            display: inline-block;
            padding: .15rem .5rem;
            border-radius: 999px;
            font-size: 12px;
            margin-right: 6px;
            background: rgba(61,48,76,0.07);
            color: var(--troika-navy);
            border: 1px solid rgba(61,48,76,0.12);
        }

        .qtybox {
            width: 64px;
            text-align: center;
            padding: 6px 8px;
            background: var(--troika-white);
            color: var(--troika-navy);
            border: 1px solid #d1d5db;
            border-radius: 6px;
        }

        /* Buttons */
        .btn {
            border: 0;
            border-radius: 8px;
            padding: 8px 12px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
        }

        .btn-ghost {
            background: transparent;
            color: var(--troika-navy);
            border: 1px solid rgba(61,48,76,0.12);
            padding: 8px 12px;
            border-radius: 8px;
        }

            .btn-ghost:hover {
                background: var(--troika-light-accent);
                color: var(--troika-white);
            }

        .btn-danger {
            background: #a93226;
            color: #fff;
            border-radius: 8px;
            padding: 8px 12px;
        }

            .btn-danger:hover {
                background: #c0392b;
            }

        .btn-primary {
            background: var(--troika-deep-green);
            color: #fff;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 700;
        }

            .btn-primary:hover {
                background: #234823;
            }

        /* Right summary panel: make it a cream card as well (lighter than main) */
        .panel {
            background: var(--troika-cream-2); /* inner summary card */
            border-radius: 10px;
            padding: 18px;
            border: 1px solid var(--card-border);
        }

        .total {
            font-size: 18px;
            color: var(--troika-navy);
            font-weight: 700;
        }

        .select, .form-control {
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            background: var(--troika-white);
            color: var(--troika-navy);
            width: 100%;
        }

        /* Address container: lighter purple card */
        .address-card {
            background: var(--troika-light-address);
            border-radius: 10px;
            padding: 14px;
            color: var(--troika-navy);
            border: 1px solid rgba(61,48,76,0.18);
            margin-top: 12px;
        }

            .address-card input, .address-card .form-control {
                color: var(--troika-navy);
            }

        /* Center the checkout button horizontally */
        .checkout-center {
            text-align: center;
            margin-top: 18px;
        }

        /* Bottom row for Clear / Back buttons inside panel */
        .panel-bottom {
            margin-top: 12px;
            display: flex;
            gap: 8px;
            justify-content: space-between;
            align-items: center;
        }

        /* Make Clear cart (left one) red and Back to shopping style */
        .btn-clear {
            background: #a93226;
            color: #fff;
            border-radius: 8px;
            padding: 8px 12px;
        }

            .btn-clear:hover {
                background: #c0392b;
            }

        .btn-back {
            background: linear-gradient(135deg, var(--troika-light-accent), var(--troika-navy));
            color: #fff;
            border-radius: 8px;
            padding: 8px 12px;
        }

            .btn-back:hover {
                transform: translateY(-2px);
            }

        /* Small responsive tweaks */
        @media(max-width:900px) {
            .panel-bottom {
                flex-direction: column;
                align-items: stretch;
                gap: 10px;
            }

            .grid {
                gap: 16px;
            }
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
                        <div class="total">Subtotal: R<asp:Label ID="lblSubtotal" runat="server" />
                           
                        </div>
                        <div class="muted">VAT Included</div>

                        <div class="muted" style="margin-bottom: 6px;">Delivery:
                            <asp:Label ID="lblDelivery" runat="server" /></div>
                        <div class="total">Total: R<asp:Label ID="lblTotal" runat="server" /></div>
                        <div class="muted" style="margin-bottom: 10px;">Estimated Delivery:
                            <asp:Label ID="lblEstDelivery" runat="server" /></div>

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