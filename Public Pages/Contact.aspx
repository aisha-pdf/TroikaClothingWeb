<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TroikaClothingWeb.Contact" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%--navy blue navigation bar with login, register etc--%>
    <nav class="navbar navbar-expand-sm navbar-troika1">
        <div class="container-fluid">
            <ul class="navbar-nav ms-auto d-flex flex-row text-white py-2">
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Public Pages/Products">Product Catalogue</a></li>
                <li class="nav-item"><a class="nav-link text-white" runat="server" href="~/Login">Login</a> </li>
            </ul>
        </div>
    </nav>
</asp:Content>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="background-color: #fff; padding: 40px; max-width: 1100px; margin: 40px auto; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
        <h2>How to Contact Us</h2>
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
</asp:Content>
