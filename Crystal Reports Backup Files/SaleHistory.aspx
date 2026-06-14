<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleHistory.aspx.cs" Inherits="TroikaClothingWeb.Sale_Pages.SaleHistory" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="troika-page sale-history-container">
        <div class="troika-section">
            <h2 class="sale-history-title">SALE HISTORY</h2>

            <div class="row">
                <div class="col-md-7">
                    <div class="troika-card">
                        <asp:GridView ID="gvSale"
                            runat="server"
                            CssClass="gridview troika-table"
                            HorizontalAlign="Center"
                            AutoGenerateColumns="False"
                            AutoGenerateSelectButton="True"
                            CellPadding="4"
                            DataKeyNames="receiptNum"
                            DataSourceID="SaleOrderDS"
                            GridLines="None"
                            OnSelectedIndexChanged="gvSale_SelectedIndexChanged">

                            <Columns>
                                <asp:BoundField DataField="receiptNum" HeaderText="Receipt No." ReadOnly="True" SortExpression="receiptNum" />
                                <asp:BoundField DataField="paymentTotal" HeaderText="Total" SortExpression="paymentTotal" />
                                <asp:BoundField DataField="paymentMethod" HeaderText="Payment Method" SortExpression="paymentMethod" />
                                <asp:BoundField DataField="paymentDate" HeaderText="Date" SortExpression="paymentDate" />
                                <asp:BoundField DataField="salesStatus" HeaderText="Status" SortExpression="salesStatus" />
                            </Columns>
                        </asp:GridView>

                        <asp:SqlDataSource ID="SaleOrderDS"
                            runat="server"
                            ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                            SelectCommand="SELECT receiptNum, paymentTotal, paymentMethod, paymentDate, salesStatus FROM Sale WHERE (CustomerID = @CusID)">
                            <SelectParameters>
                                <asp:Parameter Name="CusID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="troika-card">
                        <asp:ListView ID="lvProductsSold" runat="server" DataSourceID="ProductsSold">
                            <ItemTemplate>
                                <div class="sale-product-card">
                                    <div class="text-center">
                                        <asp:Image ID="imgProduct" runat="server"
                                            Width="150px" Height="150px"
                                            ImageUrl='<%# GetImageUrl(Eval("Picture"), Eval("ProductName")) %>' />
                                    </div>

                                    <div class="sale-history-text mt-3">
                                        <asp:Label ID="lblName" runat="server" Text='<%# Eval("ProductName") %>' Font-Bold="true" /><br />
                                        <asp:Label ID="lblPrice" runat="server" Text='<%# "Price: " + Eval("Price", "{0:C}") %>' /><br />
                                        <asp:Label ID="lblDescription" runat="server" Text='<%# Eval("Description") %>' />
                                    </div>
                                </div>
                            </ItemTemplate>

                            <EmptyDataTemplate>
                                <span class="troika-muted">No products found for this sale.</span>
                            </EmptyDataTemplate>

                            <LayoutTemplate>
                                <div id="itemPlaceholderContainer" runat="server">
                                    <span runat="server" id="itemPlaceholder" />
                                </div>
                                <div>
                                    <asp:DataPager ID="DataPager1" runat="server">
                                        <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True" />
                                        </Fields>
                                    </asp:DataPager>
                                </div>
                            </LayoutTemplate>
                        </asp:ListView>

                        <asp:SqlDataSource ID="ProductsSold"
                            runat="server"
                            ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                            SelectCommand="SELECT Product.ProductName, Product.Description, Product.Picture, Product.Price, Product.Category, ProductSold.clothingSize, ProductSold.colour 
                                       FROM Product 
                                       INNER JOIN ProductSold ON Product.ProductID = ProductSold.ProductID 
                                       WHERE (ProductSold.receiptID = @recID)">
                            <SelectParameters>
                                <asp:Parameter Name="recID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .sale-product-card {
            text-align: center;
            color: var(--troika-text);
        }

        .sale-product-card img {
            border-radius: 8px;
            object-fit: cover;
        }
    </style>
</asp:Content>