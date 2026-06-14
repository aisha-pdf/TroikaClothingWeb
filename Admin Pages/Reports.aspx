<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TroikaClothingWeb.Reports" %>
<%@ Register Src="~/Controls/AdminSidebar.ascx" TagPrefix="uc" TagName="AdminSidebar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%= ResolveUrl("~/Content/AdminShared.css") %>" rel="stylesheet" />
    <link href="<%= ResolveUrl("~/Content/Reports.css") %>" rel="stylesheet" />

    <div class="troika-admin-page">
        <uc:AdminSidebar ID="AdminSidebar1" runat="server" />

        <div class="troika-admin-content">
            <div class="troika-admin-card reports-page reports-container">
                <div class="reports-inner">

            <h1 class="reports-title">View Reports</h1>

            <div class="reports-chart-grid">

                <div class="reports-chart-item">
                    <h4 class="reports-chart-title">Monthly Sales Totals</h4>
                    <div class="reports-chart-card">
                        <canvas id="revChart"></canvas>
                    </div>
                </div>

                <div class="reports-chart-item">
                    <h4 class="reports-chart-title">Preferred Payment Method</h4>
                    <div class="reports-chart-card">
                        <canvas id="topProductsChart"></canvas>
                    </div>
                </div>

                <div class="reports-chart-item">
                    <h4 class="reports-chart-title">Sales Channel (FrontEnd vs Website)</h4>
                    <div class="reports-chart-card">
                        <canvas id="channelChart"></canvas>
                    </div>
                </div>

            </div>

                </div>
            </div>
        </div>
    </div>

    <asp:Literal ID="litDbTest" runat="server" />

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="<%= ResolveUrl("~/Scripts/reports-charts.js") %>"></script>

</asp:Content>
