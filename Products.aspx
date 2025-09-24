<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="TroikaClothingWeb.Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <div class="products-container">
     <h1>Women's Clothing Collection</h1>

     <!-- Search and Filter Section -->
     <div class="search-filter-section">
         <div class="search-bar">
             <asp:TextBox ID="searchInput" runat="server" placeholder="Search products..." CssClass="search-input" onkeyup="toggleClearButton()"></asp:TextBox>
             <button type="button" id="clearSearchButton" class="clear-search-button" onclick="clearSearch()" style="display: none;">
                 ×
             </button>
             <asp:Button ID="searchButton" runat="server" Text="Search" CssClass="search-button" OnClientClick="filterProducts(); return false;" />
         </div>

         <!-- Filter section -->
         <div class="filter-section">
             <label for="categoryFilter">Filter by Category:</label>
             <asp:DropDownList ID="categoryFilter" runat="server" CssClass="category-dropdown" AutoPostBack="false">
                 <asp:ListItem Value="all" Text="All Categories"></asp:ListItem>
                 <asp:ListItem Value="Dress" Text="Dresses"></asp:ListItem>
                 <asp:ListItem Value="Blazer" Text="Blazers"></asp:ListItem>
                 <asp:ListItem Value="Gown" Text="Gowns"></asp:ListItem>
                 <asp:ListItem Value="Coat" Text="Coats"></asp:ListItem>
                 <asp:ListItem Value="Skirt" Text="Skirts"></asp:ListItem>
                 <asp:ListItem Value="Pants" Text="Pants"></asp:ListItem>
                 <asp:ListItem Value="Shirt" Text="Shirts"></asp:ListItem>
             </asp:DropDownList>
         </div>
     </div>

     <!-- Products Grid -->
     <div class="products-grid" id="productsGrid" runat="server">
     </div>
 </div>

 <style>
     /* Color variables from Site.css */
     :root {
         --troika-navy: #3D304C;
         --troika-white: #ffffff;
         --troika-light-accent: #644F7D;
         --troika-deep-green: #2C5F2D; /* deep green */
         --troika-cream: #F5F5DC; /* cream color */
     }

     /* Styles for the product page */
     .products-container {
         padding: 20px;
         max-width: 1400px;
         margin: 0 auto;
     }

         .products-container h1 {
             text-align: center;
             margin-bottom: 30px;
             color: var(--troika-navy); /* Using navy for headings */
             font-weight: 600;
         }

     /* Search and filter section styling */
     .search-filter-section {
         display: flex;
         justify-content: space-between;
         align-items: center;
         margin-bottom: 30px;
         flex-wrap: wrap;
         gap: 20px;
         background: transparent;
         padding: 0;
         box-shadow: none;
         border: none;
     }

     .search-bar {
         display: flex;
         align-items: center;
         position: relative;
     }

     .search-input {
         padding: 10px 15px;
         border: 1px solid var(--troika-light-accent); /* Navy border */
         border-radius: 4px;
         width: 300px;
         font-size: 16px;
         height: 40px;
         box-sizing: border-box;
         padding-right: 40px; /* Space for clear button */
     }

     /* Clear search button styling */
     .clear-search-button {
         position: absolute;
         right: 85px;
         top: 50%;
         transform: translateY(-50%);
         background: none;
         border: none;
         font-size: 20px;
         cursor: pointer;
         color: #999;
         width: 30px;
         height: 30px;
         display: flex;
         align-items: center;
         justify-content: center;
         border-radius: 50%;
     }

         .clear-search-button:hover {
             background-color: #f0f0f0;
             color: #333;
         }

     /* search button styling */
     .search-button {
         padding: 0 15px;
         background: var(--troika-navy); /* Navy background */
         color: var(--troika-white); /* White text */
         border: 1px solid var(--troika-navy);
         border-radius: 0 4px 4px 0;
         cursor: pointer;
         transition: background 0.3s ease;
         font-weight: 500;
         height: 40px;
         line-height: 40px;
         margin-left: -4px; /* Overlap with search input */
     }

         .search-button:hover {
             background: var(--troika-light-accent); /* Lighter navy on hover */
         }

     .filter-section {
         display: flex;
         align-items: center;
         gap: 10px;
         margin-left: auto; /* Push filter section to the right */
     }

         .filter-section label {
             font-weight: 500;
             color: var(--troika-navy); /* Navy text */
         }

     .category-dropdown {
         padding: 10px;
         border: 1px solid var(--troika-light-accent); /* Navy border */
         border-radius: 4px;
         background: var(--troika-white);
         color: var(--troika-navy);
         height: 40px;
     }

     /* Products grid */
     .products-grid {
         display: grid;
         grid-template-columns: repeat(5, 1fr);
         gap: 20px;
     }

     /* Product card styling */
     .product-card {
         background: var(--troika-white);
         border-radius: 8px;
         overflow: hidden;
         box-shadow: 0 4px 8px rgba(0,0,0,0.1);
         transition: transform 0.3s ease, box-shadow 0.3s ease;
         display: flex;
         flex-direction: column;
         height: 100%;
         border: 1px solid #e2e8f0;
     }

         .product-card:hover {
             transform: translateY(-5px);
             box-shadow: 0 6px 12px rgba(0,0,0,0.15);
             border-color: var(--troika-light-accent);
         }

     .product-image {
         height: 320px;
         background: linear-gradient(135deg, #f5f7fa 0%, #e2e8f0 100%);
         display: flex;
         align-items: center;
         justify-content: center;
         overflow: hidden;
         position: relative;
     }

         .product-image img {
             width: 100%;
             height: 100%;
             object-fit: cover;
         }

     /* styling for missing images */
     .image-placeholder {
         width: 100%;
         height: 100%;
         display: flex;
         align-items: center;
         justify-content: center;
         background: #e2e8f0;
         color: var(--troika-light-accent); /* Navy text */
         font-size: 14px;
         text-align: center;
         padding: 20px;
     }

     .product-info {
         padding: 20px;
         display: flex;
         flex-direction: column;
         flex-grow: 1;
     }

     .product-name {
         font-weight: 600;
         font-size: 18px;
         margin-bottom: 8px;
         color: var(--troika-navy); /* Navy text */
     }

     .product-description {
         color: #718096;
         font-size: 14px;
         margin-bottom: 15px;
         flex-grow: 1;
     }

     .product-category {
         display: inline-block;
         background: rgba(61, 48, 76, 0.1); /* Light navy background */
         color: var(--troika-navy); /* Navy text */
         padding: 5px 10px;
         border-radius: 4px;
         font-size: 12px;
         margin-bottom: 15px;
         font-weight: 500;
     }

     .product-price {
         font-weight: 700;
         font-size: 20px;
         color: #000000;
         margin-bottom: 15px;
     }

     /* Add to cart button styling */
     .add-to-cart {
         width: 100%;
         padding: 10px;
         background: var(--troika-deep-green); /* deep green background */
         color: var(--troika-white); /* white text */
         border: none;
         border-radius: 4px;
         cursor: pointer;
         font-weight: 500;
         transition: background 0.3s ease;
     }

         .add-to-cart:hover {
             background: #234823; /* darker green on hover */
         }

     /* No products message styling */
     .no-products {
         grid-column: 1 / -1;
         text-align: center;
         padding: 40px;
         font-size: 18px;
         color: var(--troika-light-accent); /* Navy text */
     }

     /* Responsive design */
     @media (max-width: 1200px) {
         .products-grid {
             grid-template-columns: repeat(4, 1fr);
         }
     }

     @media (max-width: 992px) {
         .products-grid {
             grid-template-columns: repeat(3, 1fr);
         }

         .product-image {
             height: 280px;
         }

         .search-filter-section {
             flex-direction: column;
             align-items: stretch;
         }

         .search-bar {
             width: 100%;
         }

         .search-input {
             width: 100%;
         }

         .clear-search-button {
             right: 85px;
         }

         .filter-section {
             margin-left: 0; /* Reset margin on mobile */
             justify-content: flex-start; /* Align to left on mobile */
         }
     }

     @media (max-width: 768px) {
         .products-grid {
             grid-template-columns: repeat(2, 1fr);
             gap: 15px;
         }

         .product-image {
             height: 240px;
         }

         .filter-section {
             flex-wrap: wrap;
         }

         .clear-search-button {
             right: 75px;
         }
     }

     @media (max-width: 480px) {
         .products-grid {
             grid-template-columns: 1fr;
         }

         .product-image {
             height: 280px;
         }

         .clear-search-button {
             right: 65px;
         }
     }
 </style>

 <script type="text/javascript">
     // Product data with updated image paths and prices
     var products = [
         { id: 'P001', name: 'Summer Dress', description: 'Red sleeveless cotton dress for summer wear', category: 'Dress', price: 'R199.99', image: '/images/red summer dress.jpeg' },
         { id: 'P002', name: 'Formal Linen Blazer', description: 'Navy blue blazer made from fine linen', category: 'Blazer', price: 'R399.99', image: '/images/formal linen blazer.jpeg' },
         { id: 'P003', name: 'Evening Silk Gown', description: 'Green silk gown for formal evening wear', category: 'Gown', price: 'R1099.00', image: '/images/evening silk gown.jpeg' },
         { id: 'P004', name: 'Wool Winter Coat', description: 'Beige wool coat with gold buttons', category: 'Coat', price: 'R699.00', image: '/images/beige wool coat.jpg' },
         { id: 'P005', name: 'Denim Skirt', description: 'High-waisted A-line denim skirt', category: 'Skirt', price: 'R149.99', image: '/images/denim skirt.jpeg' },
         { id: 'P007', name: 'Casual Cotton Pants', description: 'Brown cotton pants for everyday wear', category: 'Pants', price: 'R129.99', image: '/images/brown cotton pants.jpeg' },
         { id: 'P009', name: 'Blue Maxi Dress', description: 'Light blue maxi dress', category: 'Dress', price: 'R549.99', image: '/images/light blue maxi dress.jpeg' },
         { id: 'P010', name: 'Office Shirt', description: 'White office wear shirt with buttons', category: 'Shirt', price: 'R149.99', image: '/images/white office shirt.jpeg' },
         { id: 'P011', name: 'White Linen Pants', description: 'White mid-rise pants perfect for summer', category: 'Pants', price: 'R169.99', image: '/images/white linen pants.jpeg' }
     ];

     // Function to toggle clear search button visibility
     function toggleClearButton() {
         var searchInput = document.getElementById('<%= searchInput.ClientID %>');
         var clearButton = document.getElementById('clearSearchButton');

         if (searchInput.value.trim() !== '') {
             clearButton.style.display = 'block';
         } else {
             clearButton.style.display = 'none';
         }
     }

     // Function to clear search
     function clearSearch() {
         var searchInput = document.getElementById('<%= searchInput.ClientID %>');
         searchInput.value = '';
         document.getElementById('clearSearchButton').style.display = 'none';
         filterProducts(); // Refresh the products display
     }

     // Function to display products
     function displayProducts(productsToShow) {
         var grid = document.getElementById('<%= productsGrid.ClientID %>');
         grid.innerHTML = '';

         if (productsToShow.length === 0) {
             grid.innerHTML = '<p class="no-products">No products found matching your criteria.</p>';
             return;
         }

         for (var i = 0; i < productsToShow.length; i++) {
             var product = productsToShow[i];

             // image handling for missing images
             var imageHtml = product.image && product.image !== '/images/'
                 ? '<img src="' + product.image + '" alt="' + product.name + '" onerror="handleImageError(this)">'
                 : '<div class="image-placeholder">Image not available</div>';

             var productCard =
                 '<div class="product-card">' +
                 '<div class="product-image">' +
                 imageHtml +
                 '</div>' +
                 '<div class="product-info">' +
                 '<div class="product-name">' + product.name + '</div>' +
                 '<div class="product-description">' + product.description + '</div>' +
                 '<span class="product-category">' + product.category + '</span>' +
                 '<div class="product-price">' + product.price + '</div>' +
                 '<button class="add-to-cart" data-product-id="' + product.id + '" data-product-name="' + product.name + '">Add to Cart</button>' +
                 '</div>' +
                 '</div>';

             grid.innerHTML += productCard;
         }

         // event listeners to all Add to Cart buttons
         var buttons = document.getElementsByClassName('add-to-cart');
         for (var j = 0; j < buttons.length; j++) {
             buttons[j].addEventListener('click', function () {
                 var productId = this.getAttribute('data-product-id');
                 var productName = this.getAttribute('data-product-name');
                 addToCart(productId, productName);
             });
         }
     }

     // Function to handle image errors
     function handleImageError(img) {
         img.parentNode.innerHTML = '<div class="image-placeholder">Image not available</div>';
     }

     // Function to filter products based on search and category
     function filterProducts() {
         var searchInput = document.getElementById('<%= searchInput.ClientID %>');
         var searchText = searchInput.value.toLowerCase().trim();
         var category = document.getElementById('<%= categoryFilter.ClientID %>').value;

         console.log("Filtering with search:", searchText, "category:", category);

         var filteredProducts = [];
         for (var i = 0; i < products.length; i++) {
             var product = products[i];

             // Search only checks name/description
             var matchesSearch = searchText === '' ||
                 product.name.toLowerCase().indexOf(searchText) >= 0 ||
                 product.description.toLowerCase().indexOf(searchText) >= 0;

             // Category only checks category
             var matchesCategory = category === 'all' || product.category === category;

             // Both must pass
             if (matchesSearch && matchesCategory) {
                 filteredProducts.push(product);
             }
         }

         console.log("Filtered products count:", filteredProducts.length);
         displayProducts(filteredProducts);

         // Update clear button visibility
         toggleClearButton();

         return false; // prevent postback
     }

     // Function to handle adding to cart 
     function addToCart(productId, productName) {
         alert(productName + ' has been added to your cart!');

     }

     // Initialize the page with all products
     function initializePage() {
         // Display all products initially
         displayProducts(products);

         // Add event listener for Enter key in search
         document.getElementById('<%= searchInput.ClientID %>').onkeypress = function (e) {
             if (e.key === 'Enter') {
                 filterProducts();
                 return false; // Prevent form submission
             }
         };

         // Add event listener for category filter change
         document.getElementById('<%= categoryFilter.ClientID %>').onchange = function () {
             filterProducts(); // Auto-filter when category changes
         };

         // Initial toggle of clear button
         toggleClearButton();
     }

     // Run initialization when page is loaded
     if (document.readyState === 'loading') {
         document.addEventListener('DOMContentLoaded', initializePage);
     } else {
         initializePage();
     }
 </script>
</asp:Content>
