using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class Cart : CustomerPage
    {
        private readonly UserService _userService = ServiceFactory.CreateUserService();
        private readonly ProductService _productService = ServiceFactory.CreateProductService();
        private readonly CheckoutService _checkoutService = ServiceFactory.CreateCheckoutService();
        private readonly CartService _cartService = ServiceFactory.CreateCartService();

        protected void Page_Load(object sender, EventArgs e)
        {
            rptCart.ItemCommand += rptCart_ItemCommand;

            if (!IsPostBack)
            {
                BindCart();
                LoadSavedAddress();
            }
        }

        // The address form's visibility is driven by the "is-open" CSS class (toggled
        // client-side from "Edit Address"/"Cancel"), not by Visible, so toggling it no
        // longer requires a postback. The base class list mirrors the .aspx markup.
        private const string AddressFormBaseClass = "ec-card ec-address ec-address-form";

        private void SetAddressFormOpen(bool open)
        {
            PanelAddress.CssClass = open ? AddressFormBaseClass + " is-open" : AddressFormBaseClass;
        }

        private void LoadSavedAddress()
        {
            CustomerAddress address = _userService.GetCustomerAddressForUsername(CurrentUsername);

            bool hasCompleteAddress = address != null && address.IsComplete;

            if (address != null)
            {
                txtStreet.Text = address.StreetAddress;
                txtSuburb.Text = address.Suburb;
                txtPostCode.Text = address.PostCode;
            }

            PanelCurrentAddress.Visible = hasCompleteAddress;
            if (hasCompleteAddress)
                lblCurrentAddress.Text = address.DisplayText;

            // No usable saved address yet -> open the form by default so the customer can
            // enter one before they reach checkout.
            SetAddressFormOpen(!hasCompleteAddress);
        }

        private void BindCart()
        {
            var cartItems = _cartService.GetItems(Session);
            string estimatedDelivery = _productService.CalculateEstimatedDelivery(cartItems);
            CartSummary summary = _cartService.GetSummary(Session, estimatedDelivery);

            phEmpty.Visible = !summary.HasItems;
            phCart.Visible = summary.HasItems;

            rptCart.DataSource = summary.Items;
            rptCart.DataBind();

            lblEstDelivery.Text = summary.EstimatedDeliveryText;
            lblSubtotal.Text = summary.Subtotal.ToString("0.00");
            lblDelivery.Text = summary.DeliveryDisplayText;
            lblDelivery.CssClass = summary.QualifiesForFreeDelivery ? "ec-free" : "ec-val";
            lblTotal.Text = summary.GrandTotal.ToString("0.00");

            ApplyDeliveryTracker(summary, dtFillCart, lblDeliveryTrackerMsg);
        }

        private static void ApplyDeliveryTracker(CartSummary summary, HtmlGenericControl fill, Label message)
        {
            // Render at 0 with the goal as data-target; delivery-tracker.js animates it up.
            fill.Attributes["data-target"] = summary.FreeDeliveryProgressPercent.ToString();
            fill.Style["width"] = "0%";
            fill.Attributes["class"] = "dt-fill" + (summary.QualifiesForFreeDelivery ? " is-free" : string.Empty);
            message.Text = summary.FreeDeliveryMessage;
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "remove") return;

            var args = (e.CommandArgument ?? "").ToString().Split('|');
            _cartService.Remove(Session, args.ElementAtOrDefault(0), args.ElementAtOrDefault(1), args.ElementAtOrDefault(2));
            BindCart();
        }

        protected void rptCart_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            var item = (CartItem)e.Item.DataItem;

            var ddlColour = (DropDownList)e.Item.FindControl("ddlColourEdit");
            ddlColour.DataSource = ProductOptions.Colours;
            ddlColour.DataBind();
            SelectValue(ddlColour, item.Colour);

            var ddlSize = (DropDownList)e.Item.FindControl("ddlSizeEdit");
            ddlSize.DataSource = ProductOptions.Sizes;
            ddlSize.DataBind();
            SelectValue(ddlSize, item.ClothingSize);
        }

        protected void rptCart_ItemChanged(object sender, EventArgs e)
        {
            var row = ((Control)sender).NamingContainer as RepeaterItem;
            if (row == null) return;

            var key = (((HiddenField)row.FindControl("hfKey")).Value ?? string.Empty).Split('|');
            string productId = key.ElementAtOrDefault(0);
            string oldColour = key.ElementAtOrDefault(1);
            string oldSize = key.ElementAtOrDefault(2);

            string newColour = ((DropDownList)row.FindControl("ddlColourEdit")).SelectedValue;
            string newSize = ((DropDownList)row.FindControl("ddlSizeEdit")).SelectedValue;

            int qty;
            if (!int.TryParse(((TextBox)row.FindControl("txtQty")).Text, out qty))
                qty = 1;

            _cartService.UpdateVariant(Session, productId, oldColour, oldSize, newColour, newSize, qty);
            BindCart();
        }

        // Selects value in the list; if the stored value isn't a standard option, inserts it so nothing is lost.
        private static void SelectValue(DropDownList ddl, string value)
        {
            value = value ?? string.Empty;
            ListItem match = ddl.Items.FindByValue(value);
            if (match == null && value.Length > 0)
            {
                match = new ListItem(value, value);
                ddl.Items.Insert(0, match);
            }
            ddl.ClearSelection();
            if (match != null) match.Selected = true;
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            _cartService.Clear(Session);
            BindCart();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            var result = _checkoutService.PlaceOrder(CurrentUsername, ddlPayment.SelectedValue, _cartService.GetItems(Session));

            if (!result.Success)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = result.Message;
                if (result.Message.Contains("address") || result.Message.Contains("linked"))
                    SetAddressFormOpen(true);
                return;
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = result.Message;
            _cartService.Clear(Session);
            Response.Redirect("~/Public Pages/OrderConfirmation.aspx?receipt=" + result.ReceiptNumber);
        }

        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            var result = _userService.SaveCustomerAddress(CurrentUsername, txtStreet.Text, txtSuburb.Text, txtPostCode.Text);

            lblMessage.ForeColor = result.Success ? System.Drawing.Color.Green : System.Drawing.Color.Red;
            lblMessage.Text = result.Message;

            if (result.Success)
                LoadSavedAddress();        // refreshes the summary and closes the form
            else
                SetAddressFormOpen(true);  // keep the form open so they can fix it
        }
    }
}
