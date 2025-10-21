<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="TroikaClothingWeb.Adminaspx" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%--navy blue navigation bar for admin--%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Admin Pages/Admin">User Management</a></li>
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Admin Pages/ProductManagement">Product Management</a> </li>
            </ul>
        </div>
    </nav>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Sidebar + Content Wrapper -->
    <div style="display: flex; min-height: 80vh;">

        <!-- Sidebar -->
        <div style="width: 220px; background-color: #3D304C; padding: 20px; color: white; display: flex; flex-direction: column; gap: 15px;">
            <asp:Button ID="btnUserList" runat="server" Text="User List" CssClass="menu-btn" OnClick="btnUserList_Click" />
            <asp:Button ID="btnProfile" runat="server" Text="Profile" CssClass="menu-btn" OnClick="btnProfile_Click" />
            <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="menu-btn" OnClick="btnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div style="flex: 1; background: #f4f4f4; padding: 30px;">
            <h2 style="color: #3D304C; margin-bottom: 20px;">USER MANAGEMENT - USER LIST</h2>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="ID" DataSourceID="UserListDs" ForeColor="#333333" GridLines="None" Height="399px" Width="979px">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <Columns>
                    <asp:CommandField ShowEditButton="True" ShowSelectButton="True" />
                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Surname" HeaderText="Surname" SortExpression="Surname" />
                    <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                </Columns>
                <EditRowStyle BackColor="#999999" />
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <SortedAscendingCellStyle BackColor="#E9E7E2" />
                <SortedAscendingHeaderStyle BackColor="#506C8C" />
                <SortedDescendingCellStyle BackColor="#FFFDF8" />
                <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
            </asp:GridView>
            <asp:SqlDataSource ID="UserListDs" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email" InsertCommand="INSERT INTO [WebsiteRegister] ([Name], [Surname], [Email]) VALUES (@Name, @Surname, @Email)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT [ID], [Name], [Surname], [Email] FROM [WebsiteRegister]" UpdateCommand="UPDATE [WebsiteRegister] SET [Name] = @Name, [Surname] = @Surname, [Email] = @Email WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email">
                <DeleteParameters>
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                    <asp:Parameter Name="original_Surname" Type="String" />
                    <asp:Parameter Name="original_Email" Type="String" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Surname" Type="String" />
                    <asp:Parameter Name="Email" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Surname" Type="String" />
                    <asp:Parameter Name="Email" Type="String" />
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                    <asp:Parameter Name="original_Surname" Type="String" />
                    <asp:Parameter Name="original_Email" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>


        </div>
    </div>

    <!-- Styles for Buttons -->
    <style>
        .menu-btn {
            background: #6C4F85;
            color: white;
            border: none;
            padding: 10px;
            text-align: left;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 14px;
        }

            .menu-btn:hover {
                background: #7D5C99;
            }

        .action-btn {
            background: #6C4F85;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            margin-left: 5px;
            cursor: pointer;
        }

            .action-btn:hover {
                background: #8365A8;
            }
    </style>

</asp:Content>
