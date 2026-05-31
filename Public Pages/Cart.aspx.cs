using System;
using System.Linq;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class Cart : System.Web.UI.Page
    {
        private readonly UserService _userService = new UserService();
        private readonly ProductService _productService = new ProductService();
        private readonly CheckoutService _checkoutService = new CheckoutService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AuthService.IsInRole(Session, "Customer") || Session["Username"] == null)
            {
                Session["ReturnUrl"] = "~/Public Pages/Cart.aspx";
                Response.Redirect("~/Login.aspx");
                return;
            }

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
            string username = Session["Username"] == null ? null : Session["Username"].ToString();
            CustomerAddress address = _userService.GetCustomerAddressForUsername(username);

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
            var cart = ShoppingCart.Get(Session);
            phEmpty.Visible = cart.Count == 0;
            phCart.Visible = cart.Count > 0;

            rptCart.DataSource = cart;
            rptCart.DataBind();

            decimal subtotal = ShoppingCart.Total(Session);
            decimal delivery = subtotal > 500 ? 0 : 80;
            decimal grandTotal = subtotal + delivery;

            lblEstDelivery.Text = _productService.CalculateEstimatedDelivery(cart);
            lblSubtotal.Text = subtotal.ToString("0.00");
            lblDelivery.Text = delivery == 0 ? "Free" : string.Format("R{0:0.00}", delivery);
            lblTotal.Text = grandTotal.ToString("0.00");
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
                    ShoppingCart.UpdateQuantity(Session, productId, colour, size, quantity);
            }
            else if (e.CommandName == "remove")
            {
                ShoppingCart.Remove(Session, productId, colour, size);
            }

            BindCart();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ShoppingCart.Clear(Session);
            BindCart();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            string username = Session["Username"] == null ? null : Session["Username"].ToString();
            var result = _checkoutService.PlaceOrder(username, ddlPayment.SelectedValue, ShoppingCart.Get(Session));

            if (!result.Success)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = result.Message;
                PanelAddress.Visible = result.Message.Contains("address") || result.Message.Contains("linked");
                return;
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = result.Message;
            ShoppingCart.Clear(Session);
            Response.Redirect("~/Public Pages/OrderConfirmation.aspx?receipt=" + result.ReceiptNumber);
        }

        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            string username = Session["Username"] == null ? null : Session["Username"].ToString();
            var result = _userService.SaveCustomerAddress(username, txtStreet.Text, txtSuburb.Text, txtPostCode.Text);

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
