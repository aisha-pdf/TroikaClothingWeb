<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrderConfirmation.aspx.cs" Inherits="TroikaClothingWeb.Public_Pages.OrderConfirmation" Async="true" %>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        :root {
            --receipt-page-bg: #ffffff;
            --receipt-main-bg: #3D304C;
            --receipt-card-bg: #FFF9F3;
            --receipt-item-bg: #FFF5EB;
            --receipt-text-dark: #1f1f1f;
            --receipt-text-purple: #3D304C;
            --receipt-muted: #6b7280;
            --receipt-border: #3D304C;
            --receipt-light-purple: #D8CDEB;
            --receipt-purple-hover: #644F7D;
            --receipt-success: #2C5F2D;
        }

        body[data-theme="dark"] {
            --receipt-page-bg: #121018;
            --receipt-main-bg: #1c1724;
            --receipt-card-bg: #FFF9F3;
            --receipt-item-bg: #FFF5EB;
            --receipt-text-dark: #1f1f1f;
            --receipt-text-purple: #3D304C;
            --receipt-muted: #6b7280;
            --receipt-border: #3b3048;
            --receipt-light-purple: #D8CDEB;
        }

        .receipt-shell {
            padding: 40px 16px;
            background: var(--receipt-page-bg) !important;
            min-height: 80vh;
        }

        .receipt {
            max-width: 1100px;
            margin: 0 auto;
        }

        .receipt-card {
            background: var(--receipt-main-bg) !important;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.35);
            border: 2px solid var(--receipt-border);
            color: #ffffff !important;
        }

            .receipt-card .title {
                font-size: 28px;
                font-weight: 700;
                color: #ffffff !important;
                margin-bottom: 18px;
            }

        .receipt-id-label {
            text-align: center;
            font-size: 18px;
            font-weight: 700;
            color: #ffffff !important;
        }

        .badge {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 20px;
            background: #644F7D !important;
            color: #ffffff !important;
            border: 1px solid rgba(255,255,255,0.3);
            font-weight: 700;
        }

        .badge {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 20px;
            background: #644F7D !important;
            color: #ffffff !important;
            border: 1px solid rgba(255,255,255,0.3);
            font-weight: 700;
        }

            .badge,
            .badge span,
            .badge label,
            .badge * {
                color: #ffffff !important;
            }

        #MainContent_lblReceipt {
            color: #ffffff !important;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1.45fr;
            gap: 22px;
            align-items: start;
            margin-top: 22px;
        }

        .items {
            margin-top: 10px;
        }

        .line {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed var(--receipt-border);
            color: var(--receipt-text-purple) !important;
            font-weight: 600;
        }

        .items > .line {
            color: #ffffff !important;
            border-bottom: 1px dashed rgba(255,255,255,0.35);
        }

            .items > .line span {
                color: #ffffff !important;
            }

        .line span,
        .line label {
            color: inherit !important;
        }

        .line:last-child {
            border-bottom: 0;
        }

        .item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px;
            border-radius: 10px;
            background: var(--receipt-item-bg) !important;
            border: 1px solid var(--receipt-border);
            margin-bottom: 8px;
            color: var(--receipt-text-dark) !important;
        }

            .item *,
            .item span,
            .item div {
                color: var(--receipt-text-dark) !important;
            }

        .item-name {
            font-weight: 700;
            color: var(--receipt-text-purple) !important;
        }

        .small {
            font-size: 12px;
            color: var(--receipt-muted) !important;
            margin-top: 4px;
        }

            .small * {
                color: var(--receipt-muted) !important;
            }

        .card-right {
            background: var(--receipt-card-bg) !important;
            border-radius: 12px;
            padding: 24px;
            border: 2px solid var(--receipt-border);
            color: var(--receipt-text-purple) !important;
        }

            .card-right *,
            .card-right span,
            .card-right label,
            .card-right div {
                color: var(--receipt-text-purple) !important;
            }

            .card-right .text-muted,
            .card-right .muted {
                color: var(--receipt-muted) !important;
            }

        .total {
            font-weight: 800;
            font-size: 18px;
            color: var(--receipt-text-purple) !important;
        }

        .panel-bottom {
            margin-top: 16px;
            display: flex;
            gap: 10px;
            justify-content: flex-start;
            align-items: center;
            flex-wrap: wrap;
        }

        .btn {
            border: 0 !important;
            border-radius: 8px !important;
            padding: 10px 14px !important;
            font-weight: 700 !important;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none !important;
            display: inline-block;
        }

        .btn-light-purple,
        .btn-primary {
            background: #D8CDEB !important;
            color: #121018 !important;
            border: 1px solid #D8CDEB !important;
        }

            .btn-light-purple:hover,
            .btn-primary:hover {
                background: #cbb7e8 !important;
                color: #121018 !important;
                border-color: #cbb7e8 !important;
            }

        body[data-theme="light"] .btn-light-purple,
        body[data-theme="light"] .btn-primary {
            background: #3D304C !important;
            color: #ffffff !important;
            border: 1px solid #3D304C !important;
        }

            body[data-theme="light"] .btn-light-purple:hover,
            body[data-theme="light"] .btn-primary:hover {
                background: #644F7D !important;
                color: #ffffff !important;
                border-color: #644F7D !important;
            }

        /* Save receipt = green with white text. Scoped under .receipt so it beats the
           global input[type=submit] !important rule (specificity 0,1,1) in TroikaTheme.css. */
        .receipt .btn-success {
            background: #2C5F2D !important;
            color: #ffffff !important;
            border: 1px solid #2C5F2D !important;
        }

            .receipt .btn-success:hover {
                background: #24521f !important;
                color: #ffffff !important;
                border-color: #24521f !important;
            }

        #MainContent_lblEmailStatus {
            display: block;
            margin-top: 10px;
            font-weight: 700;
        }

        @media(max-width: 900px) {
            .grid {
                grid-template-columns: 1fr;
            }

            .panel-bottom {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>

    <div class="receipt-shell">
        <div class="receipt">
            <div class="receipt-card">
                <div class="title">Thank you! Your order is confirmed.</div>
                <div class="receipt-id-label">Receipt ID:</div>
                <div style="text-align: center; margin-top: 6px;">
                    <span class="badge">
                        <asp:Label ID="lblReceipt" runat="server" />
                    </span>
                </div>


                <div class="grid" style="margin-top: 16px;">
                    <!-- LEFT: Items -->
                    <div>
                        <div class="items">
                            <asp:Repeater ID="rptItems" runat="server">
                                <HeaderTemplate>
                                    <div class="line"><span>Item</span><span>Amount</span></div>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <div class="item">
                                        <div>
                                            <div class="item-name">
                                                <asp:Label ID="lblProductName" runat="server" Text='<%# Eval("ProductName") %>'></asp:Label>
                                            </div>
                                            <div class="small">
                                                ID: <%# Eval("ProductID") %> • Size: <%# Eval("clothingSize") %> • Colour: <%# Eval("colour") %> • Qty:
                                                <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("quantity") %>'></asp:Label>
                                                <br />
                                                Unit: R<asp:Label ID="lblUnitPrice" runat="server" Text='<%# String.Format("{0:0.00}", Eval("UnitPrice")) %>'></asp:Label>
                                            </div>
                                        </div>
                                        <div>
                                            R<asp:Label ID="lblLineTotal" runat="server" Text='<%# String.Format("{0:0.00}", Eval("LineTotal")) %>'></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <!-- RIGHT: Summary -->
                    <div>
                        <div class="card-right">
                            <div class="line"><span>Order date</span><span><asp:Label ID="lblDate" runat="server" /></span></div>
                            <div class="line"><span>Payment method</span><span><asp:Label ID="lblPaymentMethod" runat="server" /></span></div>
                            <div class="d-flex justify-content-between text-muted">
                                <span>VAT Included</span>
                            </div>
                            <div class="line"><span>Subtotal</span><span>R<asp:Label ID="lblSubtotal" runat="server" /></span></div>


                            <div class="line"><span>Delivery</span><span><asp:Label ID="lblDelivery" runat="server" /></span></div>
                            <div class="line total"><span>Total paid</span><span>R<asp:Label ID="lblTotal" runat="server" /></span></div>

                            <div class="line">
                                <span>Ship to</span><span style="text-align: right">
                                    <asp:Label ID="lblShipName" runat="server" /><br />
                                    <asp:Label ID="lblShipStreet" runat="server" /><br />
                                    <asp:Label ID="lblShipSuburb" runat="server" /><br />
                                    <asp:Label ID="lblShipPost" runat="server" />
                                </span>
                            </div>

                            <div class="line"><span>Estimated delivery</span><span><asp:Label ID="lblEta" runat="server" /></span></div>

                            <div class="panel-bottom">
                                <a class="btn btn-light-purple" href="/Public Pages/Products.aspx">← Continue shopping</a>
                                <asp:Button ID="btnSavePdf" runat="server" Text="Save receipt (PDF)" CssClass="btn btn-success" OnClientClick="saveReceiptAsPdf(); return false;" />
                                <asp:Button ID="btnResendEmail" runat="server" Text="Resend receipt" CssClass="btn btn-light-purple" OnClick="btnEmail_Click" />
                                <asp:Label ID="lblEmailStatus" runat="server" CssClass="muted" Style="margin-left: 8px;" />
                            </div>
                        </div>
                    </div>
                </div>

                <asp:Label ID="lblChannel" runat="server" Visible="false"></asp:Label>
            </div>
        </div>
    </div>





    <script>

        function saveReceiptAsPdf() {

            function val(id) {
                const el = document.getElementById(id);
                return el ? el.innerText.trim() : "";
            }

            const receiptId = val("<%= lblReceipt.ClientID %>");
            const date = val("<%= lblDate.ClientID %>");
            const pay = val("<%= lblPaymentMethod.ClientID %>");
            const subtotal = val("<%= lblSubtotal.ClientID %>");
            let delivery = val("<%= lblDelivery.ClientID %>").replace("RR", "R");
            const total = val("<%= lblTotal.ClientID %>");
            const eta = val("<%= lblEta.ClientID %>");

            const shipName = val("<%= lblShipName.ClientID %>");
            const shipStreet = val("<%= lblShipStreet.ClientID %>");
            const shipSuburb = val("<%= lblShipSuburb.ClientID %>");
            const shipPost = val("<%= lblShipPost.ClientID %>");

            // look for all elements with the item class
            const items = document.querySelectorAll('.item');

            let rows = "";
            items.forEach(it => {
                const nameEl = it.querySelector('.item-name');
                const name = nameEl ? nameEl.innerText.trim() : "";

                const detailsEl = it.querySelector('.small');
                const details = detailsEl ? detailsEl.innerText.trim() : "";

                //get the amount from the right-side div (last child)
                const amountDiv = it.lastElementChild;
                const amount = amountDiv ? amountDiv.innerText.trim().replace("RR", "R") : "";

                rows += `
        <tr>
            <td>
                <strong>${name}</strong><br>
                <span style="font-size:12px;">${details}</span>
            </td>
            <td style="text-align:right;">${amount}</td>
        </tr>`;
            });

            const html = `
<html>
<head>
    <title>Troika Receipt</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            padding: 40px;
            color: #3D304C;
            background: #ffffff;
        }
        .logo-box { 
            text-align: center; 
            margin-bottom: 10px; 
        }
        .title {
            text-align: center;
            font-size: 26px;
            margin-bottom: 25px;
            font-weight: 700;
        }
        .receipt-line {
            display: flex;
            justify-content: space-between;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .pdf-box {
            background: #f8f8f8;
            border: 2px solid #3D304C;
            border-radius: 14px;
            padding: 28px;
            max-width: 900px;
            margin: 0 auto;
        }
        .section-title {
            font-weight: 700;
            font-size: 18px;
            margin-top: 25px;
            border-bottom: 2px solid #3D304C;
            padding-bottom: 6px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th {
            background: #2A1E37;
            color: #fff;
            padding: 10px;
            font-size: 14px;
        }
        td {
            background: #fff;
            border-bottom: 1px solid #3D304C;
            padding: 10px;
            font-size: 14px;
        }
        .totals div {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
        }
        .total-final {
            font-size: 20px;
            font-weight: 700;
            color: #2C5F2D;
        }
        .address-box {
            background: #D8CDEB;
            padding: 12px;
            border-radius: 10px;
            margin-top: 10px;
        }
        .footer {
            margin-top: 40px;
            text-align: center;
            font-size: 12px;
            color: #6b7280;
        }
    </style>
</head>

<body>

    <div class="logo-box">
        <!-- Bigger logo -->
        <img src="/Images/logo.png" height="110">
    </div>

    <div class="title">Order Receipt</div>

    <div class="pdf-box">

        <div class="receipt-line">
            <div></div>
            <div>Receipt ID: <strong>${receiptId}</strong></div>
        </div>

        <div class="section-title">Items</div>
        <table>
            <thead>
                <tr>
                    <th>Item</th>
                    <th style="text-align:right;">Amount</th>
                </tr>
            </thead>
            <tbody>${rows}</tbody>
        </table>

        <div class="section-title">Summary</div>
        <div class="totals">
            <div><span>Order date</span><span>${date}</span></div>
            <div><span>Payment method</span><span>${pay}</span></div>
            <div><span>Subtotal</span><span>R${subtotal}</span></div>
            <div><span>Delivery</span><span>${delivery}</span></div>
            <div class="total-final"><span>Total paid</span><span>R${total}</span></div>
            <div><span>Estimated delivery</span><span>${eta}</span></div>
        </div>

        <div class="section-title">Shipping Address</div>
        <div class="address-box">
            ${shipName}<br>
            ${shipStreet}<br>
            ${shipSuburb}<br>
            ${shipPost}
        </div>
    </div>

    <div class="footer">Thank you for shopping with Troika Clothing.</div>

</body>
</html>`;

            const w = window.open("", "", "width=900,height=700");
            w.document.write(html);
            w.document.close();

            setTimeout(() => {
                w.print();
                w.close();
            }, 600);
        }



    </script>

</asp:Content>
