<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="TroikaClothingWeb.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* -------------------- REGISTER PAGE LOCAL LIGHT/DARK MODE FIX -------------------- */

        .register-local-page {
            min-height: 90vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 30px 10px;
            background: var(--troika-bg) !important;
            color: var(--troika-text) !important;
        }

        .register-local-title {
            color: var(--troika-heading-text) !important;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 700;
        }

        .register-local-card {
            width: 380px;
            background: var(--troika-surface) !important;
            color: var(--troika-text) !important;
            padding: 30px;
            border-radius: 10px;
            border: 1px solid var(--troika-border) !important;
            box-shadow: var(--troika-card-shadow);
            box-sizing: border-box;
        }

        .register-local-field {
            margin-bottom: 12px;
        }

        .register-local-field label,
        .register-local-check label,
        .register-local-card label {
            color: var(--troika-text) !important;
            font-weight: 500;
        }

        .register-local-input {
            width: 100% !important;
            padding: 10px !important;
            border: 1px solid var(--troika-border) !important;
            border-radius: 5px !important;
            background: var(--troika-input-bg) !important;
            color: var(--troika-input-text) !important;
            box-sizing: border-box !important;
        }

        .register-local-input:focus {
            outline: none !important;
            border-color: var(--troika-primary) !important;
            box-shadow: 0 0 0 2px rgba(217, 200, 240, 0.25) !important;
        }

        .register-local-check {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 18px;
            color: var(--troika-text) !important;
        }

        .register-local-check label {
            user-select: none;
            cursor: pointer;
        }

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

        .register-local-button {
            width: 100% !important;
            padding: 10px !important;
            background: var(--troika-btn-bg) !important;
            color: var(--troika-btn-text) !important;
            border: 1px solid var(--troika-btn-bg) !important;
            border-radius: 5px !important;
            cursor: pointer !important;
            font-size: 16px !important;
            font-weight: 600 !important;
        }

        .register-local-button:hover {
            background: var(--troika-btn-hover-bg) !important;
            border-color: var(--troika-btn-hover-bg) !important;
            color: var(--troika-btn-text) !important;
        }

        .register-local-message {
            display: block;
            text-align: center;
            font-weight: bold;
            color: var(--troika-success) !important;
        }

        body[data-theme="dark"] .register-local-card {
            background: #1c1724 !important;
            color: #f5f3f7 !important;
            border-color: #3b3048 !important;
        }

        body[data-theme="dark"] .register-local-title,
        body[data-theme="dark"] .register-local-card label,
        body[data-theme="dark"] .register-local-check label {
            color: #f5f3f7 !important;
        }

        body[data-theme="dark"] .register-local-input {
            background: #251f2f !important;
            color: #ffffff !important;
            border-color: #3b3048 !important;
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

        @media (max-width: 480px) {
            .register-local-card {
                width: 95%;
            }
        }
    </style>

    <div class="register-local-page">

        <h1 class="register-local-title">Register</h1>

        <div class="register-local-card">

            <!-- First Name -->
            <div class="register-local-field">
                <asp:Label ID="lblName" runat="server" Text="First Name:" AssociatedControlID="txtName" />
                <asp:TextBox ID="txtName" runat="server" CssClass="register-local-input" />
            </div>

            <!-- Surname -->
            <div class="register-local-field">
                <asp:Label ID="lblSurname" runat="server" Text="Surname:" AssociatedControlID="txtSurname" />
                <asp:TextBox ID="txtSurname" runat="server" CssClass="register-local-input" />
            </div>

            <!-- Email -->
            <div class="register-local-field">
                <asp:Label ID="lblEmail" runat="server" Text="Email:" AssociatedControlID="txtEmail" />
                <asp:TextBox ID="txtEmail" runat="server" CssClass="register-local-input" />
            </div>

            <!-- Phone Number -->
            <div class="register-local-field">
                <asp:Label ID="lblPhoneNum" runat="server" Text="Phone Number:" AssociatedControlID="txtPhoneNum"></asp:Label>
                <asp:TextBox ID="txtPhoneNum" runat="server" MaxLength="10" CssClass="register-local-input"></asp:TextBox>
            </div>

            <!-- Username -->
            <div class="register-local-field">
                <asp:Label ID="lblUsername" runat="server" Text="Username (6 characters):" AssociatedControlID="txtUsername" />
                <asp:TextBox ID="txtUsername" runat="server" MaxLength="6" CssClass="register-local-input" />
            </div>

            <!-- Password -->
            <div class="register-local-field" style="margin-bottom:8px;">
                <asp:Label ID="lblPassword" runat="server" Text="Password (6-8 characters, include uppercase, lowercase, number and special character):" AssociatedControlID="txtPassword" />
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="8" CssClass="register-local-input" />
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
                        <asp:TextBox ID="txtStreet" runat="server" CssClass="register-local-input" />
                    </div>

                    <!-- Suburb -->
                    <div class="register-local-field">
                        <asp:Label ID="lblSuburb" runat="server" Text="Suburb:" AssociatedControlID="txtSuburb" />
                        <asp:TextBox ID="txtSuburb" runat="server" CssClass="register-local-input" />
                    </div>

                    <!-- Post Code -->
                    <div class="register-local-field">
                        <asp:Label ID="lblPostCode" runat="server" Text="Post Code:" AssociatedControlID="txtPostCode" />
                        <asp:TextBox ID="txtPostCode" runat="server" MaxLength="4" CssClass="register-local-input" />
                    </div>
                </div>
            </div>

            <br />

            <!-- Register button -->
            <asp:Button ID="btnRegister" runat="server" Text="Register"
                OnClick="btnRegister_Click"
                CssClass="register-local-button" />

            <br /><br />

            <asp:Label ID="lblMessage" runat="server" CssClass="register-local-message" />

            

            

            

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

</asp:Content>