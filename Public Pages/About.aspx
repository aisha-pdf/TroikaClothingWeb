<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="TroikaClothingWeb.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* -------------------- ABOUT PAGE LIGHT/DARK MODE  -------------------- */

        .about-page-wrapper {
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            padding: 40px 15px;
            min-height: 80vh;
        }

        .about-content-card {
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 40px;
            max-width: 1100px;
            margin: 40px auto;
            border-radius: 10px;
            border: 1px solid var(--troika-border) !important;
            box-shadow: var(--troika-card-shadow);
        }

        .about-content-card h1,
        .about-content-card h2,
        .about-content-card h3 {
            color: var(--troika-heading-text) !important;
            font-weight: 700;
        }

        .about-content-card h1 {
            text-align: center;
            margin-bottom: 25px;
        }

        .about-content-card h2 {
            margin-top: 50px;
        }

        .about-content-card p,
        .about-content-card li,
        .about-content-card strong,
        .about-content-card em {
            color: var(--troika-text) !important;
        }

        .about-main-text {
            font-size: 18px;
            text-align: justify;
            line-height: 1.7;
            margin-bottom: 22px;
        }

        .about-section-heading-center {
            text-align: center;
        }

        .about-card-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 30px;
        }

        .about-info-card {
    flex: 1;
    min-width: 300px;
    background: #eee3ff !important;
    color: var(--troika-text) !important;
    padding: 25px;
    border-radius: 10px;
    border: 1px solid #d8c5f4 !important;
    box-shadow: var(--troika-card-shadow);
}



        .about-info-card h3 {
            text-align: center;
            margin-bottom: 15px;
        }

        .about-info-card p {
            font-size: 16px;
            text-align: center;
            line-height: 1.6;
            color: var(--troika-text) !important;
        }

        .about-list {
            font-size: 18px;
            color: var(--troika-text) !important;
            line-height: 1.8;
            margin-top: 15px;
        }

        .about-list li {
            color: var(--troika-text) !important;
        }

        .about-values-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
        }

        .about-value-card {
    flex: 1;
    min-width: 200px;
    background: #eee3ff !important;
    color: var(--troika-text) !important;
    padding: 20px;
    border-radius: 10px;
    border: 1px solid #d8c5f4 !important;
    text-align: center;
}

        .about-value-card h3 {
            color: var(--troika-heading-text) !important;
            margin-bottom: 12px;
        }

        .about-value-card p {
            color: var(--troika-text) !important;
            line-height: 1.6;
        }

        body[data-theme="dark"] .about-content-card {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .about-content-card h1,
        body[data-theme="dark"] .about-content-card h2,
        body[data-theme="dark"] .about-content-card h3 {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .about-content-card p,
        body[data-theme="dark"] .about-content-card li,
        body[data-theme="dark"] .about-content-card strong,
        body[data-theme="dark"] .about-content-card em {
            color: #f5f3f7 !important;
        }

        body[data-theme="dark"] .about-info-card,
        body[data-theme="dark"] .about-value-card {
            background: #251f2f !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .about-info-card p,
        body[data-theme="dark"] .about-value-card p {
            color: #f5f3f7 !important;
        }

        @media (max-width: 768px) {
            .about-content-card {
                padding: 25px;
                margin: 20px auto;
            }

            .about-main-text,
            .about-list {
                font-size: 16px;
            }
        }
    </style>

    <div class="about-page-wrapper">
        <div class="about-content-card">

            <!-- About Us Section -->
            <h1>About Us</h1>

            <p class="about-main-text">
                Welcome to <strong>Troika Clothing CC</strong> – a brand built on precision,
                quality, and passion for fashion. For years, we have partnered with leading
                retailers through the <em>Cut, Make, and Trim (CMT)</em> model, producing
                high-quality garments with a focus on <strong>women’s apparel</strong>.
            </p>

            <p class="about-main-text">
                While our reputation was founded on excellence in garment production for
                suppliers, we have expanded into the <strong>retail sector</strong> to bring
                our styles directly to you. Today, Troika offers ready-made clothing collections
                that combine craftsmanship with modern design – giving individuals the same
                quality trusted by major retailers.
            </p>

            <p class="about-main-text">
                Whether you are a retail partner looking for a reliable manufacturing team
                or a customer searching for stylish, ready-to-wear fashion, Troika Clothing CC
                is here to serve you.
            </p>

            <!-- Our Story -->
            <h2 class="about-section-heading-center">Our Story</h2>

            <p class="about-main-text">
                Troika Clothing CC began as a family-led business with a passion for garment
                manufacturing. From humble beginnings in CMT production, we grew into a trusted
                name in the industry – known for precision, consistency, and strong partnerships.
                As we evolved, we saw an opportunity to extend our expertise beyond wholesale
                into the retail market, allowing us to connect directly with fashion-forward
                individuals who value both quality and style.
            </p>

            <!-- Vision & Mission -->
            <h2 class="about-section-heading-center">Our Vision & Mission</h2>

            <div class="about-card-row">

                <div class="about-info-card">
                    <h3>Vision</h3>
                    <p>
                        To be a leading fashion brand that bridges the gap between wholesale
                        production and retail fashion, offering clothing that combines
                        reliability, innovation, and style for both partners and individual
                        customers.
                    </p>
                </div>

                <div class="about-info-card">
                    <h3>Mission</h3>
                    <p>
                        Our mission is to deliver world-class garments through the CMT model
                        while expanding into retail with ready-made collections. We aim to
                        empower brands and inspire individuals with clothing that blends
                        quality, comfort, and modern design.
                    </p>
                </div>

            </div>

            <!-- Why Choose Us -->
            <h2>Why Choose Us?</h2>

            <ul class="about-list">
                <li><strong>For Retailers:</strong> Dependable CMT production with consistent quality and on-time delivery.</li>
                <li><strong>For Shoppers:</strong> Ready-made collections designed with style, comfort, and affordability in mind.</li>
                <li><strong>For Everyone:</strong> A trusted name in women’s fashion, combining tradition with innovation.</li>
            </ul>

            <!-- Core Values -->
            <h2>Our Core Values</h2>

            <div class="about-values-row">
                <div class="about-value-card">
                    <h3>Excellence</h3>
                    <p>We strive for perfection in every garment, from design to delivery.</p>
                </div>

                <div class="about-value-card">
                    <h3>Integrity</h3>
                    <p>We uphold fairness, transparency, and trust in every partnership and purchase.</p>
                </div>

                <div class="about-value-card">
                    <h3>Innovation</h3>
                    <p>We evolve with the fashion world, balancing modern design with timeless craftsmanship.</p>
                </div>
            </div>

        </div>
    </div>

</asp:Content>