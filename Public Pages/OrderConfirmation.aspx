<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="OrderConfirmation.aspx.cs" Inherits="TroikaClothingWeb.Public_Pages.OrderConfirmation" Async="true" %>

<asp:Content ID="Main" ContentPlaceHolderID="MainContent" runat="server">
     <style>
     :root{
         --troika-navy: #3D304C;          /* dark purple background */
         --troika-white: #ffffff;
         --troika-cream: #FFF9F3;         /* main cream for cards */
         --troika-cream-2: #FFF5EB;       /* slightly different cream if needed */
         --troika-light-accent: #644F7D;  /* purple accent */
         --troika-deep-green: #2C5F2D;    /* green for primary buttons */
         --card-border: #3D304C;
         --muted-text: #6b7280;
     }

     body {
         background: var(--troika-navy);
         font-family: "Segoe UI", Roboto, Arial, sans-serif;
         margin:0;
         padding:0;
     }

     .receipt-shell {
         padding: 40px 16px;
     }

     .receipt {
         max-width: 1100px;
         margin: 0 auto;
     }

     /* Main container card (purple) */
     .card {
         background: var(--troika-navy);
         border-radius: 12px;
         padding: 24px;
         box-shadow: 0 8px 24px rgba(0,0,0,0.35);
         border: 2px solid var(--card-border);
     }

     .title {
         font-size: 28px;
         font-weight: 700;
         color: var(--troika-cream);
         margin-bottom: 18px;
     }

     .muted { color: var(--muted-text); font-size: 14px; }

     /* Badge color lighter for visibility */
     .badge {
         display:inline-block;
         padding:.15rem .5rem;
         border-radius:999px;
         font-size:12px;
         background: rgba(255,255,255,0.15);
         color: var(--troika-cream);
         border:1px solid rgba(255,255,255,0.3);
     }

     .grid {
         display:grid;
         grid-template-columns:2fr 1fr;
         gap:22px;
     }

     @media(max-width:900px) {
         .grid { grid-template-columns:1fr; }
     }

     .items {
         margin-top:10px;
     }

     .item {
         display:flex;
         justify-content:space-between;
         align-items:center;
         padding:10px;
         border-radius:10px;
         background: var(--troika-cream-2);
         border: 1px solid var(--card-border);
         margin-bottom:8px;
     }

     .item-name { font-weight:600; color: var(--troika-navy); }

     .small { font-size:12px; color: var(--muted-text); margin-top:4px; }

     /* Item/Amount header lighter */
     .line {
         display:flex;
         justify-content:space-between;
         padding:10px 0;
         border-bottom:1px dashed var(--card-border);
         color: var(--troika-cream-2);
         font-weight:600;
     }

     .line:last-child { border-bottom:0; }

     .total { font-weight:700; font-size:18px; color: var(--troika-navy); }

     .btn {
         border:0;
         border-radius:8px;
         padding:8px 12px;
         font-weight:600;
         cursor:pointer;
         font-size:14px;
     }

     .btn-primary { background: var(--troika-deep-green); color:#fff; }
     .btn-primary:hover { background:#234823; }

     .btn-light-purple { background: var(--troika-light-accent); color:#fff; }
     .btn-light-purple:hover { background:#523d6f; }

     .panel-bottom {
         margin-top:12px;
         display:flex;
         gap:8px;
         justify-content:flex-start;
     }

     /* Right summary panel now cream */
     .card-right {
         background: var(--troika-cream);
         border-radius: 12px;
         padding: 24px;
         border: 2px solid var(--card-border);
     }

     .card-right .line { color: var(--troika-navy); }
     .card-right .total { color: var(--troika-navy); }
     .card-right .btn-light-purple, .card-right .btn-primary { color:#fff; }
 </style>
    <div class="receipt-shell">
        <div class="receipt">
            <div class="card">
                <div class="title">Thank you! Your order is confirmed.</div>
                <div class="muted">Receipt <span class="badge"><asp:Label ID="lblReceipt" runat="server"/></span></div>

                <div class="grid" style="margin-top:16px;">
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
                                                <br />Unit: R<asp:Label ID="lblUnitPrice" runat="server" Text='<%# String.Format("{0:0.00}", Eval("UnitPrice")) %>'></asp:Label>
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
                            <div class="line"><span>Order date</span><span><asp:Label ID="lblDate" runat="server"/></span></div>
                            <div class="line"><span>Payment method</span><span><asp:Label ID="lblPaymentMethod" runat="server"/></span></div>
                            <div class="line"><span>Subtotal</span><span>R<asp:Label ID="lblSubtotal" runat="server"/></span></div>
                            <div class="line"><span>Delivery</span><span><asp:Label ID="lblDelivery" runat="server"/></span></div>
                            <div class="line total"><span>Total paid</span><span>R<asp:Label ID="lblTotal" runat="server"/></span></div>

                            <div class="line"><span>Ship to</span><span style="text-align:right">
                                <asp:Label ID="lblShipName" runat="server"/><br/>
                                <asp:Label ID="lblShipStreet" runat="server"/><br/>
                                <asp:Label ID="lblShipSuburb" runat="server"/><br/>
                                <asp:Label ID="lblShipPost" runat="server"/>
                            </span></div>

                            <div class="line"><span>Estimated delivery</span><span><asp:Label ID="lblEta" runat="server"/></span></div>

                            <div class="panel-bottom">
                                <a class="btn btn-light-purple" href="/Public Pages/Products.aspx">← Continue shopping</a>
                                <asp:Button ID="btnSavePdf" runat="server" Text="💾 Save receipt (PDF)" CssClass="btn btn-primary" OnClientClick="saveReceiptAsPdf(); return false;" />
                                <asp:Button ID="btnResendEmail" runat="server" Text="✉ Resend receipt" CssClass="btn btn-light-purple" OnClick="btnEmail_Click" />
                                <asp:Label ID="lblEmailStatus" runat="server" CssClass="muted" Style="margin-left:8px;" />
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
            const receiptContent = document.querySelector('.receipt').outerHTML;
            const printWindow = window.open('', '', 'width=900,height=700');
            printWindow.document.write(`
            <html>
            <head>
            <title>Troika Clothing - Order Receipt</title>
            <style>
                body { font-family: 'Segoe UI', sans-serif; color: #3D304C; margin: 40px; background: white; }
                h2 { color: #4F46E5; text-align: center; }
                .card { border: 1px solid #e5e7eb; border-radius: 12px; padding: 20px; box-shadow: 0 8px 20px rgba(0,0,0,.06); }
                table { width: 100%; border-collapse: collapse; margin-top: 16px; }
                th, td { border: 1px solid #e5e7eb; padding: 8px; text-align: left; }
                th { background: #f9fafb; }
                .muted { color: #6b7280; font-size: 13px; text-align: center; margin-top: 30px; }
            </style>
            </head>
            <body>
                <h2>Troika Clothing — Order Receipt</h2>
                ${receiptContent}
                <p class="muted">Thank you for shopping with Troika Clothing.</p>
            </body>
            </html>`);
            printWindow.document.close();
            setTimeout(() => {
                printWindow.focus();
                printWindow.print();
                printWindow.close();
            }, 600);
        }
    </script>

</asp:Content>
