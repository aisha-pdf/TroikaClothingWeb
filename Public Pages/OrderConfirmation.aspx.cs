using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;


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
            var sb = new System.Text.StringBuilder();

            sb.Append("<!doctype html>");
            sb.Append("<html><head>");
            sb.Append("<meta charset='utf-8' />");
            sb.Append("<meta name='viewport' content='width=device-width, initial-scale=1' />");

            sb.Append("<style>");
            sb.Append("  body{font-family:Arial,Helvetica,sans-serif;margin:0;padding:0;background:#F5F5DC;color:#333;} "); // cream
            sb.Append("  .container{max-width:600px;margin:24px auto;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.15);} ");
            sb.Append("  .header{background:#3D304C;color:#ffffff;padding:20px;text-align:center;} "); // navy
            sb.Append("  .header-title{font-size:22px;font-weight:700;margin-bottom:4px;} ");
            sb.Append("  .header-sub{font-size:13px;opacity:0.9;} ");
            sb.Append("  .hero{padding:20px;border-bottom:1px solid #eee;} ");
            sb.Append("  .hero h2{margin:0;color:#644F7D;font-size:18px;} "); // light accent
            sb.Append("  .muted{color:#6b7280;font-size:13px;} ");
            sb.Append("  table.items{width:100%;border-collapse:collapse;margin-top:15px;} ");
            sb.Append("  table.items th, table.items td{padding:10px;border-bottom:1px solid #eee;} ");
            sb.Append("  table.items th{background:#F5F5DC;font-weight:700;font-size:13px;color:#3D304C;} "); // cream + navy
            sb.Append("  .totals{padding:20px;background:#fafafa;} ");
            sb.Append("  .totals .line{display:flex;justify-content:space-between;padding:6px 0;font-size:15px;} ");
            sb.Append("  .totals .total-amount{font-weight:700;font-size:17px;color:#2C5F2D;} "); // deep green
            sb.Append("  .footer{padding:20px;font-size:13px;color:#6b7280;text-align:center;border-top:1px solid #eee;} ");
            sb.Append("</style>");

            sb.Append("</head><body>");

            sb.Append("<div class='container'>");

            // ====== HEADER ======
            sb.Append("<div class='header'>");
            sb.Append("<div class='header-title'>Troika Clothing</div>");
            sb.Append("<div class='header-sub'>Order Confirmation</div>");
            sb.Append("</div>");

            // ===== HERO SECTION =====
            sb.Append("<div class='hero'>");
            sb.Append($"<h2>Receipt #{receipt}</h2>");
            sb.Append($"<div class='muted'>Hi {lblShipName?.Text},</div>");
            sb.Append($"<div class='muted' style='margin-top:6px;'>Order Date: {DateTime.Now:dd MMM yyyy}</div>");
            sb.Append("</div>");

            // ===== ITEMS =====
            sb.Append("<div style='padding:20px;'>");
            sb.Append("<h3 style='margin:0 0 10px 0;color:#3D304C;font-size:16px;'>Items Ordered</h3>");
            sb.Append("<table class='items'>");
            sb.Append("<tr>");
            sb.Append("<th>Product</th>");
            sb.Append("<th style='text-align:center;'>Qty</th>");
            sb.Append("<th style='text-align:right;'>Unit</th>");
            sb.Append("<th style='text-align:right;'>Total</th>");
            sb.Append("</tr>");

            foreach (RepeaterItem item in rptItems.Items)
            {
                var lblName = item.FindControl("lblProductName") as Label;
                var lblQty = item.FindControl("lblQuantity") as Label;
                var lblUnit = item.FindControl("lblUnitPrice") as Label;
                var lblLine = item.FindControl("lblLineTotal") as Label;

                sb.Append("<tr>");
                sb.Append($"<td>{lblName?.Text}</td>");
                sb.Append($"<td style='text-align:center;'>{lblQty?.Text}</td>");
                sb.Append($"<td style='text-align:right;'>R{lblUnit?.Text}</td>");
                sb.Append($"<td style='text-align:right;'>R{lblLine?.Text}</td>");
                sb.Append("</tr>");
            }

            sb.Append("</table>");
            sb.Append("</div>");

            // ===== TOTALS =====

            Func<string, string> FormatAmount = (raw) =>
            {
                if (string.IsNullOrWhiteSpace(raw)) return "R0.00";
                string s = raw.Trim();

                // Delivery might be frees
                if (s.Equals("Free", StringComparison.OrdinalIgnoreCase) ||
                    s.IndexOf("free", StringComparison.OrdinalIgnoreCase) >= 0 && !s.Any(char.IsDigit))
                {
                    return System.Net.WebUtility.HtmlEncode(s);
                }

                // Strip R if already there
                if (s.StartsWith("R") || s.StartsWith("r")) s = s.Substring(1).Trim();

                if (decimal.TryParse(s, out decimal val))
                    return "R" + val.ToString("0.00");

                return System.Net.WebUtility.HtmlEncode(raw);
            };

            string subtotalStr = FormatAmount(lblSubtotal?.Text);
            string deliveryStr = FormatAmount(lblDelivery?.Text);
            string totalStr = FormatAmount(lblTotal?.Text);

            sb.Append("<div class='totals' style='padding:20px;background:#fafafa;'>");

            // Subtotal
            sb.Append("<div style='display:flex;justify-content:space-between;align-items:center;padding:4px 0;'>");
            sb.Append("<div style='flex:1;text-align:left;'>Subtotal</div>");
            sb.Append("<div style='min-width:90px;text-align:right;'>" + subtotalStr + "</div>");
            sb.Append("</div>");

            // VAT Included under Subtotal
            sb.Append("<div style='padding:2px 0 10px 0;color:#6b7280;font-size:13px;text-align:left;'>VAT Included</div>");

            // Delivery
            sb.Append("<div style='display:flex;justify-content:space-between;align-items:center;padding:4px 0;'>");
            sb.Append("<div style='flex:1;text-align:left;'>Delivery</div>");
            sb.Append("<div style='min-width:90px;text-align:right;'>" + deliveryStr + "</div>");
            sb.Append("</div>");

            // Total
            sb.Append("<div style='display:flex;justify-content:space-between;align-items:center;padding:10px 0;margin-top:8px;border-top:1px solid #eee;'>");
            sb.Append("<div style='flex:1;text-align:left;font-weight:700;'>Total</div>");
            sb.Append("<div style='min-width:90px;text-align:right;font-weight:700;color:#2C5F2D;'>" + totalStr + "</div>");
            sb.Append("</div>");

            sb.Append("</div>");


            // ===== FOOTER =====
            sb.Append("<div class='footer'>");
            sb.Append("Thank you for shopping with Troika Clothing.<br/>");
            sb.Append("&copy; " + DateTime.Now.Year + " Troika Clothing — All rights reserved.");
            sb.Append("</div>");

            sb.Append("</div>"); // container

            sb.Append("</body></html>");

            return sb.ToString();
        }



        private async Task SendReceiptEmailAsync(string receipt, string htmlBody)
        {
            string fromEmail = ConfigurationManager.AppSettings["GmailEmail"];
            string appPassword = ConfigurationManager.AppSettings["GmailAppPassword"];

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

            var message = new MailMessage();
            message.From = new MailAddress(fromEmail, "Troika Clothing");
            message.Subject = $"Your Troika Clothing Order #{receipt}";
            message.Body = htmlBody;
            message.IsBodyHtml = true;
            message.To.Add(toEmail);

            using (var smtp = new SmtpClient("smtp.gmail.com", 587))
            {
                smtp.Credentials = new NetworkCredential(fromEmail, appPassword);
                smtp.EnableSsl = true;

                await smtp.SendMailAsync(message);
            }
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
                // Build full HTML for the PDF
                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append("<html><head>");
                sb.Append("<meta charset='utf-8' />");
                sb.Append("<meta name='viewport' content='width=device-width, initial-scale=1' />");

                // Include your receipt styles
                sb.Append("<style>");
                sb.Append(@"
            body { font-family: 'Segoe UI', sans-serif; color: #3D304C; margin: 30px; background:#ffffff; }
            h2 { text-align:center; font-size:28px; margin-bottom:20px; }
            .pdf-box { max-width:900px; margin:0 auto; border:2px solid #3D304C; border-radius:14px; padding:28px; background:#f8f8f8; }
            table { width:100%; border-collapse:collapse; margin-top:15px; }
            th, td { border-bottom:1px solid #3D304C; padding:10px; font-size:14px; }
            th { background:#2A1E37; color:#fff; text-align:left; }
            td { background:#fff; }
            .totals div { display:flex; justify-content:space-between; padding:6px 0; }
            .total-final { font-size:20px; font-weight:700; color:#2C5F2D; }
            .address-box { background:#D8CDEB; padding:12px; border-radius:10px; margin-top:10px; }
            .section-title { font-weight:700; font-size:18px; margin-top:25px; border-bottom:2px solid #3D304C; padding-bottom:6px; }
            .footer { margin-top:40px; text-align:center; font-size:12px; color:#6b7280; }
        ");
                sb.Append("</style></head><body>");

                sb.Append($"<h2>Troika Clothing — Order Receipt #{lblReceipt.Text}</h2>");
                sb.Append("<div class='pdf-box'>");

                // Receipt ID
                sb.Append($"<div style='margin-bottom:20px;'><strong>Receipt ID:</strong> {lblReceipt.Text}</div>");

                // ===== ITEMS =====
                sb.Append("<div class='section-title'>Items</div>");
                sb.Append("<table>");
                sb.Append("<tr><th>Item</th><th style='text-align:right;'>Amount</th></tr>");

                foreach (RepeaterItem item in rptItems.Items)
                {
                    var lblName = item.FindControl("lblProductName") as Label;
                    var lblQty = item.FindControl("lblQuantity") as Label;
                    var lblUnit = item.FindControl("lblUnitPrice") as Label;
                    var lblLine = item.FindControl("lblLineTotal") as Label;

                    string details = item.FindControl("lblQuantity") != null
                        ? $"Qty: {lblQty.Text} • Unit: R{lblUnit.Text}"
                        : "";

                    sb.Append("<tr>");
                    sb.Append($"<td><strong>{lblName?.Text}</strong><br><span style='font-size:12px;'>{details}</span></td>");
                    sb.Append($"<td style='text-align:right;'>R{lblLine?.Text}</td>");
                    sb.Append("</tr>");
                }

                sb.Append("</table>");

                // ===== SUMMARY =====
                sb.Append("<div class='section-title'>Summary</div>");
                sb.Append("<div class='totals'>");
                sb.Append($"<div><span>Order date</span><span>{lblDate.Text}</span></div>");
                sb.Append($"<div><span>Payment method</span><span>{lblPaymentMethod.Text}</span></div>");
                sb.Append($"<div><span>Subtotal</span><span>R{lblSubtotal.Text}</span></div>");
                sb.Append($"<div><span>Delivery</span><span>{lblDelivery.Text}</span></div>");
                sb.Append($"<div class='total-final'><span>Total paid</span><span>R{lblTotal.Text}</span></div>");
                sb.Append($"<div><span>Estimated delivery</span><span>{lblEta.Text}</span></div>");
                sb.Append("</div>");

                // ===== SHIPPING =====
                sb.Append("<div class='section-title'>Shipping Address</div>");
                sb.Append("<div class='address-box'>");
                sb.Append($"{lblShipName.Text}<br>{lblShipStreet.Text}<br>{lblShipSuburb.Text}<br>{lblShipPost.Text}");
                sb.Append("</div>");

                sb.Append("</div>"); // pdf-box
                sb.Append("<div class='footer'>Thank you for shopping with Troika Clothing.</div>");
                sb.Append("</body></html>");

                // Return HTML as downloadable file
                string htmlContent = sb.ToString();
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
