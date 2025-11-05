<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerProfile.aspx.cs" Inherits="TroikaClothingWeb.Customer_Pages.CustomerProfile" %>


<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div style="flex:1;padding:30px">
        <h2 style="color: #3D304C; margin-bottom: 20px;">CUSTOMER PROFILE</h2>
    </div>
    <div style="float:left; text-align:center; width:50%">
        <h3>Login Details</h3>
        <asp:DetailsView ID="dvWebProfile" runat="server" Height="84px" Width="538px" AutoGenerateRows="False" DataSourceID="WebProfileDS" AutoGenerateEditButton="True" CellPadding="4" ForeColor="#333333" GridLines="None" OnPageIndexChanging="dvWebProfile_PageIndexChanging">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <CommandRowStyle BackColor="#E2DED6" Font-Bold="True" />
            <EditRowStyle BackColor="#999999" />
            <FieldHeaderStyle BackColor="#E9ECF1" Font-Bold="True" />
            <Fields>
                <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
                <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password" />
            </Fields>
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        </asp:DetailsView>
        <asp:SqlDataSource ID="WebProfileDS" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT Username, Password FROM WebsiteLogin WHERE (Username = @username)">
            <SelectParameters>
                <asp:Parameter Name="username" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
    <br />
    <div style="float:left;text-align:center;width:50%">
        <h3>Customer Information</h3>
        <asp:DetailsView ID="dvCustomerProfile" runat="server" Height="50px" Width="571px" AutoGenerateRows="False" DataKeyNames="customerID" DataSourceID="ProfileDS" AutoGenerateEditButton="True" CellPadding="4" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <CommandRowStyle BackColor="#E2DED6" Font-Bold="True" />
            <EditRowStyle BackColor="#999999" />
            <FieldHeaderStyle BackColor="#E9ECF1" Font-Bold="True" />
            <Fields>
                <asp:BoundField DataField="name" HeaderText="Name" SortExpression="name" />
                <asp:BoundField DataField="surname" HeaderText="Surname" SortExpression="surname" />
                <asp:BoundField DataField="customerID" HeaderText="CustomerID" ReadOnly="True" SortExpression="customerID" />
                <asp:BoundField DataField="email" HeaderText="Email Address" SortExpression="email" />
                <asp:BoundField DataField="status" HeaderText="Status" SortExpression="status" />
                <asp:BoundField DataField="phoneNum" HeaderText="Phone Number" SortExpression="phoneNum" />
            </Fields>
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
        </asp:DetailsView>
        <asp:SqlDataSource ID="ProfileDS" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT RetailCustomer.name, RetailCustomer.surname, Customer.customerID, Customer.email, Customer.status, Customer.phoneNum FROM Customer INNER JOIN RetailCustomer ON Customer.customerID = RetailCustomer.customerID WHERE (Customer.customerID = @custID)">
            <SelectParameters>
                <asp:Parameter Name="custID" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
