<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TroikaClothingWeb.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .modern-contact-page {
            --contact-heading: #262342;
            --contact-subheading: #3d365f;
            --contact-card: #f1e9ff;
            --contact-card-soft: #f8f4ff;
            --contact-icon-bg: #3d304c;
            --contact-icon-text: #ffffff;

            background:
                radial-gradient(circle at top right, rgba(217, 200, 240, 0.40), transparent 34%),
                radial-gradient(circle at bottom left, rgba(100, 79, 125, 0.18), transparent 32%),
                var(--troika-bg);
            color: var(--troika-text);
            min-height: 100vh;
            padding-bottom: 90px;
            overflow: hidden;
            font-family: "Poppins", "Segoe UI", Arial, sans-serif;
        }

        body[data-theme="dark"] .modern-contact-page {
            --contact-heading: #f3efff;
            --contact-subheading: #ded5f4;
            --contact-card: #241f33;
            --contact-card-soft: #201b2d;
            --contact-icon-bg: #d9c8f0;
            --contact-icon-text: #211a31;

            background:
                radial-gradient(circle at top right, rgba(217, 200, 240, 0.13), transparent 34%),
                radial-gradient(circle at bottom left, rgba(100, 79, 125, 0.20), transparent 32%),
                var(--troika-bg);
        }

        .contact-modern-container {
            width: min(1180px, calc(100% - 32px));
            margin: 0 auto;
        }

        .contact-hero-modern {
            padding: 82px 0 42px;
            text-align: center;
        }

        .contact-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 17px;
            border-radius: 999px;
            background: rgba(100, 79, 125, 0.13);
            border: 1px solid rgba(100, 79, 125, 0.20);
            color: var(--troika-primary);
            font-weight: 850;
            font-size: 13px;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            margin-bottom: 18px;
            animation: pageFadeUp 0.85s ease both;
        }

        .contact-hero-modern h1 {
            color: var(--contact-heading) !important;
            font-size: clamp(42px, 6vw, 76px);
            line-height: 0.96;
            font-weight: 850;
            letter-spacing: -2.4px;
            margin: 0 0 20px;
            animation: pageFadeUp 0.95s ease both;
            animation-delay: 0.12s;
        }

        .contact-hero-modern h1 span {
            color: var(--troika-primary);
            font-family: Georgia, "Times New Roman", serif;
            font-style: italic;
            font-weight: 500;
        }

        .contact-hero-modern p {
            color: var(--troika-muted-text) !important;
            max-width: 720px;
            margin: 0 auto;
            font-size: 18px;
            line-height: 1.8;
            animation: pageFadeUp 0.95s ease both;
            animation-delay: 0.24s;
        }

        .contact-seamless-section {
            display: grid;
            grid-template-columns: 1.45fr 0.55fr;
            gap: 28px;
            align-items: stretch;
            animation: sectionReveal 1s ease both;
            animation-delay: 0.32s;
        }

        .contact-details-panel {
            background: var(--contact-card);
            border: 1px solid var(--troika-border);
            border-radius: 38px;
            box-shadow: var(--troika-card-shadow);
            padding: 42px;
            overflow: hidden;
            position: relative;
        }

        .contact-details-panel::before {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: rgba(100, 79, 125, 0.10);
            right: -90px;
            top: -90px;
        }

        .contact-details-panel h2 {
            position: relative;
            z-index: 1;
            color: var(--contact-heading) !important;
            font-size: clamp(34px, 4vw, 48px);
            font-weight: 850;
            letter-spacing: -1.4px;
            margin-bottom: 14px;
        }

        .contact-details-panel > p {
            position: relative;
            z-index: 1;
            color: var(--troika-muted-text) !important;
            font-size: 17px;
            line-height: 1.8;
            margin-bottom: 34px;
            max-width: 760px;
        }

        .contact-detail-list {
            position: relative;
            z-index: 1;
            display: grid;
            gap: 18px;
        }

        .contact-detail-item {
            display: flex;
            gap: 18px;
            align-items: flex-start;
            padding: 22px;
            border-radius: 28px;
            background: var(--contact-card-soft);
            border: 1px solid var(--troika-border);
            transition: transform 0.28s ease, border-color 0.28s ease, background 0.28s ease, box-shadow 0.28s ease;
        }

        .contact-detail-item:hover {
            transform: translateX(8px);
            border-color: var(--troika-primary-hover);
            box-shadow: 0 12px 28px rgba(61, 48, 76, 0.10);
        }

        .contact-detail-icon {
            width: 58px;
            height: 58px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--contact-icon-bg);
            color: var(--contact-icon-text);
            font-size: 25px;
            flex-shrink: 0;
            box-shadow: 0 10px 22px rgba(61, 48, 76, 0.16);
        }

        .contact-detail-item strong {
            display: block;
            color: var(--contact-heading) !important;
            margin-bottom: 7px;
            font-size: 17px;
            font-weight: 850;
        }

        .contact-detail-item span,
        .contact-detail-item a {
            color: var(--troika-muted-text) !important;
            text-decoration: none;
            line-height: 1.65;
            font-size: 16px;
        }

        .contact-detail-item a:hover {
            color: var(--troika-primary) !important;
            text-decoration: underline;
        }

        .contact-side-panel {
            display: flex;
            flex-direction: column;
            gap: 22px;
        }

        .mini-image-card {
            min-height: 330px;
            border-radius: 34px;
            border: 1px solid var(--troika-border);
            box-shadow: var(--troika-card-shadow);
            overflow: hidden;
            background: var(--contact-card);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .mini-image-card:hover {
            transform: translateY(-7px);
            box-shadow: var(--troika-card-shadow-hover);
        }

        .contact-side-img {
            width: 100%;
            height: 100%;
            min-height: 330px;
            display: block;
            object-fit: cover;
            transition: transform 0.7s ease;
        }

        .mini-image-card:hover .contact-side-img {
            transform: scale(1.08);
        }

        .quick-note-card {
            background: var(--contact-card);
            border: 1px solid var(--troika-border);
            border-radius: 30px;
            padding: 28px;
            box-shadow: var(--troika-card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .quick-note-card:hover {
            transform: translateY(-7px);
            box-shadow: var(--troika-card-shadow-hover);
        }

        .quick-note-icon {
            width: 56px;
            height: 56px;
            border-radius: 20px;
            background: var(--contact-icon-bg);
            color: var(--contact-icon-text);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin-bottom: 16px;
        }

        .quick-note-card h3 {
            color: var(--contact-heading) !important;
            font-size: 23px;
            font-weight: 850;
            margin-bottom: 10px;
            letter-spacing: -0.4px;
        }

        .quick-note-card p {
            color: var(--troika-muted-text) !important;
            font-size: 15px;
            line-height: 1.7;
            margin: 0;
        }

        .contact-cta-strip {
            margin-top: 74px;
            border-radius: 38px;
            padding: 46px 36px;
            background:
                linear-gradient(135deg, rgba(61, 48, 76, 0.96), rgba(100, 79, 125, 0.92)),
                var(--troika-primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            box-shadow: 0 24px 60px rgba(61, 48, 76, 0.25);
            animation: pageFadeUp 0.95s ease both;
            animation-delay: 0.48s;
        }

        .contact-cta-strip h2 {
            color: white !important;
            font-size: clamp(28px, 4vw, 42px);
            font-weight: 850;
            letter-spacing: -1px;
            margin: 0 0 8px;
        }

        .contact-cta-strip p {
            color: rgba(255,255,255,0.82) !important;
            margin: 0;
            line-height: 1.7;
            max-width: 680px;
        }

        .cta-btn-light {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            white-space: nowrap;
            border-radius: 999px;
            padding: 14px 24px;
            background: white;
            color: #3D304C !important;
            text-decoration: none !important;
            font-weight: 850;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .cta-btn-light:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 28px rgba(0,0,0,0.18);
            color: #3D304C !important;
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

        @media (max-width: 992px) {
            .contact-seamless-section {
                grid-template-columns: 1fr;
            }

            .contact-side-panel {
                display: grid;
                grid-template-columns: 1fr 1fr;
            }

            .contact-cta-strip {
                flex-direction: column;
                text-align: center;
            }
        }

        @media (max-width: 650px) {
            .contact-side-panel {
                grid-template-columns: 1fr;
            }

            .contact-hero-modern {
                padding-top: 48px;
            }

            .contact-details-panel {
                padding: 28px;
                border-radius: 30px;
            }

            .contact-detail-item {
                padding: 19px;
                border-radius: 24px;
            }

            .contact-detail-icon {
                width: 52px;
                height: 52px;
                font-size: 23px;
            }

            .contact-cta-strip {
                padding: 34px 24px;
            }
        }
    </style>

    <main class="modern-contact-page">
        <div class="contact-modern-container">

            <section class="contact-hero-modern">
                <div class="contact-eyebrow">✦ Contact Troika Clothing C.C.</div>

                <h1>Get in <span>touch</span> with us.</h1>

                <p>
                    Find all Troika Clothing C.C. contact details in one place. Whether you have a product,
                    company, or general enquiry, you can reach us using the information below.
                </p>
            </section>

            <section class="contact-seamless-section">

                <div class="contact-details-panel">
                    <h2>Contact Information</h2>

                    <p>
                        Troika Clothing C.C. is based in Durban, KwaZulu-Natal. Use the details below
                        to reach us directly.
                    </p>

                    <div class="contact-detail-list">

                        <div class="contact-detail-item">
                            <div class="contact-detail-icon">🏢</div>
                            <div>
                                <strong>Physical Address</strong>
                                <span>
                                    82 Statesman Drive, Havenside, Chatsworth,<br />
                                    Durban, KwaZulu-Natal, 4092
                                </span>
                            </div>
                        </div>

                        <div class="contact-detail-item">
                            <div class="contact-detail-icon">📞</div>
                            <div>
                                <strong>Telephone</strong>
                                <a href="tel:+27314009471">(031) 400 9471</a>
                            </div>
                        </div>

                        <div class="contact-detail-item">
                            <div class="contact-detail-icon">📠</div>
                            <div>
                                <strong>Fax</strong>
                                <span>(031) 400 1729</span>
                            </div>
                        </div>

                        <div class="contact-detail-item">
                            <div class="contact-detail-icon">📱</div>
                            <div>
                                <strong>Cellphone</strong>
                                <a href="tel:+27829279987">082 927 9987</a>
                            </div>
                        </div>

                        <div class="contact-detail-item">
                            <div class="contact-detail-icon">📧</div>
                            <div>
                                <strong>Email Address</strong>
                                <a href="mailto:saxonnaidoo@vodamail.co.za">saxonnaidoo@vodamail.co.za</a>
                            </div>
                        </div>

                    </div>
                </div>

                <aside class="contact-side-panel">

                    <div class="mini-image-card">
                        <img src="<%= ResolveUrl("~/Images/PageImages/contact-side.jpeg") %>" 
                             alt="Troika clothing fabric and fashion workspace" 
                             class="contact-side-img" />
                    </div>

                    <div class="quick-note-card">
                        <div class="quick-note-icon">💜</div>
                        <h3>Here to help</h3>
                        <p>
                            For product, company, or general enquiries, please use the telephone, cellphone,
                            or email details listed.
                        </p>
                    </div>

                </aside>

            </section>

            <section class="contact-cta-strip">
                <div>
                    <h2>Looking for our latest styles?</h2>
                    <p>
                        Explore the latest Troika product range and discover ready-made clothing designed
                        with quality, comfort and everyday style in mind.
                    </p>
                </div>

                <a href="<%= ResolveUrl("~/Public Pages/Products.aspx") %>" class="cta-btn-light">
                    Browse Products
                </a>
            </section>

        </div>
    </main>

</asp:Content>