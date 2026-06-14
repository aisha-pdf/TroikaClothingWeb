<%@ Page Title="Sale History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleHistory.aspx.cs" Inherits="TroikaClothingWeb.Sale_Pages.SaleHistory" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="<%= ResolveUrl("~/Content/SaleHistory.css") %>" rel="stylesheet" />

    <div class="troika-page sale-history-page">
        <div class="troika-section">
            <h2 class="sale-history-title">SALE HISTORY</h2>

            <asp:HiddenField ID="hfSelectedReceipt" runat="server" />

            <asp:Label ID="lblMessage"
                runat="server"
                CssClass="sale-history-message"
                EnableViewState="False" />

            <div class="sale-history-layout">
                <div class="sale-history-left">
                    <div class="troika-card sale-history-card">
                        <asp:GridView ID="gvSale"
                            runat="server"
                            CssClass="gridview troika-table sale-history-grid"
                            HorizontalAlign="Center"
                            AutoGenerateColumns="False"
                            AutoGenerateSelectButton="False"
                            CellPadding="4"
                            DataKeyNames="ReceiptNum"
                            GridLines="None"
                            AllowPaging="True"
                            PageSize="12"
                            OnSelectedIndexChanged="gvSale_SelectedIndexChanged"
                            OnPageIndexChanging="gvSale_PageIndexChanging">

                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkSelectSale"
                                            runat="server"
                                            Text="Select"
                                            CommandName="Select"
                                            CausesValidation="False" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="ReceiptNum" HeaderText="Receipt No." ReadOnly="True" />
                                <asp:BoundField DataField="PaymentTotal" HeaderText="Total" DataFormatString="{0:N2}" />
                                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
                                <asp:BoundField DataField="PaymentDate" HeaderText="Date" DataFormatString="{0:yyyy/MM/dd HH:mm}" />
                                <asp:BoundField DataField="SalesStatus" HeaderText="Status" />
                            </Columns>

                            <HeaderStyle CssClass="sale-history-grid-header" />
                            <RowStyle CssClass="sale-history-grid-row" />
                            <AlternatingRowStyle CssClass="sale-history-grid-alt-row" />
                            <SelectedRowStyle CssClass="sale-history-grid-selected-row" />
                            <PagerStyle CssClass="sale-history-grid-pager" HorizontalAlign="Center" />
                        </asp:GridView>
                    </div>
                </div>

                <div class="sale-history-right">
                    <div class="troika-card sale-products-card">
                        <asp:Panel ID="pnlNoSaleSelected" runat="server" CssClass="sale-empty-panel">
                            <span class="troika-muted">Select a sale to view the products purchased.</span>
                        </asp:Panel>

                        <asp:ListView ID="lvProductsSold" runat="server" DataKeyNames="ProductID">
                            <ItemTemplate>
                                <div class="sale-product-card">
                                    <div class="sale-product-image-wrap">
                                        <asp:Image ID="imgProduct"
                                            runat="server"
                                            CssClass="sale-product-image"
                                            AlternateText='<%# Eval("ProductName") %>'
                                            ImageUrl='<%# Eval("ImageUrl") %>' />
                                    </div>

                                    <div class="sale-history-text">
                                        <asp:Label ID="lblName" runat="server" CssClass="sale-product-name" Text='<%# Eval("ProductName") %>' />
                                        <asp:Label ID="lblPrice" runat="server" CssClass="sale-product-price" Text='<%# "Price: R" + Eval("Price", "{0:N2}") %>' />
                                        <asp:Label ID="lblQuantity" runat="server" CssClass="sale-product-detail" Text='<%# "Quantity: " + Eval("Quantity") %>' />
                                        <asp:Label ID="lblSize" runat="server" CssClass="sale-product-detail" Text='<%# "Size: " + Eval("ClothingSize") %>' />
                                        <asp:Label ID="lblColour" runat="server" CssClass="sale-product-detail" Text='<%# "Colour: " + Eval("Colour") %>' />
                                        <asp:Label ID="lblDescription" runat="server" CssClass="sale-product-description" Text='<%# Eval("Description") %>' />
                                    </div>
                                </div>
                            </ItemTemplate>

                            <EmptyDataTemplate>
                                <div class="sale-empty-panel">
                                    <span class="troika-muted">No products found for this sale.</span>
                                </div>
                            </EmptyDataTemplate>

                            <LayoutTemplate>
                                <div id="itemPlaceholderContainer" runat="server" class="sale-products-list">
                                    <span runat="server" id="itemPlaceholder" />
                                </div>
                            </LayoutTemplate>
                        </asp:ListView>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
