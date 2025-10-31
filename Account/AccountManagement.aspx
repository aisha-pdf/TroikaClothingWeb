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
                    <asp:TextBox ID="FirstName" runat="server" Width="393px"></asp:TextBox>
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
                    <asp:TextBox ID="LastName" runat="server" Width="393px"></asp:TextBox>
                </div>
            </div>
                <p> 




                </p>
            <div class="row">
                <asp:Label ID="Label1" runat="server" Text="Email"></asp:Label>
                </div>
              <div class="row">
                <div class="col-md-10">
                   <asp:TextBox ID="Email" runat="server" Width="393px"></asp:TextBox>
                </div>
            </div>
                <p> 




                </p>
            <div class="row">
                <asp:Label ID="Label2" runat="server" Text="Phone Number"></asp:Label>
                  </div>
              <div class="row">
                <div class="col-md-10">
                    <asp:TextBox ID="PhoneNumber" runat="server" Width="393px"></asp:TextBox>
                    </div>
                </div>
                <p> 




                </p>
            <div class="row">
                <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-2 col-form-label">Password</asp:Label>
               </div>
            <div class="row">
                <div class="col-md-10">
                    <asp:TextBox ID="Password" runat="server" Width="393px"></asp:TextBox>
                </div>
            </div>
                <p> 




                </p>
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="DSUsers" Visible="False">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                        <asp:BoundField DataField="Surname" HeaderText="Surname" SortExpression="Surname" />
                        <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                        <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
                        <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password" />
                        <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" SortExpression="PhoneNumber" />
                    </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="DSUsers" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT * FROM [WebsiteRegister]"></asp:SqlDataSource>
                <div style ="float:left; width:50%;">
                <asp:Button runat="server" OnClick="SaveChanges_Click" Text="Save Changes" CssClass="btn btn-outline-dark" ForeColor="Black" />

                    </div>

        <div style ="float:left; width:50%;">
         <asp:Button runat="server" OnClick="CloseAccount_Click" Text="Close Account" CssClass="btn btn-outline-dark" ForeColor="Red" />

        </div>

         </main>
    </asp:Content>