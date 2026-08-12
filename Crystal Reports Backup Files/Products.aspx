<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="TroikaClothingWeb.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%= ResolveUrl("~/Content/wishlist.css") %>" rel="stylesheet" />

    <span id="troikaWishCfg" style="display: none;"
        data-toggle-url='<%= ResolveUrl("~/Public Pages/WishlistHandler.ashx") %>'
        data-login-url='<%= ResolveUrl("~/Login.aspx") %>'></span>

    <div class="troika-page products-container">
        <h1 class="troika-page-title">Women's Clothing Collection</h1>

        <div class="troika-toolbar search-filter-section">
            <div class="troika-form-row search-bar">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search products..." CssClass="troika-input search-input" />
                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="troika-btn search-button" OnClick="btnSearch_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="troika-btn troika-btn-secondary search-button" OnClick="btnClear_Click" />
            </div>

            <div class="troika-form-row filter-section">
                <label for="<%= ddlCategory.ClientID %>">Filter by Category:</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="troika-select category-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" />
            </div>
        </div>

        <asp:Label ID="lblNoProducts" runat="server" Text="No products found." Visible="false" CssClass="no-products" />

        <div class="products-grid-container">
            <asp:DataList ID="dlProducts" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                CssClass="products-grid" OnItemCommand="dlProducts_ItemCommand">
                <ItemTemplate>
                    <div class="product-card">
                        <button type="button" class="wish-heart <%# GetHeartClass(Eval("ProductID")) %>"
                            data-productid='<%# Eval("ProductID") %>'
                            aria-label="Add to wishlist"
                            onclick="troikaToggleWish(this); return false;">
                            <svg viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 1 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z" />
                            </svg>
                        </button>
                        <asp:LinkButton ID="lnkProductCard" runat="server" CommandName="ViewDetails"
                            CommandArgument='<%# Eval("ProductID") %>' CssClass="product-card-link">
                            <div class="product-image">
                                <asp:Image ID="imgProduct" runat="server"
                                    ImageUrl='<%# Eval("ImageUrl") %>'
                                    AlternateText='<%# Eval("ProductName") %>'
                                    CssClass="product-img" />
                            </div>
                            <div class="product-info">
                                <div class="product-name"><%# Eval("ProductName") %></div>
                                <div class="product-description"><%# Eval("Description") %></div>
                                <span class="product-category"><%# Eval("Category") %></span>
                                <div class="product-price">R<%# Convert.ToDecimal(Eval("Price")).ToString("F2") %></div>
                            </div>
                        </asp:LinkButton>
                        <asp:Button ID="btnViewDetails" runat="server"
                            CommandName="ViewDetails"
                            CommandArgument='<%# Eval("ProductID") %>'
                            Text="View details"
                            CssClass="view-details-btn" />
                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>
    </div>

    <script src="<%= ResolveUrl("~/Scripts/wishlist.js") %>"></script>
</asp:Content>
