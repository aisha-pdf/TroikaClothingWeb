<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs" Inherits="TroikaClothingWeb.Admin_Pages.ProductManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%-- Navigation Bar --%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Admin Pages/Admin">User Management</a></li>
                <li class="nav-item"><a class="nav-link text-white active" runat="server" href="~/Admin Pages/ProductManagement">Product Management</a></li>
            </ul>
        </div>
    </nav>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Layout Wrapper -->
    <div style="display: flex; min-height: 80vh;">

        <!-- Sidebar -->
        <div style="width: 220px; background-color: #3D304C; padding: 20px; color: white; display: flex; flex-direction: column; gap: 15px;">
            <asp:Button ID="btnProductList" runat="server" Text="Product List" CssClass="menu-btn" OnClick="btnProductList_Click" />
            <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" CssClass="menu-btn" OnClick="btnAddProduct_Click" />
            <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="menu-btn" OnClick="btnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div style="flex: 1; background: #f4f4f4; padding: 30px;">
            <h2 style="color: #3D304C; margin-bottom: 20px;">PRODUCT MANAGEMENT</h2>

            <!-- Product List (GridView) -->
            <asp:GridView ID="GridViewProducts" runat="server" 
                AutoGenerateColumns="False" 
                DataKeyNames="ProductID"
                DataSourceID="SqlDSProduct"
                CssClass="table table-striped table-bordered"
                GridLines="None" 
                ForeColor="#333333"
                AllowPaging="True"
                AllowSorting="True" HorizontalAlign="Justify" OnRowUpdating="GridViewProducts_RowUpdating">
                
                <Columns>



                    <asp:CommandField ShowEditButton="True" />
                    <asp:BoundField DataField="ProductID" HeaderText="ProductID" ReadOnly="True" SortExpression="ProductID" />
                    <asp:BoundField DataField="ProductName" HeaderText="ProductName" SortExpression="ProductName" />
                    <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                    <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category" />
                    <asp:BoundField DataField="ProductionTime" HeaderText="ProductionTime" SortExpression="ProductionTime" />
                    <asp:BoundField DataField="Price" HeaderText="Price" SortExpression="Price" />

                    <asp:TemplateField HeaderText="Picture">
             <ItemTemplate>
        <asp:Image ID="imgProduct" runat="server" Width="100" Height="100"
            ImageUrl='<%# Eval("Picture") != DBNull.Value && Eval("Picture") != null
                ? "data:image/jpeg;base64," + Convert.ToBase64String((byte[])Eval("Picture"))
                : ResolveUrl("~/Images/no-image.png") %>' />
    </ItemTemplate>
    <EditItemTemplate>
        <asp:FileUpload ID="FileUploadEditImage" runat="server" />
        <br />
        <asp:Image ID="imgEditPreview" runat="server" Width="80" Height="80"
            ImageUrl='<%# Eval("Picture") != DBNull.Value && Eval("Picture") != null
                ? "data:image/jpeg;base64," + Convert.ToBase64String((byte[])Eval("Picture"))
                : ResolveUrl("~/Images/no-image.png") %>' />
        <br />
        <small>(Select new image to replace)</small>
    </EditItemTemplate>
