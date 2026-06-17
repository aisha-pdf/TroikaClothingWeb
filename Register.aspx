<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="TroikaClothingWeb.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* ============================================================
           REGISTER PAGE LOCAL LIGHT/DARK MODE FIX
           ============================================================ */

        .register-local-page {
            min-height: 90vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 46px 14px 60px 14px;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
            box-sizing: border-box;
        }

        .register-local-card {
            width: 560px;
            max-width: 100%;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 28px 34px 34px 34px;
            border-radius: 14px;
            border: 1px solid var(--troika-border) !important;
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.10);
            box-sizing: border-box;
        }

        .register-local-inner {
            width: 390px;
            max-width: 100%;
            margin: 0 auto;
        }

        /* -------------------- Back button -------------------- */

        .register-local-topbar {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            margin-bottom: 8px;
        }

        .register-local-back {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-width: 78px;
            padding: 8px 13px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            background: transparent !important;
            color: var(--troika-primary, #3D304C) !important;
            border: 1px solid var(--troika-primary, #3D304C) !important;
            text-decoration: none !important;
            line-height: 1;
        }

            .register-local-back:hover {
                background: var(--troika-primary, #3D304C) !important;
                color: var(--troika-btn-text, #ffffff) !important;
                border-color: var(--troika-primary, #3D304C) !important;
                text-decoration: none !important;
                transform: translateY(-1px);
            }

        /* -------------------- Header -------------------- */

        .register-local-title {
            color: var(--troika-heading-text) !important;
            text-align: center;
            margin: 8px 0 26px 0;
            font-size: 32px;
            font-weight: 800;
            letter-spacing: 0.3px;
        }

        /* -------------------- Form fields -------------------- */

        .register-local-field {
            display: flex;
            flex-direction: column;
            gap: 7px;
            margin-bottom: 18px;
        }

        .register-local-field label,
        .register-local-check label,
        .register-local-card label {
            color: var(--troika-heading-text) !important;
            font-weight: 800;
            font-size: 15px;
        }

        .register-local-input {
            width: 100% !important;
            height: 48px;
            padding: 10px 14px !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 10px !important;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            box-sizing: border-box !important;
            font-size: 15px;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

            .register-local-input::placeholder {
                color: var(--troika-placeholder-text, #6b7280) !important;
                opacity: 0.85;
            }

            .register-local-input:focus {
                outline: none !important;
                border-color: var(--troika-primary) !important;
                box-shadow: 0 0 0 3px rgba(100, 79, 125, 0.18) !important;
            }

        .register-password-help-text {
            display: block;
            color: var(--troika-muted-text, #666666) !important;
            font-size: 13px;
            line-height: 1.5;
            margin-top: 2px;
        }

        /* -------------------- Validation / error messages -------------------- */

        .register-validation-summary {
            margin: 0 0 18px 0;
            padding: 12px 14px;
            border: 1px solid rgba(176, 0, 32, 0.35);
            border-radius: 10px;
            background: rgba(176, 0, 32, 0.07);
            color: #b00020 !important;
            font-weight: 700;
            font-size: 13px;
            line-height: 1.5;
        }

        .register-validation-summary ul {
            margin: 0;
            padding-left: 18px;
        }

        .register-validation-summary,
        .register-validation-summary *,
        .register-local-validator,
        .register-local-message.error,
        .register-local-card .field-validation-error,
        .register-local-card .validation-summary-errors,
        .register-local-card .text-danger {
            color: #b00020 !important;
        }

        .register-local-validator {
            display: block;
            font-size: 12.5px;
            font-weight: 700;
            line-height: 1.4;
            margin-top: 2px;
        }

        .register-local-card span[style*="color:Red"],
        .register-local-card span[style*="color:red"] {
            color: #b00020 !important;
        }

        /* -------------------- Show password -------------------- */

        .register-local-check {
            display: flex;
            align-items: center;
            gap: 9px;
            margin: 4px 0 22px 0;
            color: var(--troika-heading-text) !important;
            user-select: none;
        }

            .register-local-check input {
                width: 17px;
                height: 17px;
                cursor: pointer;
                accent-color: #2C5F2D;
            }

            .register-local-check label {
                cursor: pointer;
            }

        /* ============================================================
           DELIVERY SECTION 
           ============================================================ */

        .register-address-section {
            margin-top: 20px;
        }

        .register-toggle-address {
            background: var(--troika-btn-bg) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            font-weight: 600;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            justify-content: center;
        }

        .register-toggle-address:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        .register-address-form {
            display: none;
            margin-top: 15px;
            padding: 15px;
            border: 1px dashed var(--troika-border) !important;
            border-radius: 6px;
            background: var(--troika-surface-alt) !important;
            color: var(--troika-text) !important;
        }

        .register-address-form h4 {
            color: var(--troika-heading-text) !important;
            margin-bottom: 10px;
        }

        .register-address-form p {
            color: var(--troika-muted-text) !important;
            font-size: 14px;
            margin-bottom: 15px;
        }

        /* -------------------- Green register button -------------------- */

        .register-local-button,
        input.register-local-button,
        button.register-local-button {
            width: 100% !important;
            padding: 13px 16px !important;
            background: #2C5F2D !important;
            color: #ffffff !important;
            border: 1px solid #2C5F2D !important;
            border-radius: 10px !important;
            cursor: pointer !important;
            font-size: 15px !important;
            font-weight: 800 !important;
            letter-spacing: 0.2px;
            text-align: center !important;
            transition: background 0.2s ease, border-color 0.2s ease, transform 0.15s ease;
        }

            .register-local-button:hover,
            input.register-local-button:hover,
            button.register-local-button:hover {
                background: #24521f !important;
                border-color: #24521f !important;
                color: #ffffff !important;
                transform: translateY(-1px);
            }

        .register-local-message {
            display: block;
            text-align: center;
            font-weight: 800;
            color: var(--troika-success) !important;
            line-height: 1.45;
        }

        .register-local-message.error {
            color: #b00020 !important;
        }

        /* -------------------- Dark mode -------------------- */

        body[data-theme="dark"] .register-local-card {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.45);
        }

        body[data-theme="dark"] .register-local-title,
        body[data-theme="dark"] .register-local-card label,
        body[data-theme="dark"] .register-local-check label {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .register-local-input {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
        }

            body[data-theme="dark"] .register-local-input::placeholder {
                color: #c9c3d4 !important;
            }

            body[data-theme="dark"] .register-local-input:focus {
                border-color: #d9c8f0 !important;
                box-shadow: 0 0 0 3px rgba(217, 200, 240, 0.18) !important;
            }

        body[data-theme="dark"] .register-password-help-text {
            color: #b8afc6 !important;
        }

        body[data-theme="dark"] .register-local-back {
            color: #d9c8f0 !important;
            border-color: #d9c8f0 !important;
        }

            body[data-theme="dark"] .register-local-back:hover {
                background: #d9c8f0 !important;
                color: #121018 !important;
                border-color: #d9c8f0 !important;
            }

        body[data-theme="dark"] .register-validation-summary {
            border-color: rgba(255, 138, 138, 0.35);
            background: rgba(255, 138, 138, 0.10);
        }

        body[data-theme="dark"] .register-validation-summary,
        body[data-theme="dark"] .register-validation-summary *,
        body[data-theme="dark"] .register-local-validator,
        body[data-theme="dark"] .register-local-message.error,
        body[data-theme="dark"] .register-local-card .field-validation-error,
        body[data-theme="dark"] .register-local-card .validation-summary-errors,
        body[data-theme="dark"] .register-local-card .text-danger {
            color: #ff8a8a !important;
        }

        body[data-theme="dark"] .register-local-button,
        body[data-theme="dark"] input.register-local-button,
        body[data-theme="dark"] button.register-local-button {
            background: #2C5F2D !important;
            color: #ffffff !important;
            border-color: #2C5F2D !important;
        }

            body[data-theme="dark"] .register-local-button:hover,
            body[data-theme="dark"] input.register-local-button:hover,
            body[data-theme="dark"] button.register-local-button:hover {
                background: #24521f !important;
                color: #ffffff !important;
                border-color: #24521f !important;
            }

        body[data-theme="dark"] .register-address-form {
            background: #251f2f !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .register-address-form h4 {
            color: #ffffff !important;
        }

        body[data-theme="dark"] .register-address-form p {
            color: #d6d0df !important;
        }

        /* -------------------- Responsive -------------------- */

        @media (max-width: 600px) {
            .register-local-page {
                padding: 28px 14px 50px 14px;
            }

            .register-local-card {
                width: 100%;
                padding: 24px 22px 28px 22px;
            }

            .register-local-inner {
                width: 100%;
            }

            .register-local-title {
                font-size: 26px;
            }
        }
    </style>

    <div class="register-local-page">

        <div class="register-local-card">

            <div class="register-local-topbar">
                <a href="<%= ResolveUrl("~/Login.aspx") %>" class="register-local-back">&#8592; Back</a>
            </div>

            <div class="register-local-inner">

                <h1 class="register-local-title">Register</h1>

                <asp:ValidationSummary ID="vsRegister"
                    runat="server"
                    CssClass="register-validation-summary"
                    HeaderText="Please fix the following:"
                    DisplayMode="BulletList"
                    ValidationGroup="RegisterGroup" />

                <!-- First Name -->
                <div class="register-local-field">
                    <asp:Label ID="lblName" runat="server" Text="First Name:" AssociatedControlID="txtName" />
                    <asp:TextBox ID="txtName" runat="server" CssClass="register-local-input" />

                    <asp:RequiredFieldValidator ID="rfvName"
                        runat="server"
                        ControlToValidate="txtName"
                        ErrorMessage="First name is required."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup" />

                    <asp:RegularExpressionValidator ID="revName"
                        runat="server"
                        ControlToValidate="txtName"
                        ErrorMessage="First name may only contain letters, spaces, apostrophes, or hyphens."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup"
                        ValidationExpression="^[A-Za-z\s'-]{2,50}$" />
                </div>

                <!-- Surname -->
                <div class="register-local-field">
                    <asp:Label ID="lblSurname" runat="server" Text="Surname:" AssociatedControlID="txtSurname" />
                    <asp:TextBox ID="txtSurname" runat="server" CssClass="register-local-input" />

                    <asp:RequiredFieldValidator ID="rfvSurname"
                        runat="server"
                        ControlToValidate="txtSurname"
                        ErrorMessage="Surname is required."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup" />

                    <asp:RegularExpressionValidator ID="revSurname"
                        runat="server"
                        ControlToValidate="txtSurname"
                        ErrorMessage="Surname may only contain letters, spaces, apostrophes, or hyphens."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup"
                        ValidationExpression="^[A-Za-z\s'-]{2,50}$" />
                </div>

                <!-- Email -->
                <div class="register-local-field">
                    <asp:Label ID="lblEmail" runat="server" Text="Email:" AssociatedControlID="txtEmail" />
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="register-local-input" placeholder="you@example.com" />

                    <asp:RequiredFieldValidator ID="rfvEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup" />

                    <asp:RegularExpressionValidator ID="revEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Enter a valid email address."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                </div>

                <!-- Phone Number -->
                <div class="register-local-field">
                    <asp:Label ID="lblPhoneNum" runat="server" Text="Phone Number:" AssociatedControlID="txtPhoneNum"></asp:Label>
                    <asp:TextBox ID="txtPhoneNum" runat="server" MaxLength="10" TextMode="Phone" CssClass="register-local-input" placeholder="e.g) 0821234567"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvPhoneNum"
                        runat="server"
                        ControlToValidate="txtPhoneNum"
                        ErrorMessage="Phone number is required."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup" />

                    <asp:RegularExpressionValidator ID="revPhoneNum"
                        runat="server"
                        ControlToValidate="txtPhoneNum"
                        ErrorMessage="Phone number must be 10 digits and start with 0, for example 0821234567."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup"
                        ValidationExpression="^0[0-9]{9}$" />
                </div>

                <!-- Username -->
                <div class="register-local-field">
                    <asp:Label ID="lblUsername" runat="server" Text="Username:" AssociatedControlID="txtUsername" />
                    <asp:TextBox ID="txtUsername" runat="server" MaxLength="6" CssClass="register-local-input" />
                    <small class="register-password-help-text">Username must be exactly 6 characters.</small>

                    <asp:RequiredFieldValidator ID="rfvUsername"
                        runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Username is required."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup" />

                    <asp:RegularExpressionValidator ID="revUsername"
                        runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Username must be exactly 6 letters or numbers."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup"
                        ValidationExpression="^[A-Za-z0-9]{6}$" />
                </div>

                <!-- Password -->
                <div class="register-local-field">
                    <asp:Label ID="lblPassword" runat="server" Text="Password:" AssociatedControlID="txtPassword" />
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="8" CssClass="register-local-input" />
                    <small class="register-password-help-text">
                        Password must be 6 to 8 characters and include an uppercase letter, lowercase letter, number, and special character.
                    </small>

                    <asp:RequiredFieldValidator ID="rfvPassword"
                        runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup" />

                    <asp:RegularExpressionValidator ID="revPassword"
                        runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password must be 6 to 8 characters and include an uppercase letter, lowercase letter, number, and special character."
                        CssClass="register-local-validator"
                        Display="Dynamic"
                        ValidationGroup="RegisterGroup"
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{6,8}$" />
                </div>

                <!-- Show password toggle -->
                <div class="register-local-check">
                    <input type="checkbox" id="chkShowPwd" aria-label="Show password" />
                    <label for="chkShowPwd">Show password</label>
                </div>

                <!-- Optional Address Section -->
                <div id="addressSection" class="register-address-section">
                    <button type="button" id="btnToggleAddress" class="register-toggle-address">
                        <span id="toggleIcon" style="font-size:20px;">➕</span>
                        Add Delivery Address (Optional)
                    </button>

                    <!-- Hidden Address Form -->
                    <div id="addressForm" class="register-address-form">
                        <h4>Delivery Address</h4>
                        <p>
                            You can skip this and add your address later during checkout.
                        </p>

                        <!-- Street -->
                        <div class="register-local-field">
                            <asp:Label ID="lblStreet" runat="server" Text="Street Address:" AssociatedControlID="txtStreet" />
                            <asp:TextBox ID="txtStreet" runat="server" CssClass="register-local-input js-troika-street" />
                        </div>

                        <!-- Suburb -->
                        <div class="register-local-field">
                            <asp:Label ID="lblSuburb" runat="server" Text="Suburb:" AssociatedControlID="txtSuburb" />
                            <asp:TextBox ID="txtSuburb" runat="server" CssClass="register-local-input js-troika-suburb" />
                        </div>

                        <!-- Post Code -->
                        <div class="register-local-field">
                            <asp:Label ID="lblPostCode" runat="server" Text="Post Code:" AssociatedControlID="txtPostCode" />
                            <asp:TextBox ID="txtPostCode" runat="server" MaxLength="4" CssClass="register-local-input js-troika-postcode" />
                        </div>
                    </div>
                </div>

                <br />

                <!-- Register button -->
                <asp:Button ID="btnRegister" runat="server" Text="Register"
                    OnClick="btnRegister_Click"
                    CssClass="register-local-button"
                    ValidationGroup="RegisterGroup" />

                <br /><br />

                <asp:Label ID="lblMessage" runat="server" CssClass="register-local-message" />

            </div>
        </div>
    </div>

    <script type="text/javascript">
        (function () {
            function togglePasswordElement(checked) {
                var pwd = document.getElementById('<%= txtPassword.ClientID %>');
                if (!pwd) return;

                try {
                    pwd.type = checked ? 'text' : 'password';
                } catch (e) {
                    var newInput = document.createElement('input');
                    newInput.type = checked ? 'text' : 'password';
                    newInput.id = pwd.id;
                    newInput.name = pwd.name;
                    newInput.className = pwd.className;
                    newInput.value = pwd.value;
                    pwd.parentNode.replaceChild(newInput, pwd);
                }
            }

            var chk = document.getElementById('chkShowPwd');
            if (chk) {
                chk.addEventListener('change', function () {
                    togglePasswordElement(this.checked);
                });
            }

            var label = document.querySelector('label[for="chkShowPwd"]');
            if (label && chk) {
                label.addEventListener('keydown', function (e) {
                    if (e.key === ' ' || e.key === 'Enter') {
                        e.preventDefault();
                        chk.checked = !chk.checked;
                        togglePasswordElement(chk.checked);
                    }
                });
            }
        })();
    </script>

    <script type="text/javascript">
        (function () {
            var toggleBtn = document.getElementById("btnToggleAddress");
            var addressForm = document.getElementById("addressForm");
            var toggleIcon = document.getElementById("toggleIcon");

            if (toggleBtn && addressForm && toggleIcon) {
                toggleBtn.addEventListener("click", function () {
                    if (addressForm.style.display === "none" || addressForm.style.display === "") {
                        addressForm.style.display = "block";
                        toggleIcon.textContent = "➖";
                        toggleBtn.textContent = " Hide Delivery Address";
                        toggleBtn.prepend(toggleIcon);
                    } else {
                        addressForm.style.display = "none";
                        toggleIcon.textContent = "➕";
                        toggleBtn.textContent = " Add Delivery Address (Optional)";
                        toggleBtn.prepend(toggleIcon);
                    }
                });
            }
        })();
    </script>

    <!-- Google Places address autocomplete (defines the Maps callback first, then loads Maps). -->
    <script src="<%= ResolveUrl("~/Scripts/troika-address-autocomplete.js") %>"></script>
    <script
        src="https://maps.googleapis.com/maps/api/js?key=<%= System.Configuration.ConfigurationManager.AppSettings["GoogleMapsApiKey"] %>&libraries=places&loading=async&callback=initTroikaAddressAutocomplete"
        async defer></script>

</asp:Content>