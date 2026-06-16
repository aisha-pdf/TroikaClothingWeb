<%@ Page Title="Your Cart" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="Cart.aspx.cs"
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
            --cart-item-bg: #241f2e;
            --cart-text-dark: #f5f3f7;
            --cart-text-purple: #D8CDEB;
            --cart-muted: #b5acc4;
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

        /* ---- Inline item editing (colour / size / qty) styled into the old look ---- */
        .cart .item-edit {
            display: flex;
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap;
            margin-top: 12px;
        }

        .cart .edit-field {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .cart .item .edit-label {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            color: var(--cart-muted) !important;
        }

        /* Narrow the full-width .select when used inline inside an item row */
        .cart .item .select.edit-select {
            width: auto !important;
            min-width: 120px;
            padding: 8px 9px !important;
        }

        .cart .item .select.edit-select-sm {
            min-width: 78px;
        }

        .cart .qty-stepper {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

            .cart .qty-stepper .step-btn {
                width: 34px;
                height: 44px;
                padding: 0 !important;
                border: 1px solid #d1d5db !important;
                border-radius: 6px !important;
                background: #ffffff !important;
                color: var(--cart-text-purple) !important;
                font-size: 18px;
                font-weight: 700;
                line-height: 1;
                cursor: pointer;
            }

                .cart .qty-stepper .step-btn:hover {
                    background: var(--cart-light-purple) !important;
                    border-color: var(--cart-border) !important;
                    color: var(--cart-text-purple) !important;
                }

        /* ---- Free-delivery tracker label colours inside the summary panel ---- */
        .cart .panel .ec-val {
            font-weight: 700;
        }

        .cart .panel .ec-free {
            color: #2C5F2D !important;
            font-weight: 800;
        }

        body[data-theme="dark"] .cart .panel .ec-free {
            color: #7fd083 !important;
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

        /* The delivery-address form is shown/hidden client-side via the is-open class
           (toggled from "Edit Address"/"Cancel"), so editing it never posts back. The
           code-behind sets this exact class list, so it is styled like the old address card. */
        .ec-address-form {
            display: none;
        }

            .ec-address-form.is-open {
                display: block;
            }

        .cart .ec-address-form {
            background: var(--cart-light-purple) !important;
            border-radius: 10px;
            padding: 14px;
            border: 1px solid rgba(61,48,76,0.18);
            margin-top: 14px;
        }

            .cart .ec-address-form,
            .cart .ec-address-form * {
                color: #1f1f1f !important;
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
            display: inline-block;
            text-decoration: none !important;
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

        /* ---- Item right column: line total with the Remove link beneath it ---- */
        .item-right {
            min-width: 110px;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 12px;
            text-align: right;
        }

        .cart .item .lnk-remove {
            background: none !important;
            border: none !important;
            padding: 0 !important;
            color: var(--cart-danger) !important;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

            .cart .item .lnk-remove:hover {
                text-decoration: underline;
                color: var(--cart-danger) !important;
            }

        body[data-theme="dark"] .cart .item .lnk-remove {
            color: #ff9a90 !important;
        }

        /* ---- Checkout = solid green with white text; scoped under .cart + !important to
               beat the global button rule (button/input[type=button]) in TroikaTheme.css ---- */
        /* ---- Checkout button: green with white text in both light and dark mode ---- */
        .cart .btn-success,
        .cart input.btn-success,
        .cart input[type="submit"].btn-success,
        .cart input[type="button"].btn-success {
            background: #2C5F2D !important;
            color: #ffffff !important;
            border: 1px solid #2C5F2D !important;
            -webkit-text-fill-color: #ffffff !important;
        }

            .cart .btn-success:hover,
            .cart input.btn-success:hover,
            .cart input[type="submit"].btn-success:hover,
            .cart input[type="button"].btn-success:hover {
                background: #24521f !important;
                color: #ffffff !important;
                border-color: #24521f !important;
                -webkit-text-fill-color: #ffffff !important;
            }

            .cart .btn-success:disabled,
            .cart input.btn-success:disabled {
                opacity: 0.7;
                cursor: default;
                color: #ffffff !important;
                -webkit-text-fill-color: #ffffff !important;
            }

        /* Cancel inside the address form is red; re-assert white text because the form
           forces all descendant text dark (which made the old Cancel invisible). */
        .cart .ec-address-form .btn-danger {
            background: var(--cart-danger) !important;
            color: #ffffff !important;
            border: 1px solid var(--cart-danger) !important;
        }

            .cart .ec-address-form .btn-danger:hover {
                background: #c0392b !important;
                color: #ffffff !important;
            }

        /* ---- Free-delivery progress bar: taller + green ---- */
        .cart .delivery-tracker {
            margin: 12px 0 16px 0;
        }

            .cart .delivery-tracker .dt-track {
                height: 16px;
            }

            .cart .delivery-tracker .dt-fill {
                background: #2C5F2D !important;
            }

                .cart .delivery-tracker .dt-fill.is-free {
                    background: #34a853 !important;
                }

            .cart .delivery-tracker .dt-msg {
                font-size: 14px;
            }

        /* ---- Dark mode: cart item rows (surface set via vars above) + their controls ---- */
        body[data-theme="dark"] .item {
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .badge {
            background: #2b2433 !important;
            color: #D8CDEB !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .qtybox {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .cart .qty-stepper .step-btn {
            background: #251f2f !important;
            color: #D8CDEB !important;
            border-color: #3b3048 !important;
        }

        /* ---- In-page confirmation modal (replaces the browser confirm dialog) ---- */
        .confirm-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.55);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            padding: 20px;
        }

            .confirm-overlay.is-open {
                display: flex;
            }

        .confirm-box {
            background: var(--cart-panel-bg);
            border: 1px solid var(--cart-border);
            border-radius: 12px;
            padding: 24px;
            max-width: 420px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
            text-align: center;
            animation: troikaConfirmPop 0.18s ease-out;
        }

        body[data-theme="dark"] .confirm-box {
            background: #1c1724;
        }

        .confirm-title {
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 8px;
            color: var(--troika-text) !important;
        }

        .confirm-message {
            font-size: 14px;
            margin-bottom: 20px;
            color: var(--troika-text) !important;
        }

        .confirm-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .confirm-box .confirm-btn {
            border-radius: 8px !important;
            padding: 10px 18px !important;
            font-weight: 700 !important;
            font-size: 14px;
            cursor: pointer;
        }

        .confirm-box .confirm-cancel {
            background: #e5e7eb !important;
            color: #1f1f1f !important;
            border: 1px solid #d1d5db !important;
        }

            .confirm-box .confirm-cancel:hover {
                background: #d1d5db !important;
                color: #1f1f1f !important;
            }

        body[data-theme="dark"] .confirm-box .confirm-cancel {
            background: #2b2433 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        .confirm-box .confirm-ok {
            background: var(--cart-danger) !important;
            color: #ffffff !important;
            border: 1px solid var(--cart-danger) !important;
        }

            .confirm-box .confirm-ok:hover {
                background: #c0392b !important;
                color: #ffffff !important;
            }

        @keyframes troikaConfirmPop {
            from {
                opacity: 0;
                transform: scale(0.94);
            }

            to {
                opacity: 1;
                transform: scale(1);
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
                        class="btn-back">&#8592; Back to Shopping</a>
                </div>
            </asp:PlaceHolder>


            <asp:PlaceHolder ID="phCart" runat="server">
                <div class="grid">
                    <!-- LEFT: Items -->
                    <div>
                        <asp:Repeater ID="rptCart" runat="server" OnItemDataBound="rptCart_ItemDataBound">
                            <ItemTemplate>
                                <div class="item">
                                    <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>' />
                                    <div style="flex: 1">
                                        <div class="item-name"><%# Eval("ProductName") %></div>
                                        <div class="muted" style="margin-top: 6px;">
                                            <span class="badge">ID: <%# Eval("ProductID") %></span>
                                        </div>
                                        <div class="muted" style="margin-top: 8px;">Unit Price: R<%# string.Format("{0:0.00}", Eval("UnitPrice")) %></div>

                                        <div class="item-edit">
                                            <span class="edit-field">
                                                <label class="edit-label">Colour</label>
                                                <asp:DropDownList ID="ddlColourEdit" runat="server" CssClass="select edit-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="rptCart_ItemChanged" />
                                            </span>
                                            <span class="edit-field">
                                                <label class="edit-label">Size</label>
                                                <asp:DropDownList ID="ddlSizeEdit" runat="server" CssClass="select edit-select edit-select-sm"
                                                    AutoPostBack="true" OnSelectedIndexChanged="rptCart_ItemChanged" />
                                            </span>
                                            <span class="edit-field">
                                                <label class="edit-label">Qty</label>
                                                <span class="qty-stepper">
                                                    <button type="button" class="step-btn" onclick="troikaStep(this,-1)" aria-label="Decrease quantity">&#8722;</button>
                                                    <asp:TextBox ID="txtQty" runat="server" CssClass="qtybox" TextMode="Number" min="1"
                                                        AutoPostBack="true" OnTextChanged="rptCart_ItemChanged" Text='<%# Eval("Quantity") %>' />
                                                    <button type="button" class="step-btn" onclick="troikaStep(this,1)" aria-label="Increase quantity">+</button>
                                                </span>
                                            </span>
                                        </div>
                                    </div>

                                    <div class="item-right">
                                        <div class="total">R<%# string.Format("{0:0.00}", Eval("LineTotal")) %></div>
                                        <asp:LinkButton ID="lnkRemove" runat="server" CommandName="remove" CssClass="lnk-remove"
                                            OnClientClick="return troikaConfirm(this, 'Remove this item from your cart?');"
                                            CommandArgument='<%# Eval("ProductID") + "|" + Eval("Colour") + "|" + Eval("ClothingSize") %>'>Remove</asp:LinkButton>
                                    </div>

                                    <asp:HiddenField ID="hfKey" runat="server"
                                        Value='<%# Eval("ProductID") + "|" + Eval("Colour") + "|" + Eval("ClothingSize") %>' />
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

                        <!-- Free-delivery progress bar -->
                        <div class="delivery-tracker">
                            <div class="dt-track">
                                <div id="dtFillCart" runat="server" class="dt-fill"></div>
                            </div>
                            <asp:Label ID="lblDeliveryTrackerMsg" runat="server" CssClass="dt-msg" />
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
                                OnClientClick="troikaToggleAddress(); return false;" CausesValidation="false" />
                        </asp:Panel>

                        <!-- Address form (toggled client-side, no postback) -->
                        <asp:Panel ID="PanelAddress" runat="server" CssClass="ec-card ec-address ec-address-form">
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
                                <asp:Button ID="btnCancelAddress" runat="server" Text="Cancel" CssClass="btn btn-danger"
                                    OnClientClick="troikaToggleAddress(false); return false;" CausesValidation="false" />
                            </div>
                        </asp:Panel>

                        <!-- Checkout centered -->
                        <div class="checkout-center">
                            <asp:Button ID="btnCheckout" runat="server" Text="Checkout" CssClass="btn btn-success"
                                UseSubmitBehavior="false" OnClientClick="this.value='Processing...'; this.disabled=true;"
                                OnClick="btnCheckout_Click" />
                        </div>

                        <asp:Label ID="lblMessage" runat="server" CssClass="muted" />

                        <div class="panel-bottom">
                            <asp:Button ID="btnClear" runat="server" Text="Clear cart" CssClass="btn-clear" CausesValidation="false"
                                OnClientClick="return troikaConfirm(this, 'Clear your entire cart?');" OnClick="btnClear_Click" />
                            <a class="btn-back" href='<%= ResolveUrl("~/Public Pages/Products.aspx") %>'>&#8592; Back to Shopping</a>
                        </div>
                    </div>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>

    <!-- In-page confirmation modal (shared by Remove and Clear cart) -->
    <div id="troikaConfirmModal" class="confirm-overlay" aria-hidden="true">
        <div class="confirm-box" role="dialog" aria-modal="true" aria-labelledby="troikaConfirmTitle">
            <div class="confirm-title" id="troikaConfirmTitle">Please confirm</div>
            <div class="confirm-message" id="troikaConfirmMsg"></div>
            <div class="confirm-actions">
                <button type="button" class="confirm-btn confirm-cancel" onclick="troikaConfirmRespond(false)">Cancel</button>
                <button type="button" class="confirm-btn confirm-ok" onclick="troikaConfirmRespond(true)">Confirm</button>
            </div>
        </div>
    </div>

    <script src="<%= ResolveUrl("~/Scripts/delivery-tracker.js") %>"></script>

    <script>
        // In-page confirmation: replaces the native confirm() dialog. Returns false to
        // stop the control's postback, opens the modal, and re-triggers the same control
        // (with a one-shot data-confirmed flag) only if the user clicks Confirm.
        var _troikaPendingEl = null;

        function troikaConfirm(el, message) {
            if (el.getAttribute('data-confirmed') === '1') {
                el.removeAttribute('data-confirmed');
                return true; // second pass: let the real postback through
            }
            _troikaPendingEl = el;
            document.getElementById('troikaConfirmMsg').textContent = message;
            var modal = document.getElementById('troikaConfirmModal');
            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            return false; // first pass: wait for the modal answer
        }

        function troikaConfirmRespond(ok) {
            var modal = document.getElementById('troikaConfirmModal');
            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            var el = _troikaPendingEl;
            _troikaPendingEl = null;
            if (ok && el) {
                el.setAttribute('data-confirmed', '1');
                el.click(); // re-fire; troikaConfirm now returns true so the postback runs
            }
        }

        // Close the modal on backdrop click or Escape (treated as Cancel).
        document.addEventListener('DOMContentLoaded', function () {
            var modal = document.getElementById('troikaConfirmModal');
            if (modal) {
                modal.addEventListener('click', function (e) {
                    if (e.target === modal) troikaConfirmRespond(false);
                });
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && modal && modal.classList.contains('is-open')) {
                    troikaConfirmRespond(false);
                }
            });
        });

        // Show/hide the delivery-address form entirely client-side, so editing the
        // address no longer triggers a postback (which caused the page to jump).
        function troikaToggleAddress(force) {
            var form = document.querySelector('.ec-address-form');
            if (!form) return;
            var open = (typeof force === 'boolean') ? force : !form.classList.contains('is-open');
            form.classList.toggle('is-open', open);
        }

        // +/- quantity stepper: nudges the number box and fires its change event so the
        // existing AutoPostBack (OnTextChanged) updates totals server-side.
        function troikaStep(btn, delta) {
            var input = btn.parentNode.querySelector('input[type=number]');
            if (!input) return;
            var current = parseInt(input.value, 10);
            if (isNaN(current)) current = 1;
            var next = Math.max(1, current + delta);
            if (next === current) return;
            input.value = next;
            input.dispatchEvent(new Event('change', { bubbles: true }));
        }
    </script>

</asp:Content>
