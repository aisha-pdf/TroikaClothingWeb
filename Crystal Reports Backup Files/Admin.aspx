<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="TroikaClothingWeb.Adminaspx" %>
<%@ Register Src="~/Controls/AdminSidebar.ascx" TagPrefix="uc" TagName="AdminSidebar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%= ResolveUrl("~/Content/AdminShared.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/AdminUserList.css") %>" rel="stylesheet" />

<div class="admin-local-page">

        <uc:AdminSidebar ID="AdminSidebar1" runat="server" />

        <div class="admin-local-content">
            <div class="admin-local-card">

                <h2 class="admin-local-heading">USER MANAGEMENT - USER LIST</h2>

                <asp:ValidationSummary ID="UpdateValidationSummary"
                    runat="server"
                    ValidationGroup="UpdateUserValidation"
                    CssClass="admin-validation-summary"
                    HeaderText="Please fix the following before updating the user:" />

                <div class="admin-local-grid-wrapper">
                    <asp:GridView ID="GridView1"
                        runat="server"
                        CssClass="admin-local-grid"
                        AllowPaging="True"
                        AllowSorting="False"
                        AutoGenerateColumns="False"
                        CellPadding="4"
                        DataKeyNames="ID"
                        GridLines="None"
                        Width="100%"
                        OnRowEditing="GridView1_RowEditing"
                        OnRowCancelingEdit="GridView1_RowCancelingEdit"
                        OnRowUpdating="GridView1_RowUpdating"
                        OnPageIndexChanging="GridView1_PageIndexChanging"
                        OnSelectedIndexChanged="GridView1_SelectedIndexChanged">

                        <Columns>

                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEdit"
                                        runat="server"
                                        CommandName="Edit"
                                        Text="Edit"
                                        CausesValidation="False" />

                                    &nbsp;

                                    <asp:LinkButton ID="lnkSelect"
                                        runat="server"
                                        CommandName="Select"
                                        Text="Select"
                                        CausesValidation="False" />
                                </ItemTemplate>

                                <EditItemTemplate>
                                    <asp:LinkButton ID="lnkUpdate"
                                        runat="server"
                                        CommandName="Update"
                                        Text="Update"
                                        ValidationGroup="UpdateUserValidation"
                                        CausesValidation="True" />

                                    &nbsp;

                                    <asp:LinkButton ID="lnkCancel"
                                        runat="server"
                                        CommandName="Cancel"
                                        Text="Cancel"
                                        CausesValidation="False" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />

                            <asp:TemplateField HeaderText="Name" SortExpression="Name">
                                <ItemTemplate>
                                    <%# Eval("Name") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditName"
                                        runat="server"
                                        Text='<%# Bind("Name") %>'
                                        CssClass="admin-edit-input"
                                        MaxLength="50" />

                                    <asp:RequiredFieldValidator ID="rfvEditName"
                                        runat="server"
                                        ControlToValidate="txtEditName"
                                        ErrorMessage="Name is required."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />

                                    <asp:RegularExpressionValidator ID="revEditName"
                                        runat="server"
                                        ControlToValidate="txtEditName"
                                        ValidationExpression="^[A-Za-z\s'-]{2,50}$"
                                        ErrorMessage="Name must only contain letters and must be 2 to 50 characters."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Surname" SortExpression="Surname">
                                <ItemTemplate>
                                    <%# Eval("Surname") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditSurname"
                                        runat="server"
                                        Text='<%# Bind("Surname") %>'
                                        CssClass="admin-edit-input"
                                        MaxLength="50" />

                                    <asp:RequiredFieldValidator ID="rfvEditSurname"
                                        runat="server"
                                        ControlToValidate="txtEditSurname"
                                        ErrorMessage="Surname is required."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />

                                    <asp:RegularExpressionValidator ID="revEditSurname"
                                        runat="server"
                                        ControlToValidate="txtEditSurname"
                                        ValidationExpression="^[A-Za-z\s'-]{2,50}$"
                                        ErrorMessage="Surname must only contain letters and must be 2 to 50 characters."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Email" SortExpression="Email">
                                <ItemTemplate>
                                    <%# Eval("Email") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditEmail"
                                        runat="server"
                                        Text='<%# Bind("Email") %>'
                                        CssClass="admin-edit-input"
                                        MaxLength="100"
                                        TextMode="Email" />

                                    <asp:RequiredFieldValidator ID="rfvEditEmail"
                                        runat="server"
                                        ControlToValidate="txtEditEmail"
                                        ErrorMessage="Email is required."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />

                                    <asp:RegularExpressionValidator ID="revEditEmail"
                                        runat="server"
                                        ControlToValidate="txtEditEmail"
                                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                        ErrorMessage="Enter a valid email address."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="PhoneNumber" SortExpression="PhoneNumber">
                                <ItemTemplate>
                                    <%# Eval("PhoneNumber") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEditPhoneNumber"
                                        runat="server"
                                        Text='<%# Bind("PhoneNumber") %>'
                                        CssClass="admin-edit-input"
                                        MaxLength="10" />

                                    <asp:RequiredFieldValidator ID="rfvEditPhoneNumber"
                                        runat="server"
                                        ControlToValidate="txtEditPhoneNumber"
                                        ErrorMessage="Phone number is required."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />

                                    <asp:RegularExpressionValidator ID="revEditPhoneNumber"
                                        runat="server"
                                        ControlToValidate="txtEditPhoneNumber"
                                        ValidationExpression="^0[0-9]{9}$"
                                        ErrorMessage="Phone number must be 10 digits and start with 0."
                                        Text="*"
                                        CssClass="admin-validation-error"
                                        Display="Dynamic"
                                        ValidationGroup="UpdateUserValidation" />
                                </EditItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                        <HeaderStyle CssClass="admin-local-header" Font-Bold="True" />
                        <RowStyle CssClass="admin-local-row" />
                        <AlternatingRowStyle CssClass="admin-local-alt-row" />
                        <SelectedRowStyle CssClass="admin-local-selected-row" Font-Bold="True" />
                        <EditRowStyle CssClass="admin-local-edit-row" />
                        <PagerStyle CssClass="admin-local-pager" HorizontalAlign="Center" />
                        <FooterStyle CssClass="admin-local-footer" Font-Bold="True" />
                    </asp:GridView>
                </div>



            </div>
        </div>

    </div>

</asp:Content>