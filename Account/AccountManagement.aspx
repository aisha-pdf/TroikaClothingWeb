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
            <asp:Label ID="LblMessage" runat="server"></asp:Label>
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
                        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                    </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="DSUsers" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT * FROM [WebsiteRegister]"></asp:SqlDataSource>
                <asp:SqlDataSource ID="DSUpdate" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password AND (([PhoneNumber] = @original_PhoneNumber) OR ([PhoneNumber] IS NULL AND @original_PhoneNumber IS NULL)) AND (([Status] = @original_Status) OR ([Status] IS NULL AND @original_Status IS NULL))" InsertCommand="INSERT INTO [WebsiteRegister] ([Name], [Surname], [Email], [Username], [Password], [PhoneNumber], [Status]) VALUES (@Name, @Surname, @Email, @Username, @Password, @PhoneNumber, @Status)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [WebsiteRegister]" UpdateCommand="UPDATE WebsiteRegister SET Name = @Name, Surname = @Surname, Email = @Email, Password = @Password, PhoneNumber = @PhoneNumber WHERE (ID = @ID)">
                    <DeleteParameters>
                        <asp:Parameter Name="original_ID" Type="Int32" />
                        <asp:Parameter Name="original_Name" Type="String" />
                        <asp:Parameter Name="original_Surname" Type="String" />
                        <asp:Parameter Name="original_Email" Type="String" />
                        <asp:Parameter Name="original_Username" Type="String" />
                        <asp:Parameter Name="original_Password" Type="String" />
                        <asp:Parameter Name="original_PhoneNumber" Type="String" />
                        <asp:Parameter Name="original_Status" Type="String" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="Name" Type="String" />
                        <asp:Parameter Name="Surname" Type="String" />
                        <asp:Parameter Name="Email" Type="String" />
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="PhoneNumber" Type="String" />
                        <asp:Parameter Name="Status" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:ControlParameter ControlID="FirstName" Name="Name" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="LastName" Name="Surname" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="Email" Name="Email" PropertyName="Text" Type="String" />
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:ControlParameter ControlID="Password" Name="Password" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="Password" Name="PhoneNumber" PropertyName="Text" Type="String" />
                        <asp:Parameter Name="Status" Type="String" />
                        <asp:Parameter Name="original_ID" Type="Int32" />
                        <asp:Parameter Name="original_Name" Type="String" />
                        <asp:Parameter Name="original_Surname" Type="String" />
                        <asp:Parameter Name="original_Email" Type="String" />
                        <asp:Parameter Name="original_Username" Type="String" />
                        <asp:Parameter Name="original_Password" Type="String" />
                        <asp:Parameter Name="original_PhoneNumber" Type="String" />
                        <asp:Parameter Name="original_Status" Type="String" />
                        <asp:ControlParameter ControlID="ID" Name="ID" PropertyName="Text" />
                    </UpdateParameters>
    </asp:SqlDataSource>
                <div style ="float:left; width:50%;">
                <asp:Button runat="server" OnClick="SaveChanges_Click" Text="Save Changes" CssClass="btn btn-outline-dark" ForeColor="Black" />

                    <asp:SqlDataSource ID="DSClose" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password AND (([PhoneNumber] = @original_PhoneNumber) OR ([PhoneNumber] IS NULL AND @original_PhoneNumber IS NULL)) AND (([Status] = @original_Status) OR ([Status] IS NULL AND @original_Status IS NULL))" InsertCommand="INSERT INTO [WebsiteRegister] ([Name], [Surname], [Email], [Username], [Password], [PhoneNumber], [Status]) VALUES (@Name, @Surname, @Email, @Username, @Password, @PhoneNumber, @Status)" OldValuesParameterFormatString="original_{0}" OnSelecting="DSClose_Selecting" SelectCommand="SELECT * FROM [WebsiteRegister]" UpdateCommand="UPDATE WebsiteRegister SET Status = 'Inactive' WHERE (ID = @ID)">
                        <DeleteParameters>
                            <asp:Parameter Name="original_ID" Type="Int32" />
                            <asp:Parameter Name="original_Name" Type="String" />
                            <asp:Parameter Name="original_Surname" Type="String" />
                            <asp:Parameter Name="original_Email" Type="String" />
                            <asp:Parameter Name="original_Username" Type="String" />
                            <asp:Parameter Name="original_Password" Type="String" />
                            <asp:Parameter Name="original_PhoneNumber" Type="String" />
                            <asp:Parameter Name="original_Status" Type="String" />
                        </DeleteParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Name" Type="String" />
                            <asp:Parameter Name="Surname" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="Username" Type="String" />
                            <asp:Parameter Name="Password" Type="String" />
                            <asp:Parameter Name="PhoneNumber" Type="String" />
                            <asp:Parameter Name="Status" Type="String" />
                        </InsertParameters>
                        <UpdateParameters>
                            <asp:ControlParameter ControlID="ID" Name="ID" PropertyName="Text" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

                    </div>

        <div style ="float:left; width:50%;">
         <asp:Button runat="server" OnClick="CloseAccount_Click" Text="Close Account" CssClass="btn btn-outline-dark" ForeColor="Red" OnClientClick="return confirm('Are you sure you want to delete your account? This cannot be undone');" />

        </div>

         <asp:Label ID="ID" runat="server" Visible="False"></asp:Label>

         </main>
    </asp:Content>