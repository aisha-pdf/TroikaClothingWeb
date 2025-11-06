<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TroikaClothingWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Homepage Main Section -->
    <section class="py-5" style="background-color: #ffffff;">
        <div class="container text-center">
            <div class="row justify-content-center gy-4">

                <!-- About Us Card -->
                <div class="col-12 col-md-4">
                    <div class="card h-100 text-center shadow-sm"
                        style="border-radius: 20px; background-color: #3D304C; color: white; min-height: 420px; padding: 25px;">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <img src="Images/1.png" alt="About Us" class="mb-4" style="width: 150px;">
                                <h4 class="card-title fw-bold">ABOUT US</h4>
                                <p class="card-text mt-3">
                                    Learn more about our journey, values, and the team dedicated to bringing you the best.
                                </p>
                            </div>
                            <a href="Public Pages/About.aspx" class="btn btn-light mt-4">Learn More</a>
                        </div>
                    </div>
                </div>

                <!-- Contact Card -->
                <div class="col-12 col-md-4">
                    <div class="card h-100 text-center shadow-sm"
                        style="border-radius: 20px; background-color: #3D304C; color: white; min-height: 420px; padding: 25px;">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <img src="Images/2.png" alt="Contact" class="mb-4" style="width: 150px;">
                                <h4 class="card-title fw-bold">CONTACT</h4>
                                <p class="card-text mt-3">
                                    Get in touch with us for inquiries, support, or just to say hello!
                                </p>
                            </div>
                            <a href="Public Pages/Contact.aspx" class="btn btn-light mt-4">Contact Us</a>
                        </div>
                    </div>
                </div>

                <!-- Browse Collection Card -->
                <div class="col-12 col-md-4">
                    <div class="card h-100 text-center shadow-sm"
                        style="border-radius: 20px; background-color: #3D304C; color: white; min-height: 420px; padding: 25px;">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <img src="Images/3.png" alt="Products" class="mb-4" style="width: 150px;">
                                <h4 class="card-title fw-bold">BROWSE OUR COLLECTION</h4>
                                <p class="card-text mt-3">
                                    Explore our range of quality products designed to meet your needs and preferences.
                                </p>
                            </div>
                            <a href="Public Pages/Products.aspx" class="btn btn-light mt-4">View Catalogue</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

</asp:Content>
