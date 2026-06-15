<%@ Page Title="Order History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleHistory.aspx.cs" Inherits="TroikaClothingWeb.Sale_Pages.SaleHistory" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/SaleHistory.css") %>" rel="stylesheet" />

    <div class="troika-page sale-history-page">
        <div class="troika-section sale-history-wrap">

            <div class="sale-history-head">
                <h2 class="sale-history-title">Order History</h2>
                <p class="sale-history-subtitle">Review every order you've placed with Troika and the items in each.</p>
            </div>

            <asp:HiddenField ID="hfSelectedReceipt" runat="server" />

            <asp:Label ID="lblMessage" runat="server" CssClass="sale-history-message" EnableViewState="False" />

            <!-- At-a-glance summary -->
            <asp:Panel ID="pnlStats" runat="server" CssClass="sale-stats" Visible="false">
                <div class="sale-stat">
                    <div class="sale-stat-body">
                        <span class="sale-stat-value"><asp:Label ID="lblStatOrders" runat="server" Text="0" /></span>
                        <span class="sale-stat-label">Orders</span>
                    </div>
                </div>
                <div class="sale-stat">
                    <div class="sale-stat-body">
                        <span class="sale-stat-value"><asp:Label ID="lblStatSpent" runat="server" Text="R0.00" /></span>
                        <span class="sale-stat-label">Total spent</span>
                    </div>
                </div>
                <div class="sale-stat">
                    <div class="sale-stat-body">
                        <span class="sale-stat-value"><asp:Label ID="lblStatLatest" runat="server" Text="—" /></span>
                        <span class="sale-stat-label">Latest order</span>
                    </div>
                </div>
            </asp:Panel>

            <%-- Order selection / paging run as partial (async) postbacks so the page never
                 reloads or scroll-jumps when a record on the left is clicked. --%>
            <asp:UpdatePanel ID="upSaleHistory" runat="server" UpdateMode="Conditional">
                <ContentTemplate>

            <div class="sale-history-layout">

                <!-- LEFT: order list -->
                <div class="sale-orders-col">
                    <div class="sale-col-head">Your orders</div>

                    <asp:GridView ID="gvSale" runat="server"
                        CssClass="sale-orders"
                        AutoGenerateColumns="False"
                        ShowHeader="False"
                        GridLines="None"
                        DataKeyNames="ReceiptNum"
                        AllowPaging="True"
                        PageSize="8"
                        OnSelectedIndexChanged="gvSale_SelectedIndexChanged"
                        OnPageIndexChanging="gvSale_PageIndexChanging">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CssClass="order-card" CommandName="Select"
                                        CausesValidation="False" ToolTip="View the items in this order">
                                        <span class="order-card-top">
                                            <span class="order-card-id">#<%# Eval("ReceiptNum") %></span>
                                            <span class='<%# "sale-status-badge " + GetStatusCssClass(Eval("SalesStatus")) %>'><%# Eval("SalesStatus") %></span>
                                        </span>
                                        <span class="order-card-meta">
                                            <span><%# Eval("PaymentDate", "{0:dd MMM yyyy}") %></span>
                                            <span class="oc-dot">•</span>
                                            <span><%# Eval("PaymentMethod") %></span>
                                        </span>
                                        <span class="order-card-bottom">
                                            <span class="order-card-total">R<%# Eval("PaymentTotal", "{0:N2}") %></span>
                                            <span class="order-card-view">View details &#8250;</span>
                                        </span>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <SelectedRowStyle CssClass="order-row-selected" />
                        <PagerStyle CssClass="sale-pager" HorizontalAlign="Center" />

                        <EmptyDataTemplate>
                            <div class="order-empty-text" style="padding: 20px 4px;">You haven't placed any orders yet.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <!-- RIGHT: order detail -->
                <div class="sale-detail-col">

                    <asp:Panel ID="pnlNoSaleSelected" runat="server" CssClass="order-empty">
                        <div class="order-empty-title">No order selected</div>
                        <div class="order-empty-text">Pick an order on the left to see its items, totals and delivery details.</div>
                    </asp:Panel>

                    <asp:Panel ID="pnlSaleDetail" runat="server" Visible="false" CssClass="order-detail">

                        <div class="order-detail-head">
                            <div>
                                <div class="order-detail-label">Order</div>
                                <div class="order-detail-id">#<asp:Label ID="lblSelectedReceipt" runat="server" /></div>
                            </div>
                            <asp:Label ID="lblSelectedStatus" runat="server" CssClass="sale-status-badge status-neutral" />
                        </div>

                        <div class="order-detail-meta">
                            <div class="odm-item">
                                <span class="odm-k">Date</span>
                                <span class="odm-v"><asp:Label ID="lblSelectedDate" runat="server" /></span>
                            </div>
                            <div class="odm-item">
                                <span class="odm-k">Payment</span>
                                <span class="odm-v"><asp:Label ID="lblSelectedPayment" runat="server" /></span>
                            </div>
                            <div class="odm-item">
                                <span class="odm-k">Items</span>
                                <span class="odm-v"><asp:Label ID="lblSelectedCount" runat="server" /></span>
                            </div>
                        </div>

                        <div class="order-detail-section">Items</div>

                        <asp:ListView ID="lvProductsSold" runat="server" DataKeyNames="ProductID">
                            <LayoutTemplate>
                                <div class="order-items">
                                    <span runat="server" id="itemPlaceholder" />
                                </div>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <div class="order-item">
                                    <img class="order-item-img" src='<%# Eval("ImageUrl") %>' alt='<%# Eval("ProductName") %>' />
                                    <div class="order-item-info">
                                        <div class="order-item-name"><%# Eval("ProductName") %></div>
                                        <div class="order-item-chips">
                                            <span class="oi-chip">Size: <%# Eval("ClothingSize") %></span>
                                            <span class="oi-chip">Colour: <%# Eval("Colour") %></span>
                                            <span class="oi-chip">Qty: <%# Eval("Quantity") %></span>
                                        </div>
                                        <div class="order-item-unit">R<%# Eval("Price", "{0:N2}") %> each</div>
                                    </div>
                                    <div class="order-item-total">R<%# Eval("LineTotal", "{0:N2}") %></div>
                                </div>
                            </ItemTemplate>
                            <EmptyDataTemplate>
                                <div class="order-empty-text" style="padding: 16px 0;">No products found for this order.</div>
                            </EmptyDataTemplate>
                        </asp:ListView>

                        <div class="order-totals">
                            <div class="ot-row"><span>Subtotal</span><span><asp:Label ID="lblSelectedSubtotal" runat="server" /></span></div>
                            <div class="ot-row"><span>Delivery</span><span><asp:Label ID="lblSelectedDelivery" runat="server" /></span></div>
                            <div class="ot-row ot-total"><span>Total paid</span><span><asp:Label ID="lblSelectedTotal" runat="server" /></span></div>
                        </div>

                        <div class="order-actions">
                            <button type="button" class="order-save-btn" onclick="saveSaleReceipt(); return false;">Save receipt (PDF)</button>
                        </div>

                    </asp:Panel>
                </div>
            </div>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <script>
        // Builds a printable receipt for the currently-selected order and opens it in a
        // print window — the same "save receipt" behaviour as the order-confirmation page.
        function saveSaleReceipt() {
            function val(id) {
                var el = document.getElementById(id);
                return el ? el.innerText.trim() : "";
            }

            var receiptId = val("<%= lblSelectedReceipt.ClientID %>");
            var status = val("<%= lblSelectedStatus.ClientID %>");
            var date = val("<%= lblSelectedDate.ClientID %>");
            var pay = val("<%= lblSelectedPayment.ClientID %>");
            var subtotal = val("<%= lblSelectedSubtotal.ClientID %>");
            var delivery = val("<%= lblSelectedDelivery.ClientID %>");
            var total = val("<%= lblSelectedTotal.ClientID %>");

            if (!receiptId) return;

            var detail = document.getElementById("<%= pnlSaleDetail.ClientID %>");
            var items = detail ? detail.querySelectorAll(".order-item") : [];

            var rows = "";
            Array.prototype.forEach.call(items, function (it) {
                var nameEl = it.querySelector(".order-item-name");
                var name = nameEl ? nameEl.innerText.trim() : "";
                var chipEls = it.querySelectorAll(".oi-chip");
                var chips = Array.prototype.map.call(chipEls, function (c) { return c.innerText.trim(); }).join(" · ");
                var amtEl = it.querySelector(".order-item-total");
                var amount = amtEl ? amtEl.innerText.trim() : "";
                rows += '<tr><td><strong>' + name + '</strong><br><span style="font-size:12px;color:#6b7280;">' + chips + '</span></td><td style="text-align:right;white-space:nowrap;">' + amount + '</td></tr>';
            });

            var html =
'<html><head><title>Troika Receipt</title><style>'
+ 'body{font-family:\'Segoe UI\',sans-serif;padding:40px;color:#3D304C;background:#fff;}'
+ '.logo-box{text-align:center;margin-bottom:10px;}'
+ '.title{text-align:center;font-size:26px;margin-bottom:25px;font-weight:700;}'
+ '.pdf-box{background:#f8f8f8;border:2px solid #3D304C;border-radius:14px;padding:28px;max-width:900px;margin:0 auto;}'
+ '.receipt-line{display:flex;justify-content:space-between;font-size:18px;font-weight:600;margin-bottom:10px;}'
+ '.section-title{font-weight:700;font-size:18px;margin-top:25px;border-bottom:2px solid #3D304C;padding-bottom:6px;}'
+ 'table{width:100%;border-collapse:collapse;margin-top:10px;}'
+ 'th{background:#2A1E37;color:#fff;padding:10px;font-size:14px;text-align:left;}'
+ 'td{background:#fff;border-bottom:1px solid #3D304C;padding:10px;font-size:14px;}'
+ '.totals div{display:flex;justify-content:space-between;padding:6px 0;}'
+ '.total-final{font-size:20px;font-weight:700;color:#2C5F2D;}'
+ '.footer{margin-top:40px;text-align:center;font-size:12px;color:#6b7280;}'
+ '</style></head><body>'
+ '<div class="logo-box"><img src="/Images/logo.png" height="110"></div>'
+ '<div class="title">Order Receipt</div>'
+ '<div class="pdf-box">'
+ '<div class="receipt-line"><div>Status: ' + status + '</div><div>Receipt ID: <strong>' + receiptId + '</strong></div></div>'
+ '<div class="section-title">Items</div>'
+ '<table><thead><tr><th>Item</th><th style="text-align:right;">Amount</th></tr></thead><tbody>' + rows + '</tbody></table>'
+ '<div class="section-title">Summary</div>'
+ '<div class="totals">'
+ '<div><span>Order date</span><span>' + date + '</span></div>'
+ '<div><span>Payment method</span><span>' + pay + '</span></div>'
+ '<div><span>Subtotal</span><span>' + subtotal + '</span></div>'
+ '<div><span>Delivery</span><span>' + delivery + '</span></div>'
+ '<div class="total-final"><span>Total paid</span><span>' + total + '</span></div>'
+ '</div></div>'
+ '<div class="footer">Thank you for shopping with Troika Clothing.</div>'
+ '</body></html>';

            var w = window.open("", "", "width=900,height=700");
            if (!w) return;
            w.document.write(html);
            w.document.close();
            setTimeout(function () { w.print(); w.close(); }, 600);
        }
    </script>
</asp:Content>
