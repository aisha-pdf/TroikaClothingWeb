

<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TroikaClothingWeb.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="min-height: 90vh; padding: 30px 10px; background-color: #f8f8f8;">

        <h1 style="color: #4B0082; text-align: center; margin-bottom: 25px; font-weight: 700;">
            View Reports
        </h1>

        

        <!-- 3 charts -->
        <div style="
            display:flex;
            justify-content:center;
            align-items:flex-start;
            width:100%;
            box-sizing:border-box;
            gap:40px;
            flex-wrap:wrap;
        ">

            <!-- Chart 1 -->
            <div style="flex: 1; min-width: 350px; max-width: 500px;"> 
                <h4 style="text-align:center; margin-bottom:10px;">Monthly Sales Totals</h4>
                <div style="border: 2px solid #ccc; padding:20px; border-radius:10px; background:white; height:300px;">
                    <canvas id="revChart"></canvas>
                </div>
            </div>

            <!-- Chart 2 -->
            <div style="flex: 1; min-width: 350px; max-width: 500px;">
                <h4 style="text-align:center; margin-bottom:10px;">Preferred Payment Method</h4>
                <div style="border: 2px solid #ccc; padding:20px; border-radius:10px; background:white; height:300px;">
                    <canvas id="topProductsChart"></canvas>
                </div>
            </div>

            <!-- Third Chart: Sales Channel -->
            <div style="flex: 1; min-width: 350px; max-width: 500px;">
                <h4 style="text-align:center; margin-bottom:10px;">Sales Channel (FrontEnd vs Website)</h4>
                <div style="border: 2px solid #ccc; padding:20px; border-radius:10px; background:white; height:300px;">
                <canvas id="channelChart"></canvas>
               </div>
            </div>


        </div>

        
    </div>
    <asp:Literal ID="litDbTest" runat="server" />
    <script>
        function loadSalesCharts(monthlyData, paymentData, channelData) {

            // ------- Monthly Revenue -------
            const months = monthlyData.map(x => x.Month);
            const totals = monthlyData.map(x => x.TotalSales);

            new Chart(document.getElementById("revChart"), {
                type: "bar",
                data: {
                    labels: months,
                    datasets: [{
                        label: "Total Monthly Sales",
                        data: totals,
                        backgroundColor: "rgba(75, 192, 192, 0.6)", // soft teal color
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });


            // ------- Payment Method Pie Chart -------
            new Chart(document.getElementById("topProductsChart"), {
                type: "pie",
                data: {
                    labels: paymentData.map(x => x.paymentMethod),
                    datasets: [{
                        data: paymentData.map(x => x.TotalCount)
                    }]
                }
            });

            // ------- Sales Channel Bar Chart -------
            new Chart(document.getElementById("channelChart"), {
                type: "bar",
                data: {
                    labels: channelData.map(x => x.saleChannel),
                    datasets: [{
                        label: "Sales Count",
                        data: channelData.map(x => x.TotalSales),
                        borderWidth: 1
                    }]
                }
            });
        }

    </script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</asp:Content>
