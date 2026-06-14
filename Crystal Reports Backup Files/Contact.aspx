<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TroikaClothingWeb.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="troika-page contact-container">
        <div class="troika-section">
            <div class="troika-card">
                <h2 class="section-title">How to Contact Us</h2>

                <address>
                    <strong>Physical Address: </strong>
                    <br />
                    82 Statesman Drive<br />
                    Havenside, Chatsworth
                    <br />
                    Durban, KwaZulu-Natal
                    <br />
                    4092
                    <br />
                    <br />

                    <strong>Contact Information: </strong>
                    <br />
                    <abbr title="Telephone">Tel:</abbr>
                    (031) 4009471
                    <br />
                    <abbr title="Fax">Fax: </abbr>
                    (031) 4001729
                    <br />
                    <abbr title="Cellphone">Cell: </abbr>
                    082 927 9987
                    <br />
                    <abbr title="Email Address">Email: </abbr>
                    saxonnaidoo@vodamail.co.za
                </address>
            </div>
        </div>
    </div>

    <style>
        .contact-container address,
        .contact-container strong,
        .contact-container abbr {
            color: var(--troika-text) !important;
        }
    </style>
</asp:Content>