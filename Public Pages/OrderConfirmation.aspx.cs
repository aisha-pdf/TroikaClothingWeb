using System;
using System.Drawing;
using System.Web.UI;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class OrderConfirmation : Page
    {
        private readonly OrderConfirmationService _orderConfirmationService = new OrderConfirmationService();

        protected async void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            string receiptNumber = Request.QueryString["receipt"];

            if (string.IsNullOrWhiteSpace(receiptNumber))
            {
                Response.Redirect("~/Public Pages/Products.aspx");
                return;
            }

            OrderReceipt receipt = _orderConfirmationService.GetReceipt(receiptNumber);

            if (receipt == null)
            {
                Response.Redirect("~/Public Pages/Products.aspx");
                return;
            }

            BindReceipt(receipt);

            try
            {
                await _orderConfirmationService.SendReceiptEmailAsync(receipt);
                ShowEmailStatus("✔ Receipt sent to your email.", true);
            }
            catch (Exception ex)
            {
                ShowEmailStatus("⚠ Could not send email: " + ex.Message, false);
            }
        }

        protected async void btnEmail_Click(object sender, EventArgs e)
        {
            OrderReceipt receipt = GetReceiptForCurrentPage();

            if (receipt == null)
            {
                ShowEmailStatus("⚠ Receipt details could not be loaded.", false);
                return;
            }

            try
            {
                await _orderConfirmationService.SendReceiptEmailAsync(receipt);
                ShowEmailStatus("✔ Receipt resent successfully.", true);
            }
            catch (Exception ex)
            {
                ShowEmailStatus("⚠ Resend failed: " + ex.Message, false);
            }
        }

        protected void btnSavePdf_Click(object sender, EventArgs e)
        {
            OrderReceipt receipt = GetReceiptForCurrentPage();

            if (receipt == null)
            {
                ShowEmailStatus("⚠ Receipt details could not be loaded.", false);
                return;
            }

            try
            {
                string htmlContent = _orderConfirmationService.BuildDownloadHtml(receipt);

                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=TroikaReceipt_" + receipt.ReceiptNumber + ".html");
                Response.Charset = "";
                Response.ContentType = "text/html";
                Response.Output.Write(htmlContent);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowEmailStatus("⚠ Could not generate receipt download: " + ex.Message, false);
            }
        }

        private void BindReceipt(OrderReceipt receipt)
        {
            lblReceipt.Text = receipt.ReceiptNumber;
            lblDate.Text = receipt.DateOfIssue.ToString("yyyy-MM-dd HH:mm");
            lblPaymentMethod.Text = receipt.PaymentMethod;
            lblChannel.Text = receipt.SaleChannel;

            lblShipName.Text = receipt.ShippingName;
            lblShipStreet.Text = receipt.StreetAddress;
            lblShipSuburb.Text = receipt.Suburb;
            lblShipPost.Text = receipt.PostCode;

            rptItems.DataSource = receipt.Items;
            rptItems.DataBind();

            lblSubtotal.Text = receipt.Subtotal.ToString("0.00");
            lblDelivery.Text = receipt.DeliveryFee == 0 ? "Free" : "R" + receipt.DeliveryFee.ToString("0.00");
            lblTotal.Text = receipt.PaymentTotal.ToString("0.00");
            lblEta.Text = receipt.EstimatedDeliveryDays + " days";
        }

        private OrderReceipt GetReceiptForCurrentPage()
        {
            if (string.IsNullOrWhiteSpace(lblReceipt.Text))
                return null;

            OrderReceipt receipt = _orderConfirmationService.GetReceipt(lblReceipt.Text);

            if (receipt != null)
                BindReceipt(receipt);

            return receipt;
        }

        private void ShowEmailStatus(string message, bool success)
        {
            lblEmailStatus.ForeColor = success
                ? ColorTranslator.FromHtml("#1a7f37")
                : ColorTranslator.FromHtml("#d60000");

            lblEmailStatus.Text = message;
        }
    }
}
