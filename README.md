# Troika Clothing Web

The e-commerce website for Troika Clothing C.C., a Cut, Make and Trim clothing
manufacturer in Durban that wanted to move from wholesale into direct-to-consumer
retail. Customers browse the women's collection, save favourites, build a cart,
check out and receive an emailed receipt. Administrators maintain the catalogue,
manage user accounts and read a business intelligence dashboard built on the same
sales data. Written in C# with ASP.NET Web Forms on .NET Framework 4.7.2, over
SQL Server, and deployed to Azure App Service.

**Developed by:** Aisha Abba Omar, Denica Chetty, Peyton Govender, Firdous Mariam
Khan, Nontando Mthethwa, Antoinette Naidoo, Moosa Suliman Nakooda and Mohammed
Saib, across the 2025 and 2026 ISTN modules.

The site is one half of a two-platform system. The other half is
[Troika Mobile](https://github.com/Mohammed-Saib/Troika-Mobile-App), an Android
client that was built against the same SQL Server database, the same validation
rules and the same receipt design, so orders placed on either platform land in
the same tables and show up together in the reports.

## Screenshots

| Home | Home, dark mode | Shop |
| :---: | :---: | :---: |
| ![Home](docs/screenshots/01-home.jpg) | ![Home in dark mode](docs/screenshots/02-home-dark.jpg) | ![Shop](docs/screenshots/03-shop.jpg) |

| Product detail | Size guide | Wishlist |
| :---: | :---: | :---: |
| ![Product detail](docs/screenshots/04-product-detail.jpg) | ![Size guide](docs/screenshots/05-size-guide.jpg) | ![Wishlist](docs/screenshots/06-wishlist.jpg) |

| Cart | Free delivery earned | Order confirmed |
| :---: | :---: | :---: |
| ![Cart](docs/screenshots/07-cart.jpg) | ![Cart with free delivery](docs/screenshots/08-cart-free-delivery.jpg) | ![Order confirmation](docs/screenshots/09-order-confirmation.jpg) |

| Order history | Account | Register |
| :---: | :---: | :---: |
| ![Order history](docs/screenshots/10-order-history.jpg) | ![Account](docs/screenshots/11-profile.jpg) | ![Register](docs/screenshots/12-register.jpg) |

| Sign in | About | Contact |
| :---: | :---: | :---: |
| ![Login](docs/screenshots/13-login.jpg) | ![About](docs/screenshots/14-about.jpg) | ![Contact](docs/screenshots/15-contact.jpg) |

## Features

### Accounts and access
Two roles, Customer and Administrator, both authenticated by `AuthService`
against the shared `WebsiteLogin` table rather than by ASP.NET Identity, so the
website and the mobile app sign in against exactly the same credentials. An
account must be `Active` before it is let in, which lets an administrator disable
a compromised account without deleting it and losing its order history.
Registration is screened by `RegistrationValidationService`: usernames are exactly
six characters, phone numbers exactly ten digits, and passwords are six to eight
characters carrying an uppercase letter, a lowercase letter, a digit and a symbol.
Forgotten passwords go through `PasswordResetService`.

Access control is not repeated page by page. Protected pages inherit `AdminPage`
or `CustomerPage`, which override `OnLoad` and redirect anyone without the right
session role, so every administrative page requires Administrator by construction
rather than by remembering to add a check.

### Browse and search
The catalogue lists active products only, searchable by name and description and
filterable by category. A product page carries its image, description, price,
colour and size selectors, a quantity stepper, a "you may also like" row of
related items, and a size guide dialog with the full measurement chart in
centimetres. Product images are stored as `VARBINARY(MAX)` in SQL Server and
streamed through `ProductImageHandler.ashx` with a half-hour public cache. Pages
that list products append an image version taken from the stored photo's byte
length to the handler's URL, so re-uploading a photo changes the URL and busts
that cache on its own.

### Wishlist
A heart on any product card or detail page saves the item, toggled through
`WishlistHandler.ashx` as JSON so the page never reloads. Saved items collect on a
My Wishlist page, newest first, where they can be viewed, added to the cart or
removed. A unique constraint on the `Wishlist` table stops the same product being
saved twice, and administrators are refused outright since the feature belongs to
shopping, not maintenance.

### Cart and checkout
The cart lives in session rather than the database, keyed by product, colour and
size, so the same dress in two sizes stays two lines. Quantities can never be
driven below one. `DeliveryRates` is the single source of truth for the money
rule, R80 delivery below R500 and free at or above it, and the cart, the progress
bar that tells you how much more you need for free delivery, and checkout all read
it, so the three can never disagree. Checkout refuses an empty cart and refuses to
proceed without a complete delivery address. The estimated delivery date is
derived from the longest production time in the order plus a week, because the
clothes are cut and made to order.

Placing an order writes the `Sale` record and all of its `ProductSold` lines
inside one `SqlTransaction`, so a failure anywhere rolls the whole thing back and
a half-written order never survives.

### Receipts
The confirmation screen shows the receipt number, the itemised order, the totals,
the delivery address and the estimated arrival. The same receipt is emailed
automatically, and can be resent or saved from the page. Money is formatted the
South African way throughout, R1 299,00 rather than R1,299.00, and order times are
stamped in South African Standard Time.

### Administration
Administrators get full create, read and update over the catalogue: name,
description, category, price, production time and image, with
`ProductValidationService` rejecting missing fields and non-numeric or non-positive
prices before anything reaches the database. Products are archived rather than
deleted, flipped from Active to Inactive, which takes them out of the shop while
keeping them intact in the orders that already reference them. Administrators can
also manage user accounts and read the reporting dashboard.

### Dark mode
`TroikaTheme.css` replaced colours that had been hardcoded across many ASPX pages
with a set of CSS variables covering backgrounds, text, cards, tables, buttons,
borders and form inputs. `theme-toggle.js` switches the theme state and remembers
the choice between visits, so a single stylesheet serves both looks and a future
palette change is one file rather than thirty.

### External integrations
Three services sit outside the application. Tokia, a Botpress chatbot, is embedded
site-wide for customer questions. The Gmail HTTP API sends the receipts; it is
used over HTTPS rather than SMTP because the campus network blocked the outbound
SMTP ports, and it authenticates with OAuth2 so no mailbox password is stored, a
refresh token being exchanged for a short-lived access token on each send. The
Google Maps Places API suggests delivery addresses as they are typed and fills in
the suburb and postal code, restricted to South Africa, with every field left
editable so the form still works when the service does not load.
