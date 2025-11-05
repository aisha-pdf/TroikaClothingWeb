<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TroikaClothingWeb.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="min-height: 90vh; display:flex; flex-direction:column; justify-content:center; align-items:center; background-color:#f8f8f8; padding:30px 10px;">

        <!-- Page heading -->
        <h1 style="color:#4B0082; text-align:center; margin-bottom:25px; font-weight:700;">View Reports</h1>

        <!-- Dropdown -->
        <asp:DropDownList ID="ddlReports" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlReports_SelectedIndexChanged"
    CssClass="form-control" style="width: 300px; margin-bottom: 20px;">
    <asp:ListItem Text="-- Select Report --" Value="" />
    <asp:ListItem Text="Sales Report" Value="sales" />
    <asp:ListItem Text="Monthly Products Report" Value="monthlyproducts" />
</asp:DropDownList>

<!-- Image container with flexbox -->
<div style="display: flex; gap: 20px; justify-content: center; align-items: center; margin-top: 20px;">
    <!-- First image -->
    <asp:Image ID="imgReport1" runat="server" CssClass="img-thumbnail" Width="600px" Visible="false" />

    <!-- Second image -->
    <asp:Image ID="imgReport2" runat="server" CssClass="img-thumbnail" Width="600px" Visible="false" />
</div>
<asp:Button ID="btnPrint" runat="server" Text="Print Report"
    CssClass="btn btn-primary mt-3"
    OnClientClick="printReport(); return false;"
    Visible="false" OnClick="btnPrint_Click" />


<script type="text/javascript">
    function printReport() {
        var printWindow = window.open('', '_blank');
        var content = '';

        var img1 = document.getElementById('<%= imgReport1.ClientID %>');
        var img2 = document.getElementById('<%= imgReport2.ClientID %>');

        if (img1 && img1.style.display !== 'none' && img1.src) {
            content += '<img src="' + img1.src + '" style="width:100%; margin-bottom:20px;" />';
        }
        if (img2 && img2.style.display !== 'none' && img2.src) {
            content += '<img src="' + img2.src + '" style="width:100%;" />';
        }

        printWindow.document.write('<html><head><title>Print Report</title></head><body>' + content + '</body></html>');
        printWindow.document.close();
        printWindow.focus();
        printWindow.print();
    }
</script>
<script type="text/javascript">
    function printReport() {
        var printWindow = window.open('', '_blank');
        var content = '';

        var img1 = document.getElementById('<%= imgReport1.ClientID %>');
        var img2 = document.getElementById('<%= imgReport2.ClientID %>');

        if (img1 && img1.style.display !== 'none' && img1.src) {
            content += '<img src="' + img1.src + '" style="width:100%; margin-bottom:20px;" />';
        }
        if (img2 && img2.style.display !== 'none' && img2.src) {
            content += '<img src="' + img2.src + '" style="width:100%;" />';
        }

        printWindow.document.write('<html><head><title>Print Report</title></head><body>' + content + '</body></html>');
        printWindow.document.close();
        printWindow.focus();
        printWindow.print();
    }
</script>



    </div>
</asp:Content>

