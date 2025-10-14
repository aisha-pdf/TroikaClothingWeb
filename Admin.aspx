<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="TroikaClothingWeb.Adminaspx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Sidebar + Content Wrapper -->
    <div style="display:flex; min-height:80vh;">

        <!-- Sidebar -->
        <div style="width:220px; background-color:#5B4470; padding:20px; color:white; display:flex; flex-direction:column; gap:15px;">
            <asp:Button ID="btnUserList" runat="server" Text="User List" CssClass="menu-btn" OnClick="btnUserList_Click" />
            <asp:Button ID="btnProfile" runat="server" Text="Profile" CssClass="menu-btn" OnClick="btnProfile_Click" />
            <asp:Button ID="btnSettings" runat="server" Text="Settings" CssClass="menu-btn" OnClick="btnSettings_Click" />
            <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="menu-btn" OnClick="btnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div style="flex:1; background:#f4f4f4; padding:30px;">
            <h2 style="color:#5B4470; margin-bottom:20px;">USER MANAGEMENT</h2>

            <!-- User Cards -->
            <div style="display:flex; flex-direction:column; gap:20px;">
                <!-- Example User -->
                <div style="background:white; padding:20px; display:flex; align-items:center; justify-content:space-between; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1);">
                    <div style="display:flex; align-items:center; gap:15px;">
                        <div>
                            <p style="margin:0; font-weight:bold;">Bella Simpson</p>
                            <p style="margin:0; color:gray;">bellas123@gmail.com</p>
                        </div>
                    </div>
                    <div>
                        <asp:Button runat="server" Text="View" CssClass="action-btn" />
                        <asp:Button runat="server" Text="Update" CssClass="action-btn" />
                    </div>
                </div>

                <!-- More users can be added here -->
            </div>
        </div>
    </div>

    <!-- Styles for Buttons -->
    <style>
        .menu-btn {
            background:#6C4F85;
            color:white;
            border:none;
            padding:10px;
            text-align:left;
            border-radius:5px;
            cursor:pointer;
            width:100%;
            font-size:14px;
        }
        .menu-btn:hover {
            background:#7D5C99;
        }
        .action-btn {
            background:#6C4F85;
            color:white;
            border:none;
            padding:8px 15px;
            border-radius:6px;
            margin-left:5px;
            cursor:pointer;
        }
        .action-btn:hover {
            background:#8365A8;
        }
    </style>
    
</asp:Content>
