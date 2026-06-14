using System;
using System.Linq;
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
            btnBack.PostBackUrl = ResolveUrl("~/Public Pages/Products.aspx");

            if (!IsPostBack)
            {
                BindCart();
                LoadSavedAddress();
            }
        }

        private void LoadSavedAddress()
        {
            CustomerAddress address = _userService.GetCustomerAddressForUsername(CurrentUsername);

            if (address == null) return;

            txtStreet.Text = address.StreetAddress;
            txtSuburb.Text = address.Suburb;
            txtPostCode.Text = address.PostCode;

            PanelCurrentAddress.Visible = address.IsComplete;
            if (address.IsComplete)
                lblCurrentAddress.Text = address.DisplayText;
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
            lblTotal.Text = summary.GrandTotal.ToString("0.00");
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            var args = (e.CommandArgument ?? "").ToString().Split('|');
            string productId = args.ElementAtOrDefault(0);
            string colour = args.ElementAtOrDefault(1);
            string size = args.ElementAtOrDefault(2);

            if (e.CommandName == "update")
            {
                var txt = (TextBox)e.Item.FindControl("txtQty");
                int quantity;
                if (int.TryParse(txt.Text, out quantity) && quantity > 0)
                    _cartService.UpdateQuantity(Session, productId, colour, size, quantity);
            }
            else if (e.CommandName == "remove")
            {
                _cartService.Remove(Session, productId, colour, size);
            }

            BindCart();
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
                PanelAddress.Visible = result.Message.Contains("address") || result.Message.Contains("linked");
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
            {
                PanelAddress.Visible = false;
                LoadSavedAddress();
            }
        }

        protected void btnToggleAddress_Click(object sender, EventArgs e)
        {
            PanelAddress.Visible = !PanelAddress.Visible;
        }

        protected void btnCancelAddress_Click(object sender, EventArgs e)
        {
            PanelAddress.Visible = false;
        }
    }
}
