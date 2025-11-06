<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerProfile.aspx.cs" Inherits="TroikaClothingWeb.Customer_Pages.CustomerProfile" %>


<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>
    <h4>Manage your account</h4>

    <div class="container mt-4">
        <div class="row">
            <!-- account details boxes -->
            <div class="col-md-6">
                <h5>Account Details</h5>
                <hr />
                <asp:Label ID="LblMessage" runat="server"></asp:Label>
                <asp:SqlDataSource ID="DSWebDetails" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT [Name], [Surname], [Email], [Username], [Password], [PhoneNumber] FROM [WebsiteRegister] WHERE ([Username] = @Username)" UpdateCommand="UPDATE WebsiteRegister SET Name = @Name, Surname = @Surname, Email = @Email, PhoneNumber = @PhoneNumber WHERE (Username = @Username)">
                    <SelectParameters>
                        <asp:SessionParameter Name="Username" SessionField="Username" Type="String" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Name" />
                        <asp:Parameter Name="Surname" />
                        <asp:Parameter Name="Email" />
                        <asp:Parameter Name="PhoneNumber" />
                        <asp:Parameter Name="Username" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:ValidationSummary runat="server" CssClass="text-danger" />
                <br />

                <!-- FormView for Customer Info -->
                <asp:FormView ID="CustomerForm" runat="server" DefaultMode="Edit" DataSourceID="DSWebDetails" OnItemCommand="CustomerForm_ItemCommand" OnItemUpdating="CustomerForm_ItemUpdating" Width="544px">
                    <EditItemTemplate>
                        <div class="form-group mb-3">
                            <label>Name:</label>
                            <asp:TextBox ID="Name" runat="server" CssClass="form-control"
                                Text='<%# Bind("Name") %>' />
                        </div>

                        <div class="form-group mb-3">
                            <label>Surname:</label>
                            <asp:TextBox ID="Surname" runat="server" CssClass="form-control"
                                Text='<%# Bind("Surname") %>' />
                        </div>

                        <div class="form-group mb-3">
                            <label>Email:</label>
                            <asp:TextBox ID="Email" runat="server" CssClass="form-control"
                                Text='<%# Bind("Email") %>' />
                        </div>

                        <div class="form-group mb-3">
                            <label>Username:</label>
                            <asp:TextBox ID="Username" runat="server" CssClass="form-control"
                                Text='<%# Bind("Username") %>' ReadOnly="true" />
                        </div>

                        <div class="form-group mb-3">
                            <label>Password:</label>
                            <asp:TextBox ID="Password" runat="server" CssClass="form-control"
                                Text='<%# Bind("Password") %>' />
                        </div>

                        <div class="form-group mb-3">
                            <label>Phone Number:</label>
                            <asp:TextBox ID="PhoneNumber" runat="server" CssClass="form-control"
                                Text='<%# Bind("PhoneNumber") %>' />
                        </div>

                        <div class="form-group mt-4 button-group">
                            <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Save Changes"
                                CssClass="menu-btn" />
                            <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel"
                                CssClass="menu-btn" />
                        </div>
                    </EditItemTemplate>
                </asp:FormView>
            </div>

            <!-- address detail boxes -->
            <div class="col-md-6">
                <h5>Address Details</h5>
                <hr />
                <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DefaultMode="Edit" DataSourceID="DSAddress"
                    BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="4"
                    ForeColor="Black" GridLines="None" Width="100%" OnItemCommand="DetailsView1_ItemCommand"
                    OnItemUpdating="DetailsView1_ItemUpdating" OnItemUpdated="DetailsView1_ItemUpdated" Height="156px">

                   
                    <HeaderStyle BackColor="#333333" Font-Bold="True" ForeColor="White" CssClass="p-2" />
                    <FooterStyle BackColor="#CCCC99" ForeColor="Black" />
                    <PagerStyle BackColor="White" ForeColor="Black" HorizontalAlign="Right" />

                    <Fields>
                        <asp:TemplateField HeaderText="Street Address">
                            <EditItemTemplate>
                                <div class="form-group mb-3">
                                    <asp:TextBox ID="txtStreetAddress" runat="server" CssClass="form-control"
                                        Text='<%# Bind("streetAddress") %>' />
                                </div>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("streetAddress") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Suburb">
                            <EditItemTemplate>
                                <div class="form-group mb-3">
                                    <asp:TextBox ID="txtSuburb" runat="server" CssClass="form-control"
                                        Text='<%# Bind("suburb") %>' />
                                </div>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("suburb") %>
                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Post Code">
                            <EditItemTemplate>
                                <div class="form-group mb-3">
                                    <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control"
                                        Text='<%# Bind("postCode") %>' />
                                </div>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <%# Eval("postCode") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Phone Number" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblPhoneNum" runat="server"
                                    Text='<%# Eval("phoneNum") %>'
                                    ForeColor="White" Font-Bold="true" CssClass="p-1 rounded" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField>
                            <EditItemTemplate>
                                <div class="form-group mt-4 d-flex gap-2">
                                    <asp:Button ID="btnUpdate" runat="server" CommandName="Update" Text="Save Changes"
                                        CssClass="menu-btn" />
                                    <asp:Button ID="btnCancel" runat="server" CommandName="CancelChanges" Text="Cancel"
                                        CssClass="menu-btn" />
                                </div>
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Fields>
                </asp:DetailsView>

                <%-- <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DefaultMode="Edit" DataSourceID="DSAddress" Width="100%" OnItemCommand="DetailsView1_ItemCommand" BorderColor="White">
                    <HeaderStyle CssClass="p-2" />
                    <Fields>
                        <asp:BoundField DataField="streetAddress" HeaderText="streetAddress" SortExpression="streetAddress" />
                        <asp:BoundField DataField="suburb" HeaderText="suburb" SortExpression="suburb" />
                        <asp:BoundField DataField="postCode" HeaderText="postCode" SortExpression="postCode" />
                        
                    </Fields>
                </asp:DetailsView>
            </div>--%>

                <asp:SqlDataSource ID="DSAddress" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT streetAddress, suburb, postCode, phoneNum FROM Customer WHERE (customerID = @CusID)" UpdateCommand="UPDATE Customer SET streetAddress = @streetAddress, suburb = @suburb, postCode = @postCode, phoneNum = @phoneNum WHERE (customerID = @CusID)">
                    <SelectParameters>
                        <asp:Parameter Name="CusID" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="streetAddress" />
                        <asp:Parameter Name="suburb" />
                        <asp:Parameter Name="postCode" />
                        <asp:Parameter Name="phoneNum" />
                        <asp:Parameter Name="CusID" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>

            <!-- Styles for Buttons -->
            <style>
                .button-group {
                    display: flex;
                    gap: 10px; /* space between buttons */
                }

                .menu-btn {
                    background: #6C4F85;
                    color: white;
                    border: none;
                    padding: 10px;
                    text-align: left;
                    border-radius: 5px;
                    cursor: pointer;
                    width: 100%;
                    font-size: 14px;
                }

                    .menu-btn:hover {
                        background: #7D5C99;
                    }

                .action-btn {
                    background: #6C4F85;
                    color: white;
                    border: none;
                    padding: 8px 15px;
                    border-radius: 6px;
                    margin-left: 5px;
                    cursor: pointer;
                }

                    .action-btn:hover {
                        background: #8365A8;
                    }
            </style>
        </div>
    </div>
</asp:Content>
