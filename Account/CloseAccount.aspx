<%@ Page Title="Account Management" Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CloseAccount.aspx.cs" Inherits="TroikaClothingWeb.Account.CloseAccount" Async="true"%>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <p class="text-danger">
            <asp:Literal runat="server" ID="ErrorMessage" />
        </p>
        <div>
            <h4>Close Account</h4>
            <hr />
            <asp:ValidationSummary runat="server" CssClass="text-danger" />

        
            <div class="row">
                <asp:Label runat="server"  CssClass="col-md-2 col-form-label">Close Account</asp:Label>
                  </div>
              <div class="row">
                <div class="col-md-10">
                  <asp:Label runat="server"  CssClass="col-md-2 col-form-label">Are you sure you want to close your account?</asp:Label>
                  <%-- change to on submit button when added <asp:RequiredFieldValidator runat="server" ControlToValidate="CloseAccount" CssClass="text-danger" ErrorMessage="The Email field is required." /> --%>
                   <asp:Button runat="server" OnClick="Back_Click" Text="Back" CssClass="btn btn-outline-dark" />
                </div>
            </div>

    </main>
</asp:Content>