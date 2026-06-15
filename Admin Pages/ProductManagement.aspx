<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs"
    Inherits="TroikaClothingWeb.Admin_Pages.ProductManagement" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%= ResolveUrl("~/Content/ProductManagement.css") %>" rel="stylesheet" />

<div class="product-management-container main-container">

        <div class="sidebar">
            <asp:Button ID="btnViewProducts" runat="server" Text="View Products" CssClass="menu-btn" OnClick="btnViewProducts_Click" />
            <asp:Button ID="btnShowAdd" runat="server" Text="Add New Product" CssClass="menu-btn" OnClick="btnShowAdd_Click" />
        </div>

        <div class="content-wrapper">

            <asp:Panel ID="PanelList" runat="server" Visible="true" CssClass="grid-wrapper">
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
                    DataKeyNames="ProductID" AllowPaging="true" PageSize="10"
                    OnRowCommand="GridViewProducts_RowCommand"
                    OnPageIndexChanging="GridViewProducts_PageIndexChanging">

                    <PagerSettings Mode="NumericFirstLast"
                        FirstPageText="« First"
                        LastPageText="Last »"
                        PageButtonCount="7" />

                    <PagerStyle CssClass="product-grid-pager" />


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
                                    ImageUrl='<%# ResolveUrl("~/Admin Pages/ProductImageHandler.ashx?id=" + Eval("ProductID") + "&v=" + Eval("ImageVersion")) %>'
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




            </asp:Panel>


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



                <div class="form-grid">
                    <label for="txtProductID">Product ID</label>
                    <div>
                        <asp:TextBox ID="txtProductID" runat="server"
                            CssClass="field-input readonly-product-id"
                            ReadOnly="true"
                            TabIndex="-1"
                            ToolTip="Product ID is generated automatically" />

                        

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
        window.troikaProductManagementConfig = {
            uploadInputId: "<%= fuEditPicture.ClientID %>",
            previewImageId: "<%= imgEditCurrent.ClientID %>",
            productIdInputId: "<%= txtProductID.ClientID %>"
        };
    </script>
    <script src="<%= ResolveUrl("~/Scripts/product-management.js") %>"></script>
</asp:Content>