</asp:TemplateField>




                </Columns>

                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <AlternatingRowStyle BackColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            </asp:GridView>

  <!-- Add Product Panel -->
            <asp:Panel ID="PanelAddProduct" runat="server" Visible="False" Style="margin-top:20px; background:white; padding:20px; border-radius:10px;">
                <h4>Add Product</h4>
                <table class="table">
                    <tr>
                        <td>Product ID:</td>
                        <td>
                            <asp:TextBox ID="txtProductID" runat="server" CssClass="form-control" ReadOnly="true" OnTextChanged="txtField_TextChanged" />
                            <asp:Label ID="lblProductIDError" runat="server" CssClass="field-error" />
                        </td>
                    </tr>
                    <tr>
        <td>Product Name:</td>
        <td>
            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtField_TextChanged" />
            <asp:Label ID="lblNameError" runat="server" CssClass="field-error" />
        </td>
    </tr>
    <tr>
        <td>Description:</td>
        <td>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtField_TextChanged" />
            <asp:Label ID="lblDescriptionError" runat="server" CssClass="field-error" />
        </td>
    </tr>
    <tr>
        <td>Category:</td>
        <td>
            <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtField_TextChanged" />
            <asp:Label ID="lblCategoryError" runat="server" CssClass="field-error" />
        </td>
    </tr>
    <tr>
        <td>Production Time:</td>
        <td>
            <asp:TextBox ID="txtProductionTime" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtField_TextChanged" />
            <asp:Label ID="lblProductionTimeError" runat="server" CssClass="field-error" />
        </td>
    </tr>
    <tr>
        <td>Price:</td>
        <td>
            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtField_TextChanged" />
            <asp:Label ID="lblPriceError" runat="server" CssClass="field-error" />
        </td>
    </tr>
                    <tr><td>Image:</td>
                        <td>
                            <asp:FileUpload ID="FileUploadImage" runat="server" />
                        </td>
                    </tr>
                </table>
                <asp:Button ID="btnSaveProduct" runat="server" Text="Add Product" CssClass="action-btn" OnClick="btnSaveProduct_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="action-btn" OnClick="btnCancel_Click" />
                <asp:Label ID="lblStatus" runat="server" CssClass="status-label" ForeColor="Green" />

            </asp:Panel>

            <!-- SQL Data Source -->
            <asp:SqlDataSource ID="SqlDSProduct" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [Product] WHERE [ProductID] = @original_ProductID AND [ProductName] = @original_ProductName AND [Description] = @original_Description AND [Category] = @original_Category AND [ProductionTime] = @original_ProductionTime AND [Price] = @original_Price AND (([Picture] = @original_Picture) OR ([Picture] IS NULL AND @original_Picture IS NULL))" InsertCommand="INSERT INTO [Product] ([ProductID], [ProductName], [Description], [Category], [ProductionTime], [Price], [Picture]) VALUES (@ProductID, @ProductName, @Description, @Category, @ProductionTime, @Price, @Picture)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [Product]" UpdateCommand="UPDATE [Product] SET [ProductName] = @ProductName, [Description] = @Description, [Category] = @Category, [ProductionTime] = @ProductionTime, [Price] = @Price, [Picture] = @Picture WHERE [ProductID] = @original_ProductID AND [ProductName] = @original_ProductName AND [Description] = @original_Description AND [Category] = @original_Category AND [ProductionTime] = @original_ProductionTime AND [Price] = @original_Price AND (([Picture] = @original_Picture) OR ([Picture] IS NULL AND @original_Picture IS NULL))">
                <DeleteParameters>
                    <asp:Parameter Name="original_ProductID" Type="String" />
                    <asp:Parameter Name="original_ProductName" Type="String" />
                    <asp:Parameter Name="original_Description" Type="String" />
                    <asp:Parameter Name="original_Category" Type="String" />
                    <asp:Parameter Name="original_ProductionTime" Type="String" />
                    <asp:Parameter Name="original_Price" Type="Decimal" />
                    <asp:Parameter Name="original_Picture" Type="Object" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="ProductID" Type="String" />
                    <asp:Parameter Name="ProductName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Category" Type="String" />
                    <asp:Parameter Name="ProductionTime" Type="String" />
                    <asp:Parameter Name="Price" Type="Decimal" />
                    <asp:Parameter Name="Picture" Type="Object" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="ProductName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="Category" Type="String" />
                    <asp:Parameter Name="ProductionTime" Type="String" />
                    <asp:Parameter Name="Price" Type="Decimal" />
                    <asp:Parameter Name="Picture" Type="Object" />
                    <asp:Parameter Name="original_ProductID" Type="String" />
                    <asp:Parameter Name="original_ProductName" Type="String" />
                    <asp:Parameter Name="original_Description" Type="String" />
                    <asp:Parameter Name="original_Category" Type="String" />
                    <asp:Parameter Name="original_ProductionTime" Type="String" />
                    <asp:Parameter Name="original_Price" Type="Decimal" />
                    <asp:Parameter Name="original_Picture" Type="Object" />
                </UpdateParameters>
            </asp:SqlDataSource>
   
        </div>
    </div>


    <asp:SqlDataSource ID="SqlDslastID" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT TOP 1 ProductID
FROM Product
ORDER BY ProductID DESC;
"></asp:SqlDataSource>

    <!-- Button Styles -->
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
            margin-top: 10px;
            cursor: pointer;
        }
        .action-btn:hover { background: #8365A8; }
    </style>

    <style>
    .status-label {
        display: block;
        margin-top: 15px;
        font-weight: bold;
        font-size: 14px;
    } 
    </style>
    <style>
    .field-error {
        color: red;
        font-size: 12px;
        margin-left: 5px;
        display: block;
    }
</style>


</asp:Content>


