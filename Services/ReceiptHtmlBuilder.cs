using System;
using System.Collections.Generic;
using System.Globalization;
using System.Net;
using System.Text;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class ReceiptHtmlBuilder
    {
        private const string Serif = "'Cormorant Garamond', Georgia, 'Times New Roman', serif";
        private const string SupportEmail = "hello@troikaclothing.co.za";

        /// <summary>
        /// Builds the styled HTML order-receipt email (header band, item table with inline thumbnails,
        /// summary, payment/ETA cards, delivery address, footer). <paramref name="imageSrcs"/> is a per-item
        /// parallel list of image sources — e.g. "cid:img0" for an inline MIME attachment, or null when the
        /// item has no image. The caller (<see cref="ReceiptEmailService"/>) wires up the matching attachments.
        /// </summary>
        public string BuildEmailHtml(OrderReceipt receipt, IList<string> imageSrcs, string eyebrow = "ORDER CONFIRMED")
        {
            if (receipt == null)
                return string.Empty;

            IList<ReceiptLineItem> lines = receipt.Items ?? new List<ReceiptLineItem>();
            if (imageSrcs == null) imageSrcs = new List<string>();

            string firstName = receipt.CustomerName;
            string status = string.IsNullOrWhiteSpace(receipt.SalesStatus) ? "Placed" : receipt.SalesStatus;
            DateTime date = receipt.DateOfIssue;
            decimal subtotal = receipt.Subtotal;
            decimal delivery = receipt.DeliveryFee;
            decimal total = receipt.PaymentTotal;
            string paymentMethod = receipt.PaymentMethod;
            int etaDays = receipt.EstimatedDeliveryDays;

            string greeting = string.IsNullOrWhiteSpace(firstName) ? "Thank you." : "Thank you, " + Enc(firstName) + ".";
            string statusColour = string.Equals(status, "Delivered", StringComparison.OrdinalIgnoreCase) ? "#2C5F2D" : "#644F7D";

            var sb = new StringBuilder();
            sb.Append("<!DOCTYPE html><html><head><meta charset='utf-8'>");
            sb.Append("<meta name='viewport' content='width=device-width, initial-scale=1'>");
            sb.Append("<style>@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&display=swap');body{margin:0;padding:0;}</style></head>");
            sb.Append("<body style='margin:0;padding:0;background:#E9E7EB;'>");
            sb.Append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='background:#E9E7EB;'><tr>");
            sb.Append("<td align='center' style='padding:32px 16px;'>");
            sb.Append("<table role='presentation' width='600' cellpadding='0' cellspacing='0' style='width:600px;max-width:100%;background:#FFFFFF;border-radius:22px;overflow:hidden;border:1px solid #ECE8F1;'>");

            // Header band
            sb.Append("<tr><td style=\"background-color:#3D304C;background-image:linear-gradient(140deg,#3D304C 0%,#4A3660 58%,#644F7D 100%);padding:40px 44px 36px;\">");
            sb.Append("<div style=\"font-family:" + Serif + ";font-size:25px;font-weight:700;letter-spacing:3px;color:#F4F1EC;line-height:1;\">TROIKA</div>");
            sb.Append("<div style='font-size:9px;font-weight:600;letter-spacing:3px;color:#C9BBDF;margin-top:3px;'>CLOTHING C.C.</div>");
            sb.Append("<div style='font-size:13px;font-weight:700;letter-spacing:2.5px;color:#D8CDEB;margin-top:30px;'>" + Enc(eyebrow) + "</div>");
            sb.Append("<div style=\"font-family:" + Serif + ";font-size:34px;font-weight:700;color:#F4F1EC;line-height:1.1;margin-top:8px;\">" + greeting + "</div>");
            sb.Append("</td></tr>");

            // Intro + meta strip
            sb.Append("<tr><td style='padding:34px 44px 0;'>");
            sb.Append("<div style='font-size:15px;line-height:1.6;color:#6B6477;'>Your order is confirmed and is being prepared with care. Here's a summary of your purchase.</div>");
            sb.Append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='margin-top:24px;'><tr>");
            sb.Append(MetaCard("ORDER NO.", "#" + Enc(receipt.ReceiptNumber), "0 4px 0 0"));
            sb.Append(MetaCard("ORDER DATE", date.ToString("dd MMM yyyy", CultureInfo.InvariantCulture), "0 4px"));
            sb.Append("<td width='33%' valign='top' style='padding:0 0 0 4px;'>");
            sb.Append("<div style='background:#F7F5F1;border:1px solid #ECE8F1;border-radius:14px;padding:14px 16px;'>");
            sb.Append("<div style='font-size:10.5px;font-weight:700;letter-spacing:1.4px;color:#A39EB0;'>STATUS</div>");
            sb.Append("<div style='margin-top:6px;'><span style='display:inline-block;width:7px;height:7px;border-radius:999px;background:" + statusColour + ";'></span>");
            sb.Append("<span style='font-size:14px;font-weight:700;color:" + statusColour + ";margin-left:6px;'>" + Enc(status) + "</span></div>");
            sb.Append("</div></td>");
            sb.Append("</tr></table></td></tr>");

            // Items
            sb.Append("<tr><td style='padding:32px 44px 0;'>");
            sb.Append("<div style=\"font-family:" + Serif + ";font-size:22px;font-weight:700;color:#3D304C;\">Items ordered</div>");
            sb.Append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='margin-top:16px;border:1px solid #ECE8F1;border-radius:16px;border-collapse:separate;overflow:hidden;'>");
            sb.Append("<tr style='background:#EFEAF5;'>");
            sb.Append("<td style='padding:12px 18px;font-size:11px;font-weight:700;letter-spacing:1px;color:#6B6477;'>PRODUCT</td>");
            sb.Append("<td width='50' align='center' style='padding:12px 6px;font-size:11px;font-weight:700;letter-spacing:1px;color:#6B6477;'>QTY</td>");
            sb.Append("<td width='92' align='right' style='padding:12px 18px;font-size:11px;font-weight:700;letter-spacing:1px;color:#6B6477;'>TOTAL</td>");
            sb.Append("</tr>");
            for (int i = 0; i < lines.Count; i++)
            {
                ReceiptLineItem l = lines[i];
                string src = (i < imageSrcs.Count) ? imageSrcs[i] : null;
                string thumb = (src != null)
                    ? "<img src=\"" + src + "\" width='40' height='40' alt='' style='width:40px;height:40px;border-radius:10px;object-fit:cover;display:block;background:#D2C5E6;'>"
                    : "<div style='width:40px;height:40px;border-radius:10px;background:#D2C5E6;'></div>";
                sb.Append("<tr>");
                sb.Append("<td style='padding:14px 18px;border-top:1px solid #F1EDF6;'>");
                sb.Append("<table role='presentation' cellpadding='0' cellspacing='0'><tr>");
                sb.Append("<td width='40' valign='middle'>" + thumb + "</td>");
                sb.Append("<td width='12'></td><td valign='middle'>");
                sb.Append("<div style='font-size:15px;font-weight:600;color:#3D304C;line-height:1.25;'>" + Enc(l.ProductName) + "</div>");
                sb.Append("<div style='font-size:12.5px;color:#A39EB0;margin-top:3px;'>" + Money(l.UnitPrice) + " each</div>");
                sb.Append("</td></tr></table></td>");
                sb.Append("<td align='center' style='padding:14px 6px;border-top:1px solid #F1EDF6;font-size:14.5px;font-weight:600;color:#3D304C;'>" + l.Quantity + "</td>");
                sb.Append("<td align='right' style='padding:14px 18px;border-top:1px solid #F1EDF6;font-size:14.5px;font-weight:700;color:#3D304C;'>" + Money(l.UnitPrice * l.Quantity) + "</td>");
                sb.Append("</tr>");
            }
            sb.Append("</table></td></tr>");

            // Summary
            sb.Append("<tr><td style='padding:24px 44px 0;'>");
            sb.Append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0' style='background:#F7F5F1;border:1px solid #ECE8F1;border-radius:16px;'><tr><td style='padding:20px 22px;'>");
            sb.Append(SummaryRow("Subtotal", Money(subtotal), "#3D304C", "600", "14px"));
            sb.Append(delivery == 0m ? SummaryRow("Delivery", "FREE", "#2C5F2D", "700", "13px")
                                     : SummaryRow("Delivery", Money(delivery), "#3D304C", "600", "14px"));
            sb.Append("<div style='height:1px;background:#E4DEEC;margin:14px 0;'></div>");
            sb.Append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0'><tr>");
            sb.Append("<td style=\"font-family:" + Serif + ";font-size:22px;font-weight:700;color:#3D304C;\">Total</td>");
            sb.Append("<td align='right' style='font-size:22px;font-weight:800;color:#2C5F2D;'>" + Money(total) + "</td>");
            sb.Append("</tr></table>");
            sb.Append("</td></tr></table></td></tr>");

            // Payment method + estimated delivery (two cards)
            string payInner =
                "<div style='font-size:15px;font-weight:700;color:#3D304C;margin-top:7px;'>" +
                    (string.IsNullOrWhiteSpace(paymentMethod) ? "&mdash;" : Enc(paymentMethod)) + "</div>" +
                "<div style='font-size:13px;font-weight:600;color:#2C5F2D;margin-top:5px;'>" + Money(total) + " paid</div>";

            string etaInner =
                "<div style='font-size:15px;font-weight:700;color:#3D304C;margin-top:7px;'>" + etaDays + " days</div>" +
                "<div style='font-size:13px;color:#6B6477;margin-top:5px;'>by " + date.AddDays(etaDays).ToString("dd MMM yyyy", CultureInfo.InvariantCulture) + "</div>";

            sb.Append("<tr><td style='padding:20px 44px 0;'>");
            sb.Append("<table role='presentation' width='100%' cellpadding='0' cellspacing='0'><tr>");
            sb.Append(DetailCard("PAYMENT METHOD", payInner, "0 8px 0 0"));
            sb.Append(DetailCard("ESTIMATED DELIVERY", etaInner, "0 0 0 8px"));
            sb.Append("</tr></table></td></tr>");

            // Delivery address (full width)
            string shipName = string.IsNullOrWhiteSpace(receipt.ShippingName) ? "&mdash;" : Enc(receipt.ShippingName);
            string addrLines = Enc(receipt.StreetAddress);
            if (!string.IsNullOrWhiteSpace(receipt.Suburb)) addrLines += (addrLines.Length > 0 ? "<br>" : "") + Enc(receipt.Suburb);
            if (!string.IsNullOrWhiteSpace(receipt.PostCode)) addrLines += (addrLines.Length > 0 ? "<br>" : "") + Enc(receipt.PostCode);
            if (addrLines.Length == 0) addrLines = "No address on file";

            sb.Append("<tr><td style='padding:14px 44px 0;'>");
            sb.Append("<div style='background:#F7F5F1;border:1px solid #ECE8F1;border-radius:14px;padding:16px 18px;'>");
            sb.Append("<div style='font-size:10.5px;font-weight:700;letter-spacing:1.4px;color:#A39EB0;'>DELIVERING TO</div>");
            sb.Append("<div style='font-size:15px;font-weight:700;color:#3D304C;margin-top:7px;'>" + shipName + "</div>");
            sb.Append("<div style='font-size:13.5px;color:#6B6477;margin-top:5px;line-height:1.6;'>" + addrLines + "</div>");
            sb.Append("</div></td></tr>");

            // Support
            sb.Append("<tr><td style='padding:30px 44px 4px;text-align:center;font-size:13px;color:#8A8499;line-height:1.6;'>");
            sb.Append("Questions about your order? Reach us at<br><span style='color:#644F7D;font-weight:600;'>" + SupportEmail + "</span></td></tr>");

            // Footer
            sb.Append("<tr><td style='padding:26px 44px 30px;background:#F4F1EC;text-align:center;'>");
            sb.Append("<div style=\"font-family:" + Serif + ";font-size:15px;font-weight:700;letter-spacing:2px;color:#3D304C;\">TROIKA CLOTHING C.C.</div>");
            sb.Append("<div style='font-size:12px;color:#A39EB0;margin-top:12px;line-height:1.7;'>Thank you for shopping with us.<br>&copy; " + date.Year + " Troika Clothing C.C. &middot; All rights reserved.</div>");
            sb.Append("</td></tr>");

            sb.Append("</table></td></tr></table></body></html>");
            return sb.ToString();
        }

        public string BuildDownloadHtml(OrderReceipt receipt)
        {
            if (receipt == null)
                return string.Empty;

            var sb = new StringBuilder();
            sb.Append("<html><head><meta charset='utf-8' />");
            sb.Append("<style>");
            sb.Append("body{font-family:'Segoe UI',Arial,sans-serif;color:#3D304C;margin:30px;background:#ffffff;}");
            sb.Append("h2{text-align:center;font-size:28px;margin-bottom:20px;}");
            sb.Append(".pdf-box{max-width:900px;margin:0 auto;border:2px solid #3D304C;border-radius:14px;padding:28px;background:#f8f8f8;}");
            sb.Append("table{width:100%;border-collapse:collapse;margin-top:15px;} th,td{border-bottom:1px solid #3D304C;padding:10px;font-size:14px;} th{background:#2A1E37;color:#fff;text-align:left;} td{background:#fff;}");
            sb.Append(".totals div{display:flex;justify-content:space-between;padding:6px 0;} .total-final{font-size:20px;font-weight:700;color:#2C5F2D;}");
            sb.Append(".address-box{background:#D8CDEB;padding:12px;border-radius:10px;margin-top:10px;} .section-title{font-weight:700;font-size:18px;margin-top:25px;border-bottom:2px solid #3D304C;padding-bottom:6px;} .footer{margin-top:40px;text-align:center;font-size:12px;color:#6b7280;}");
            sb.Append("</style></head><body>");
            sb.Append("<h2>Troika Clothing — Order Receipt #" + Enc(receipt.ReceiptNumber) + "</h2>");
            sb.Append("<div class='pdf-box'>");
            sb.Append("<div style='margin-bottom:20px;'><strong>Receipt ID:</strong> " + Enc(receipt.ReceiptNumber) + "</div>");

            sb.Append("<div class='section-title'>Items</div><table><tr><th>Item</th><th style='text-align:right;'>Amount</th></tr>");
            foreach (ReceiptLineItem item in receipt.Items)
            {
                sb.Append("<tr>");
                sb.Append("<td><strong>" + Enc(item.ProductName) + "</strong><br><span style='font-size:12px;'>Qty: " + item.Quantity + " • Unit: R" + item.UnitPrice.ToString("0.00") + "</span></td>");
                sb.Append("<td style='text-align:right;'>R" + item.LineTotal.ToString("0.00") + "</td>");
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            sb.Append("<div class='section-title'>Summary</div><div class='totals'>");
            sb.Append("<div><span>Order date</span><span>" + receipt.DateOfIssue.ToString("yyyy-MM-dd HH:mm") + "</span></div>");
            sb.Append("<div><span>Payment method</span><span>" + Enc(receipt.PaymentMethod) + "</span></div>");
            sb.Append("<div><span>Subtotal</span><span>R" + receipt.Subtotal.ToString("0.00") + "</span></div>");
            sb.Append("<div><span>Delivery</span><span>" + (receipt.DeliveryFee == 0 ? "Free" : "R" + receipt.DeliveryFee.ToString("0.00")) + "</span></div>");
            sb.Append("<div class='total-final'><span>Total paid</span><span>R" + receipt.PaymentTotal.ToString("0.00") + "</span></div>");
            sb.Append("<div><span>Estimated delivery</span><span>" + receipt.EstimatedDeliveryDays + " days</span></div>");
            sb.Append("</div>");

            sb.Append("<div class='section-title'>Shipping Address</div><div class='address-box'>");
            sb.Append(Enc(receipt.ShippingName) + "<br>" + Enc(receipt.StreetAddress) + "<br>" + Enc(receipt.Suburb) + "<br>" + Enc(receipt.PostCode));
            sb.Append("</div></div>");
            sb.Append("<div class='footer'>Thank you for shopping with Troika Clothing.</div>");
            sb.Append("</body></html>");
            return sb.ToString();
        }

        private static string MetaCard(string label, string value, string padding)
        {
            return "<td width='33%' valign='top' style='padding:" + padding + ";'>" +
                   "<div style='background:#F7F5F1;border:1px solid #ECE8F1;border-radius:14px;padding:14px 16px;'>" +
                   "<div style='font-size:10.5px;font-weight:700;letter-spacing:1.4px;color:#A39EB0;'>" + Enc(label) + "</div>" +
                   "<div style='font-size:15px;font-weight:700;color:#3D304C;margin-top:5px;'>" + Enc(value) + "</div></div></td>";
        }

        // A 50%-width info card whose body is pre-built HTML (callers encode their own values).
        private static string DetailCard(string label, string innerHtml, string padding)
        {
            return "<td width='50%' valign='top' style='padding:" + padding + ";'>" +
                   "<div style='background:#F7F5F1;border:1px solid #ECE8F1;border-radius:14px;padding:16px 18px;'>" +
                   "<div style='font-size:10.5px;font-weight:700;letter-spacing:1.4px;color:#A39EB0;'>" + Enc(label) + "</div>" +
                   innerHtml + "</div></td>";
        }

        private static string SummaryRow(string label, string value, string valueColour, string valueWeight, string valueSize)
        {
            return "<table role='presentation' width='100%' cellpadding='0' cellspacing='0'><tr>" +
                   "<td style='padding:4px 0;font-size:14px;color:#6B6477;'>" + Enc(label) + "</td>" +
                   "<td align='right' style='padding:4px 0;font-size:" + valueSize + ";font-weight:" + valueWeight + ";color:" + valueColour + ";'>" + value + "</td>" +
                   "</tr></table>";
        }

        // South African money format: space thousands separator, comma decimals, e.g. R1 299,00.
        private static string Money(decimal d)
        {
            string s = d.ToString("#,##0.00", CultureInfo.InvariantCulture); // 1,299.00
            s = s.Replace(",", " ").Replace(".", ",");                       // 1 299,00
            return "R" + s;
        }

        private static string Enc(string value)
        {
            return WebUtility.HtmlEncode(value ?? string.Empty);
        }
    }
}
