<%@ Page Title="Account Management" Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true"  CodeBehind="UpdateLastName.aspx.cs" Inherits="TroikaClothingWeb.Account.UpdateLastName" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <p class="text-danger">
            <asp:Literal runat="server" ID="ErrorMessage" />
        </p>
        <div>
            <h4>Update Last Name</h4>
            <hr />
            <asp:ValidationSummary runat="server" CssClass="text-danger" />

        
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="LastName" CssClass="col-md-2 col-form-label">Last Name</asp:Label>
                  </div>
              <div class="row">
                <div class="col-md-10">
                   <asp:TextBox runat="server" ID="LastName" CssClass="form-control" />
                  <%-- change to on submit button when added <asp:RequiredFieldValidator runat="server" ControlToValidate="LastName" CssClass="text-danger" ErrorMessage="The Last Name field is required." /> --%>
                   <asp:Button runat="server" OnClick="Back_Click" Text="Back" CssClass="btn btn-outline-dark" />
                </div>
            </div>

    </main>
</asp:Content>
