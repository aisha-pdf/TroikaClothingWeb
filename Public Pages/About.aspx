<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="TroikaClothingWeb.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .modern-about-page {
            --about-heading: #262342;
            --about-subheading: #3d365f;
            --about-card: #f1e9ff;
            --about-card-soft: #f8f4ff;
            --about-icon-bg: #3d304c;
            --about-icon-text: #ffffff;
            background: radial-gradient(circle at top left, rgba(217, 200, 240, 0.42), transparent 34%), radial-gradient(circle at bottom right, rgba(100, 79, 125, 0.20), transparent 30%), var(--troika-bg);
            color: var(--troika-text);
            min-height: 100vh;
            padding-bottom: 90px;
            overflow: hidden;
            font-family: "Poppins", "Segoe UI", Arial, sans-serif;
        }

        body[data-theme="dark"] .modern-about-page {
            --about-heading: #f3efff;
            --about-subheading: #ded5f4;
            --about-card: #241f33;
            --about-card-soft: #201b2d;
            --about-icon-bg: #d9c8f0;
            --about-icon-text: #211a31;
            background: radial-gradient(circle at top left, rgba(217, 200, 240, 0.13), transparent 34%), radial-gradient(circle at bottom right, rgba(100, 79, 125, 0.20), transparent 30%), var(--troika-bg);
        }

        .about-modern-container {
            width: min(1180px, calc(100% - 32px));
            margin: 0 auto;
        }

        .about-hero-modern {
            display: grid;
            grid-template-columns: 1.05fr 0.95fr;
            gap: 46px;
            align-items: center;
            padding: 86px 0 62px;
        }

        .about-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 17px;
            border-radius: 999px;
            background: rgba(100, 79, 125, 0.13);
            border: 1px solid rgba(100, 79, 125, 0.20);
            color: var(--troika-primary);
            font-weight: 800;
            font-size: 13px;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 18px;
            animation: pageFadeUp 0.85s ease both;
        }

        .about-hero-modern h1 {
            color: var(--about-heading) !important;
            font-size: clamp(42px, 6vw, 74px);
            line-height: 0.96;
            font-weight: 850;
            letter-spacing: -2.4px;
            margin: 0 0 22px;
            animation: pageFadeUp 0.95s ease both;
            animation-delay: 0.12s;
        }

            .about-hero-modern h1 span {
                color: var(--troika-primary);
                font-family: Georgia, "Times New Roman", serif;
                font-style: italic;
                font-weight: 500;
            }

        .about-hero-modern p {
            color: var(--troika-muted-text) !important;
            font-size: 18px;
            line-height: 1.8;
            max-width: 680px;
            margin-bottom: 28px;
            animation: pageFadeUp 0.95s ease both;
            animation-delay: 0.24s;
        }

        .about-hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            animation: pageFadeUp 0.95s ease both;
            animation-delay: 0.36s;
        }

        .modern-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            padding: 13px 25px;
            font-weight: 800;
            text-decoration: none !important;
            transition: transform 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
        }

        .modern-btn-primary {
            background: var(--troika-btn-bg);
            color: var(--troika-btn-text) !important;
            box-shadow: 0 14px 28px rgba(61, 48, 76, 0.22);
        }

        .modern-btn-secondary {
            background: var(--about-card);
            color: var(--about-subheading) !important;
            border: 1px solid var(--troika-border);
        }

        .modern-btn:hover {
            transform: translateY(-4px);
            box-shadow: var(--troika-card-shadow-hover);
        }

        .about-image-stack {
            position: relative;
            min-height: 520px;
            animation: imageSlideIn 1s ease both;
            animation-delay: 0.28s;
        }

        .about-image-main,
        .about-image-small {
            position: absolute;
            border-radius: 34px;
            overflow: hidden;
            border: 1px solid var(--troika-border);
            box-shadow: 0 24px 60px rgba(0,0,0,0.14);
            background: var(--about-card);
        }

        .about-image-main {
            right: 0;
            top: 0;
            width: 74%;
            height: 390px;
        }

        .about-image-small {
            left: 0;
            bottom: 0;
            width: 52%;
            height: 245px;
        }

        .about-img {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover;
            transition: transform 0.7s ease;
        }

        .about-image-main:hover .about-img,
        .about-image-small:hover .about-img {
            transform: scale(1.08);
        }

        .floating-cmt-image {
            position: absolute;
            right: 28px;
            bottom: 42px;
            width: 230px;
            height: 185px;
            border-radius: 28px;
            overflow: hidden;
            border: 1px solid var(--troika-border);
            background: var(--about-card);
            box-shadow: var(--troika-card-shadow-hover);
            animation: softFloat 3.6s ease-in-out infinite;
        }

            .floating-cmt-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
                transition: transform 0.7s ease;
            }

            .floating-cmt-image:hover img {
                transform: scale(1.08);
            }

        .modern-section {
            margin-top: 78px;
            animation: sectionReveal 0.9s ease both;
            animation-delay: 0.2s;
        }

        .section-heading-modern {
            text-align: center;
            margin-bottom: 38px;
        }

            .section-heading-modern .section-kicker {
                color: var(--troika-primary);
                font-size: 13px;
                font-weight: 850;
                letter-spacing: 1.5px;
                text-transform: uppercase;
                margin-bottom: 10px;
            }

            .section-heading-modern h2 {
                color: var(--about-heading) !important;
                font-size: clamp(32px, 4vw, 48px);
                font-weight: 850;
                letter-spacing: -1.1px;
                margin-bottom: 14px;
            }

            .section-heading-modern .dotted-line {
                width: 190px;
                border-top: 4px dotted var(--troika-primary-hover);
                margin: 0 auto;
                opacity: 0.65;
            }

        /* ---------- FIXED STORY SECTION HEIGHT ---------- */

        .story-card-modern {
            display: grid;
            grid-template-columns: 0.85fr 1.15fr;
            gap: 0;
            align-items: stretch;
            background: var(--about-card);
            border: 1px solid var(--troika-border);
            border-radius: 36px;
            padding: 16px;
            box-shadow: var(--troika-card-shadow);
            transition: transform 0.35s ease, box-shadow 0.35s ease;
            max-height: 520px;
            overflow: hidden;
        }

            .story-card-modern:hover {
                transform: translateY(-7px);
                box-shadow: var(--troika-card-shadow-hover);
            }

        .story-image-wrap {
            height: 488px;
            border-radius: 28px;
            overflow: hidden;
            background: var(--about-card-soft);
            display: flex;
            align-items: center;
            justify-content: center;
        }

            .story-image-wrap img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                object-position: center;
                display: block;
                transition: transform 0.7s ease;
            }

            .story-image-wrap:hover img {
                transform: scale(1.05);
            }

        .story-text-modern {
            padding: 34px 52px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

            .story-text-modern h3 {
                color: var(--about-heading) !important;
                font-size: clamp(28px, 3vw, 40px);
                font-weight: 850;
                letter-spacing: -0.7px;
                line-height: 1.15;
                margin-bottom: 18px;
            }

            .story-text-modern p {
                color: var(--troika-muted-text) !important;
                font-size: 16px;
                line-height: 1.75;
                margin-bottom: 16px;
            }

        .pill-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 6px;
        }

        .fashion-pill {
            display: inline-flex;
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(100, 79, 125, 0.13);
            color: var(--troika-primary);
            border: 1px solid rgba(100, 79, 125, 0.18);
            font-weight: 750;
            font-size: 13px;
        }

        .vision-mission-grid,
        .choose-grid,
        .values-grid {
            display: grid;
            gap: 24px;
        }

        .vision-mission-grid {
            grid-template-columns: repeat(2, 1fr);
        }

        .choose-grid,
        .values-grid {
            grid-template-columns: repeat(3, 1fr);
        }

        .vm-card,
        .modern-feature-card {
            position: relative;
            overflow: hidden;
            background: var(--about-card);
            border: 1px solid var(--troika-border);
            border-radius: 32px;
            box-shadow: var(--troika-card-shadow);
            transition: transform 0.35s ease, box-shadow 0.35s ease, border-color 0.35s ease;
        }

        .vm-card {
            padding: 38px;
            min-height: 280px;
        }

        .modern-feature-card {
            padding: 30px;
        }

            .vm-card::before,
            .modern-feature-card::before {
                content: "";
                position: absolute;
                width: 160px;
                height: 160px;
                border-radius: 50%;
                background: rgba(100, 79, 125, 0.11);
                right: -70px;
                top: -70px;
            }

            .vm-card:hover,
            .modern-feature-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--troika-card-shadow-hover);
                border-color: var(--troika-primary-hover);
            }

        .vm-icon,
        .feature-icon {
            position: relative;
            z-index: 1;
            width: 64px;
            height: 64px;
            border-radius: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--about-icon-bg);
            color: var(--about-icon-text);
            font-size: 30px;
            margin-bottom: 22px;
            box-shadow: 0 10px 22px rgba(61, 48, 76, 0.18);
        }

        .feature-icon {
            width: 58px;
            height: 58px;
            border-radius: 20px;
            font-size: 27px;
            margin-bottom: 18px;
        }

        .vm-card h3,
        .modern-feature-card h3 {
            position: relative;
            z-index: 1;
            color: var(--about-heading) !important;
            font-weight: 850;
            letter-spacing: -0.5px;
        }

        .vm-card h3 {
            font-size: 30px;
            margin-bottom: 14px;
        }

        .modern-feature-card h3 {
            font-size: 23px;
            margin-bottom: 12px;
        }

        .vm-card p,
        .modern-feature-card p {
            position: relative;
            z-index: 1;
            color: var(--troika-muted-text) !important;
            line-height: 1.75;
            margin: 0;
        }

        .about-cta-modern {
            margin-top: 84px;
            border-radius: 38px;
            padding: 54px 38px;
            background: linear-gradient(135deg, rgba(61, 48, 76, 0.96), rgba(100, 79, 125, 0.92)), var(--troika-primary);
            color: white;
            text-align: center;
            box-shadow: 0 24px 60px rgba(61, 48, 76, 0.25);
            animation: pageFadeUp 0.95s ease both;
        }

            .about-cta-modern h2 {
                color: white !important;
                font-size: clamp(30px, 4vw, 46px);
                font-weight: 850;
                letter-spacing: -1px;
                margin-bottom: 14px;
            }

            .about-cta-modern p {
                color: rgba(255,255,255,0.82) !important;
                max-width: 730px;
                margin: 0 auto 28px;
                font-size: 17px;
                line-height: 1.7;
            }

            .about-cta-modern .modern-btn-secondary {
                background: white;
                color: #3D304C !important;
                border-color: white;
            }

        @keyframes pageFadeUp {
            from {
                opacity: 0;
                transform: translateY(42px);
                filter: blur(4px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
                filter: blur(0);
            }
        }

        @keyframes sectionReveal {
            from {
                opacity: 0;
                transform: translateY(56px) scale(0.98);
                filter: blur(5px);
            }

            to {
                opacity: 1;
                transform: translateY(0) scale(1);
                filter: blur(0);
            }
        }

        @keyframes imageSlideIn {
            from {
                opacity: 0;
                transform: translateX(46px) scale(0.95);
                filter: blur(6px);
            }

            to {
                opacity: 1;
                transform: translateX(0) scale(1);
                filter: blur(0);
            }
        }

        @keyframes softFloat {
            0%, 100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-11px);
            }
        }

        @media (max-width: 992px) {
            .about-hero-modern {
                grid-template-columns: 1fr;
            }

            .story-card-modern {
                grid-template-columns: 1fr;
                max-height: none;
            }

            .story-image-wrap {
                height: 340px;
            }

            .story-text-modern {
                padding: 32px 28px;
            }

            .about-image-stack {
                min-height: 430px;
            }

            .about-image-main {
                width: 78%;
                height: 320px;
            }

            .about-image-small {
                width: 54%;
                height: 220px;
            }

            .vision-mission-grid,
            .choose-grid,
            .values-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 576px) {
            .about-hero-modern {
                padding-top: 48px;
            }

            .about-image-stack {
                min-height: auto;
            }

            .about-image-main,
            .about-image-small,
            .floating-cmt-image {
                position: relative;
                width: 100%;
                right: auto;
                left: auto;
                top: auto;
                bottom: auto;
                margin-bottom: 18px;
            }

            .about-image-main {
                height: 280px;
            }

            .about-image-small {
                height: 220px;
            }

            .floating-cmt-image {
                height: 230px;
            }

            .story-card-modern {
                padding: 12px;
                border-radius: 28px;
                max-height: none;
            }

            .story-image-wrap {
                height: 260px;
                border-radius: 22px;
            }

            .story-text-modern {
                padding: 26px 18px;
            }

            .story-text-modern p {
                font-size: 15px;
                line-height: 1.65;
            }

            .vm-card,
            .modern-feature-card {
                padding: 26px;
            }
        }
    </style>

    <main class="modern-about-page">
        <div class="about-modern-container">

            <section class="about-hero-modern">
                <div>
                    <div class="about-eyebrow">✦ Durban Fashion & CMT Manufacturing</div>

                    <h1>Clothing made with <span>precision</span>, quality and style.</h1>

                    <p>
                        Troika Clothing C.C. combines trusted garment manufacturing experience with a growing
                        retail identity, creating ready-to-wear fashion that feels polished, modern and reliable.
                    </p>

                    <div class="about-hero-actions">
                        <a href="<%= ResolveUrl("~/Public Pages/Products.aspx") %>" class="modern-btn modern-btn-primary">Shop Collection
                        </a>
                        <a href="<%= ResolveUrl("~/Public Pages/Contact.aspx") %>" class="modern-btn modern-btn-secondary">Contact Us
                        </a>
                    </div>
                </div>

                <div class="about-image-stack">
                    <div class="about-image-main">
                        <img src="<%= ResolveUrl("~/Images/PageImages/about-hero.jpeg") %>"
                            alt="Troika fashion fabric and garment styling"
                            class="about-img" />
                    </div>

                    <div class="about-image-small">
                        <img src="<%= ResolveUrl("~/Images/PageImages/about-sewing.jpeg") %>"
                            alt="Garment stitching and sewing production"
                            class="about-img" />
                    </div>

                    <div class="floating-cmt-image">
                        <img src="<%= ResolveUrl("~/Images/PageImages/about-cmt.jpeg") %>"
                            alt="Troika clothing manufacturing and retail fashion image" />
                    </div>
                </div>
            </section>

            <section class="modern-section">
                <div class="section-heading-modern">
                    <div class="section-kicker">Our Identity</div>
                    <h2>About Troika Clothing C.C.</h2>
                    <div class="dotted-line"></div>
                </div>

                <div class="story-card-modern">
                    <div class="story-image-wrap">
                        <img src="<%= ResolveUrl("~/Images/PageImages/about-story.jpeg") %>"
                            alt="Fashion production materials and sewing tools" />
                    </div>

                    <div class="story-text-modern">
                        <h3>From production roots to retail-ready fashion.</h3>

                        <p>
                            Welcome to <strong>Troika Clothing C.C.</strong>, a brand built on precision,
                            quality and passion for fashion. For years, Troika has partnered with leading
                            retailers through the <em>Cut, Make and Trim (CMT)</em> model, producing
                            high-quality garments with a focus on women’s apparel.
                        </p>

                        <p>
                            Today, Troika continues to grow beyond wholesale production by offering
                            ready-made clothing collections directly to customers. This allows shoppers
                            to enjoy the same trusted quality, craftsmanship and attention to detail that
                            has supported the company’s manufacturing reputation.
                        </p>

                        <div class="pill-row">
                            <span class="fashion-pill">Women’s Apparel</span>
                            <span class="fashion-pill">CMT Production</span>
                            <span class="fashion-pill">Ready-to-Wear</span>
                            <span class="fashion-pill">Modern Fashion</span>
                        </div>
                    </div>
                </div>
            </section>

            <section class="modern-section">
                <div class="section-heading-modern">
                    <div class="section-kicker">Purpose</div>
                    <h2>Vision & Mission</h2>
                    <div class="dotted-line"></div>
                </div>

                <div class="vision-mission-grid">
                    <div class="vm-card">
                        <div class="vm-icon">✨</div>
                        <h3>Vision</h3>
                        <p>
                            To be a leading fashion brand that bridges the gap between wholesale production
                            and retail fashion, offering clothing that combines reliability, innovation and
                            style for both partners and individual customers.
                        </p>
                    </div>

                    <div class="vm-card">
                        <div class="vm-icon">🎯</div>
                        <h3>Mission</h3>
                        <p>
                            To deliver world-class garments through the CMT model while expanding into
                            retail with ready-made collections that inspire customers through quality,
                            comfort and modern design.
                        </p>
                    </div>
                </div>
            </section>

            <section class="modern-section">
                <div class="section-heading-modern">
                    <div class="section-kicker">Why Choose Us</div>
                    <h2>Designed for partners and shoppers</h2>
                    <div class="dotted-line"></div>
                </div>

                <div class="choose-grid">
                    <div class="modern-feature-card">
                        <div class="feature-icon">🤝</div>
                        <h3>For Retailers</h3>
                        <p>
                            Dependable CMT production with consistent quality, reliable garment finishing
                            and a focus on strong business partnerships.
                        </p>
                    </div>

                    <div class="modern-feature-card">
                        <div class="feature-icon">🛍️</div>
                        <h3>For Shoppers</h3>
                        <p>
                            Ready-made collections designed with style, comfort and affordability in mind,
                            giving customers fashionable everyday choices.
                        </p>
                    </div>

                    <div class="modern-feature-card">
                        <div class="feature-icon">💜</div>
                        <h3>For Everyone</h3>
                        <p>
                            A trusted name in women’s fashion, combining traditional craftsmanship with a
                            modern retail experience.
                        </p>
                    </div>
                </div>
            </section>

            <section class="modern-section">
                <div class="section-heading-modern">
                    <div class="section-kicker">What Guides Us</div>
                    <h2>Our Core Values</h2>
                    <div class="dotted-line"></div>
                </div>

                <div class="values-grid">
                    <div class="modern-feature-card">
                        <div class="feature-icon">🌟</div>
                        <h3>Excellence</h3>
                        <p>
                            We strive for high standards in every garment, from fabric handling to final delivery.
                        </p>
                    </div>

                    <div class="modern-feature-card">
                        <div class="feature-icon">🕊️</div>
                        <h3>Integrity</h3>
                        <p>
                            We value fairness, transparency and trust in every partnership and customer interaction.
                        </p>
                    </div>

                    <div class="modern-feature-card">
                        <div class="feature-icon">🪡</div>
                        <h3>Innovation</h3>
                        <p>
                            We evolve with fashion trends while preserving the quality and craftsmanship behind each piece.
                        </p>
                    </div>
                </div>
            </section>

            <section class="about-cta-modern">
                <h2>Fashion with a production-quality foundation.</h2>
                <p>
                    Whether you are a retail partner searching for a reliable manufacturing team or a shopper
                    looking for stylish ready-to-wear fashion, Troika Clothing C.C. is here to serve you.
                </p>

                <div class="about-hero-actions" style="justify-content: center;">
                    <a href="<%= ResolveUrl("~/Public Pages/Products.aspx") %>" class="modern-btn modern-btn-secondary">Browse Products
                    </a>
                    <a href="<%= ResolveUrl("~/Public Pages/Contact.aspx") %>" class="modern-btn modern-btn-secondary">Get in Touch
                    </a>
                </div>
            </section>

        </div>
    </main>

</asp:Content>