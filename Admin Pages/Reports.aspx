<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TroikaClothingWeb.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .reports-page {
            min-height: 90vh;
            padding: 40px 10px;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
        }

        .reports-inner {
            max-width: 1500px;
            margin: 0 auto;
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 14px;
            padding: 35px 28px 45px 28px;
            box-shadow: var(--troika-card-shadow);
        }

        .reports-title {
            color: var(--troika-heading-text) !important;
            text-align: center;
            margin-bottom: 35px;
            font-weight: 700;
            font-size: 34px;
        }

        .reports-chart-grid {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            width: 100%;
            box-sizing: border-box;
            gap: 40px;
            flex-wrap: wrap;
        }

        .reports-chart-item {
            flex: 1;
            min-width: 350px;
            max-width: 500px;
        }

        .reports-chart-title {
            text-align: center;
            margin-bottom: 14px;
            color: var(--troika-heading-text) !important;
            font-weight: 700;
            font-size: 24px;
        }

        .reports-chart-card {
            border: 2px solid var(--troika-border) !important;
            padding: 20px;
            border-radius: 10px;
            background: #ffffff !important;
            height: 300px;
            box-shadow: var(--troika-card-shadow);
        }

        .reports-chart-card canvas {
            background: #ffffff !important;
        }

        body[data-theme="dark"] .reports-inner {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .reports-title,
        body[data-theme="dark"] .reports-chart-title {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .reports-chart-card {
            background: #ffffff !important;
            border-color: #b99cdd !important;
        }

        @media (max-width: 768px) {
            .reports-inner {
                padding: 25px 16px;
            }

            .reports-chart-grid {
                gap: 28px;
            }

            .reports-chart-item {
                min-width: 100%;
                max-width: 100%;
            }

            .reports-title {
                font-size: 28px;
            }

            .reports-chart-title {
                font-size: 20px;
            }
        }
    </style>

    <div class="reports-page reports-container">
        <div class="reports-inner">

            <h1 class="reports-title">View Reports</h1>

            <div class="reports-chart-grid">

                <!-- Chart 1 -->
                <div class="reports-chart-item">
                    <h4 class="reports-chart-title">Monthly Sales Totals</h4>
                    <div class="reports-chart-card">
                        <canvas id="revChart"></canvas>
                    </div>
                </div>

                <!-- Chart 2 -->
                <div class="reports-chart-item">
                    <h4 class="reports-chart-title">Preferred Payment Method</h4>
                    <div class="reports-chart-card">
                        <canvas id="topProductsChart"></canvas>
                    </div>
                </div>

                <!-- Chart 3 -->
                <div class="reports-chart-item">
                    <h4 class="reports-chart-title">Sales Channel (FrontEnd vs Website)</h4>
                    <div class="reports-chart-card">
                        <canvas id="channelChart"></canvas>
                    </div>
                </div>

            </div>

        </div>
    </div>

    <asp:Literal ID="litDbTest" runat="server" />

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        function loadSalesCharts(monthlyData, paymentData, channelData) {

            // Keep chart text readable because the chart cards stay white in both modes
            Chart.defaults.color = "#555555";
            Chart.defaults.font.family = "'Segoe UI', Roboto, Arial, sans-serif";

            const chartGridColor = "rgba(0, 0, 0, 0.10)";
            const chartTickColor = "#555555";

            // Destroy existing charts if page reloads/updates
            if (window.revChartInstance) {
                window.revChartInstance.destroy();
            }

            if (window.paymentChartInstance) {
                window.paymentChartInstance.destroy();
            }

            if (window.channelChartInstance) {
                window.channelChartInstance.destroy();
            }

            // ------- Monthly Sales Totals -------
            const months = monthlyData.map(x => x.Month);
            const totals = monthlyData.map(x => x.TotalSales);

            window.revChartInstance = new Chart(document.getElementById("revChart"), {
                type: "bar",
                data: {
                    labels: months,
                    datasets: [{
                        label: "Total Monthly Sales",
                        data: totals,
                        backgroundColor: "rgba(75, 192, 192, 0.6)",
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            labels: {
                                color: chartTickColor
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: chartTickColor
                            },
                            grid: {
                                color: chartGridColor
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                color: chartTickColor
                            },
                            grid: {
                                color: chartGridColor
                            }
                        }
                    }
                }
            });

            // ------- Preferred Payment Method -------
            window.paymentChartInstance = new Chart(document.getElementById("topProductsChart"), {
                type: "pie",
                data: {
                    labels: paymentData.map(x => x.paymentMethod),
                    datasets: [{
                        data: paymentData.map(x => x.TotalCount),
                        backgroundColor: [
                            "#36A2EB",
                            "#FF6384",
                            "#FF9F40",
                            "#4BC0C0",
                            "#9966FF"
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            labels: {
                                color: chartTickColor
                            }
                        }
                    }
                }
            });

            // ------- Sales Channel -------
            window.channelChartInstance = new Chart(document.getElementById("channelChart"), {
                type: "bar",
                data: {
                    labels: channelData.map(x => x.saleChannel),
                    datasets: [{
                        label: "Sales Count",
                        data: channelData.map(x => x.TotalSales),
                        backgroundColor: "rgba(54, 162, 235, 0.45)",
                        borderColor: "rgba(54, 162, 235, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            labels: {
                                color: chartTickColor
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: chartTickColor
                            },
                            grid: {
                                color: chartGridColor
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                color: chartTickColor
                            },
                            grid: {
                                color: chartGridColor
                            }
                        }
                    }
                }
            });
        }
    </script>

</asp:Content>