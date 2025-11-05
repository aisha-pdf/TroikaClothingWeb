<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SaleHistory.aspx.cs" Inherits="TroikaClothingWeb.Sale_Pages.SaleHistory" %>

<asp:Content ID="Content0" ContentPlaceHolderID="WhiteNavbar" runat="server">
    <nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-troika">
        <div class="container">
            <%--navy blue navigation bar for admin--%>
            <span class="navbar-toggler-icon"></span>
            <%--profile
                cart--%>
            <a class="navbar-brand" runat="server" href="~/">
                <img src="/Images/logo.png" alt="Troika Clothing CC" height="60" class="d-inline-block align-text-top">
            </a>
            <div class="collapse navbar-collapse d-sm-inline-flex justify-content-between">
                <ul class="navbar-nav flex-grow-1">
                    <li class="nav-item"><a class="nav-link" runat="server" href="~/Customer Pages/HomePage">Home</a></li>
                    <li class="nav-item"><a class="nav-link" runat="server" href="~/Public Pages/About">About Us</a></li>
                    <li class="nav-item"><a class="nav-link" runat="server" href="/~Public Pages/Contact">Contact</a></li>
                    <%-- <li class="nav-item"><a class="nav-link" runat="server" href="~/Help">FAQs/Help</a></li>--%>
                </ul>
            </div>
        </div>
    </nav>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%--navy blue navigation bar for admin--%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Public Pages/Products">Products</a> </li>
                <%--profile
                cart--%>
            </ul>
        </div>
    </nav>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div style="flex: 1; padding: 30px">
        <h2 style="color: #3D304C; margin-bottom: 20px;">SALE HISTORY</h2>
    </div>
    <div style="float:left; text-align:center; width: 60%">
        <asp:GridView ID="gvSale"
            runat="server"
            HorizontalAlign="Center"
            AutoGenerateColumns="False"
            AutoGenerateSelectButton="True"
            CellPadding="4"
            DataKeyNames="receiptNum"
            DataSourceID="SaleOrderDS"
            ForeColor="#333333"
            GridLines="None"
            OnSelectedIndexChanged="gvSale_SelectedIndexChanged">

            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:BoundField DataField="receiptNum" HeaderText="Receipt No." ReadOnly="True" SortExpression="receiptNum" />
                <asp:BoundField DataField="paymentTotal" HeaderText="Total" SortExpression="paymentTotal" />
                <asp:BoundField DataField="paymentMethod" HeaderText="Payment Method" SortExpression="paymentMethod" />
                <asp:BoundField DataField="paymentDate" HeaderText="Date" SortExpression="paymentDate" />
                <asp:BoundField DataField="salesStatus" HeaderText="Status" SortExpression="salesStatus" />
            </Columns>

            <EditRowStyle BackColor="#2461BF" />
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#EFF3FB" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#F5F7FB" />
            <SortedAscendingHeaderStyle BackColor="#6D95E1" />
            <SortedDescendingCellStyle BackColor="#E9EBEF" />
            <SortedDescendingHeaderStyle BackColor="#4870BE" />
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
    <br />
    <div style="float:left;text-align: center; width: 40%">
        <asp:ListView ID="lvProductsSold" runat="server" DataSourceID="ProductsSold">
            <ItemTemplate>
                <div style="text-align: center;">
                    <asp:Image ID="imgProduct" runat="server"
                        Width="150px" Height="150px"
                        ImageUrl='<%# GetImageUrl(Eval("Picture"), Eval("ProductName")) %>' />
                </div>

                <div style="margin-top: 10px;">
                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("ProductName") %>' Font-Bold="true" /><br />
                    <asp:Label ID="lblPrice" runat="server" Text='<%# "Price: " + Eval("Price", "{0:C}") %>' /><br />
                    <asp:Label ID="lblDescription" runat="server" Text='<%# Eval("Description") %>' />
                </div>
            </ItemTemplate>

            <EmptyDataTemplate>
                <span>No products found for this sale.</span>
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

</asp:Content>
