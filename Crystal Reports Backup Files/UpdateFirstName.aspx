<%@ Page Title="Account Management" Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UpdateFirstName.aspx.cs" Inherits="TroikaClothingWeb.Account.UpdateFirstName" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <p class="text-danger">
            <asp:Literal runat="server" ID="ErrorMessage" />
        </p>
        <div>
            <h4>Update First Name</h4>
            <hr />
            <asp:ValidationSummary runat="server" CssClass="text-danger" />

        
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="FirstName" CssClass="col-md-2 col-form-label">First Name</asp:Label>
                  </div>
              <div class="row">
                <div class="col-md-10">
                   <asp:TextBox runat="server" ID="FirstName" CssClass="form-control" />
                   <asp:RequiredFieldValidator runat="server" ControlToValidate="FirstName" CssClass="text-danger" ErrorMessage="The First Name field is required." />
                   <asp:Button runat="server" OnClick="Back_Click" Text="Back" CssClass="btn btn-outline-dark" />
                </div>
            </div>

    </main>
</asp:Content>
