// Phase 6 reusable report chart renderer.
// Reports.aspx.cs only supplies data; this file owns chart rendering.

function loadSalesCharts(monthlyData, paymentData, channelData) {
    if (typeof Chart === "undefined") {
        console.error("Chart.js is not loaded.");
        return;
    }

    monthlyData = monthlyData || [];
    paymentData = paymentData || [];
    channelData = channelData || [];

    Chart.defaults.color = "#555555";
    Chart.defaults.font.family = "'Segoe UI', Roboto, Arial, sans-serif";

    const chartGridColor = "rgba(0, 0, 0, 0.10)";
    const chartTickColor = "#555555";

    destroyExistingReportCharts();
    renderMonthlySalesChart(monthlyData, chartGridColor, chartTickColor);
    renderPaymentMethodChart(paymentData, chartTickColor);
    renderSalesChannelChart(channelData, chartGridColor, chartTickColor);
}

function destroyExistingReportCharts() {
    if (window.revChartInstance) {
        window.revChartInstance.destroy();
    }

    if (window.paymentChartInstance) {
        window.paymentChartInstance.destroy();
    }

    if (window.channelChartInstance) {
        window.channelChartInstance.destroy();
    }
}

function renderMonthlySalesChart(monthlyData, chartGridColor, chartTickColor) {
    const canvas = document.getElementById("revChart");
    if (!canvas) return;

    window.revChartInstance = new Chart(canvas, {
        type: "bar",
        data: {
            labels: monthlyData.map(x => x.Month),
            datasets: [{
                label: "Total Monthly Sales",
                data: monthlyData.map(x => x.TotalSales),
                backgroundColor: "rgba(75, 192, 192, 0.6)",
                borderColor: "rgba(75, 192, 192, 1)",
                borderWidth: 1
            }]
        },
        options: buildBarChartOptions(chartGridColor, chartTickColor)
    });
}

function renderPaymentMethodChart(paymentData, chartTickColor) {
    const canvas = document.getElementById("topProductsChart");
    if (!canvas) return;

    window.paymentChartInstance = new Chart(canvas, {
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
}

function renderSalesChannelChart(channelData, chartGridColor, chartTickColor) {
    const canvas = document.getElementById("channelChart");
    if (!canvas) return;

    window.channelChartInstance = new Chart(canvas, {
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
        options: buildBarChartOptions(chartGridColor, chartTickColor)
    });
}

function buildBarChartOptions(chartGridColor, chartTickColor) {
    return {
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
    };
}
