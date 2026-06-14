<%@ Page Title="Admin Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminProfile.aspx.cs" Inherits="TroikaClothingWeb.Admin_Pages.AdminProfile" %>
<%@ Register Src="~/Controls/AdminSidebar.ascx" TagPrefix="uc" TagName="AdminSidebar" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%= ResolveUrl("~/Content/AdminShared.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/AdminProfile.css") %>" rel="stylesheet" />

<div class="admin-profile-page">

        <uc:AdminSidebar ID="AdminSidebar1" runat="server" />

        <div class="admin-profile-content">

            <h2 class="admin-profile-heading">USER MANAGEMENT - PROFILE</h2>

            <asp:Label ID="lblProfileMessage"
                runat="server"
                CssClass="admin-profile-message"
                EnableViewState="False" />

            <asp:ValidationSummary ID="ProfileValidationSummary"
                runat="server"
                ValidationGroup="UpdateProfileValidation"
                CssClass="admin-validation-summary"
                HeaderText="Please fix the following before updating your profile:" />

            <asp:DetailsView ID="DetailsView1"
                runat="server"
                CssClass="admin-profile-details"
                Height="50px"
                Width="646px"
                AutoGenerateRows="False"
                CellPadding="4"
                DataKeyNames="ID"
                GridLines="None"
                OnModeChanging="DetailsView1_ModeChanging"
                OnItemUpdating="DetailsView1_ItemUpdating">

                <AlternatingRowStyle CssClass="admin-profile-alt-row" />
                <CommandRowStyle CssClass="admin-profile-command-row" Font-Bold="True" />
                <EditRowStyle CssClass="admin-profile-edit-row" />
                <FieldHeaderStyle CssClass="admin-profile-field-header" Font-Bold="True" />
                <FooterStyle CssClass="admin-profile-footer" Font-Bold="True" />
                <HeaderStyle CssClass="admin-profile-header" Font-Bold="True" />
                <PagerStyle CssClass="admin-profile-pager" HorizontalAlign="Center" />
                <RowStyle CssClass="admin-profile-row" />

                <Fields>

                    <asp:BoundField DataField="ID"
                        HeaderText="ID"
                        InsertVisible="False"
                        ReadOnly="True"
                        SortExpression="ID" />

                    <asp:TemplateField HeaderText="Name" SortExpression="Name">
                        <ItemTemplate>
                            <%# Eval("Name") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditName"
                                runat="server"
                                Text='<%# Bind("Name") %>'
                                MaxLength="50" />

                            <asp:RequiredFieldValidator ID="rfvEditName"
                                runat="server"
                                ControlToValidate="txtEditName"
                                ErrorMessage="Name is required."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />

                            <asp:RegularExpressionValidator ID="revEditName"
                                runat="server"
                                ControlToValidate="txtEditName"
                                ValidationExpression="^[A-Za-z\s'-]{2,50}$"
                                ErrorMessage="Name must only contain letters and must be 2 to 50 characters."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />
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
                                MaxLength="50" />

                            <asp:RequiredFieldValidator ID="rfvEditSurname"
                                runat="server"
                                ControlToValidate="txtEditSurname"
                                ErrorMessage="Surname is required."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />

                            <asp:RegularExpressionValidator ID="revEditSurname"
                                runat="server"
                                ControlToValidate="txtEditSurname"
                                ValidationExpression="^[A-Za-z\s'-]{2,50}$"
                                ErrorMessage="Surname must only contain letters and must be 2 to 50 characters."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />
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
                                MaxLength="100"
                                TextMode="Email" />

                            <asp:RequiredFieldValidator ID="rfvEditEmail"
                                runat="server"
                                ControlToValidate="txtEditEmail"
                                ErrorMessage="Email is required."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />

                            <asp:RegularExpressionValidator ID="revEditEmail"
                                runat="server"
                                ControlToValidate="txtEditEmail"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Enter a valid email address."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Username"
                        HeaderText="Username"
                        ReadOnly="True"
                        SortExpression="Username" />

                    <asp:TemplateField HeaderText="PhoneNumber" SortExpression="PhoneNumber">
                        <ItemTemplate>
                            <%# Eval("PhoneNumber") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditPhoneNumber"
                                runat="server"
                                Text='<%# Bind("PhoneNumber") %>'
                                MaxLength="10" />

                            <asp:RequiredFieldValidator ID="rfvEditPhoneNumber"
                                runat="server"
                                ControlToValidate="txtEditPhoneNumber"
                                ErrorMessage="Phone number is required."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />

                            <asp:RegularExpressionValidator ID="revEditPhoneNumber"
                                runat="server"
                                ControlToValidate="txtEditPhoneNumber"
                                ValidationExpression="^0[0-9]{9}$"
                                ErrorMessage="Phone number must be 10 digits and start with 0."
                                Text="*"
                                CssClass="admin-validation-error"
                                Display="Dynamic"
                                ValidationGroup="UpdateProfileValidation" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit"
                                runat="server"
                                CommandName="Edit"
                                Text="Edit"
                                CausesValidation="False" />
                        </ItemTemplate>

                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkUpdate"
                                runat="server"
                                CommandName="Update"
                                Text="Update"
                                ValidationGroup="UpdateProfileValidation"
                                CausesValidation="True" />

                            &nbsp;

                            <asp:LinkButton ID="lnkCancel"
                                runat="server"
                                CommandName="Cancel"
                                Text="Cancel"
                                CausesValidation="False" />
                        </EditItemTemplate>
                    </asp:TemplateField>

                </Fields>
            </asp:DetailsView>



        </div>

    </div>

</asp:Content>