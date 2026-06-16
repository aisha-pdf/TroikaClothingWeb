<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TroikaClothingWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Kaushan+Script&family=Archivo+Black&display=swap" rel="stylesheet">

    <style>
        /* ===================== HOMEPAGE REDESIGN (scoped to #troika-home) ===================== */

        html { scroll-behavior: smooth; overflow-x: clip; } /* clip (not hidden) so the sticky header keeps working */

        /* Full-bleed: break out of the Bootstrap .container so the purple bands run edge-to-edge */
        #troika-home {
            width: 100vw;
            margin-left: calc(50% - 50vw);
            margin-top: -15px; /* cancel .body-content top margin so the hero sits flush under the nav */
            overflow-x: hidden;
            background: var(--troika-bg);
            color: var(--troika-text);
            font-family: 'Poppins', system-ui, sans-serif;
        }

        /* ---------- Keyframes ---------- */
        @keyframes th-floatY  { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-14px); } }
        @keyframes th-floatYb { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-22px); } }
        @keyframes th-slideInRight { from { opacity: 0; transform: translateX(70px) scale(1.04); } to { opacity: 1; transform: translateX(0) scale(1); } }
        @keyframes th-glowPulse { 0%,100% { box-shadow: 0 14px 34px rgba(20,12,32,0.34); } 50% { box-shadow: 0 14px 46px rgba(20,12,32,0.52); } }
        @keyframes th-heroZoom { from { transform: scale(1); } to { transform: scale(1.09); } }

        /* ---------- Scroll-reveal (transition based, robust against stuck frames) ----------
           Matches the About/Contact entrance: fade up while un-blurring and scaling in. */
        #troika-home .th-reveal {
            opacity: 0;
            transform: translateY(42px) scale(0.985);
            filter: blur(5px);
            transition: opacity 0.85s cubic-bezier(.22,1,.36,1), transform 0.85s cubic-bezier(.22,1,.36,1), filter 0.85s cubic-bezier(.22,1,.36,1), letter-spacing 0.9s cubic-bezier(.22,1,.36,1);
            will-change: opacity, transform, filter;
        }
        #troika-home .th-reveal.th-from-left  { transform: translateX(-34px) scale(0.985); }
        #troika-home .th-reveal.th-in { opacity: 1; transform: none; filter: blur(0); }

        /* ---------- HERO ---------- */
        #troika-home .th-hero {
            position: relative;
            min-height: 600px;
            overflow: hidden;
            background: #3D304C; /* base colour behind the photo layer */
        }
        /* Photo backdrop: the two outfit shots, slowly drifting (Ken-Burns) */
        #troika-home .th-hero-bg { position: absolute; inset: 0; z-index: 0; display: flex; }
        #troika-home .th-hero-bg > div { flex: 1; background-size: cover; background-position: center; }
        #troika-home .th-hero-bg-a { background-image: url('Images/outfit-green.jpg'); animation: th-heroZoom 20s ease-in-out infinite alternate; }
        #troika-home .th-hero-bg-b { background-image: url('Images/outfit-burgundy.jpg'); animation: th-heroZoom 20s ease-in-out -10s infinite alternate; }
        /* Semi-transparent purple gradient so the photos read through it; kept denser on the
           left (where the copy sits) and more see-through toward the centre/right. */
        #troika-home .th-hero-overlay {
            position: absolute; inset: 0; z-index: 1; pointer-events: none;
            background: linear-gradient(118deg, rgba(61,48,76,0.92) 0%, rgba(77,63,100,0.82) 42%, rgba(106,96,148,0.66) 100%);
        }
        #troika-home .th-hero-glow {
            position: absolute; inset: 0; z-index: 2; pointer-events: none;
            background: radial-gradient(circle at 18% 30%, rgba(255,255,255,0.10), transparent 45%);
        }
        #troika-home .th-hero-inner {
            position: relative; z-index: 4;
            max-width: 1240px; margin: 0 auto; padding: 64px 28px 60px;
            display: flex; align-items: center;
        }
        #troika-home .th-hero-copy { max-width: 560px; }
        #troika-home .th-hero-script {
            font-family: 'Kaushan Script', cursive;
            font-size: clamp(34px, 5vw, 58px); color: #ffffff; line-height: 1;
            transform: rotate(-3deg); margin-left: 6px;
        }
        #troika-home .th-hero-script.th-in { transform: rotate(-3deg); }
        #troika-home h1.th-hero-title {
            font-family: 'Archivo Black', sans-serif;
            font-size: clamp(72px, 11vw, 132px); line-height: 0.88; margin: 6px 0 0;
            color: transparent !important; -webkit-text-stroke: 3px #ffffff; letter-spacing: 4px;
        }
        #troika-home h1.th-hero-title.th-reveal { letter-spacing: 16px; }
        #troika-home h1.th-hero-title.th-reveal.th-in { letter-spacing: 4px; }
        #troika-home .th-hero-text {
            margin: 26px 0 0; max-width: 440px; font-size: 13px; line-height: 2;
            letter-spacing: 1.4px; text-transform: uppercase; color: rgba(255,255,255,0.9) !important;
        }
        #troika-home .th-hero-tag {
            font-family: 'Kaushan Script', cursive; font-size: clamp(24px, 3vw, 32px);
            color: #e9e3f7 !important; margin-top: 18px;
        }
        #troika-home a.th-hero-btn {
            display: inline-block; margin-top: 28px; background: #ffffff; color: #3D304C;
            padding: 15px 50px; border-radius: 999px; font-family: 'Poppins', sans-serif;
            font-size: 15px; font-weight: 600; letter-spacing: 1px; text-decoration: none;
            box-shadow: 0 14px 34px rgba(20,12,32,0.34);
            transition: transform 0.2s ease, background 0.2s ease;
            animation: th-glowPulse 3.4s ease-in-out 2.4s infinite;
        }
        #troika-home a.th-hero-btn:hover { transform: translateY(-3px) scale(1.04); background: #f3eef9; color: #3D304C; }

        #troika-home .th-hero-media {
            position: absolute; top: 0; right: 0; bottom: 0; width: 48%;
            display: flex; gap: 5px; z-index: 3;
            clip-path: polygon(15% 0, 100% 0, 100% 100%, 0% 100%);
        }
        #troika-home .th-hero-col { flex: 1; }
        #troika-home .th-hero-col-a { background: url('Images/hoodie-navy.jpg') center 18% / cover; }
        #troika-home .th-hero-col-b { background: url('Images/hoodie-brown.jpg') center / cover; }
        #troika-home .th-hero-media-fade {
            position: absolute; inset: 0; pointer-events: none;
            background: linear-gradient(105deg, rgba(61,48,76,0.55) 0%, rgba(61,48,76,0) 32%);
        }

        /* ---------- FEATURE STRIP ---------- */
        #troika-home .th-features {
            position: relative;
            background: linear-gradient(180deg, #6f6398 0%, #5b4e7e 100%);
        }
        #troika-home .th-wave { position: absolute; left: 0; width: 100%; height: 62px; display: block; }
        #troika-home .th-wave path { fill: var(--troika-bg); }
        #troika-home .th-wave-top { top: 0; }
        #troika-home .th-wave-bottom { bottom: 0; }
        #troika-home .th-features-grid {
            position: relative; max-width: 1180px; margin: 0 auto; padding: 96px 28px;
            display: grid; grid-template-columns: repeat(4, 1fr); align-items: start;
        }
        #troika-home .th-feature {
            text-align: center; padding: 0 16px; cursor: default;
            border-right: 2px dotted rgba(255,255,255,0.4);
            transition: transform 0.3s ease;
        }
        #troika-home .th-feature:last-child { border-right: none; }
        #troika-home .th-feature:hover { transform: translateY(-6px); }
        #troika-home .th-feature svg { display: block; margin: 0 auto; }
        #troika-home .th-feature-label { margin-top: 18px; font-size: 16px; font-weight: 700; color: #ffffff !important; line-height: 1.3; }

        /* ---------- SECTION TITLES ---------- */
        #troika-home .th-section { padding: 74px 0 60px; background: var(--troika-bg); }
        #troika-home .th-section-head { text-align: center; }
        #troika-home h2.th-section-title {
            font-size: clamp(34px, 4.5vw, 52px); font-weight: 800; letter-spacing: 2px;
            color: var(--troika-primary) !important; margin: 0;
        }
        #troika-home .th-dots-rule { height: 0; border-top: 3px dotted #b9b2d6; width: 200px; margin: 22px auto 0; }

        /* ---------- CAROUSEL ---------- */
        #troika-home .th-carousel { position: relative; max-width: 1200px; margin: 46px auto 0; padding: 0 70px; }
        #troika-home .th-viewport { overflow: hidden; }
        #troika-home .th-track {
            display: flex; gap: 24px; width: max-content;
            transition: transform 0.6s cubic-bezier(.22,1,.36,1);
        }
        /* Neutralise the DataList wrapper element so cards become flex items of the track */
        #<%= dlDresses.ClientID %> { display: contents; }

        #troika-home .th-arrow {
            position: absolute; top: 42%; transform: translateY(-50%); z-index: 6;
            width: 46px; height: 46px; border-radius: 50% !important;
            background: var(--troika-surface) !important; color: var(--troika-primary) !important;
            border: 2px solid var(--troika-border) !important;
            display: flex; align-items: center; justify-content: center; cursor: pointer; padding: 0 !important;
            box-shadow: 0 4px 14px rgba(31,24,40,0.12);
            transition: background 0.2s ease, color 0.2s ease, transform 0.2s ease;
        }
        #troika-home .th-arrow:hover {
            background: var(--troika-primary) !important; color: #ffffff !important;
            border-color: var(--troika-primary) !important; transform: translateY(-50%) scale(1.08);
        }
        body[data-theme="dark"] #troika-home .th-arrow:hover { color: #121018 !important; }
        #troika-home .th-arrow-prev { left: 8px; }
        #troika-home .th-arrow-next { right: 8px; }

        /* Product cards */
        #troika-home .th-card {
            width: 260px; flex: 0 0 260px; background: var(--troika-surface);
            border: 1px solid var(--troika-border); border-radius: 12px; overflow: hidden;
            display: flex; flex-direction: column; box-shadow: 0 4px 12px rgba(0,0,0,0.07);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }
        #troika-home .th-card:hover {
            transform: translateY(-8px); box-shadow: 0 14px 30px rgba(31,24,40,0.18);
            border-color: var(--troika-primary-hover);
        }
        #troika-home .th-card-link { text-decoration: none; color: inherit !important; display: flex; flex-direction: column; flex-grow: 1; cursor: pointer; }
        #troika-home .th-card-imgbox { height: 300px; overflow: hidden; background: var(--troika-surface-alt); }
        #troika-home .th-card-img { width: 100%; height: 100%; object-fit: cover; display: block; transition: transform 0.6s ease; }
        #troika-home .th-card:hover .th-card-img { transform: scale(1.07); }
        #troika-home .th-card-body { padding: 18px 18px 12px; display: flex; flex-direction: column; gap: 8px; flex-grow: 1; }
        #troika-home .th-card-foot { padding: 0 18px 18px; }
        #troika-home .th-card-cat {
            align-self: flex-start; background: var(--troika-secondary); color: var(--troika-primary);
            font-size: 11px; font-weight: 600; letter-spacing: 0.6px; text-transform: uppercase;
            padding: 4px 10px; border-radius: 4px;
        }
        #troika-home .th-card-name { font-size: 17px; font-weight: 600; color: var(--troika-primary) !important; }
        #troika-home .th-card-price { font-size: 19px; font-weight: 700; color: var(--troika-text) !important; margin-top: 2px; }
        #troika-home .th-card-btn {
            margin-top: 8px; padding: 11px !important; border-radius: 7px !important;
            font-family: 'Poppins', sans-serif; font-size: 14px; font-weight: 600; width: 100%;
        }

        /* Dots */
        #troika-home .th-dots { display: flex; justify-content: center; gap: 12px; margin-top: 34px; }
        #troika-home .th-dot {
            width: 11px; height: 11px; padding: 0 !important; border-radius: 50% !important;
            border: none !important; cursor: pointer; background: #cfc9dd !important;
            transition: background 0.3s ease, transform 0.3s ease;
        }
        #troika-home .th-dot:hover { transform: scale(1.3); }
        #troika-home .th-dot.th-dot-active { background: var(--troika-primary) !important; }

        /* See-all button */
        #troika-home .th-seeall-wrap { text-align: center; margin-top: 44px; }
        #troika-home .th-seeall {
            padding: 13px 42px !important; border-radius: 999px !important;
            font-size: 15px; font-weight: 600; letter-spacing: 0.5px;
        }

        /* ---------- INFORMATION CARDS ---------- */
        #troika-home .th-info { background: var(--troika-bg); padding: 50px 0 90px; }
        #troika-home .th-info-grid {
            max-width: 1180px; margin: 50px auto 0; padding: 0 28px;
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 28px;
        }
        #troika-home .th-info-card {
            background: #3D304C; border-radius: 20px; padding: 40px 32px 34px;
            display: flex; flex-direction: column; align-items: center; text-align: center;
            min-height: 380px; box-shadow: 0 10px 28px rgba(31,24,40,0.16);
            transition: transform 0.35s ease, box-shadow 0.35s ease;
        }
        #troika-home .th-info-card:hover { transform: translateY(-10px); box-shadow: 0 22px 44px rgba(31,24,40,0.3); }
        #troika-home .th-info-top { flex-grow: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 26px; }
        #troika-home .th-info-icon { display: block; transition: transform 0.4s ease; }
        #troika-home .th-info-card:hover .th-info-icon-1 { transform: rotate(-8deg) scale(1.08); }
        #troika-home .th-info-card:hover .th-info-icon-2 { transform: rotate(8deg) scale(1.08); }
        #troika-home .th-info-card:hover .th-info-icon-3 { transform: scale(1.12); }
        #troika-home .th-info-text { font-size: 23px; font-weight: 600; color: #ffffff !important; line-height: 1.4; }
        #troika-home a.th-info-btn {
            display: inline-block; margin-top: 24px; width: 100%; max-width: 230px;
            background: #ffffff; color: #3D304C; padding: 13px; border-radius: 999px;
            font-family: 'Poppins', sans-serif; font-size: 15px; font-weight: 600; text-decoration: none;
            transition: transform 0.2s ease, background 0.2s ease;
        }
        #troika-home a.th-info-btn:hover { transform: scale(1.05); background: #F5F5DC; color: #3D304C; }

        /* ---------- RESPONSIVE ---------- */
        @media (max-width: 980px) {
            #troika-home .th-hero-media { width: 42%; opacity: 0.55; }
            #troika-home .th-features-grid { grid-template-columns: repeat(2, 1fr); gap: 40px 0; }
            #troika-home .th-feature:nth-child(2) { border-right: none; }
            #troika-home .th-info-grid { grid-template-columns: 1fr; max-width: 480px; }
        }
        @media (max-width: 720px) {
            #troika-home .th-hero { min-height: 480px; }
            #troika-home .th-hero-media { display: none; }
            #troika-home .th-hero-inner { padding: 48px 24px; }
            #troika-home .th-features-grid { grid-template-columns: 1fr; gap: 36px 0; }
            #troika-home .th-feature { border-right: none; }
            #troika-home .th-carousel { padding: 0 48px; }
        }

        /* ---------- REDUCED MOTION ---------- */
        @media (prefers-reduced-motion: reduce) {
            #troika-home *, #troika-home *::before, #troika-home *::after {
                animation-duration: 0.001ms !important; animation-iteration-count: 1 !important;
                transition-duration: 0.001ms !important;
            }
            #troika-home .th-reveal { opacity: 1 !important; transform: none !important; filter: none !important; }
        }
    </style>

    <%-- If JS is disabled, reveal everything immediately so no content stays hidden --%>
    <noscript>
        <style> #troika-home .th-reveal { opacity: 1 !important; transform: none !important; filter: none !important; } </style>
    </noscript>

    <div id="troika-home">

        <%-- ===================== HERO ===================== --%>
        <section class="th-hero">
            <div class="th-hero-bg" aria-hidden="true">
                <div class="th-hero-bg-a"></div>
                <div class="th-hero-bg-b"></div>
            </div>
            <div class="th-hero-overlay"></div>
            <div class="th-hero-glow"></div>
            <div class="th-hero-inner">
                <div class="th-hero-copy">
                    <div class="th-hero-script th-reveal th-from-left">Find your new</div>
                    <h1 class="th-hero-title th-reveal">HOODIE</h1>
                    <p class="th-hero-text th-reveal" style="transition-delay:0.1s;">Introducing our new luxurious hoodie range &mdash; designed for ultimate comfort, warmth, and effortless style. Whether you're layering up for chilly days or keeping it casual, these hoodies are made to become your everyday essential.</p>
                    <div class="th-hero-tag th-reveal" style="transition-delay:0.2s;">stay warm and stylish</div>
                    <div class="th-reveal" style="transition-delay:0.3s;">
                        <a href="#th-latest" class="th-hero-btn">Shop Now</a>
                    </div>
                </div>
            </div>
            <div class="th-hero-media" aria-hidden="true">
                <div class="th-hero-col th-hero-col-a" data-anim="th-slideInRight 1.1s cubic-bezier(.22,1,.36,1), th-floatY 6.5s ease-in-out 1.6s infinite"></div>
                <div class="th-hero-col th-hero-col-b" data-anim="th-slideInRight 1.3s cubic-bezier(.22,1,.36,1), th-floatYb 7.5s ease-in-out 1.8s infinite"></div>
                <div class="th-hero-media-fade"></div>
            </div>
        </section>

        <%-- ===================== FEATURE STRIP ===================== --%>
        <section class="th-features">
            <svg class="th-wave th-wave-top" viewBox="0 0 1440 90" preserveAspectRatio="none"><path d="M0,0 L1440,0 L1440,30 C1140,82 900,8 660,46 C440,80 200,72 0,42 Z"></path></svg>
            <svg class="th-wave th-wave-bottom" viewBox="0 0 1440 90" preserveAspectRatio="none"><path d="M0,90 L1440,90 L1440,52 C1140,4 900,84 660,46 C440,16 200,22 0,54 Z"></path></svg>
            <div class="th-features-grid">
                <div class="th-feature th-reveal">
                    <svg width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                    <div class="th-feature-label">wide range of<br>products</div>
                </div>
                <div class="th-feature th-reveal" style="transition-delay:0.1s;">
                    <svg width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
                    <div class="th-feature-label">quality and<br>authenticity</div>
                </div>
                <div class="th-feature th-reveal" style="transition-delay:0.2s;">
                    <svg width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20"/></svg>
                    <div class="th-feature-label">competitive<br>pricing</div>
                </div>
                <div class="th-feature th-reveal" style="transition-delay:0.3s;">
                    <svg width="50" height="50" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    <div class="th-feature-label">secure<br>shopping</div>
                </div>
            </div>
        </section>

        <%-- ===================== LATEST PRODUCTS ===================== --%>
        <section id="th-latest" class="th-section">
            <div class="th-section-head th-reveal">
                <h2 class="th-section-title">LATEST PRODUCTS</h2>
                <div class="th-dots-rule"></div>
            </div>

            <div class="th-carousel">
                <button type="button" id="thPrev" class="th-arrow th-arrow-prev" aria-label="Previous">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                </button>
                <button type="button" id="thNext" class="th-arrow th-arrow-next" aria-label="Next">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
                </button>

                <div class="th-viewport">
                    <div class="th-track" id="thTrack">
                        <asp:DataList ID="dlDresses" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                            OnItemCommand="dlDresses_ItemCommand">
                            <ItemTemplate>
                                <div class="th-card th-reveal">
                                    <asp:LinkButton ID="lnkProductCard" runat="server" CommandName="ViewDetails"
                                        CommandArgument='<%# Eval("ProductID") %>' CssClass="th-card-link">
                                        <div class="th-card-imgbox">
                                            <asp:Image ID="imgProduct" runat="server"
                                                ImageUrl='<%# Eval("ImageUrl") %>'
                                                AlternateText='<%# Eval("ProductName") %>'
                                                CssClass="th-card-img" />
                                        </div>
                                        <div class="th-card-body">
                                            <span class="th-card-cat"><%# Eval("Category") %></span>
                                            <div class="th-card-name"><%# Eval("ProductName") %></div>
                                            <div class="th-card-price">R<%# Convert.ToDecimal(Eval("Price")).ToString("F2") %></div>
                                        </div>
                                    </asp:LinkButton>
                                    <div class="th-card-foot">
                                        <asp:Button ID="btnAddToCart" runat="server"
                                            CommandName="ViewDetails"
                                            CommandArgument='<%# Eval("ProductID") %>'
                                            Text="View Details"
                                            CssClass="th-card-btn" />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:DataList>
                    </div>
                </div>

                <div class="th-dots" id="thDots"></div>
            </div>

            <div class="th-seeall-wrap th-reveal">
                <asp:Button ID="btnProducts" runat="server" Text="View All Products" CssClass="th-seeall" OnClick="btnProducts_Click" />
            </div>
        </section>

        <%-- ===================== INFORMATION ===================== --%>
        <section id="information" class="th-info">
            <div class="th-section-head th-reveal">
                <h2 class="th-section-title">INFORMATION</h2>
                <div class="th-dots-rule"></div>
            </div>

            <div class="th-info-grid">
                <div class="th-info-card th-reveal">
                    <div class="th-info-top">
                        <svg class="th-info-icon th-info-icon-1" width="82" height="82" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                        <div class="th-info-text">Shop our wide range of products</div>
                    </div>
                    <a href="Public Pages/Products.aspx" class="th-info-btn">Shop Now</a>
                </div>

                <div class="th-info-card th-reveal" style="transition-delay:0.12s;">
                    <div class="th-info-top">
                        <svg class="th-info-icon th-info-icon-2" width="82" height="82" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>
                        <div class="th-info-text">Find more about the company that makes your clothes</div>
                    </div>
                    <a href="Public Pages/About.aspx" class="th-info-btn">Learn More</a>
                </div>

                <div class="th-info-card th-reveal" style="transition-delay:0.24s;">
                    <div class="th-info-top">
                        <svg class="th-info-icon th-info-icon-3" width="84" height="84" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8z"/></svg>
                        <div class="th-info-text">Feel free to contact us if you have questions</div>
                    </div>
                    <a href="Public Pages/Contact.aspx" class="th-info-btn">Contact Information</a>
                </div>
            </div>
        </section>

    </div>

    <script type="text/javascript">
        (function () {
            function init() {
                var root = document.getElementById('troika-home');
                if (!root) return;

                var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

                // 1) Scroll-reveal entrances
                var reveals = [].slice.call(root.querySelectorAll('.th-reveal'));
                if (reduce || !('IntersectionObserver' in window)) {
                    reveals.forEach(function (el) { el.classList.add('th-in'); });
                } else {
                    var io = new IntersectionObserver(function (entries) {
                        entries.forEach(function (e) {
                            if (e.isIntersecting) { e.target.classList.add('th-in'); io.unobserve(e.target); }
                        });
                    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
                    reveals.forEach(function (el) { io.observe(el); });

                    // Hero entrance: play the staggered blur cascade on load (don't wait for a scroll).
                    // Two rAFs let the initial hidden state paint first so the transition actually runs.
                    var heroReveals = [].slice.call(root.querySelectorAll('.th-hero .th-reveal'));
                    requestAnimationFrame(function () {
                        requestAnimationFrame(function () {
                            heroReveals.forEach(function (el) { el.classList.add('th-in'); });
                        });
                    });

                    // Safety net: force-reveal anything still hidden shortly after load
                    setTimeout(function () {
                        reveals.forEach(function (el) {
                            var r = el.getBoundingClientRect();
                            if (r.top < window.innerHeight && !el.classList.contains('th-in')) {
                                el.classList.add('th-in');
                            }
                        });
                    }, 1600);
                }

                // 2) Continuous hero image animations (slide-in + float)
                if (!reduce) {
                    root.querySelectorAll('[data-anim]').forEach(function (el) {
                        el.style.animation = el.getAttribute('data-anim');
                    });
                }

                // 3) Products carousel
                var track = document.getElementById('thTrack');
                var dotsWrap = document.getElementById('thDots');
                var prevBtn = document.getElementById('thPrev');
                var nextBtn = document.getElementById('thNext');
                var GAP = 24;
                var index = 0;

                function cards() { return track ? track.querySelectorAll('.th-card') : []; }
                function step() { var c = cards()[0]; return c ? Math.round(c.getBoundingClientRect().width + GAP) : 284; }
                function visibleCount() {
                    var w = window.innerWidth;
                    if (w < 640) return 1;
                    if (w < 900) return 2;
                    if (w < 1200) return 3;
                    return 4;
                }
                function maxIndex() { return Math.max(0, cards().length - visibleCount()); }

                function syncControls() {
                    var scrollable = maxIndex() > 0;
                    if (prevBtn) prevBtn.style.display = scrollable ? '' : 'none';
                    if (nextBtn) nextBtn.style.display = scrollable ? '' : 'none';
                    if (dotsWrap) dotsWrap.style.display = scrollable ? '' : 'none';
                }

                function renderDots() {
                    if (!dotsWrap) return;
                    var total = maxIndex() + 1;
                    if (dotsWrap.childNodes.length !== total) {
                        dotsWrap.innerHTML = '';
                        for (var i = 0; i < total; i++) {
                            (function (n) {
                                var b = document.createElement('button');
                                b.type = 'button';
                                b.className = 'th-dot';
                                b.setAttribute('aria-label', 'Go to slide ' + (n + 1));
                                b.addEventListener('click', function () { index = n; update(); });
                                dotsWrap.appendChild(b);
                            })(i);
                        }
                    }
                    var dots = dotsWrap.querySelectorAll('.th-dot');
                    for (var j = 0; j < dots.length; j++) {
                        dots[j].classList.toggle('th-dot-active', j === index);
                    }
                }

                function update() {
                    if (!track) return;
                    if (index > maxIndex()) index = maxIndex();
                    if (index < 0) index = 0;
                    track.style.transform = 'translateX(' + (-index * step()) + 'px)';
                    syncControls();
                    renderDots();
                }

                if (track && cards().length) {
                    if (prevBtn) prevBtn.addEventListener('click', function () { index = (index <= 0) ? maxIndex() : index - 1; update(); });
                    if (nextBtn) nextBtn.addEventListener('click', function () { index = (index >= maxIndex()) ? 0 : index + 1; update(); });

                    var timer = null;
                    function startTimer() {
                        if (reduce || timer || maxIndex() === 0) return;
                        timer = setInterval(function () {
                            index = (index >= maxIndex()) ? 0 : index + 1;
                            update();
                        }, 4500);
                    }
                    function stopTimer() { if (timer) { clearInterval(timer); timer = null; } }

                    var carousel = track.closest('.th-carousel');
                    if (carousel) {
                        carousel.addEventListener('mouseenter', stopTimer);
                        carousel.addEventListener('mouseleave', startTimer);
                    }

                    var rt;
                    window.addEventListener('resize', function () {
                        clearTimeout(rt);
                        rt = setTimeout(update, 150);
                    });

                    update();
                    startTimer();
                    // Re-measure once product images have loaded (card width is fixed, but be safe)
                    window.addEventListener('load', update);
                }
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', init);
            } else {
                init();
            }
        })();
    </script>

</asp:Content>
