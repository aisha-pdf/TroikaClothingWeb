<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminProfile.aspx.cs" Inherits="TroikaClothingWeb.Admin_Pages.AdminProfile" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* -------------------- ADMIN PROFILE LOCAL LIGHT/DARK MODE FIX -------------------- */

        .admin-profile-page {
            display: flex;
            min-height: 80vh;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
        }

        .admin-profile-sidebar {
            width: 220px;
            min-width: 220px;
            padding: 20px;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            display: flex;
            flex-direction: column;
            gap: 15px;
            box-sizing: border-box;
        }

        .admin-profile-btn {
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            padding: 10px;
            text-align: left;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 14px;
            font-weight: 600;
        }

        .admin-profile-btn:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        .admin-profile-content {
            flex: 1;
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
            padding: 30px;
            box-sizing: border-box;
        }

        .admin-profile-heading {
            color: var(--troika-heading-text) !important;
            margin-bottom: 20px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        .admin-profile-details {
            width: 646px !important;
            max-width: 100%;
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
            border-collapse: collapse !important;
            border: none !important;
        }

        .admin-profile-details td,
        .admin-profile-details th {
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
            border-color: var(--troika-border) !important;
            padding: 10px 12px !important;
        }

        .admin-profile-field-header td,
        .admin-profile-field-header th,
        .admin-profile-details .admin-profile-field-header {
            background: var(--troika-table-header-bg) !important;
            color: var(--troika-table-header-text) !important;
            font-weight: 700 !important;
        }

        .admin-profile-row td,
        .admin-profile-alt-row td {
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
        }

        .admin-profile-command-row td {
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
            font-weight: 700 !important;
        }

        .admin-profile-edit-row td {
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
        }

        .admin-profile-details a {
            color: var(--troika-primary) !important;
            font-weight: 600 !important;
            text-decoration: underline !important;
        }

        .admin-profile-details a:hover {
            color: var(--troika-primary-hover) !important;
        }

        .admin-profile-details input,
        .admin-profile-details select,
        .admin-profile-details textarea {
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 6px !important;
            padding: 8px !important;
        }

        body[data-theme="dark"] .admin-profile-content {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
        }

        body[data-theme="dark"] .admin-profile-heading {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .admin-profile-details,
        body[data-theme="dark"] .admin-profile-details td,
        body[data-theme="dark"] .admin-profile-details th {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .admin-profile-field-header td,
        body[data-theme="dark"] .admin-profile-field-header th {
            background: #2b2433 !important;
            color: #ffffff !important;
        }

        body[data-theme="dark"] .admin-profile-details a {
            color: #d9c8f0 !important;
        }

        body[data-theme="dark"] .admin-profile-details a:hover {
            color: #b99cdd !important;
        }

        body[data-theme="dark"] .admin-profile-btn {
            background: #d9c8f0 !important;
            color: #121018 !important;
            border-color: #d9c8f0 !important;
        }

        body[data-theme="dark"] .admin-profile-btn:hover {
            background: #b99cdd !important;
            color: #121018 !important;
        }

        @media (max-width: 900px) {
            .admin-profile-page {
                flex-direction: column;
            }

            .admin-profile-sidebar {
                width: 100%;
                min-width: 100%;
                flex-direction: row;
                flex-wrap: wrap;
            }

            .admin-profile-btn {
                width: auto;
                min-width: 130px;
            }

            .admin-profile-content {
                padding: 20px;
            }
        }
    </style>

    <div class="admin-profile-page">

        <!-- Sidebar -->
        <div class="admin-profile-sidebar">
            <asp:Button ID="btnUserList" runat="server" Text="User List" CssClass="admin-profile-btn" OnClick="btnUserList_Click" />
            <asp:Button ID="btnProfile" runat="server" Text="Profile" CssClass="admin-profile-btn" OnClick="btnProfile_Click" />
            <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="admin-profile-btn" OnClick="btnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div class="admin-profile-content">
            <h2 class="admin-profile-heading">USER MANAGEMENT - PROFILE</h2>

            <asp:DetailsView ID="DetailsView1"
                runat="server"
                CssClass="admin-profile-details"
                Height="50px"
                Width="646px"
                AutoGenerateRows="False"
                CellPadding="4"
                DataKeyNames="ID"
                DataSourceID="AdminProfileDS"
                GridLines="None">

                <AlternatingRowStyle CssClass="admin-profile-alt-row" />
                <CommandRowStyle CssClass="admin-profile-command-row" Font-Bold="True" />
                <EditRowStyle CssClass="admin-profile-edit-row" />
                <FieldHeaderStyle CssClass="admin-profile-field-header" Font-Bold="True" />
                <FooterStyle CssClass="admin-profile-footer" Font-Bold="True" />
                <HeaderStyle CssClass="admin-profile-header" Font-Bold="True" />
                <PagerStyle CssClass="admin-profile-pager" HorizontalAlign="Center" />
                <RowStyle CssClass="admin-profile-row" />

                <Fields>
                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="Surname" HeaderText="Surname" SortExpression="Surname" />
                    <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                    <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
                    <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password" />
                    <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" SortExpression="PhoneNumber" />
                    <asp:CommandField ShowEditButton="True" />
                </Fields>
            </asp:DetailsView>

            <asp:SqlDataSource ID="AdminProfileDS"
                runat="server"
                ConflictDetection="CompareAllValues"
                ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password"
                InsertCommand="INSERT INTO [WebsiteRegister] ([Name], [Surname], [Email], [Username], [Password]) VALUES (@Name, @Surname, @Email, @Username, @Password)"
                OldValuesParameterFormatString="original_{0}"
                SelectCommand="SELECT ID, Name, Surname, Email, Username, Password, PhoneNumber FROM WebsiteRegister"
                UpdateCommand="UPDATE [WebsiteRegister] SET [Name] = @Name, [Surname] = @Surname, [Email] = @Email, [Username] = @Username, [Password] = @Password WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password">

                <DeleteParameters>
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                    <asp:Parameter Name="original_Surname" Type="String" />
                    <asp:Parameter Name="original_Email" Type="String" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                </DeleteParameters>

                <InsertParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Surname" Type="String" />
                    <asp:Parameter Name="Email" Type="String" />
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                </InsertParameters>

                <UpdateParameters>
                    <asp:Parameter Name="Name" Type="String" />
                    <asp:Parameter Name="Surname" Type="String" />
                    <asp:Parameter Name="Email" Type="String" />
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Password" Type="String" />
                    <asp:Parameter Name="original_ID" Type="Int32" />
                    <asp:Parameter Name="original_Name" Type="String" />
                    <asp:Parameter Name="original_Surname" Type="String" />
                    <asp:Parameter Name="original_Email" Type="String" />
                    <asp:Parameter Name="original_Username" Type="String" />
                    <asp:Parameter Name="original_Password" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </div>

    </div>

</asp:Content>