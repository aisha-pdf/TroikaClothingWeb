using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;
using SendGrid;
using SendGrid.Helpers.Mail;

namespace TroikaClothingWeb.Public_Pages
{
    public partial class OrderConfirmation : Page
    {
        string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string receipt = Request.QueryString["receipt"];
                if (string.IsNullOrWhiteSpace(receipt))
                {
                    Response.Redirect("~/Public Pages/Products.aspx");
                    return;
                }

                lblReceipt.Text = receipt;
                LoadReceipt(receipt);

                // Automatically send the email
                try
                {
                    string htmlBody = BuildEmailHtml(receipt);
                    await SendReceiptEmailAsync(receipt, htmlBody);
                    lblEmailStatus.ForeColor = System.Drawing.Color.Green;
                    lblEmailStatus.Text = "✔ Receipt sent to your email.";
                }
                catch (Exception ex)
                {
                    lblEmailStatus.ForeColor = System.Drawing.Color.Red;
                    lblEmailStatus.Text = "⚠ Could not send email: " + ex.Message;
                }
            }
        }

        private void LoadReceipt(string receipt)
        {
            string paymentMethod = null, channel = null;
            DateTime dateOfIssue = DateTime.Now;
            decimal paymentTotal = 0m;

            using (var con = new SqlConnection(cs))
            using (var cmd = new SqlCommand(@"
                SELECT s.receiptNum, s.dateOfIssue, s.paymentMethod, s.paymentTotal, s.saleChannel,
                       c.customerID, c.email, c.streetAddress, c.suburb, c.postCode,
                       rc.name, rc.surname
                FROM Sale s
                LEFT JOIN Customer c ON c.customerID = s.CustomerID
                LEFT JOIN RetailCustomer rc ON rc.customerID = c.customerID
                WHERE s.receiptNum = @r", con))
            {
                cmd.Parameters.AddWithValue("@r", receipt);
                con.Open();
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) { Response.Redirect("~/Public Pages/Products.aspx"); return; }

                    dateOfIssue = Convert.ToDateTime(r["dateOfIssue"]);
                    paymentMethod = r["paymentMethod"].ToString();
                    channel = r["saleChannel"].ToString();
                    paymentTotal = Convert.ToDecimal(r["paymentTotal"]);

                    lblShipName.Text = $"{r["name"]} {r["surname"]}".Trim();
                    lblShipStreet.Text = Convert.ToString(r["streetAddress"]);
                    lblShipSuburb.Text = Convert.ToString(r["suburb"]);
                    lblShipPost.Text = Convert.ToString(r["postCode"]);
                }
            }

            lblDate.Text = dateOfIssue.ToString("yyyy-MM-dd HH:mm");
            lblPaymentMethod.Text = paymentMethod;
            lblChannel.Text = channel;

            DataTable dt = new DataTable();
            dt.Columns.Add("ProductID");
            dt.Columns.Add("ProductName");
            dt.Columns.Add("clothingSize");
            dt.Columns.Add("colour");
            dt.Columns.Add("quantity", typeof(int));
            dt.Columns.Add("UnitPrice", typeof(decimal));
            dt.Columns.Add("LineTotal", typeof(decimal));

            decimal subtotal = 0m;
            int maxProductionDays = 0;

            using (var con = new SqlConnection(cs))
            using (var cmd = new SqlCommand(@"
                SELECT ps.ProductID, ps.clothingSize, ps.colour, ps.quantity,
                       p.ProductName, p.Price, p.ProductionTime
                FROM ProductSold ps
                JOIN Product p ON p.ProductID = ps.ProductID
                WHERE ps.receiptID = @r", con))
            {
                cmd.Parameters.AddWithValue("@r", receipt);
                con.Open();
                using (var rd = cmd.ExecuteReader())
                {
                    while (rd.Read())
                    {
                        string pid = rd["ProductID"].ToString();
                        string pname = rd["ProductName"].ToString();
                        string size = rd["clothingSize"].ToString();
                        string colour = rd["colour"].ToString();
                        int qty = Convert.ToInt32(rd["quantity"]);
                        decimal unit = Convert.ToDecimal(rd["Price"]);
                        decimal line = unit * qty;
                        subtotal += line;

                        int prod = 0;
                        int.TryParse(rd["ProductionTime"].ToString(), out prod);
                        if (prod > maxProductionDays) maxProductionDays = prod;

                        dt.Rows.Add(pid, pname, size, colour, qty, unit, line);
                    }
                }
            }

            rptItems.DataSource = dt;
            rptItems.DataBind();

            decimal delivery = paymentTotal - subtotal;
            if (delivery < 0) delivery = 0;

            lblSubtotal.Text = subtotal.ToString("0.00");
            lblDelivery.Text = delivery == 0 ? "Free" : $"R{delivery:0.00}";
            lblTotal.Text = paymentTotal.ToString("0.00");

            int etaDays = maxProductionDays + 7;
            lblEta.Text = $"{etaDays} days";
        }

        private string BuildEmailHtml(string receipt)
        {
            return $@"
            <html>
            <body style='font-family:Segoe UI,Roboto,Arial,sans-serif;background:#0f172a;color:#e2e8f0;padding:30px;'>
                <div style='max-width:700px;margin:0 auto;background:#111827;padding:30px;border-radius:10px;'>
                    <h2 style='color:#a78bfa;text-align:center;'>Order Confirmation #{receipt}</h2>
                    <p style='font-size:16px;'>Hi {lblShipName.Text},</p>
                    <p>Thank you for shopping with <b>Troika Clothing</b>! Your order has been received and is being processed.</p>
                    <hr style='border:1px solid #1e293b;margin:20px 0;'/>
                    <p><b>Date:</b> {lblDate.Text}<br/>
                       <b>Payment:</b> {lblPaymentMethod.Text}<br/>
                       <b>Channel:</b> {lblChannel.Text}</p>
                    <p><b>Shipping Address:</b><br/>
                       {lblShipStreet.Text}, {lblShipSuburb.Text}, {lblShipPost.Text}</p>
                    <p><b>Total Paid:</b> R{lblTotal.Text}</p>
                    <p style='text-align:center;color:#a78bfa;margin-top:30px;'>— The Troika Clothing Team</p>
                </div>
            </body>
            </html>";
        }

        private async Task SendReceiptEmailAsync(string receipt, string htmlBody)
        {
            string apiKey = ConfigurationManager.AppSettings["SendGridApiKey"];
            var client = new SendGridClient(apiKey);

            string toEmail = null;
            using (var con = new SqlConnection(cs))
            using (var cmd = new SqlCommand(@"
                SELECT c.email FROM Sale s
                JOIN Customer c ON c.customerID = s.CustomerID
                WHERE s.receiptNum = @r", con))
            {
                cmd.Parameters.AddWithValue("@r", receipt);
                con.Open();
                var obj = cmd.ExecuteScalar();
                if (obj != null && obj != DBNull.Value)
                    toEmail = obj.ToString();
            }

            if (string.IsNullOrWhiteSpace(toEmail))
                throw new Exception("No email address on file for this order.");

            var from = new EmailAddress("troikasales123@gmail.com", "Troika Clothing");
            var to = new EmailAddress(toEmail);
            var subject = $"Your Troika Clothing Order #{receipt}";
            var msg = MailHelper.CreateSingleEmail(from, to, subject, null, htmlBody);

            var response = await client.SendEmailAsync(msg);
            if (response.StatusCode != System.Net.HttpStatusCode.Accepted)
                throw new Exception("SendGrid API returned: " + response.StatusCode);
        }

        protected async void btnEmail_Click(object sender, EventArgs e)
        {
            try
            {
                string htmlBody = BuildEmailHtml(lblReceipt.Text);
                await SendReceiptEmailAsync(lblReceipt.Text, htmlBody);
                lblEmailStatus.ForeColor = System.Drawing.Color.Green;
                lblEmailStatus.Text = "✔ Receipt resent successfully.";
            }
            catch (Exception ex)
            {
                lblEmailStatus.ForeColor = System.Drawing.Color.Red;
                lblEmailStatus.Text = "⚠ Resend failed: " + ex.Message;
            }
        }

        protected void btnSavePdf_Click(object sender, EventArgs e)
        {
            try
            {
                // Capture receipt HTML
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                sb.Append("<html><head>");
                sb.Append("<style>");
                sb.Append(@"body { font-family: 'Segoe UI', sans-serif; color: #111827; margin: 30px; }
                    h2 { color: #4F46E5; }
                    .section { margin-bottom: 20px; }
                    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
                    th, td { border: 1px solid #e5e7eb; padding: 8px; text-align: left; }
                    th { background: #f9fafb; }");
                sb.Append("</style>");
                sb.Append("</head><body>");
                sb.Append($"<h2>Troika Clothing — Order Receipt #{lblReceipt.Text}</h2>");
                sb.Append($"<p><b>Date:</b> {lblDate.Text}<br/>");
                sb.Append($"<b>Payment method:</b> {lblPaymentMethod.Text}<br/>");
                sb.Append($"<b>Sale channel:</b> {lblChannel.Text}</p>");

                sb.Append("<div class='section'><h3>Items</h3><table>");
                sb.Append("<tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Total</th></tr>");
                foreach (RepeaterItem item in rptItems.Items)
                {
                    var lblName = item.FindControl("lblProductName") as Label;
                    var lblQty = item.FindControl("lblQuantity") as Label;
                    var lblUnit = item.FindControl("lblUnitPrice") as Label;
                    var lblTotal = item.FindControl("lblLineTotal") as Label;

                    sb.Append("<tr>");
                    sb.Append($"<td>{(lblName != null ? lblName.Text : "")}</td>");
                    sb.Append($"<td>{(lblQty != null ? lblQty.Text : "")}</td>");
                    sb.Append($"<td>{(lblUnit != null ? lblUnit.Text : "")}</td>");
                    sb.Append($"<td>{(lblTotal != null ? lblTotal.Text : "")}</td>");
                    sb.Append("</tr>");
                }
                sb.Append("</table></div>");

                sb.Append("<div class='section'>");
                sb.Append($"<p><b>Subtotal:</b> R{lblSubtotal.Text}<br/>");
                sb.Append($"<b>Delivery:</b> {lblDelivery.Text}<br/>");
                sb.Append($"<b>Total:</b> R{lblTotal.Text}</p>");
                sb.Append("</div>");

                sb.Append("<div class='section'><h3>Shipping Address</h3>");
                sb.Append($"<p>{lblShipName.Text}<br/>{lblShipStreet.Text}<br/>{lblShipSuburb.Text}<br/>{lblShipPost.Text}</p>");
                sb.Append($"<p><b>Estimated delivery:</b> {lblEta.Text}</p>");
                sb.Append("</div>");
                sb.Append("<p style='color:#6b7280'>Thank you for shopping with Troika Clothing!</p>");
                sb.Append("</body></html>");

                string htmlContent = sb.ToString();

                // Convert HTML to PDF using browser print dialog
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", $"attachment; filename=TroikaReceipt_{lblReceipt.Text}.html");
                Response.Charset = "";
                Response.ContentType = "text/html";
                Response.Output.Write(htmlContent);
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                lblEmailStatus.ForeColor = System.Drawing.Color.Red;
                lblEmailStatus.Text = "⚠ Could not generate PDF: " + ex.Message;
            }
        }

    }
}
