<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master" 
    AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs" 
    Inherits="TroikaClothingWeb.Admin_Pages.ProductManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%-- Navigation Bar --%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item">
                    <a class="nav-link text-white" runat="server" href="~/Admin Pages/Admin">User Management</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white active" runat="server" href="~/Admin Pages/ProductManagement">Product Management</a>
                </li>
            </ul>
        </div>
    </nav>

<style>
/* --- Root Layout --- */
body, html {
    font-family: "Segoe UI", Roboto, Arial, sans-serif;
    background-color: #f7f8fa;
    color: #333;
    margin: 0;
    padding: 0;
}

/* --- Sidebar --- */
.menu-btn {
    background: linear-gradient(135deg, #6c5a7a, #5b4c67);
    border: none;
    padding: 12px 14px;
    color: #fff;
    text-align: left;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    transition: background 0.2s ease, transform 0.1s ease;
}
.menu-btn:hover {
    background: linear-gradient(135deg, #5b4c67, #4a3c56);
    transform: translateY(-2px);
}

/* --- Section Titles --- */
.section-title {
    font-weight: 600;
    font-size: 1.4rem;
    margin-bottom: 18px;
    color: #3D304C;
}

/* --- Toolbar (filter + sort) --- */
.toolbar {
    display: flex;
    gap: 10px;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
    flex-wrap: wrap;
    margin: 0 auto 16px auto;
    background: #fff;
    padding: 10px 14px;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}
.toolbar span {
    font-weight: 500;
    color: #3D304C;
    margin-right: 4px;
}
.toolbar select,
.toolbar input[type=text] {
    padding: 6px 8px;
    border: 1px solid #ccc;
    border-radius: 6px;
    min-width: 180px;
}
.toolbar input[type=text]:focus,
.toolbar select:focus {
    border-color: #3D304C;
    outline: none;
    box-shadow: 0 0 0 2px rgba(61,48,76,0.2);
}

/* --- GridView Container --- */
.grid-wrapper {
    overflow-x: auto;
    background: #fff;
    padding: 10px;
    border-radius: 10px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.1);
}

/* --- GridView styling --- */
.grid {
    width: 100%;
    border-collapse: collapse;
    table-layout: fixed;
    border-radius: 8px;
    overflow: hidden;
}
.grid th {
    background-color: #3D304C;
    color: white;
    font-weight: 600;
    text-align: left;
    padding: 12px 10px;
    border-bottom: 2px solid #ddd;
    white-space: normal !important;   
    word-wrap: break-word;
    overflow-wrap: break-word;
    text-overflow: clip;
    line-height: 1.3;
}
.grid td {
    padding: 12px 10px;
    border-bottom: 1px solid #eee;
    border-right: 1px solid #eee;
    vertical-align: middle;
    word-wrap: break-word;
    overflow-wrap: break-word;
    text-overflow: ellipsis;
}
/* --- GridView action buttons (Edit + Change Status) --- */
/* --- GridView action buttons (vertical + centered) --- */
.grid .actions {
    display: flex;
    flex-direction: column;   /* stack vertically */
    justify-content: center;  /* center vertically in the cell */
    align-items: center;      /* center horizontally */
    gap: 20px;                 /* small space between buttons */
    height: 100%;             /* ensure full cell height for centering */
}

.grid .actions .btn:first-child {
    margin-bottom: 10px;
}


.grid td:last-child {
    vertical-align: middle;   /* align the cell content vertically */
    text-align: center;       /* ensure buttons are centered horizontally */
}

.grid td:last-child a,
.grid td:last-child button {
    display: inline-block;
}

.grid .actions .btn {
    min-width: 130px;
    text-align: center;
}



.grid tr:hover td {
    background-color: #f6f3fa;
}

/* --- Image column (7th col, adjust index if needed) --- */
.grid td:nth-child(7),
.grid th:nth-child(7) {
    width: 130px;
    text-align: center;
    vertical-align: middle;
    white-space: nowrap;
}

/* --- Product Image Styling --- */
.grid img {
    max-width: 110px;
    max-height: 110px;
    object-fit: cover;
    aspect-ratio: 1 / 1;
    border-radius: 8px;
    box-shadow: 0 0 4px rgba(0,0,0,0.15);
    display: block;
    margin: 0 auto;
}

/* --- Prevent stretching in edit mode --- */
.grid input[type="text"],
.grid input[type="number"],
.grid select,
.grid textarea {
    width: 95% !important;
    box-sizing: border-box;
    font-size: 0.95rem;
    padding: 6px 8px;
}
.grid input[type="file"] {
    width: 95% !important;
    font-size: 0.85rem;
}

/* --- Form for Add/Edit --- */
.form-card {
    background: #fff;
    padding: 24px;
    border-radius: 12px;
    border: 1px solid #ddd;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    max-width: 700px;
}
.form-grid {
    display: grid;
    grid-template-columns: 160px 1fr;
    gap: 10px 16px;
}
.form-grid label {
    align-self: center;
    font-weight: 500;
    color: #3D304C;
}
.field-input {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 6px;
    width: 100%;
    background-color: #fafafa;
    transition: border-color 0.2s ease;
}
.field-input:focus {
    border-color: #3D304C;
    background-color: #fff;
    outline: none;
    box-shadow: 0 0 0 2px rgba(61,48,76,0.2);
}
.input-invalid {
    border-color: #d93025 !important;
    background-color: #fff5f5;
}
.error-label {
    color: #d93025;
    font-size: 0.86rem;
    margin-top: -4px;
    margin-bottom: 6px;
}
.success {
    color: #1a7f37;
    font-weight: 500;
    margin-top: 10px;
}

/* --- Action Buttons --- */
.actions {
    display: flex;
    gap: 8px;
    margin-top: 14px;
}
.btn {
    padding: 8px 14px;
    border: 0;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    font-size: 0.95rem;
    transition: background 0.2s ease, transform 0.1s ease;
}
.btn-primary {
    background: #3D304C;
    color: #fff;
}
.btn-primary:hover {
    background: #2f243a;
    transform: translateY(-2px);
}
.btn-light {
    background: #f3f3f3;
    color: #333;
}
.btn-light:hover {
    background: #e8e8e8;
}
.btn-danger {
    background: #c0392b;
    color: #fff;
}
.btn-danger:hover {
    background: #a93226;
}

/* --- Sidebar container --- */
.sidebar {
    width: 220px;
    background-color: #3D304C;
    padding: 20px;
    color: white;
    display: flex;
    flex-direction: column;
    gap: 15px;
    border-top-right-radius: 12px;
    border-bottom-right-radius: 12px;
    box-shadow: 2px 0 8px rgba(0,0,0,0.15);
}

/* --- Layout Container --- */
.main-container {
    display: flex;
    min-height: 80vh;
    gap: 0;
}
.content-wrapper {
    flex: 1;
    padding: 24px;
}

/* --- Responsive improvements --- */
@media (max-width: 992px) {
    .form-grid {
        grid-template-columns: 1fr;
    }
    .toolbar {
        flex-direction: column;
        align-items: flex-start;
    }
    .sidebar {
        width: 100%;
        border-radius: 0;
        flex-direction: row;
        justify-content: space-around;
    }
    .main-container {
        flex-direction: column;
    }
    .grid td, .grid th {
        max-width: none;
    }
}

.success {
    color: #1a7f37;
    font-weight: 600;
    margin-top: 10px;
    display: block;
}

#imgEditCurrent {
    transition: opacity 0.3s ease-in-out;
}
#imgEditCurrent.loading {
    opacity: 0.5;
}
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Sidebar and Content Wrapper -->
    <div style="display: flex; min-height: 80vh;">

        <!-- Sidebar -->
        <div style="width: 220px; background-color: #3D304C; padding: 20px; color: white; display: flex; flex-direction: column; gap: 15px;">
            <asp:Button ID="btnViewProducts" runat="server" Text="View Products" CssClass="menu-btn" OnClick="btnViewProducts_Click" />
            <asp:Button ID="btnShowAdd" runat="server" Text="Add New Product" CssClass="menu-btn" OnClick="btnShowAdd_Click" />
        </div>

        <!-- Main content -->
        <div style="flex: 1; padding: 20px;">

            <!-- LIST PANEL -->
            <div class="grid-wrapper">
            <asp:Panel ID="PanelList" runat="server" Visible="true">
                <div class="section-title">Products</div>

                <div class="toolbar">
                    <span>Status:</span>
                    <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                        <asp:ListItem Text="Active" Value="Active" Selected="True" />
                        <asp:ListItem Text="Inactive" Value="Inactive" />
                        <asp:ListItem Text="All" Value="All" />
                    </asp:DropDownList>

                    <span>Sort by:</span>
                    <asp:DropDownList ID="ddlSort" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                        <asp:ListItem Text="Product Name (A → Z)" Value="ProductName ASC" />
                        <asp:ListItem Text="Product Name (Z → A)" Value="ProductName DESC" />
                        <asp:ListItem Text="Price (Low → High)" Value="Price ASC" Selected="True" />
                        <asp:ListItem Text="Price (High → Low)" Value="Price DESC" />
                        <asp:ListItem Text="Newest (ID DESC)" Value="ProductID DESC" />
                        <asp:ListItem Text="Oldest (ID ASC)" Value="ProductID ASC" />
                    </asp:DropDownList>

                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search name/description..." />
                    <asp:Button ID="btnApply" runat="server" Text="Apply" CssClass="btn btn-primary" OnClick="btnApply_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-light" OnClick="btnClear_Click" />
                </div>

                <asp:GridView ID="GridViewProducts" runat="server" CssClass="grid" AutoGenerateColumns="False"
                    DataKeyNames="ProductID" DataSourceID="SqlDSProducts"
                    AllowPaging="true" PageSize="10"
                    OnRowCommand="GridViewProducts_RowCommand"
                    OnRowDataBound="GridViewProducts_RowDataBound">
                    <Columns>
                    <asp:BoundField DataField="ProductID" HeaderText="ID" ReadOnly="true" />

                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <%# Eval("ProductName") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtProductNameEdit" runat="server" 
                                Text='<%# Bind("ProductName") %>' CssClass="field-input" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Description">
                        <ItemTemplate>
                            <%# Eval("Description") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDescriptionEdit" runat="server" 
                                Text='<%# Bind("Description") %>' CssClass="field-input" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Category">
                        <ItemTemplate>
                            <%# Eval("Category") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtCategoryEdit" runat="server" 
                                Text='<%# Bind("Category") %>' CssClass="field-input" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Production Time (in days)">
                        <ItemTemplate>
                            <%# Eval("ProductionTime") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtProductionTimeEdit" runat="server" 
                                Text='<%# Bind("ProductionTime") %>' CssClass="field-input" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Price">
                        <ItemTemplate>
                            <%# "R" + Eval("Price", "{0:N2}") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtPriceEdit" runat="server" 
                                Text='<%# Bind("Price") %>' CssClass="field-input" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Picture">
                        <ItemTemplate>
                            <asp:Image ID="imgProduct" runat="server"
                                ImageUrl='<%# ResolveUrl("~/Admin Pages/ProductImageHandler.ashx?id=" + Eval("ProductID") + "&v=" + DateTime.Now.Ticks) %>'
                                Width="100" Height="100" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:FileUpload ID="fuEdit" runat="server" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# Eval("Status") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlStatusEdit" runat="server" SelectedValue='<%# Bind("Status") %>'>
                                <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>


                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CssClass="btn btn-primary"
                                CommandName="EditProduct"
                                CommandArgument='<%# Eval("ProductID") %>'
                                Text="Edit"
                                />
                            <asp:LinkButton ID="lnkToggle" runat="server" CssClass="btn btn-light"
                                CommandName="ToggleStatus"
                                CommandArgument='<%# Eval("ProductID") %>'
                                Text="Change Status" />
                        </ItemTemplate>
                    </asp:TemplateField>


                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDSProducts" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    SelectCommand="SELECT * FROM Product WHERE Status = @Status"
                    OnSelecting="SqlDSProducts_Selecting">
                    <SelectParameters>
                        <asp:Parameter Name="Status" DefaultValue="Active" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>


                <asp:SqlDataSource ID="SqlDSUpdateProduct" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    UpdateCommand="UPDATE Product
                                   SET ProductName=@ProductName,
                                       [Description]=@Description,
                                       Category=@Category,
                                       ProductionTime=@ProductionTime,
                                       Price=@Price,
                                       Status=@Status
                                   WHERE ProductID=@ProductID">
                </asp:SqlDataSource>


                <asp:SqlDataSource ID="SqlDSUpdateImage" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    UpdateCommand="UPDATE Product SET Picture=@Picture WHERE ProductID=@ProductID">
                </asp:SqlDataSource>




                <asp:SqlDataSource ID="SqlDSToggle" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    UpdateCommand="UPDATE Product SET Status = CASE WHEN Status='Active' THEN 'Inactive' ELSE 'Active' END WHERE ProductID=@ProductID">
                    <UpdateParameters>
                        <asp:Parameter Name="ProductID" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </asp:Panel>
            </div>


            <!-- EDIT PANEL -->
                <asp:Panel ID="PanelEdit" runat="server" Visible="false">
                    <div class="section-title">Edit Product</div>

                    <asp:HiddenField ID="hfEditProductID" runat="server" />

                    <div class="form-grid">

                        <label>Product ID</label>
                        <div>
                            <asp:TextBox ID="txtEditProductID" runat="server" CssClass="field-input" ReadOnly="true" />
                        </div>

                        <label>Product Name</label>
                        <div>
                            <asp:TextBox ID="txtEditName" runat="server" CssClass="field-input" />
                            <asp:Label ID="lblEditNameError" runat="server" CssClass="error-label" />
                        </div>

                        <label>Description</label>
                        <div>
                            <asp:TextBox ID="txtEditDesc" runat="server" TextMode="MultiLine" Rows="3" CssClass="field-input" />
                            <asp:Label ID="lblEditDescError" runat="server" CssClass="error-label" />
                        </div>

                        <label>Category</label>
                        <div>
                            <asp:TextBox ID="txtEditCategory" runat="server" CssClass="field-input" />
                            <asp:Label ID="lblEditCategoryError" runat="server" CssClass="error-label" />
                        </div>

                        <label>Production Time</label>
                        <div>
                            <asp:TextBox ID="txtEditProductionTime" runat="server" CssClass="field-input" />
                             <asp:Label ID="lblEditProductionTimeError" runat="server" CssClass="error-label" />
                        </div>

                        <label>Price</label>
                        <div>
                            <asp:TextBox ID="txtEditPrice" runat="server" CssClass="field-input" />
                            <asp:Label ID="lblEditPriceError" runat="server" CssClass="error-label" />
                        </div>

                        <label>Current Picture</label>
                        <div>
                            <asp:Image ID="imgEditCurrent" runat="server" Width="110" Height="110" ClientIDMode="Static" />
                        </div>

                        <label>Upload New Picture</label>
                        <div>
                            <asp:FileUpload ID="fuEditPicture" runat="server" ClientIDMode="Static" />
                        </div>

                        <label>Status</label>
                        <div>
                            <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="field-input">
                                <asp:ListItem Text="Active" Value="Active" />
                                <asp:ListItem Text="Inactive" Value="Inactive" />
                            </asp:DropDownList>
                        </div>

                        <div></div>
                        <div class="actions">
                            <asp:Button ID="btnUpdateProduct" runat="server" Text="Save Changes" CssClass="btn btn-primary" OnClick="btnUpdateProduct_Click" />
                            <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-light" OnClick="btnCancelEdit_Click" CausesValidation="false" />
                        </div>

                        <div></div>
                        <asp:Label ID="lblEditResult" runat="server" CssClass="success" />
                    </div>
                </asp:Panel>


            <!-- ADD PANEL -->
            <asp:Panel ID="PanelAdd" runat="server" Visible="false">
                <div class="section-title">Add Product</div>

                <asp:SqlDataSource ID="SqlDslastID" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    SelectCommand="SELECT TOP 1 ProductID FROM Product ORDER BY ProductID DESC">
                </asp:SqlDataSource>

                <asp:SqlDataSource ID="SqlDSInsert" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    InsertCommand="
                        INSERT INTO Product(ProductID, ProductName, [Description], Category, ProductionTime, Price, Picture, Status)
                        VALUES(@ProductID, @ProductName, @Description, @Category, @ProductionTime, @Price, @Picture, @Status)">
                    <InsertParameters>
                        <asp:Parameter Name="ProductID" Type="String" />
                        <asp:Parameter Name="ProductName" Type="String" />
                        <asp:Parameter Name="Description" Type="String" />
                        <asp:Parameter Name="Category" Type="String" />
                        <asp:Parameter Name="ProductionTime" Type="String" />
                        <asp:Parameter Name="Price" Type="Decimal" />
                        <asp:Parameter Name="Picture" Type="Object" />
                        <asp:Parameter Name="Status" Type="String" />
                    </InsertParameters>
                </asp:SqlDataSource>

                <div class="form-grid">
                    <label for="txtProductID">Product ID</label>
                    <div>
                        <asp:TextBox ID="txtProductID" runat="server" CssClass="field-input" ReadOnly="true" />
                        <asp:Label ID="lblProductIDError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="txtName">Product Name</label>
                    <div>
                        <asp:TextBox ID="txtName" runat="server" CssClass="field-input" />
                        <asp:Label ID="lblNameError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="txtDesc">Description</label>
                    <div>
                        <asp:TextBox ID="txtDesc" runat="server" TextMode="MultiLine" Rows="3" CssClass="field-input" />
                        <asp:Label ID="lblDescError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="txtCategory">Category</label>
                    <div>
                        <asp:TextBox ID="txtCategory" runat="server" CssClass="field-input" />
                        <asp:Label ID="lblCategoryError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="txtProductionTime">Production Time</label>
                    <div>
                        <asp:TextBox ID="txtProductionTime" runat="server" CssClass="field-input" />
                        <asp:Label ID="lblProductionTimeError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="txtPrice">Price</label>
                    <div>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="field-input" />
                        <asp:Label ID="lblPriceError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="fuPicture">Picture</label>
                    <div>
                        <asp:FileUpload ID="fuPicture" runat="server" />
                        <asp:Label ID="lblPictureError" runat="server" CssClass="error-label" />
                    </div>

                    <label for="ddlStatusAdd">Status</label>
                    <div>
                        <asp:DropDownList ID="ddlStatusAdd" runat="server" CssClass="field-input">
                            <asp:ListItem Text="Active" Value="Active" Selected="True" />
                            <asp:ListItem Text="Inactive" Value="Inactive" />
                        </asp:DropDownList>
                        <asp:Label ID="lblStatusError" runat="server" CssClass="error-label" />
                    </div>

                    <div></div>
                    <div class="actions">
                        <asp:Button ID="btnSaveProduct" runat="server" Text="Save Product" CssClass="btn btn-primary" OnClick="btnSaveProduct_Click" />
                        <asp:Button ID="btnCancelAdd" runat="server"
                            Text="Cancel"
                            CssClass="btn btn-light"
                            OnClick="btnCancelAdd_Click"
                            CausesValidation="false"
                            OnClientClick="return confirm('Any unsaved data will be lost. Do you want to continue?');"     />
                    </div>
                    <div></div>
                    <asp:Label ID="lblAddResult" runat="server" CssClass="success" />

                </div>
            </asp:Panel>


        </div>
    </div>

    <script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function () {
        const uploadInput = document.getElementById("fuEditPicture");
        const previewImg = document.getElementById("imgEditCurrent");

        if (uploadInput && previewImg) {
            uploadInput.addEventListener("change", function () {
                if (uploadInput.files && uploadInput.files[0]) {
                    const reader = new FileReader();

                    reader.onloadstart = function () {
                        previewImg.classList.add("loading");
                    };

                    reader.onload = function (e) {
                        previewImg.src = e.target.result;
                        previewImg.classList.remove("loading");
                    };
                    reader.readAsDataURL(uploadInput.files[0]);

                }
            });
        }
    });
    </script>


</asp:Content>