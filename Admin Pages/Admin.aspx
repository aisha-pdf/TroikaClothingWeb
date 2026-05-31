<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="TroikaClothingWeb.Adminaspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* ---------- ADMIN PAGE LOCAL FIX ---------- */

        .admin-local-page {
            display: flex !important;
            flex-direction: row !important;
            align-items: flex-start !important;
            width: 100% !important;
            min-height: 80vh !important;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            padding: 0 !important;
            margin: 0 !important;
            box-sizing: border-box !important;
        }

        /* LEFT BUTTON AREA */
        .admin-local-sidebar {
            width: 230px !important;
            min-width: 230px !important;
            padding: 35px 20px 20px 80px !important;
            background: var(--troika-bg) !important;
            display: flex !important;
            flex-direction: column !important;
            gap: 16px !important;
            box-sizing: border-box !important;
        }

        .admin-local-btn {
            width: 135px !important;
            max-width: 135px !important;
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            padding: 12px 16px !important;
            text-align: left !important;
            border-radius: 6px !important;
            cursor: pointer !important;
            font-size: 15px !important;
            font-weight: 600 !important;
        }

            .admin-local-btn:hover {
                background: var(--troika-btn-hover-bg) !important;
                border-color: var(--troika-btn-hover-bg) !important;
                color: var(--troika-btn-text) !important;
            }

        /* RIGHT CONTENT AREA */
        .admin-local-content {
            flex: 1 !important;
            padding: 20px 40px 30px 20px !important;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            box-sizing: border-box !important;
        }

        .admin-local-card {
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
            padding: 35px !important;
            border: 1px solid var(--troika-border) !important;
            min-height: 540px !important;
            max-width: 1400px !important;
            box-sizing: border-box !important;
        }

        .admin-local-heading {
            color: var(--troika-heading-text) !important;
            margin-bottom: 25px !important;
            font-weight: 700 !important;
            letter-spacing: 2px !important;
        }

        .admin-local-grid-wrapper {
            overflow-x: auto !important;
            background: transparent !important;
        }

        .admin-local-grid {
            width: 100% !important;
            max-width: 1180px !important;
            border-collapse: collapse !important;
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
        }

            .admin-local-grid th,
            .admin-local-grid td {
                background: var(--troika-table-bg) !important;
                color: var(--troika-table-text) !important;
                padding: 10px 12px !important;
                border-color: var(--troika-border) !important;
            }

            .admin-local-grid th {
                background: var(--troika-table-header-bg) !important;
                color: var(--troika-table-header-text) !important;
                font-weight: 700 !important;
                text-decoration: underline !important;
            }

            .admin-local-grid a {
                color: var(--troika-primary) !important;
                font-weight: 500 !important;
                text-decoration: underline !important;
            }

                .admin-local-grid a:hover {
                    color: var(--troika-primary-hover) !important;
                }

        .admin-local-row td,
        .admin-local-alt-row td {
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
        }

        .admin-local-grid tr:hover td {
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
        }

        /* SELECTED ROW HIGHLIGHT */
        .admin-local-selected-row td {
            background: var(--troika-primary-hover) !important;
            color: var(--troika-btn-text) !important;
            font-weight: 700 !important;
        }

        .admin-local-selected-row a {
            color: var(--troika-btn-text) !important;
            font-weight: 700 !important;
        }

        .admin-local-edit-row td {
            background: var(--troika-secondary) !important;
            color: var(--troika-primary) !important;
            font-weight: 600 !important;
        }

        .admin-local-pager td {
            background: var(--troika-table-bg) !important;
            color: var(--troika-table-text) !important;
            text-align: center !important;
        }

        .admin-local-pager a,
        .admin-local-pager span {
            color: var(--troika-primary) !important;
            font-weight: 600 !important;
            padding: 0 3px !important;
        }

        /* DARK MODE EXTRA OVERRIDES */
        body[data-theme="dark"] .admin-local-card {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .admin-local-heading {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .admin-local-grid,
        body[data-theme="dark"] .admin-local-grid td {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
        }

            body[data-theme="dark"] .admin-local-grid th {
                background: #2b2433 !important;
                color: #ffffff !important;
            }

        body[data-theme="dark"] .admin-local-selected-row td {
            background: #b99cdd !important;
            color: #121018 !important;
            font-weight: 700 !important;
        }

        body[data-theme="dark"] .admin-local-selected-row a {
            color: #121018 !important;
            font-weight: 700 !important;
        }

        body[data-theme="dark"] .admin-local-grid a {
            color: #d9c8f0 !important;
        }

        body[data-theme="dark"] .admin-local-btn {
            background: #d9c8f0 !important;
            color: #121018 !important;
            border-color: #d9c8f0 !important;
        }

            body[data-theme="dark"] .admin-local-btn:hover {
                background: #b99cdd !important;
                color: #121018 !important;
            }

        @media (max-width: 900px) {
            .admin-local-page {
                flex-direction: column !important;
            }

            .admin-local-sidebar {
                width: 100% !important;
                min-width: 100% !important;
                padding: 20px !important;
                flex-direction: row !important;
                flex-wrap: wrap !important;
            }

            .admin-local-btn {
                width: auto !important;
                min-width: 130px !important;
                max-width: none !important;
            }

            .admin-local-content {
                padding: 20px !important;
            }
        }

        /* Keep Edit/Select links readable on hover and selected rows */
        .admin-local-grid tr:hover a,
        .admin-local-grid tr:hover td a {
            color: var(--troika-table-text) !important;
            font-weight: 600 !important;
            text-decoration: underline !important;
        }

        /* In dark mode, keep links readable when hovering normal rows */
        body[data-theme="dark"] .admin-local-grid tr:hover a,
        body[data-theme="dark"] .admin-local-grid tr:hover td a {
            color: #f5f3f7 !important;
        }

        /* In selected row, make Edit/Select match the selected row text */
        .admin-local-selected-row a,
        .admin-local-selected-row td a {
            color: var(--troika-btn-text) !important;
            font-weight: 700 !important;
            text-decoration: underline !important;
        }

        /* Dark mode selected row uses dark text on purple highlight */
        body[data-theme="dark"] .admin-local-selected-row a,
        body[data-theme="dark"] .admin-local-selected-row td a {
            color: #121018 !important;
        }
    </style>

    <div class="admin-local-page">

        <!-- Left Sidebar -->
        <div class="admin-local-sidebar">
            <asp:Button ID="btnUserList" runat="server" Text="User List" CssClass="admin-local-btn" OnClick="btnUserList_Click" />
            <asp:Button ID="btnProfile" runat="server" Text="Profile" CssClass="admin-local-btn" OnClick="btnProfile_Click" />
            <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="admin-local-btn" OnClick="btnLogout_Click" />
        </div>

        <!-- Right Main Content -->
        <div class="admin-local-content">
            <div class="admin-local-card">

                <h2 class="admin-local-heading">USER MANAGEMENT - USER LIST</h2>

                <div class="admin-local-grid-wrapper">
                    <asp:GridView ID="GridView1"
                        runat="server"
                        CssClass="admin-local-grid"
                        AllowPaging="True"
                        AllowSorting="True"
                        AutoGenerateColumns="False"
                        CellPadding="4"
                        DataKeyNames="ID"
                        DataSourceID="UserListDs"
                        GridLines="None"
                        Width="100%">

                        <Columns>
                            <asp:CommandField ShowEditButton="True" ShowSelectButton="True" />
                            <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="Surname" HeaderText="Surname" SortExpression="Surname" />
                            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                            <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" SortExpression="PhoneNumber" />
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

                <asp:SqlDataSource ID="UserListDs"
                    runat="server"
                    ConflictDetection="CompareAllValues"
                    ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>"
                    DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email"
                    InsertCommand="INSERT INTO [WebsiteRegister] ([Name], [Surname], [Email]) VALUES (@Name, @Surname, @Email)"
                    OldValuesParameterFormatString="original_{0}"
                    SelectCommand="SELECT ID, Name, Surname, Email, PhoneNumber FROM WebsiteRegister"
                    UpdateCommand="UPDATE [WebsiteRegister] SET [Name] = @Name, [Surname] = @Surname, [Email] = @Email WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email">

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

    </div>

</asp:Content>
