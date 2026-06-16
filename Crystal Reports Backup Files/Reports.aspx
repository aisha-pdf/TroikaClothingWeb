<%@ Page Title="Business Intelligence" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="TroikaClothingWeb.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .bi-page {
            min-height: 90vh;
            padding: 30px 10px 60px;
            background: var(--troika-bg, #f4f2f8) !important;
            color: var(--troika-text, #211c2b) !important;
        }

        .bi-inner { max-width: 1500px; margin: 0 auto; }

        .bi-header {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 18px;
        }

        .bi-title { color: var(--troika-heading-text, #4a2c70) !important; font-weight: 800; font-size: 32px; margin: 0; }
        .bi-subtitle { margin: 4px 0 0; font-size: 14px; opacity: 0.7; }

        /* Report picker + filters */
        .bi-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 16px; margin-bottom: 12px; }
        .bi-report-pick { display: flex; flex-direction: column; gap: 4px; font-size: 11px; font-weight: 700; letter-spacing: .04em; text-transform: uppercase; opacity: .65; }
        .bi-report-pick select {
            font-size: 16px; font-weight: 700; padding: 10px 14px; border-radius: 10px; min-width: 250px;
            border: 1px solid var(--troika-border, #d8cfe6); background: var(--troika-surface, #fff); color: var(--troika-text, #211c2b);
        }
        .bi-period-summary { font-size: 13.5px; font-weight: 600; opacity: .65; align-self: flex-end; padding-bottom: 9px; }

        /* Filter panel: grouped, labelled, auto-applying */
        .bi-filters {
            display: flex; flex-wrap: wrap; align-items: center; margin-bottom: 20px;
            background: var(--troika-surface-alt, #fff); border: 1px solid var(--troika-border, #e4dcef);
            border-radius: 12px; padding: 4px 6px; box-shadow: var(--troika-card-shadow, 0 6px 18px rgba(60, 40, 90, 0.06));
        }
        .bi-fgroup { display: flex; align-items: center; gap: 9px; padding: 8px 18px; border-right: 1px solid var(--troika-border, #ece6f3); }
        .bi-fgroup:last-of-type { border-right: none; }
        .bi-flabel { font-size: 10px; font-weight: 800; letter-spacing: .07em; text-transform: uppercase; opacity: .5; }
        .bi-input {
            padding: 7px 10px; border-radius: 8px; border: 1px solid var(--troika-border, #d8cfe6);
            background: var(--troika-surface, #fff); color: var(--troika-text, #211c2b); font-size: 13.5px;
        }
        .bi-dash { font-size: 12px; opacity: .55; }

        /* Help (?) button + modal */
        .bi-actions { display: flex; flex-direction: column; align-items: flex-end; gap: 8px; }
        .bi-help-btn {
            width: 34px; height: 34px; border-radius: 50%; cursor: pointer; font-size: 17px; font-weight: 800; line-height: 1;
            display: inline-flex; align-items: center; justify-content: center; padding: 0;
            border: 1px solid var(--troika-border, #d8cfe6); background: var(--troika-surface, #fff); color: #7c4dff;
        }
        .bi-help-btn:hover { background: #7c4dff; color: #fff; border-color: #7c4dff; }

        .bi-help-overlay {
            position: fixed; inset: 0; z-index: 1000; background: rgba(28, 18, 40, 0.55);
            display: flex; align-items: flex-start; justify-content: center; padding: 40px 16px; overflow-y: auto;
        }
        .bi-help-modal {
            width: 720px; max-width: 100%; background: var(--troika-surface-alt, #fff);
            border-radius: 16px; border: 1px solid var(--troika-border, #e4dcef);
            box-shadow: 0 20px 60px rgba(28, 18, 40, 0.4); overflow: hidden;
        }
        .bi-help-head {
            display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 18px 22px;
            background-color: #3d304c; background-image: linear-gradient(135deg, #3d304c, #644f7d);
        }
        .bi-help-head h2 { margin: 0; font-size: 19px; font-weight: 800; color: #f4f1ec; }
        .bi-help-x { background: transparent; border: none; color: #f4f1ec; font-size: 26px; line-height: 1; cursor: pointer; opacity: .8; }
        .bi-help-x:hover { opacity: 1; }
        .bi-help-body { padding: 20px 24px 26px; max-height: 70vh; overflow-y: auto; color: var(--troika-text, #211c2b); font-size: 14px; line-height: 1.6; }
        .bi-help-body h4 { margin: 18px 0 8px; font-size: 14.5px; color: var(--troika-heading-text, #3a235c); }
        .bi-help-body p { margin: 0 0 10px; }
        .bi-help-graph { margin: 0 0 9px; }
        .bi-help-graph b { color: var(--troika-heading-text, #3a235c); }
        .bi-help-method { background: #f7f5fb; border: 1px solid var(--troika-border, #ece6f3); border-radius: 10px; padding: 12px 14px; margin: 6px 0 4px; }
        .bi-help-badge { display: inline-block; background: #00c6ab; color: #06241f; font-size: 11px; font-weight: 800; letter-spacing: .04em; text-transform: uppercase; padding: 4px 10px; border-radius: 999px; margin-bottom: 12px; }
        .bi-help-sub { opacity: .7; margin: -4px 0 14px; font-size: 13px; }

        body[data-theme="dark"] .bi-help-btn { background: #241d30; color: #c9bbed; border-color: #3b3048; }
        body[data-theme="dark"] .bi-help-modal { background: #1c1724; border-color: #3b3048; }
        body[data-theme="dark"] .bi-help-body { color: #e7e0f3; }
        body[data-theme="dark"] .bi-help-body h4,
        body[data-theme="dark"] .bi-help-graph b { color: #f3eefb; }
        body[data-theme="dark"] .bi-help-method { background: #241d30; border-color: #3b3048; }

        .bi-btn { padding: 9px 18px; border-radius: 8px; border: none; font-weight: 700; font-size: 14px; cursor: pointer; background: #7c4dff; color: #fff; }
        .bi-btn.secondary { background: transparent; color: var(--troika-text, #211c2b); border: 1px solid var(--troika-border, #d8cfe6); }
        .bi-btn:hover { filter: brightness(1.05); }

        .bi-kpis { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-bottom: 22px; }
        .bi-kpi {
            background: var(--troika-surface-alt, #fff) !important; border: 1px solid var(--troika-border, #e4dcef) !important;
            border-radius: 14px; padding: 18px 18px 16px; box-shadow: var(--troika-card-shadow, 0 6px 18px rgba(60, 40, 90, 0.08));
            border-top: 4px solid #7c4dff !important;
        }
        .bi-kpi .label { font-size: 12.5px; text-transform: uppercase; letter-spacing: .04em; opacity: .7; }
        .bi-kpi .value { font-size: 27px; font-weight: 800; margin-top: 6px; color: var(--troika-heading-text, #3a235c); }

        .bi-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }
        .bi-card {
            background: var(--troika-surface-alt, #fff) !important; border: 1px solid var(--troika-border, #e4dcef) !important;
            border-radius: 14px; padding: 18px 18px 8px; box-shadow: var(--troika-card-shadow, 0 6px 18px rgba(60, 40, 90, 0.08)); min-height: 340px;
        }
        .bi-card h3 { font-size: 16px; font-weight: 700; margin: 0 0 8px; color: var(--troika-heading-text, #3a235c) !important; }
        .bi-col-2 { grid-column: span 2; }

        /* Tables / stats / notes used by the Python-backed reports */
        .bi-note { padding: 30px 18px; text-align: center; color: #8a8499; font-size: 14px; line-height: 1.7; }
        .bi-note code { background: rgba(124, 77, 255, .12); padding: 2px 6px; border-radius: 6px; }
        .bi-table { width: 100%; border-collapse: collapse; font-size: 13.5px; }
        .bi-table th { text-align: left; font-size: 11px; text-transform: uppercase; letter-spacing: .04em; opacity: .6; padding: 8px 10px; border-bottom: 1px solid var(--troika-border, #e4dcef); }
        .bi-table td { padding: 8px 10px; border-bottom: 1px solid var(--troika-border, #efeaf5); }
        .bi-table td.num { text-align: right; }
        .bi-stat-row { display: flex; justify-content: space-between; padding: 12px 4px; border-bottom: 1px solid var(--troika-border, #efeaf5); font-size: 14.5px; }
        .bi-stat-row b { color: var(--troika-heading-text, #3a235c); }
        .bi-stat-big { text-align: center; padding: 36px 10px; }
        .bi-stat-big .value { font-size: 44px; font-weight: 800; color: #7c4dff; }
        .bi-stat-big .label { opacity: .7; margin-top: 6px; }
        .bi-gen { font-size: 12px; opacity: .6; margin: -4px 0 14px; }

        .bi-loading, .bi-error { text-align: center; padding: 14px; border-radius: 10px; margin-top: 16px; font-weight: 600; }
        .bi-loading { opacity: .7; }
        .bi-error { background: #fdecec; color: #b3261e; border: 1px solid #f3c0bd; }

        .print-only { display: none; }

        /* Dark mode */
        body[data-theme="dark"] .bi-kpi,
        body[data-theme="dark"] .bi-card { background: #1c1724 !important; border-color: #3b3048 !important; }
        body[data-theme="dark"] .bi-title,
        body[data-theme="dark"] .bi-kpi .value,
        body[data-theme="dark"] .bi-card h3,
        body[data-theme="dark"] .bi-stat-row b { color: #f3eefb !important; }
        body[data-theme="dark"] .bi-filters { background: #1c1724; border-color: #3b3048; }
        body[data-theme="dark"] .bi-fgroup { border-right-color: #33293f; }
        body[data-theme="dark"] .bi-input,
        body[data-theme="dark"] .bi-report-pick select { background: #241d30; color: #f3eefb; border-color: #3b3048; }
        body[data-theme="dark"] .bi-table th { border-color: #3b3048; }
        body[data-theme="dark"] .bi-table td { border-color: #2c2438; }

        @media (max-width: 1100px) { .bi-grid { grid-template-columns: repeat(2, 1fr); } .bi-col-2 { grid-column: span 2; } }
        @media (max-width: 700px) { .bi-grid { grid-template-columns: 1fr; } .bi-col-2 { grid-column: span 1; } }

        /* ---- Print / Save as PDF ---- */
        @media print {
            body * { visibility: hidden; }
            #printArea, #printArea * { visibility: visible; }
            #printArea { position: absolute; left: 0; top: 0; width: 100%; }
            .no-print { display: none !important; }
            .print-only { display: block !important; }
            .bi-page { background: #fff !important; color: #000 !important; padding: 0 !important; min-height: 0 !important; }
            .bi-kpi, .bi-card { box-shadow: none !important; border: 1px solid #cccccc !important; background: #fff !important; break-inside: avoid; }
            .bi-title, .bi-subtitle, .bi-card h3, .bi-kpi .value, .bi-kpi .label { color: #000 !important; }
            .bi-grid { grid-template-columns: repeat(2, 1fr) !important; gap: 10px !important; }
            .bi-col-2 { grid-column: span 2 !important; }
            @page { margin: 12mm; }
        }
    </style>

    <div class="bi-page">
        <div class="bi-inner" id="printArea">

            <div class="bi-header">
                <div>
                    <h1 class="bi-title">Business Intelligence</h1>
                    <p class="bi-subtitle" id="reportSubtitle">Live sales analytics &middot; admin only</p>
                    <p class="bi-subtitle print-only" id="printStamp"></p>
                </div>
                <div class="bi-actions no-print">
                    <button type="button" id="btnPrint" class="bi-btn"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:7px"><path d="M6 9V2h12v7"></path><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>Print / Save as PDF</button>
                    <button type="button" id="btnExport" class="bi-btn secondary"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:7px"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>Download Excel</button>
                    <button type="button" id="btnHelp" class="bi-help-btn" title="What am I looking at?" aria-label="Help">?</button>
                </div>
            </div>

            <div class="bi-toolbar no-print">
                <label class="bi-report-pick">Report
                    <select id="fReport">
                        <option value="overview">Overview (All)</option>
                        <option value="sales">Sales</option>
                        <option value="products">Products</option>
                        <option value="customers">Customers</option>
                        <option value="operations">Operations / Fulfilment</option>
                        <option value="seasonality">Seasonality &amp; Forecast</option>
                        <option value="basket">Basket / Affinity</option>
                        <option value="geography">Geography</option>
                    </select>
                </label>
                <div class="bi-period-summary" id="periodSummary"></div>
            </div>

            <div class="bi-filters no-print">
                <div class="bi-fgroup">
                    <span class="bi-flabel">Period</span>
                    <select id="fPreset" class="bi-input">
                        <option value="all">All time</option>
                        <option value="thisMonth">This month</option>
                        <option value="lastMonth">Last month</option>
                        <option value="thisYear">This year</option>
                        <option value="ytd">Year to date</option>
                        <option value="custom">Custom / specific</option>
                    </select>
                </div>
                <div class="bi-fgroup">
                    <span class="bi-flabel">Or month</span>
                    <select id="fMonth" class="bi-input" aria-label="Month"></select>
                    <select id="fYear" class="bi-input" aria-label="Year"></select>
                </div>
                <div class="bi-fgroup">
                    <span class="bi-flabel">Custom</span>
                    <input type="date" id="fFrom" class="bi-input" aria-label="From date" />
                    <span class="bi-dash">to</span>
                    <input type="date" id="fTo" class="bi-input" aria-label="To date" />
                </div>
                <div class="bi-fgroup">
                    <span class="bi-flabel">Refine</span>
                    <select id="fStatus" class="bi-input"><option value="All">All status</option></select>
                    <select id="fChannel" class="bi-input"><option value="All">All channels</option></select>
                </div>
                <div class="bi-fgroup">
                    <button type="button" id="btnReset" class="bi-btn secondary">Reset</button>
                </div>
            </div>

            <p class="bi-gen no-print" id="biGen" style="display:none;"></p>
            <div id="biError" class="bi-error no-print" style="display:none;"></div>

            <div class="bi-kpis" id="biKpis"></div>
            <div class="bi-grid" id="reportGrid"></div>

            <div id="biLoading" class="bi-loading no-print">Loading dashboard&hellip;</div>
        </div>
    </div>

    <div id="helpOverlay" class="bi-help-overlay no-print" style="display:none;">
        <div class="bi-help-modal" role="dialog" aria-modal="true" aria-labelledby="helpTitle">
            <div class="bi-help-head">
                <h2 id="helpTitle">Help</h2>
                <button type="button" id="helpClose" class="bi-help-x" aria-label="Close help">&times;</button>
            </div>
            <div class="bi-help-body" id="helpBody"></div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <script src="https://cdn.jsdelivr.net/npm/exceljs@4.4.0/dist/exceljs.min.js"></script>
    <script>
        (function () {
            var HANDLER_URL = encodeURI("<%= ResolveUrl("~/Admin Pages/ReportDataHandler.ashx") %>");
            var PALETTE = ["#7c4dff", "#ff6e7f", "#00c6ab", "#ffb547", "#36a2eb", "#9c27b0", "#ff5252", "#26c6da"];
            var MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
            var WEEK = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

            var charts = {};
            var lastData = null;
            var optionsBuilt = false;
            var forcePrintLight = false;
            var state = { report: "overview" };

            // ---------- small utils ----------
            function isDark() { return document.body.getAttribute("data-theme") === "dark"; }
            function theme() {
                var dark = !forcePrintLight && isDark();
                return { mode: dark ? "dark" : "light", text: dark ? "#d8cfe6" : "#4b4459", grid: dark ? "rgba(255,255,255,0.08)" : "rgba(0,0,0,0.08)" };
            }
            function money(n) { return "R" + (Number(n) || 0).toLocaleString("en-ZA", { minimumFractionDigits: 0, maximumFractionDigits: 0 }); }
            // Compact money for axis ticks (e.g. R90k, R1.2m) so labels don't collide.
            function moneyShort(n) {
                n = Number(n) || 0; var a = Math.abs(n);
                if (a >= 1e6) return "R" + (n / 1e6).toFixed(a >= 1e7 ? 0 : 1).replace(/\.0$/, "") + "m";
                if (a >= 1e3) return "R" + Math.round(n / 1e3) + "k";
                return "R" + Math.round(n);
            }
            function num(n) { return (Number(n) || 0).toLocaleString("en-ZA"); }
            function pct(n) { return Math.round((Number(n) || 0) * 100) + "%"; }
            function pad(n) { return (n < 10 ? "0" : "") + n; }
            function el(id) { return document.getElementById(id); }
            function setHtml(sel, markup) { var e = document.querySelector(sel); if (e) e.innerHTML = markup; }
            function col(rows, name) { return (rows || []).map(function (r) { return r[name]; }); }

            function base(extra) {
                var t = theme();
                var opts = {
                    chart: { background: "transparent", foreColor: t.text, toolbar: { show: false }, fontFamily: "'Segoe UI', Roboto, Arial, sans-serif" },
                    colors: PALETTE, grid: { borderColor: t.grid }, theme: { mode: t.mode }, tooltip: { theme: t.mode }, dataLabels: { enabled: false }
                };
                return Object.assign(opts, extra || {});
            }
            function chart(extra) { return Object.assign(base().chart, extra || {}); }

            function draw(id, options) {
                var node = document.querySelector(id);
                if (!node) return;
                if (charts[id]) { try { charts[id].destroy(); } catch (e) { } }
                charts[id] = new ApexCharts(node, options);
                charts[id].render();
            }
            function destroyAll() {
                Object.keys(charts).forEach(function (k) { try { charts[k].destroy(); } catch (e) { } });
                charts = {};
            }

            function movingAverage(values, window) {
                var out = [];
                for (var i = 0; i < values.length; i++) {
                    var slice = values.slice(Math.max(0, i - window + 1), i + 1);
                    var sum = slice.reduce(function (a, b) { return a + Number(b || 0); }, 0);
                    out.push(Math.round((sum / slice.length) * 100) / 100);
                }
                return out;
            }

            // long-form rows [{label, series, value}] -> { categories, series:[{name,data}] }
            function pivot(rows, labelKey, seriesKey, valueKey) {
                rows = rows || [];
                var cats = [], catIdx = {}, names = [], nameIdx = {};
                rows.forEach(function (r) {
                    var c = r[labelKey], n = r[seriesKey];
                    if (!(c in catIdx)) { catIdx[c] = cats.length; cats.push(c); }
                    if (!(n in nameIdx)) { nameIdx[n] = names.length; names.push(n); }
                });
                var series = names.map(function (n) { return { name: n, data: cats.map(function () { return 0; }) }; });
                rows.forEach(function (r) { series[nameIdx[r[seriesKey]]].data[catIdx[r[labelKey]]] = Number(r[valueKey] || 0); });
                return { categories: cats, series: series };
            }

            function tableHtml(sel, cols, rows) {
                var head = "<tr>" + cols.map(function (c) { return "<th>" + c.h + "</th>"; }).join("") + "</tr>";
                var body = (rows || []).map(function (r) {
                    return "<tr>" + cols.map(function (c) {
                        var v = c.f ? c.f(r[c.k], r) : (r[c.k] == null ? "" : r[c.k]);
                        return "<td" + (c.num ? " class='num'" : "") + ">" + v + "</td>";
                    }).join("") + "</tr>";
                }).join("");
                setHtml(sel, "<table class='bi-table'>" + head + body + "</table>");
            }
            function pyNote(sel) {
                setHtml(sel, "<div class='bi-note'>This report is produced by the Python builder.<br>Run <code>python analysis/build_reports.py</code> to generate it, then reload.</div>");
            }
            function hasPy(d) { return d && d.python && typeof d.python === "object"; }

            function renderKpis(k) {
                k = k || {};
                var cards = [
                    { label: "Total Revenue", value: money(k.Revenue) },
                    { label: "Orders", value: num(k.Orders) },
                    { label: "Avg Order Value", value: money(k.AverageOrderValue) },
                    { label: "Units Sold", value: num(k.Units) },
                    { label: "Customers", value: num(k.Customers) },
                    { label: "Completion Rate", value: pct(k.CompletionRate) }
                ];
                el("biKpis").innerHTML = cards.map(function (c) {
                    return '<div class="bi-kpi"><div class="label">' + c.label + '</div><div class="value">' + c.value + '</div></div>';
                }).join("");
            }

            // ---------- individual chart renderers (shared by overview + focused reports) ----------
            function rTrend(d) {
                var rev = col(d.trend, "Revenue").map(Number);
                draw("#chartTrend", base({
                    chart: chart({ type: "line", height: 300 }),
                    series: [{ name: "Revenue", type: "area", data: rev }, { name: "3-mo avg", type: "line", data: movingAverage(rev, 3) }],
                    stroke: { width: [2, 3], curve: "smooth", dashArray: [0, 5] },
                    fill: { type: ["gradient", "solid"], opacity: [0.35, 1] },
                    xaxis: { categories: col(d.trend, "Label") },
                    yaxis: { labels: { formatter: money } }
                }));
            }
            function rTrendSmart(d) {
                var daily = d.trendDaily || [];
                var useDaily = daily.length > 1 && daily.length <= 62;
                var src = useDaily ? daily : (d.trend || []);
                var rev = col(src, "Revenue").map(Number);
                var series = [{ name: "Revenue", type: "area", data: rev }];
                if (!useDaily) series.push({ name: "3-mo avg", type: "line", data: movingAverage(rev, 3) });
                draw("#chartTrend", base({
                    chart: chart({ type: "line", height: 300 }),
                    series: series,
                    stroke: { width: useDaily ? [2] : [2, 3], curve: "smooth", dashArray: useDaily ? [0] : [0, 5] },
                    fill: { type: useDaily ? ["gradient"] : ["gradient", "solid"], opacity: useDaily ? [0.35] : [0.35, 1] },
                    xaxis: { categories: col(src, "Label") },
                    yaxis: { labels: { formatter: money } }
                }));
            }
            function rAov(d) {
                draw("#chartAov", base({
                    chart: chart({ type: "line", height: 300 }),
                    series: [{ name: "Avg order value", data: col(d.aov, "Value").map(Number) }],
                    stroke: { width: 3, curve: "smooth" }, markers: { size: 4 },
                    xaxis: { categories: col(d.aov, "Label") }, yaxis: { labels: { formatter: money } }
                }));
            }
            function rPayment(d) {
                draw("#chartPayment", base({ chart: chart({ type: "donut", height: 300 }), series: col(d.payment, "Value").map(Number), labels: col(d.payment, "Label"), legend: { position: "bottom" } }));
            }
            function rChannel(d) {
                draw("#chartChannel", base({ chart: chart({ type: "donut", height: 300 }), series: col(d.channel, "Value").map(Number), labels: col(d.channel, "Label"), legend: { position: "bottom" } }));
            }
            function rStatusFunnel(d) {
                draw("#chartStatus", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Orders", data: col(d.status, "Value").map(Number) }],
                    plotOptions: { bar: { horizontal: true, distributed: true, barHeight: "75%", isFunnel: true } },
                    dataLabels: {
                        enabled: true, style: { colors: ["#111111"], fontWeight: 700 }, dropShadow: { enabled: false },
                        formatter: function (v, o) { return col(d.status, "Label")[o.dataPointIndex] + ": " + num(v); }
                    },
                    xaxis: { categories: col(d.status, "Label") }, legend: { show: false }
                }));
            }
            function rCategory(d) {
                draw("#chartCategory", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Revenue", data: col(d.category, "Revenue").map(Number) }],
                    plotOptions: { bar: { borderRadius: 6, columnWidth: "55%" } },
                    xaxis: { categories: col(d.category, "Label") }, yaxis: { labels: { formatter: money } }
                }));
            }
            function rTopProducts(d) {
                draw("#chartTopProducts", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Units", data: col(d.topProducts, "Units").map(Number) }],
                    plotOptions: { bar: { horizontal: true, borderRadius: 4, barHeight: "70%" } },
                    xaxis: { categories: col(d.topProducts, "Label") }
                }));
            }
            function rCategoryMix(d) {
                var p = pivot(d.categoryMix, "Label", "Category", "Revenue");
                draw("#chartCategoryMix", base({
                    chart: chart({ type: "bar", height: 320, stacked: true }),
                    series: p.series, xaxis: { categories: p.categories },
                    plotOptions: { bar: { columnWidth: "60%" } }, yaxis: { labels: { formatter: money } }, legend: { position: "bottom" }
                }));
            }
            function rSize(d) {
                draw("#chartSize", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Units", data: col(d.size, "Value").map(Number) }],
                    plotOptions: { bar: { borderRadius: 6, columnWidth: "55%", distributed: true } },
                    xaxis: { categories: col(d.size, "Label") }, legend: { show: false }
                }));
            }
            function rColour(d) {
                draw("#chartColour", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Units", data: col(d.colour, "Value").map(Number) }],
                    plotOptions: { bar: { borderRadius: 6, columnWidth: "55%", distributed: true } },
                    xaxis: { categories: col(d.colour, "Label") }, legend: { show: false }
                }));
            }
            function rRegion(d) {
                draw("#chartRegion", base({
                    chart: chart({ type: "bar", height: 360 }),
                    series: [{ name: "Revenue", data: col(d.region, "Revenue").map(Number) }],
                    plotOptions: { bar: { horizontal: true, borderRadius: 4, barHeight: "70%" } },
                    dataLabels: { enabled: false },
                    xaxis: { categories: col(d.region, "Label"), tickAmount: 4, labels: { formatter: moneyShort, rotate: 0, hideOverlappingLabels: true } }
                }));
            }
            function rStatusTrend(d) {
                var p = pivot(d.statusTrend, "Label", "Status", "Value");
                draw("#chartStatusTrend", base({
                    chart: chart({ type: "bar", height: 300, stacked: true }),
                    series: p.series, xaxis: { categories: p.categories }, legend: { position: "bottom" }
                }));
            }
            function rCompletion(d) {
                draw("#chartCompletion", base({
                    chart: chart({ type: "line", height: 300 }),
                    series: [{ name: "Completion %", data: col(d.completion, "Value").map(Number) }],
                    stroke: { width: 3, curve: "smooth" }, markers: { size: 4 },
                    xaxis: { categories: col(d.completion, "Label") },
                    yaxis: { min: 0, max: 100, labels: { formatter: function (v) { return Math.round(v) + "%"; } } }
                }));
            }
            function rLeadTime(d) {
                draw("#chartLeadTime", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Avg days", data: col(d.leadTime, "Value").map(Number) }],
                    plotOptions: { bar: { horizontal: true, borderRadius: 4, barHeight: "65%", distributed: true } },
                    xaxis: { categories: col(d.leadTime, "Label") }, legend: { show: false }
                }));
            }
            function rDelivery(d) {
                draw("#chartDelivery", base({ chart: chart({ type: "donut", height: 300 }), series: col(d.delivery, "Value").map(Number), labels: col(d.delivery, "Label"), legend: { position: "bottom" } }));
            }
            function rByMonth(d) {
                draw("#chartByMonth", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Revenue", data: col(d.byMonth, "Revenue").map(Number) }],
                    plotOptions: { bar: { borderRadius: 6, columnWidth: "55%" } },
                    xaxis: { categories: col(d.byMonth, "Label") }, yaxis: { labels: { formatter: money } }
                }));
            }
            function rByWeekday(d) {
                var rows = (d.byWeekday || []).slice().sort(function (a, b) { return WEEK.indexOf(a.Label) - WEEK.indexOf(b.Label); });
                draw("#chartByWeekday", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Orders", data: rows.map(function (r) { return Number(r.Value) || 0; }) }],
                    plotOptions: { bar: { borderRadius: 6, columnWidth: "55%", distributed: true } },
                    xaxis: { categories: rows.map(function (r) { return r.Label; }) }, legend: { show: false }
                }));
            }
            function rByHour(d) {
                draw("#chartByHour", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Orders", data: col(d.byHour, "Value").map(Number) }],
                    plotOptions: { bar: { borderRadius: 3, columnWidth: "70%" } },
                    xaxis: { categories: col(d.byHour, "Label") }
                }));
            }
            function rForecast(d) {
                if (!hasPy(d)) { pyNote("#chartForecast"); return; }
                var hist = d.python.history || [], fc = d.python.forecast || [];
                var labels = hist.map(function (r) { return r.Label; }).concat(fc.map(function (r) { return r.Label; }));
                var rev = hist.map(function (r) { return Number(r.Revenue) || 0; }).concat(fc.map(function () { return null; }));
                var lin = hist.map(function () { return null; });
                if (hist.length) lin[hist.length - 1] = Number(hist[hist.length - 1].Revenue) || 0;
                lin = lin.concat(fc.map(function (r) { return Number(r.Linear) || 0; }));
                var series = [{ name: "Revenue", data: rev }, { name: "Forecast", data: lin }];
                if (fc.some(function (r) { return r.HoltWinters != null; })) {
                    var hw = hist.map(function () { return null; });
                    if (hist.length) hw[hist.length - 1] = Number(hist[hist.length - 1].Revenue) || 0;
                    hw = hw.concat(fc.map(function (r) { return r.HoltWinters == null ? null : Number(r.HoltWinters); }));
                    series.push({ name: "Holt-Winters", data: hw });
                }
                draw("#chartForecast", base({
                    chart: chart({ type: "line", height: 320 }),
                    series: series, stroke: { width: [3, 2, 2], curve: "smooth", dashArray: [0, 6, 4] }, markers: { size: 3 },
                    xaxis: { categories: labels }, yaxis: { labels: { formatter: money } }, legend: { position: "bottom" }
                }));
            }
            // Customers (Python)
            function rRfm(d) {
                if (!hasPy(d)) { pyNote("#chartRfm"); return; }
                var seg = (d.python.rfm && d.python.rfm.segments) || [];
                draw("#chartRfm", base({
                    chart: chart({ type: "bar", height: 320 }),
                    series: [{ name: "Customers", data: seg.map(function (r) { return Number(r.Customers) || 0; }) }],
                    plotOptions: { bar: { horizontal: true, borderRadius: 4, barHeight: "70%", distributed: true } },
                    xaxis: { categories: seg.map(function (r) { return r.Label; }) }, legend: { show: false }
                }));
            }
            function rNewReturning(d) {
                if (!hasPy(d)) { pyNote("#chartNewReturning"); return; }
                var nr = d.python.newVsReturning || [];
                draw("#chartNewReturning", base({
                    chart: chart({ type: "bar", height: 300, stacked: true }),
                    series: [{ name: "New", data: nr.map(function (r) { return Number(r.New) || 0; }) }, { name: "Returning", data: nr.map(function (r) { return Number(r.Returning) || 0; }) }],
                    plotOptions: { bar: { columnWidth: "55%" } }, xaxis: { categories: nr.map(function (r) { return r.Label; }) }, legend: { position: "bottom" }
                }));
            }
            function rTopCustomers(d) {
                if (!hasPy(d)) { pyNote("#tblTopCustomers"); return; }
                tableHtml("#tblTopCustomers",
                    [{ h: "Customer", k: "Customer" }, { h: "Orders", k: "Orders", num: true, f: num }, { h: "Revenue", k: "Revenue", num: true, f: money }, { h: "AOV", k: "AOV", num: true, f: money }],
                    d.python.topCustomers);
            }
            function rRepeat(d) {
                if (!hasPy(d)) { pyNote("#custRepeat"); return; }
                setHtml("#custRepeat", "<div class='bi-stat-big'><div class='value'>" + pct(d.python.repeatRate) + "</div><div class='label'>customers with 2 or more orders</div></div>");
            }
            // Basket (Python)
            function rBasketStats(d) {
                if (!hasPy(d)) { pyNote("#basketStats"); return; }
                var po = d.python.perOrder || {};
                setHtml("#basketStats",
                    "<div class='bi-stat-row'><span>Avg items / order</span><b>" + (Number(po.avgItems) || 0).toFixed(1) + "</b></div>" +
                    "<div class='bi-stat-row'><span>Avg value / order</span><b>" + money(po.avgValue) + "</b></div>" +
                    "<div class='bi-stat-row'><span>Distinct lines / order</span><b>" + (Number(po.avgLines) || 0).toFixed(1) + "</b></div>");
            }
            function rUnitsDist(d) {
                if (!hasPy(d)) { pyNote("#chartUnitsDist"); return; }
                var u = d.python.unitsDistribution || [];
                draw("#chartUnitsDist", base({
                    chart: chart({ type: "bar", height: 300 }),
                    series: [{ name: "Orders", data: u.map(function (r) { return Number(r.Value) || 0; }) }],
                    plotOptions: { bar: { borderRadius: 6, columnWidth: "55%" } },
                    xaxis: { categories: u.map(function (r) { return r.Label; }), title: { text: "items in order" } }
                }));
            }
            function rAffinity(d) {
                if (!hasPy(d)) { pyNote("#tblAffinity"); return; }
                tableHtml("#tblAffinity",
                    [{ h: "Bought", k: "A" }, { h: "Also bought", k: "B" },
                     { h: "Support", k: "Support", num: true, f: pct }, { h: "Confidence", k: "Confidence", num: true, f: pct },
                     { h: "Lift", k: "Lift", num: true, f: function (v) { return (Number(v) || 0).toFixed(2); } }],
                    d.python.affinity);
            }

            // ---------- report definitions ----------
            var REPORTS = {
                overview: {
                    label: "Overview (All)", subtitle: "Live sales analytics for administrators",
                    cards: [
                        { id: "chartTrend", title: "Revenue Trend (with 3-month average)", span: 2, render: rTrend },
                        { id: "chartStatus", title: "Order Status Funnel", render: rStatusFunnel },
                        { id: "chartCategory", title: "Revenue by Category", render: rCategory },
                        { id: "chartTopProducts", title: "Top 10 Products (units)", render: rTopProducts },
                        { id: "chartRegion", title: "Top Regions (revenue)", render: rRegion },
                        { id: "chartPayment", title: "Payment Methods", render: rPayment },
                        { id: "chartChannel", title: "Sales Channel", render: rChannel },
                        { id: "chartSize", title: "Size Popularity (units)", render: rSize },
                        { id: "chartColour", title: "Colour Popularity (units)", render: rColour }
                    ]
                },
                sales: {
                    label: "Sales", subtitle: "Revenue, order value and how orders are paid & placed",
                    cards: [
                        { id: "chartTrend", title: "Revenue Trend", span: 2, render: rTrendSmart },
                        { id: "chartStatus", title: "Order Status Funnel", render: rStatusFunnel },
                        { id: "chartAov", title: "Average Order Value (monthly)", span: 2, render: rAov },
                        { id: "chartPayment", title: "Payment Methods", render: rPayment },
                        { id: "chartChannel", title: "Sales Channel", render: rChannel }
                    ]
                },
                products: {
                    label: "Products", subtitle: "What sells, by category, product, size and colour",
                    cards: [
                        { id: "chartCategory", title: "Revenue by Category", render: rCategory },
                        { id: "chartTopProducts", title: "Top 10 Products (units)", render: rTopProducts },
                        { id: "chartCategoryMix", title: "Category Mix Over Time", render: rCategoryMix },
                        { id: "chartSize", title: "Size Popularity (units)", render: rSize },
                        { id: "chartColour", title: "Colour Popularity (units)", render: rColour }
                    ]
                },
                customers: {
                    label: "Customers", subtitle: "Segments, loyalty and the highest-value customers (generated by Python)",
                    cards: [
                        { id: "chartRfm", title: "RFM Segments", render: rRfm },
                        { id: "custRepeat", title: "Repeat-Purchase Rate", render: rRepeat },
                        { id: "chartNewReturning", title: "New vs Returning (monthly)", span: 2, render: rNewReturning },
                        { id: "tblTopCustomers", title: "Top Customers", render: rTopCustomers }
                    ]
                },
                operations: {
                    label: "Operations / Fulfilment", subtitle: "Order flow, completion, lead time and delivery",
                    cards: [
                        { id: "chartStatusTrend", title: "Order Status Over Time", span: 2, render: rStatusTrend },
                        { id: "chartCompletion", title: "Completion Rate Trend", render: rCompletion },
                        { id: "chartLeadTime", title: "Avg Production Lead Time by Category (days)", span: 2, render: rLeadTime },
                        { id: "chartDelivery", title: "Delivery: Free vs Paid", render: rDelivery }
                    ]
                },
                seasonality: {
                    label: "Seasonality & Forecast", subtitle: "When demand happens, and where it's heading",
                    cards: [
                        { id: "chartByMonth", title: "Revenue by Calendar Month", render: rByMonth },
                        { id: "chartByWeekday", title: "Orders by Day of Week", render: rByWeekday },
                        { id: "chartByHour", title: "Orders by Hour of Day", render: rByHour },
                        { id: "chartForecast", title: "Revenue Forecast (next 3 months, Python)", span: 2, render: rForecast }
                    ]
                },
                basket: {
                    label: "Basket / Affinity", subtitle: "Basket size and which products sell together (generated by Python)",
                    cards: [
                        { id: "basketStats", title: "Per-Order Basket", render: rBasketStats },
                        { id: "chartUnitsDist", title: "Items per Order (distribution)", render: rUnitsDist },
                        { id: "tblAffinity", title: "Frequently Bought Together", span: 2, render: rAffinity }
                    ]
                },
                geography: {
                    label: "Geography", subtitle: "Where revenue comes from",
                    cards: [
                        { id: "chartRegion", title: "Top Suburbs by Revenue", span: 2, render: rRegion }
                    ]
                }
            };

            function buildCards(rep) {
                destroyAll();
                el("reportGrid").innerHTML = rep.cards.map(function (c) {
                    return '<div class="bi-card' + (c.span === 2 ? ' bi-col-2' : '') + '"><h3>' + c.title + '</h3><div id="' + c.id + '"></div></div>';
                }).join("");
            }

            function renderActive(d) {
                lastData = d;
                var rep = REPORTS[state.report] || REPORTS.overview;
                el("reportSubtitle").textContent = rep.subtitle || "";

                // generated-on caption for the Python-backed reports
                var gen = el("biGen");
                if (hasPy(d) && d.python.generatedAt) { gen.textContent = "Python snapshot generated " + d.python.generatedAt; gen.style.display = "block"; }
                else { gen.style.display = "none"; }

                renderKpis(d.kpis);

                if (!optionsBuilt) {
                    fillSelect("fStatus", (d.filterOptions || {}).statuses, "All status");
                    fillSelect("fChannel", (d.filterOptions || {}).channels, "All channels");
                    optionsBuilt = true;
                }

                buildCards(rep);
                rep.cards.forEach(function (c) { try { c.render(d); } catch (e) { console.error("render " + c.id, e); } });
            }

            function fillSelect(id, values, allLabel) {
                var sel = el(id); if (!sel) return;
                var current = sel.value;
                sel.innerHTML = '<option value="All">' + (allLabel || "All") + '</option>' + (values || []).map(function (v) { return '<option value="' + v + '">' + v + '</option>'; }).join("");
                if (current) sel.value = current;
            }

            // ---------- period handling ----------
            function computePeriod() {
                var from = el("fFrom").value, to = el("fTo").value;
                if (from || to) return { from: from, to: to, label: "Custom (" + (from || "start") + " to " + (to || "today") + ")" };

                var y = el("fYear").value, m = el("fMonth").value;
                if (!y && !m) return { from: "", to: "", label: "All time" };
                if (y && !m) return { from: y + "-01-01", to: y + "-12-31", label: y };
                if (!y && m) y = String(new Date().getFullYear());
                var mm = parseInt(m, 10);
                var last = new Date(parseInt(y, 10), mm, 0).getDate();
                return { from: y + "-" + pad(mm) + "-01", to: y + "-" + pad(mm) + "-" + pad(last), label: MONTHS[mm - 1] + " " + y };
            }

            function applyPreset(name) {
                var now = new Date(), y = now.getFullYear(), m = now.getMonth() + 1;
                el("fFrom").value = ""; el("fTo").value = "";
                if (name === "thisMonth") { el("fYear").value = String(y); el("fMonth").value = String(m); }
                else if (name === "lastMonth") { var lm = m === 1 ? 12 : m - 1, ly = m === 1 ? y - 1 : y; el("fYear").value = String(ly); el("fMonth").value = String(lm); }
                else if (name === "thisYear") { el("fYear").value = String(y); el("fMonth").value = ""; }
                else if (name === "ytd") { el("fYear").value = ""; el("fMonth").value = ""; el("fFrom").value = y + "-01-01"; el("fTo").value = y + "-" + pad(m) + "-" + pad(now.getDate()); }
                else if (name === "all") { el("fYear").value = ""; el("fMonth").value = ""; }
                el("fPreset").value = name;
                load();
            }

            function updateSummary() {
                el("periodSummary").textContent = "Showing " + computePeriod().label;
            }

            function buildUrl() {
                var p = computePeriod();
                var params = ["report=" + encodeURIComponent(state.report)];
                if (p.from) params.push("from=" + encodeURIComponent(p.from));
                if (p.to) params.push("to=" + encodeURIComponent(p.to));
                var st = el("fStatus").value, ch = el("fChannel").value;
                if (st && st !== "All") params.push("status=" + encodeURIComponent(st));
                if (ch && ch !== "All") params.push("channel=" + encodeURIComponent(ch));
                return HANDLER_URL + "?" + params.join("&");
            }

            function load() {
                var loading = el("biLoading"), error = el("biError");
                updateSummary();
                loading.style.display = "block"; error.style.display = "none";
                fetch(buildUrl(), { credentials: "same-origin" })
                    .then(function (r) { if (!r.ok) throw new Error("Server returned " + r.status); return r.json(); })
                    .then(function (d) { if (d.error) throw new Error(d.error); renderActive(d); loading.style.display = "none"; })
                    .catch(function (e) { loading.style.display = "none"; error.textContent = "Could not load report data: " + e.message; error.style.display = "block"; });
            }

            // ---------- Excel export (formatted multi-sheet workbook + embedded charts) ----------
            // Single source of truth for the look of the workbook, so every sheet is consistent.
            var XL_BRAND = "FF4B2E83";        // Troika purple - header bands and titles
            var XL_WHITE = "FFFFFFFF";
            var XL_MONEY = '"R"#,##0.00';     // currency columns (matches the KPI sheet)
            var XL_COUNT = '#,##0';           // whole-number / count columns
            var XL_PCT = '0.0%';              // percentage columns (values stored as fractions)

            var DATASET_LABELS = {
                trend: "Sales Trend", trendDaily: "Sales Trend (Daily)", aov: "Average Order Value Trend",
                category: "Revenue by Category", topProducts: "Top Products", payment: "Payment Methods",
                channel: "Sales Channels", status: "Order Status", region: "Sales by Region",
                size: "Size Breakdown", colour: "Colour Breakdown", categoryMix: "Category Mix Over Time",
                statusTrend: "Status Trend", completion: "Completion Trend", leadTime: "Lead Time by Category",
                delivery: "Delivery Split", byMonth: "Seasonality by Month", byWeekday: "Seasonality by Weekday",
                byHour: "Seasonality by Hour"
            };
            function prettyLabel(k) {
                return DATASET_LABELS[k] || String(k).replace(/([a-z])([A-Z])/g, "$1 $2").replace(/^./, function (c) { return c.toUpperCase(); });
            }
            function isRowArray(v) {
                return Array.isArray(v) && v.length > 0 && v[0] && typeof v[0] === "object" && !Array.isArray(v[0]);
            }

            // Money is reliably named "Revenue"/"Price" in the report SQL. The generic "Value" column
            // is NOT money for most datasets (it is a COUNT for payment/status/channel/weekday/hour,
            // units for size/colour, days for lead time, a percentage for completion) - so it must not
            // get the R prefix. The one exception is the AOV trend, where "Value" is a money amount.
            function isMoneyCol(name) { return /\b(revenue|price|aov|spend|cost|fee)\b/i.test(name); }
            function isCountCol(name) { return /\b(orders?|units?|customers?|count|qty|quantity)\b/i.test(name); }
            function isPercentCol(name) { return /\b(rate|percent|percentage|share|pct|ratio|conversion)\b/i.test(name); }
            function isGenericValueCol(name) { return /^(value|v)$/i.test(name); }
            var MONEY_VALUE_DATASETS = { aov: 1 };   // datasets whose generic "Value" column is money

            function allIntegers(rows, key) {
                var any = false;
                for (var i = 0; i < rows.length; i++) {
                    var v = rows[i][key];
                    if (v == null || v === "" || isNaN(v) || !isFinite(v) || typeof v === "boolean") continue;
                    any = true;
                    if (Number(v) % 1 !== 0) return false;
                }
                return any;
            }

            // Pick a number format for a column, consistent with the KPI sheet. Detection runs on the
            // display label (spaced) so camelCase keys like "CompletionRate" are matched correctly.
            function columnNumFmt(label, rows, key, datasetKey) {
                var genericValue = isGenericValueCol(label);
                if (isMoneyCol(label) || (genericValue && MONEY_VALUE_DATASETS[datasetKey])) return XL_MONEY;
                if (isPercentCol(label)) {
                    // Only treat as % when stored as fractions (|v| <= 1); otherwise leave the raw
                    // number so a 0-100 value isn't wrongly multiplied to a 0-10000% display.
                    var anyNumeric = false, allFraction = true;
                    for (var i = 0; i < rows.length; i++) {
                        var v = rows[i][key];
                        if (v == null || v === "" || isNaN(v) || !isFinite(v) || typeof v === "boolean") continue;
                        anyNumeric = true;
                        if (Math.abs(Number(v)) > 1) { allFraction = false; break; }
                    }
                    if (anyNumeric && allFraction) return XL_PCT;
                }
                if (isCountCol(label)) return XL_COUNT;
                // Generic whole-number metric (e.g. the Value count on payment/status) -> thousands, no R.
                if (genericValue && allIntegers(rows, key)) return XL_COUNT;
                return null;
            }

            function styleHeaderRow(ws, colCount) {
                var hr = ws.getRow(1);
                hr.font = { bold: true, color: { argb: XL_WHITE } };
                hr.fill = { type: "pattern", pattern: "solid", fgColor: { argb: XL_BRAND } };
                hr.alignment = { vertical: "middle" };
                hr.height = 18;
                ws.views = [{ state: "frozen", ySplit: 1 }];
                if (colCount > 0) ws.autoFilter = { from: { row: 1, column: 1 }, to: { row: 1, column: colCount } };
            }

            function sheetName(raw, used) {
                var n = String(raw).replace(/[\\\/\?\*\[\]:]/g, " ").replace(/\s+/g, " ").trim().slice(0, 28) || "Sheet";
                var base = n, i = 2;
                while (used[n.toLowerCase()]) { n = base.slice(0, 25) + " " + i; i++; }
                used[n.toLowerCase()] = true; return n;
            }

            function addInfoSheet(wb, rep) {
                var ws = wb.addWorksheet("Report Info");
                ws.columns = [{ width: 22 }, { width: 54 }];
                ws.mergeCells("A1:B1");
                var title = ws.getCell("A1");
                title.value = "Troika Business Intelligence";
                title.font = { bold: true, size: 15, color: { argb: XL_WHITE } };
                title.fill = { type: "pattern", pattern: "solid", fgColor: { argb: XL_BRAND } };
                title.alignment = { vertical: "middle" };
                ws.getRow(1).height = 22;
                ws.addRow([]);
                var p = computePeriod();
                var st = el("fStatus").value, ch = el("fChannel").value;
                [["Report", rep.label], ["Period", p.label],
                 ["Status filter", (st && st !== "All") ? st : "All"],
                 ["Channel filter", (ch && ch !== "All") ? ch : "All"],
                 ["Generated", new Date().toLocaleString("en-ZA")]
                ].forEach(function (r) { ws.addRow(r).getCell(1).font = { bold: true }; });
            }

            function addKpiSheet(wb, k) {
                k = k || {};
                var ws = wb.addWorksheet("KPIs");
                ws.columns = [{ header: "Metric", width: 24 }, { header: "Value", width: 18 }];
                var defs = [
                    ["Total Revenue", k.Revenue, XL_MONEY],
                    ["Orders", k.Orders, XL_COUNT],
                    ["Avg Order Value", k.AverageOrderValue, XL_MONEY],
                    ["Units Sold", k.Units, XL_COUNT],
                    ["Customers", k.Customers, XL_COUNT],
                    ["Completion Rate", k.CompletionRate, XL_PCT]
                ];
                defs.forEach(function (d) {
                    var row = ws.addRow([d[0], d[1] == null ? "" : Number(d[1])]);
                    row.getCell(1).font = { bold: true };
                    if (d[1] != null) row.getCell(2).numFmt = d[2];
                });
                styleHeaderRow(ws, 2);
            }

            function addTableSheet(wb, title, rows, used, suffix, datasetKey) {
                var cols = [], seen = {};
                rows.forEach(function (r) { Object.keys(r).forEach(function (c) { if (!seen[c]) { seen[c] = true; cols.push(c); } }); });
                if (!cols.length) return;
                var ws = wb.addWorksheet(sheetName(title + (suffix || ""), used));
                ws.columns = cols.map(function (c) {
                    var h = prettyLabel(c);
                    return { header: h, key: c, width: Math.max(12, Math.min(38, h.length + 4)) };
                });
                rows.forEach(function (r) {
                    var vals = cols.map(function (c) {
                        var v = r[c];
                        if (v != null && v !== "" && !isNaN(v) && isFinite(v) && typeof v !== "boolean") return Number(v);
                        return v == null ? "" : v;
                    });
                    ws.addRow(vals);
                });
                cols.forEach(function (c, i) {
                    var fmt = columnNumFmt(prettyLabel(c), rows, c, datasetKey);
                    if (fmt) ws.getColumn(i + 1).numFmt = fmt;
                });
                styleHeaderRow(ws, cols.length);
            }

            // Re-render charts in light theme (if currently dark) and grab a PNG of each.
            function captureCharts() {
                var rep = REPORTS[state.report] || REPORTS.overview;
                var wasDark = isDark();
                var prep = Promise.resolve();
                if (wasDark) { forcePrintLight = true; renderActive(lastData); prep = new Promise(function (res) { setTimeout(res, 450); }); }
                return prep.then(function () {
                    var jobs = (rep.cards || []).map(function (card) {
                        var inst = charts["#" + card.id];
                        if (!inst || typeof inst.dataURI !== "function") return null;
                        return inst.dataURI({ scale: 2 }).then(function (out) {
                            return (out && out.imgURI) ? { title: card.title, uri: out.imgURI } : null;
                        }).catch(function () { return null; });
                    }).filter(Boolean);
                    return Promise.all(jobs);
                }).then(function (imgs) {
                    if (wasDark) { forcePrintLight = false; renderActive(lastData); }
                    return imgs.filter(Boolean);
                });
            }

            function addChartsSheet(wb, images) {
                if (!images.length) return;
                var ws = wb.addWorksheet("Charts");
                ws.getColumn(1).width = 4;
                var row = 1;
                images.forEach(function (im) {
                    var cell = ws.getCell(row, 2);
                    cell.value = im.title;
                    cell.font = { bold: true, size: 13, color: { argb: XL_BRAND } };
                    var b64 = im.uri.indexOf(",") >= 0 ? im.uri.split(",")[1] : im.uri;
                    var id = wb.addImage({ base64: b64, extension: "png" });
                    ws.addImage(id, { tl: { col: 1, row: row }, ext: { width: 600, height: 320 } });
                    row += 19;
                });
            }

            function downloadBlob(blob, name) {
                var url = URL.createObjectURL(blob);
                var a = document.createElement("a");
                a.href = url; a.download = name;
                document.body.appendChild(a); a.click(); document.body.removeChild(a);
                setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
            }

            function exportExcel() {
                var error = el("biError"), btn = el("btnExport");
                if (!lastData) { error.textContent = "Nothing to export yet - wait for the report to load."; error.style.display = "block"; return; }
                if (!window.ExcelJS) { error.textContent = "The Excel library is still loading - please try again in a moment."; error.style.display = "block"; return; }
                error.style.display = "none";
                var original = btn.innerHTML;
                btn.disabled = true; btn.textContent = "Building Excel…";

                captureCharts().then(function (images) {
                    var d = lastData, rep = REPORTS[state.report] || REPORTS.overview, used = {};
                    var wb = new ExcelJS.Workbook();
                    wb.creator = "Troika BI"; wb.created = new Date();

                    addInfoSheet(wb, rep);
                    if (d.kpis && typeof d.kpis === "object") addKpiSheet(wb, d.kpis);

                    var skip = { report: 1, kpis: 1, filterOptions: 1, python: 1 };
                    Object.keys(d).forEach(function (key) {
                        if (!skip[key] && isRowArray(d[key])) addTableSheet(wb, prettyLabel(key), d[key], used, "", key);
                    });
                    if (d.python && typeof d.python === "object") {
                        Object.keys(d.python).forEach(function (key) {
                            if (isRowArray(d.python[key])) addTableSheet(wb, prettyLabel(key), d.python[key], used, " (Py)", key);
                        });
                    }
                    addChartsSheet(wb, images);

                    return wb.xlsx.writeBuffer().then(function (buf) {
                        var stamp = new Date().toISOString().slice(0, 10);
                        downloadBlob(new Blob([buf], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }),
                            "troika-" + state.report + "-" + stamp + ".xlsx");
                    });
                }).catch(function (e) {
                    error.textContent = "Could not build the Excel file: " + (e && e.message ? e.message : e);
                    error.style.display = "block";
                }).then(function () {
                    btn.disabled = false; btn.innerHTML = original;
                });
            }

            // ---------- help (context-aware, explains the report on screen) ----------
            function esc(s) { return String(s == null ? "" : s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }

            var FILTER_HELP =
                "<h4>How the filters work</h4>" +
                "<div class='bi-help-graph'><b>Report.</b> The dropdown at the top picks which report you are looking at.</div>" +
                "<div class='bi-help-graph'><b>Period.</b> A quick range - This month, Last month, This year, Year to date, or All time.</div>" +
                "<div class='bi-help-graph'><b>Or month.</b> Pick a specific Month and Year (2025 onward) to see just that month, e.g. January 2026.</div>" +
                "<div class='bi-help-graph'><b>Custom.</b> Pick an exact From / To date range.</div>" +
                "<div class='bi-help-graph'><b>Refine.</b> Limit to a single order Status or sales Channel.</div>" +
                "<div class='bi-help-graph'><b>Auto-apply.</b> Changes take effect immediately (there is no Apply button); Reset clears everything.</div>" +
                "<p style='margin-top:10px;'>Note: the live reports re-query for your filters. The snapshot (Python) reports - Customers, Basket and the Forecast - always show the latest generated snapshot and are not changed by the date filter.</p>";

            // Shown on every report - the two export buttons in the top-right work the same everywhere.
            var EXPORT_HELP =
                "<h4>Saving &amp; exporting</h4>" +
                "<div class='bi-help-graph'><b>Download Excel.</b> Saves the report you are currently looking at - with its period and filters applied - as a formatted Excel (.xlsx) workbook. It contains a <b>Report Info</b> sheet (report name, period and filters used), a <b>KPIs</b> sheet, one sheet per table of figures, and a <b>Charts</b> sheet with each graph as an image. Money and percentage columns are formatted, and the figures are saved as real numbers so you can sort, total and pivot them in Excel.</div>" +
                "<div class='bi-help-graph'><b>Print / Save as PDF.</b> Sends the whole dashboard on screen - the KPI cards and every chart - to your printer, or to \"Save as PDF\", for a quick visual snapshot to share or file.</div>" +
                "<div class='bi-help-graph'><b>Which to use.</b> Choose Excel when you want to work with the numbers; choose PDF when you just want a picture of the dashboard as it looks now.</div>" +
                "<p style='margin-top:10px;'>Both exports capture exactly what is on screen, so set the Report, Period and Refine filters first, then export.</p>";

            // Shown on every report - the six KPI cards across the top are the same on each screen.
            var KPI_HELP =
                "<h4>The KPI cards (across the top of every report)</h4>" +
                "<div class='bi-help-graph'><b>Total Revenue.</b> Money taken in - the sum of every order's paid total. This is the amount actually charged, so it includes delivery and is after any discount.</div>" +
                "<div class='bi-help-graph'><b>Orders.</b> The number of orders (sales) that match the current filter.</div>" +
                "<div class='bi-help-graph'><b>Avg Order Value.</b> Total Revenue divided by Orders - the typical amount spent per order.</div>" +
                "<div class='bi-help-graph'><b>Units Sold.</b> The total number of individual items sold across those orders.</div>" +
                "<div class='bi-help-graph'><b>Customers.</b> How many different customers placed those orders.</div>" +
                "<div class='bi-help-graph'><b>Completion Rate.</b> The share of those orders marked Completed - a quick gauge of how much of the order book is being fulfilled.</div>";

            var HELP = {
                overview: {
                    intro: "The executive view - every headline chart on one screen. Each chart is explained in its own focused report (Sales, Products, and so on); this is the same set combined.",
                    graphs: [
                        { t: "Revenue Trend", d: "Monthly revenue with a 3-month moving average." },
                        { t: "Order Status Funnel", d: "How orders flow from Placed to Completed to Cancelled." },
                        { t: "Revenue by Category / Top Products", d: "Which categories and products earn and sell the most." },
                        { t: "Top Regions", d: "The highest-earning suburbs." },
                        { t: "Payment / Channel", d: "How customers pay, and Website vs front-desk." },
                        { t: "Size / Colour", d: "The most popular sizes and colours by units sold." }
                    ]
                },
                sales: {
                    intro: "The money view - how revenue moves over time, the typical order value, and how orders are paid and placed.",
                    graphs: [
                        { t: "Revenue Trend", d: "Revenue over time. It switches to a day-by-day view automatically when you pick a single month, otherwise it shows months with a 3-month average." },
                        { t: "Order Status Funnel", d: "Order counts at each status (Placed / Completed / Cancelled)." },
                        { t: "Average Order Value", d: "Average spend per order each month - is the basket growing?" },
                        { t: "Payment Methods", d: "The Card / EFT / Cash split." },
                        { t: "Sales Channel", d: "Website vs front-desk." }
                    ],
                    method: "The 3-month moving average is the average of the last three months at each point. It smooths out one-off spikes so the underlying direction is easier to see."
                },
                products: {
                    intro: "What actually sells - so you can range, restock and merchandise the right items, sizes and colours.",
                    graphs: [
                        { t: "Revenue by Category", d: "Which categories earn the most, measured as Price x quantity." },
                        { t: "Top 10 Products", d: "The best-selling products by units sold." },
                        { t: "Category Mix Over Time", d: "How the share of each category shifts month to month, shown as stacked columns." },
                        { t: "Size Popularity", d: "Units sold by clothing size - what to stock more or less of." },
                        { t: "Colour Popularity", d: "Units sold by colour." }
                    ],
                    method: "Revenue on this report is Price x quantity - the gross value of the items sold, before delivery and discounts. That is deliberately a different figure from the Total Revenue KPI (which is the booked order totals), so these charts won't add up to that number."
                },
                customers: {
                    snapshot: true,
                    intro: "Who your customers are and how loyal they are - the basis for retention, targeting and VIP care.",
                    graphs: [
                        { t: "RFM Segments", d: "Customers grouped into Champions, Loyal, New, At-risk and Hibernating." },
                        { t: "Repeat-Purchase Rate", d: "The share of customers who have ordered two or more times." },
                        { t: "New vs Returning", d: "Each month, how many buyers are brand new vs returning." },
                        { t: "Top Customers", d: "The highest-spending customers, with order count and average order value." }
                    ],
                    method: "RFM scores every customer on three things - Recency (how recently they bought), Frequency (how often) and Monetary (how much) - each ranked into quartiles. Combining the three scores places each customer in a named segment, so you can focus effort: reward Champions, win back the At-risk."
                },
                operations: {
                    intro: "The back-office view - are orders getting completed, how long do they take to make, and how much delivery is being given away.",
                    graphs: [
                        { t: "Order Status Over Time", d: "The monthly Placed / Completed / Cancelled mix, shown as stacked columns." },
                        { t: "Completion Rate Trend", d: "The percentage of orders completed each month." },
                        { t: "Avg Production Lead Time by Category", d: "Average days to make the products in each category - this is what drives the delivery promise." },
                        { t: "Delivery: Free vs Paid", d: "How often delivery is free (orders over R500) vs paid, plus the delivery revenue earned." }
                    ],
                    method: "Completion Rate is 100 x Completed orders / total orders for each month. Free vs Paid delivery is worked out per order by subtracting the value of the items from what was actually paid: a positive difference means the customer paid for delivery, otherwise it was free (orders over R500 ship free)."
                },
                seasonality: {
                    intro: "When demand happens (so you can stock and staff for it) and where it is heading.",
                    graphs: [
                        { t: "Revenue by Calendar Month", d: "Which months of the year are strongest, across all years." },
                        { t: "Orders by Day of Week", d: "Which weekdays are busiest." },
                        { t: "Orders by Hour of Day", d: "Peak trading hours." },
                        { t: "Revenue Forecast", d: "Projected revenue for the next 3 months. This card is a Python snapshot (see below)." }
                    ],
                    method: "The forecast is produced by the Python builder, not live. It fits a simple straight-line trend to the monthly revenue history and extends it three months (the 'Forecast' line). When there is enough history it also draws a Holt-Winters line, which weights recent months more heavily so it reacts faster to a change in trend. Read the two lines as a rough range, not a promise."
                },
                basket: {
                    snapshot: true,
                    intro: "How big baskets are and which products sell together - the inputs for bundling, cross-sell and store layout.",
                    graphs: [
                        { t: "Per-Order Basket", d: "Average items, value and number of distinct product lines per order." },
                        { t: "Items per Order", d: "How many orders contain 1, 2, 3, 4 or 5+ items." },
                        { t: "Frequently Bought Together", d: "Product pairs often bought in the same order, with support, confidence and lift." }
                    ],
                    method: "Frequently-bought-together uses simple association rules. Support is how often a pair appears across all orders; confidence is how often B is bought when A is; lift is how much more often the pair occurs than chance (above 1 means a real association). Pairs with high lift and decent support are the ones worth bundling or recommending."
                },
                geography: {
                    intro: "Where revenue comes from - the basis for regional marketing and delivery planning.",
                    graphs: [
                        { t: "Top Suburbs by Revenue", d: "The highest-earning suburbs, taken from each customer's saved suburb." }
                    ]
                }
            };

            function openHelp() {
                var key = state.report;
                var rep = REPORTS[key] || REPORTS.overview;
                var h = HELP[key] || HELP.overview;
                el("helpTitle").textContent = rep.label;

                var html = "<p class='bi-help-sub'>" + esc(rep.subtitle) + "</p>";
                if (h.snapshot) {
                    html += "<div class='bi-help-badge'>Snapshot report</div>" +
                        "<p>This report is generated by the Python builder (<code>analysis/build_reports.py</code>). It is a point-in-time snapshot - it is not changed by the date filter, so re-run the builder to refresh it.</p>";
                }
                html += "<p>" + esc(h.intro) + "</p>";
                html += KPI_HELP;
                html += "<h4>What each graph shows</h4>" +
                    h.graphs.map(function (g) { return "<div class='bi-help-graph'><b>" + esc(g.t) + ".</b> " + esc(g.d) + "</div>"; }).join("");
                if (h.method) html += "<h4>How it's calculated</h4><div class='bi-help-method'>" + esc(h.method) + "</div>";
                html += FILTER_HELP;
                html += EXPORT_HELP;

                el("helpBody").innerHTML = html;
                el("helpOverlay").style.display = "flex";
            }
            function closeHelp() { el("helpOverlay").style.display = "none"; }

            // ---------- print ----------
            function setPrintStamp() {
                var rep = REPORTS[state.report] || REPORTS.overview;
                var p = computePeriod();
                var parts = ["Report: " + rep.label, "Period: " + p.label];
                var st = el("fStatus").value, ch = el("fChannel").value;
                if (st && st !== "All") parts.push("Status: " + st);
                if (ch && ch !== "All") parts.push("Channel: " + ch);
                el("printStamp").textContent = "Generated " + new Date().toLocaleString("en-ZA") + "  |  " + parts.join("  |  ");
            }
            function printReport() {
                setPrintStamp();
                if (isDark() && lastData) { forcePrintLight = true; renderActive(lastData); setTimeout(function () { window.print(); }, 400); }
                else { window.print(); }
            }

            // ---------- init ----------
            function fillPeriodSelects() {
                // Years from 2025 onward only (the business has no data before 2025).
                var maxY = Math.max(new Date().getFullYear(), 2026);
                var years = ['<option value="">All years</option>'];
                for (var y = maxY; y >= 2025; y--) years.push('<option value="' + y + '">' + y + '</option>');
                el("fYear").innerHTML = years.join("");
                el("fMonth").innerHTML = '<option value="">All months</option>' + MONTHS.map(function (m, i) { return '<option value="' + (i + 1) + '">' + m + '</option>'; }).join("");
            }

            function init() {
                fillPeriodSelects();

                // Report + filters all auto-apply on change (no separate Apply button).
                el("fReport").addEventListener("change", function () { state.report = this.value; load(); });

                // Period dropdown applies a preset; a specific month / custom range marks it "Custom".
                el("fPreset").addEventListener("change", function () { if (this.value !== "custom") applyPreset(this.value); });

                function onMonthYear() { el("fFrom").value = ""; el("fTo").value = ""; el("fPreset").value = "custom"; load(); }
                el("fYear").addEventListener("change", onMonthYear);
                el("fMonth").addEventListener("change", onMonthYear);

                function onCustom() { el("fYear").value = ""; el("fMonth").value = ""; el("fPreset").value = "custom"; load(); }
                el("fFrom").addEventListener("change", onCustom);
                el("fTo").addEventListener("change", onCustom);

                el("fStatus").addEventListener("change", load);
                el("fChannel").addEventListener("change", load);

                el("btnReset").addEventListener("click", function () {
                    el("fStatus").value = "All"; el("fChannel").value = "All";
                    applyPreset("all");
                });
                el("btnPrint").addEventListener("click", printReport);
                el("btnExport").addEventListener("click", exportExcel);

                // Help modal
                el("btnHelp").addEventListener("click", openHelp);
                el("helpClose").addEventListener("click", closeHelp);
                el("helpOverlay").addEventListener("click", function (e) { if (e.target === this) closeHelp(); });
                document.addEventListener("keydown", function (e) { if (e.key === "Escape") closeHelp(); });

                window.addEventListener("beforeprint", setPrintStamp);
                window.addEventListener("afterprint", function () { if (forcePrintLight) { forcePrintLight = false; if (lastData) renderActive(lastData); } });
                new MutationObserver(function () { if (lastData && !forcePrintLight) renderActive(lastData); })
                    .observe(document.body, { attributes: true, attributeFilter: ["data-theme"] });

                el("fPreset").value = "all";
                load();
            }

            if (window.ApexCharts) { init(); } else { window.addEventListener("load", init); }
        })();
    </script>

</asp:Content>
