<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs"
    Inherits="TroikaClothingWeb.Admin_Pages.ProductManagement" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .product-management-container {
            background: var(--troika-bg);
            color: var(--troika-text);
            min-height: 80vh;
        }

        .menu-btn {
            background: var(--troika-btn-bg) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            padding: 12px 14px;
            color: var(--troika-btn-text) !important;
            text-align: left;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.2s ease, transform 0.1s ease;
        }

        .menu-btn:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            transform: translateY(-2px);
        }

        .section-title {
            font-weight: 600;
            font-size: 1.4rem;
            margin-bottom: 18px;
            color: var(--troika-heading-text) !important;
        }

        .toolbar {
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px auto;
            flex-wrap: wrap;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 10px 14px;
            border: 1px solid var(--troika-border);
            border-radius: 8px;
            box-shadow: var(--troika-card-shadow);
        }

        .toolbar span {
            font-weight: 500;
            color: var(--troika-text) !important;
            margin-right: 4px;
        }

        .toolbar select,
        .toolbar input[type=text] {
            padding: 6px 8px;
            border: 1px solid var(--troika-border);
            border-radius: 6px;
            min-width: 180px;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
        }

        .toolbar input[type=text]:focus,
        .toolbar select:focus {
            border-color: var(--troika-primary);
            outline: none;
            box-shadow: 0 0 0 2px rgba(217,200,240,0.25);
        }

        .grid-wrapper {
            overflow-x: auto;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 10px;
            border-radius: 10px;
            border: 1px solid var(--troika-border);
            box-shadow: var(--troika-card-shadow);
        }

        .grid {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            border-radius: 8px;
            overflow: hidden;
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
        }

        .grid th {
            background-color: var(--troika-table-header-bg) !important;
            color: var(--troika-table-header-text) !important;
            font-weight: 600;
            text-align: left;
            padding: 12px 10px;
            border-bottom: 2px solid var(--troika-border);
            white-space: normal !important;
            word-wrap: break-word;
            overflow-wrap: break-word;
            text-overflow: clip;
            line-height: 1.3;
        }

        .grid td {
            background-color: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
            padding: 12px 10px;
            border-bottom: 1px solid var(--troika-border);
            border-right: 1px solid var(--troika-border);
            vertical-align: middle;
            word-wrap: break-word;
            overflow-wrap: break-word;
            text-overflow: ellipsis;
        }

        .grid tr:hover td {
            background-color: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
        }

        .grid a {
            color: var(--troika-btn-text) !important;
        }

        .grid .actions {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 20px;
            height: 100%;
        }

        .grid .actions .btn:first-child {
            margin-bottom: 10px;
        }

        .grid td:last-child {
            vertical-align: middle;
            text-align: center;
        }

        .grid td:last-child a,
        .grid td:last-child button {
            display: inline-block;
        }

        .grid .actions .btn {
            min-width: 130px;
            text-align: center;
        }

        .grid td:nth-child(7),
        .grid th:nth-child(7) {
            width: 130px;
            text-align: center;
            vertical-align: middle;
            white-space: nowrap;
        }

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

        .grid input[type="text"],
        .grid input[type="number"],
        .grid select,
        .grid textarea {
            width: 95% !important;
            box-sizing: border-box;
            font-size: 0.95rem;
            padding: 6px 8px;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            border: 1px solid var(--troika-border) !important;
        }

        .grid input[type="file"] {
            width: 95% !important;
            font-size: 0.85rem;
            color: var(--troika-text) !important;
        }

        .form-card {
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid var(--troika-border);
            box-shadow: var(--troika-card-shadow);
            max-width: 700px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 160px 1fr;
            gap: 10px 16px;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid var(--troika-border);
            box-shadow: var(--troika-card-shadow);
            max-width: 800px;
        }

        .form-grid label {
            align-self: center;
            font-weight: 500;
            color: var(--troika-text) !important;
        }

        .field-input {
            padding: 10px;
            border: 1px solid var(--troika-border) !important;
            border-radius: 6px;
            width: 100%;
            background-color: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            transition: border-color 0.2s ease;
        }

        .field-input:focus {
            border-color: var(--troika-primary) !important;
            background-color: var(--troika-input-bg) !important;
            outline: none;
            box-shadow: 0 0 0 2px rgba(217,200,240,0.25);
        }

        .input-invalid {
            border-color: var(--troika-danger) !important;
        }

        .error-label {
            color: var(--troika-danger) !important;
            font-size: 0.86rem;
            margin-top: -4px;
            margin-bottom: 6px;
        }

        .success {
            color: var(--troika-success) !important;
            font-weight: 600;
            margin-top: 10px;
            display: block;
        }

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
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        .btn-primary:hover {
            background: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
            transform: translateY(-2px);
        }

        .btn-light {
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border) !important;
        }

        .btn-light:hover {
            background: var(--troika-secondary) !important;
            color: var(--troika-primary) !important;
        }

        .btn-danger {
            background: var(--troika-danger) !important;
            color: var(--troika-bg) !important;
        }

        .sidebar {
            width: 220px;
            background-color: var(--troika-primary) !important;
            padding: 20px;
            color: var(--troika-bg) !important;
            display: flex;
            flex-direction: column;
            gap: 15px;
            border-top-right-radius: 12px;
            border-bottom-right-radius: 12px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.15);
        }

        body[data-theme="dark"] .sidebar {
            color: #121018 !important;
        }

        .main-container {
            display: flex;
            min-height: 80vh;
            gap: 0;
            background: var(--troika-bg) !important;
        }

        .content-wrapper {
            flex: 1;
            padding: 24px;
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
        }

        #imgEditCurrent {
            transition: opacity 0.3s ease-in-out;
        }

        #imgEditCurrent.loading {
            opacity: 0.5;
        }

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

            .grid td,
            .grid th {
                max-width: none;
            }
        }
    </style>

    <div class="product-management-container main-container">

        <div class="sidebar">
            <asp:Button ID="btnViewProducts" runat="server" Text="View Products" CssClass="menu-btn" OnClick="btnViewProducts_Click" />
            <asp:Button ID="btnShowAdd" runat="server" Text="Add New Product" CssClass="menu-btn" OnClick="btnShowAdd_Click" />
        </div>

        <div class="content-wrapper">

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

                    <asp:GridView ID="GridViewProducts" runat="server" CssClass="grid gridview troika-table" AutoGenerateColumns="False"
                        DataKeyNames="ProductID" DataSourceID="SqlDSProducts"
                        AllowPaging="true" PageSize="10"
                        OnRowCommand="GridViewProducts_RowCommand"
                        OnRowDataBound="GridViewProducts_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="ProductID" HeaderText="ID" ReadOnly="true" />

                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate><%# Eval("ProductName") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtProductNameEdit" runat="server" Text='<%# Bind("ProductName") %>' CssClass="field-input" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Description">
                                <ItemTemplate><%# Eval("Description") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtDescriptionEdit" runat="server" Text='<%# Bind("Description") %>' CssClass="field-input" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Category">
                                <ItemTemplate><%# Eval("Category") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtCategoryEdit" runat="server" Text='<%# Bind("Category") %>' CssClass="field-input" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Production Time (in days)">
                                <ItemTemplate><%# Eval("ProductionTime") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtProductionTimeEdit" runat="server" Text='<%# Bind("ProductionTime") %>' CssClass="field-input" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Price">
                                <ItemTemplate><%# "R" + Eval("Price", "{0:N2}") %></ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtPriceEdit" runat="server" Text='<%# Bind("Price") %>' CssClass="field-input" />
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
                                <ItemTemplate><%# Eval("Status") %></ItemTemplate>
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
                                        Text="Edit" />
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
                                   WHERE ProductID=@ProductID"></asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDSUpdateImage" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                        UpdateCommand="UPDATE Product SET Picture=@Picture WHERE ProductID=@ProductID"></asp:SqlDataSource>

                    <asp:SqlDataSource ID="SqlDSToggle" runat="server"
                        ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                        UpdateCommand="UPDATE Product SET Status = CASE WHEN Status='Active' THEN 'Inactive' ELSE 'Active' END WHERE ProductID=@ProductID">
                        <UpdateParameters>
                            <asp:Parameter Name="ProductID" Type="String" />
                        </UpdateParameters>
                    </asp:SqlDataSource>
                </asp:Panel>
            </div>

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

            <asp:Panel ID="PanelAdd" runat="server" Visible="false">
                <div class="section-title">Add Product</div>

                <asp:SqlDataSource ID="SqlDslastID" runat="server"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    SelectCommand="SELECT TOP 1 ProductID FROM Product ORDER BY ProductID DESC"></asp:SqlDataSource>

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
                            OnClientClick="return confirm('Any unsaved data will be lost. Do you want to continue?');" />
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