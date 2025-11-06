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
<asp:Button ID="btnCloseAccount" runat="server" Text="Close Account" Width="545px" ForeColor="White" BackColor="Red" Height="43px"  OnClientClick="return confirm('Are you sure you want to delete your account? This cannot be undone');" OnClick="btnCloseAccount_Click"/>            
                <asp:SqlDataSource ID="DSCloseLogin" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteLogin] WHERE [ID] = @original_ID AND [Username] = @original_Username AND [Password] = @original_Password AND [Role] = @original_Role AND (([Status] = @original_Status) OR ([Status] IS NULL AND @original_Status IS NULL))" InsertCommand="INSERT INTO [WebsiteLogin] ([Username], [Password], [Role], [Status]) VALUES (@Username, @Password, @Role, @Status)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [WebsiteLogin]" UpdateCommand="UPDATE WebsiteLogin SET Status = 'Inactive' WHERE (Username = @Username)">
                    <DeleteParameters>
                        <asp:Parameter Name="original_ID" Type="Int32" />
                        <asp:Parameter Name="original_Username" Type="String" />
                        <asp:Parameter Name="original_Password" Type="String" />
                        <asp:Parameter Name="original_Role" Type="String" />
                        <asp:Parameter Name="original_Status" Type="String" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="Role" Type="String" />
                        <asp:Parameter Name="Status" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="Role" Type="String" />
                        <asp:Parameter Name="Status" Type="String" />
                        <asp:Parameter Name="original_ID" Type="Int32" />
                        <asp:Parameter Name="original_Username" Type="String" />
                        <asp:Parameter Name="original_Password" Type="String" />
                        <asp:Parameter Name="original_Role" Type="String" />
                        <asp:Parameter Name="original_Status" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="DSCloseRegister" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [WebsiteRegister] WHERE [ID] = @original_ID AND [Name] = @original_Name AND [Surname] = @original_Surname AND [Email] = @original_Email AND [Username] = @original_Username AND [Password] = @original_Password AND [PhoneNumber] = @original_PhoneNumber AND [Status] = @original_Status" InsertCommand="INSERT INTO [WebsiteRegister] ([Name], [Surname], [Email], [Username], [Password], [PhoneNumber], [Status]) VALUES (@Name, @Surname, @Email, @Username, @Password, @PhoneNumber, @Status)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [WebsiteRegister]" UpdateCommand="UPDATE WebsiteRegister SET Status = 'Inactive' WHERE (Username = @Username)">
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
                        <asp:Parameter Name="Name" Type="String" />
                        <asp:Parameter Name="Surname" Type="String" />
                        <asp:Parameter Name="Email" Type="String" />
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="PhoneNumber" Type="String" />
                        <asp:Parameter Name="Status" Type="String" />
                        <asp:Parameter Name="original_ID" Type="Int32" />
                        <asp:Parameter Name="original_Name" Type="String" />
                        <asp:Parameter Name="original_Surname" Type="String" />
                        <asp:Parameter Name="original_Email" Type="String" />
                        <asp:Parameter Name="original_Username" Type="String" />
                        <asp:Parameter Name="original_Password" Type="String" />
                        <asp:Parameter Name="original_PhoneNumber" Type="String" />
                        <asp:Parameter Name="original_Status" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="DSCloseCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" DeleteCommand="DELETE FROM [Customer] WHERE [customerID] = @original_customerID AND (([email] = @original_email) OR ([email] IS NULL AND @original_email IS NULL)) AND (([status] = @original_status) OR ([status] IS NULL AND @original_status IS NULL)) AND (([phoneNum] = @original_phoneNum) OR ([phoneNum] IS NULL AND @original_phoneNum IS NULL)) AND (([streetAddress] = @original_streetAddress) OR ([streetAddress] IS NULL AND @original_streetAddress IS NULL)) AND (([suburb] = @original_suburb) OR ([suburb] IS NULL AND @original_suburb IS NULL)) AND (([postCode] = @original_postCode) OR ([postCode] IS NULL AND @original_postCode IS NULL))" InsertCommand="INSERT INTO [Customer] ([customerID], [email], [status], [phoneNum], [streetAddress], [suburb], [postCode]) VALUES (@customerID, @email, @status, @phoneNum, @streetAddress, @suburb, @postCode)" OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [Customer]" UpdateCommand="UPDATE Customer SET status = 'Inactive' WHERE (customerID = @customerID)">
                    <DeleteParameters>
                        <asp:Parameter Name="original_customerID" Type="String" />
                        <asp:Parameter Name="original_email" Type="String" />
                        <asp:Parameter Name="original_status" Type="String" />
                        <asp:Parameter Name="original_phoneNum" Type="String" />
                        <asp:Parameter Name="original_streetAddress" Type="String" />
                        <asp:Parameter Name="original_suburb" Type="String" />
                        <asp:Parameter Name="original_postCode" Type="String" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="customerID" Type="String" />
                        <asp:Parameter Name="email" Type="String" />
                        <asp:Parameter Name="status" Type="String" />
                        <asp:Parameter Name="phoneNum" Type="String" />
                        <asp:Parameter Name="streetAddress" Type="String" />
                        <asp:Parameter Name="suburb" Type="String" />
                        <asp:Parameter Name="postCode" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="email" Type="String" />
                        <asp:Parameter Name="status" Type="String" />
                        <asp:Parameter Name="phoneNum" Type="String" />
                        <asp:Parameter Name="streetAddress" Type="String" />
                        <asp:Parameter Name="suburb" Type="String" />
                        <asp:Parameter Name="postCode" Type="String" />
                        <asp:Parameter Name="original_customerID" Type="String" />
                        <asp:Parameter Name="original_email" Type="String" />
                        <asp:Parameter Name="original_status" Type="String" />
                        <asp:Parameter Name="original_phoneNum" Type="String" />
                        <asp:Parameter Name="original_streetAddress" Type="String" />
                        <asp:Parameter Name="original_suburb" Type="String" />
                        <asp:Parameter Name="original_postCode" Type="String" />
                        <asp:Parameter Name="customerID" />
                    </UpdateParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="gvCustomer" runat="server" AutoGenerateColumns="False" DataKeyNames="customerID" DataSourceID="DSCustomer" Visible="False">
                    <Columns>
                        <asp:BoundField DataField="customerID" HeaderText="customerID" ReadOnly="True" SortExpression="customerID" />
                        <asp:BoundField DataField="email" HeaderText="email" SortExpression="email" />
                        <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" />
                        <asp:BoundField DataField="phoneNum" HeaderText="phoneNum" SortExpression="phoneNum" />
                        <asp:BoundField DataField="streetAddress" HeaderText="streetAddress" SortExpression="streetAddress" />
                        <asp:BoundField DataField="suburb" HeaderText="suburb" SortExpression="suburb" />
                        <asp:BoundField DataField="postCode" HeaderText="postCode" SortExpression="postCode" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="DSCustomer" runat="server" ConnectionString="<%$ ConnectionStrings:LoginConnectionString %>" SelectCommand="SELECT * FROM [Customer]"></asp:SqlDataSource>
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
