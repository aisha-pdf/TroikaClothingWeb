<%@ Page Title="Account Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountManagement.aspx.cs" Inherits="TroikaClothingWeb.Account.AccountManagement" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <p class="text-danger">
            <asp:Literal runat="server" ID="ErrorMessage" />
        </p>
        <div>
            <h4>Manage your account</h4>
            <hr />
            <asp:ValidationSummary runat="server" CssClass="text-danger" />

            <div class="row">
                <asp:Label runat="server" AssociatedControlID="FirstName" CssClass="col-md-2 col-form-label">First Name</asp:Label>
                  </div>
              <div class="row">
                <div class="col-md-10">
                    <asp:Label runat="server" ID="FirstName" CssClass="form-control" TextMode="FirstName" Text="****" />
                    <asp:Button runat="server" OnClick="Name_Click" Text="Edit" CssClass="btn btn-outline-dark" />
                </div>
            </div>
            </div>
            <p> 




            </p>
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="LastName" CssClass="col-md-2 col-form-label">Last Name</asp:Label>
                  </div>
             <div class="row">
                <div class="col-md-10">
                    <asp:Label runat="server" ID="LastName" CssClass="form-control" TextMode="LastName" />
                     <asp:Button runat="server" OnClick="LastName_Click" Text="Edit" CssClass="btn btn-outline-dark" />
                </div>
            </div>
                <p> 




                </p>
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="Email" CssClass="col-md-2 col-form-label">Email</asp:Label>
                </div>
              <div class="row">
                <div class="col-md-10">
                    <asp:Label runat="server" ID="Email" CssClass="form-control" TextMode="Email" />
                     <asp:Button runat="server" OnClick="Email_Click" Text="Edit" CssClass="btn btn-outline-dark" />
                </div>
            </div>
                <p> 




                </p>
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="PhoneNumber" CssClass="col-md-2 col-form-label">Phone Number</asp:Label>
                  </div>
              <div class="row">
                <div class="col-md-10">
                    <asp:Label runat="server" ID="PhoneNumber" CssClass="form-control" TextMode="Phone" />
                     <asp:Button runat="server" OnClick="PhoneNumber_Click" Text="Edit" CssClass="btn btn-outline-dark" />
                    </div>
                </div>
                <p> 




                </p>
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-2 col-form-label">Password</asp:Label>
               </div>
            <div class="row">
                <div class="col-md-10">
                    <asp:Label runat="server" ID="Password" CssClass="form-control" TextMode="Password" />
                    <asp:Button runat="server" OnClick="Password_Click" Text="Edit" CssClass="btn btn-outline-dark" />
                </div>
            </div>
                <p> 




                </p>
         </main>
    </asp:Content>