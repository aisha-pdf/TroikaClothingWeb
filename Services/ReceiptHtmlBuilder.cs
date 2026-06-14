using System;
using System.Net;
using System.Text;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class ReceiptHtmlBuilder
    {
        public string BuildEmailHtml(OrderReceipt receipt)
        {
            if (receipt == null)
                return string.Empty;

            var sb = new StringBuilder();

            sb.Append("<!doctype html>");
            sb.Append("<html><head>");
            sb.Append("<meta charset='utf-8' />");
            sb.Append("<meta name='viewport' content='width=device-width, initial-scale=1' />");
            sb.Append("<style>");
            sb.Append("body{font-family:Arial,Helvetica,sans-serif;margin:0;padding:0;background:#F5F5DC;color:#333;}");
            sb.Append(".container{max-width:600px;margin:24px auto;background:#ffffff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.15);}");
            sb.Append(".header{background:#3D304C;color:#ffffff;padding:20px;text-align:center;}");
            sb.Append(".header-title{font-size:22px;font-weight:700;margin-bottom:4px;}");
            sb.Append(".header-sub{font-size:13px;opacity:0.9;}");
            sb.Append(".hero{padding:20px;border-bottom:1px solid #eee;}");
            sb.Append(".hero h2{margin:0;color:#644F7D;font-size:18px;}");
            sb.Append(".muted{color:#6b7280;font-size:13px;}");
            sb.Append("table.items{width:100%;border-collapse:collapse;margin-top:15px;}");
            sb.Append("table.items th,table.items td{padding:10px;border-bottom:1px solid #eee;}");
            sb.Append("table.items th{background:#F5F5DC;font-weight:700;font-size:13px;color:#3D304C;}");
            sb.Append(".footer{padding:20px;font-size:13px;color:#6b7280;text-align:center;border-top:1px solid #eee;}");
            sb.Append("</style>");
            sb.Append("</head><body>");
            sb.Append("<div class='container'>");
            sb.Append("<div class='header'><div class='header-title'>Troika Clothing</div><div class='header-sub'>Order Confirmation</div></div>");
            sb.Append("<div class='hero'>");
            sb.Append("<h2>Receipt #" + Html(receipt.ReceiptNumber) + "</h2>");
            sb.Append("<div class='muted'>Hi " + Html(receipt.ShippingName) + ",</div>");
            sb.Append("<div class='muted' style='margin-top:6px;'>Order Date: " + receipt.DateOfIssue.ToString("dd MMM yyyy") + "</div>");
            sb.Append("</div>");

            sb.Append("<div style='padding:20px;'>");
            sb.Append("<h3 style='margin:0 0 10px 0;color:#3D304C;font-size:16px;'>Items Ordered</h3>");
            sb.Append("<table class='items'>");
            sb.Append("<tr><th>Product</th><th style='text-align:center;'>Qty</th><th style='text-align:right;'>Unit</th><th style='text-align:right;'>Total</th></tr>");

            foreach (ReceiptLineItem item in receipt.Items)
            {
                sb.Append("<tr>");
                sb.Append("<td>" + Html(item.ProductName) + "</td>");
                sb.Append("<td style='text-align:center;'>" + item.Quantity + "</td>");
                sb.Append("<td style='text-align:right;'>R" + item.UnitPrice.ToString("0.00") + "</td>");
                sb.Append("<td style='text-align:right;'>R" + item.LineTotal.ToString("0.00") + "</td>");
                sb.Append("</tr>");
            }

            sb.Append("</table>");
            sb.Append("</div>");

            sb.Append("<div style='padding:20px;background:#fafafa;'>");
            AppendTotalLine(sb, "Subtotal", "R" + receipt.Subtotal.ToString("0.00"), false);
            sb.Append("<div style='padding:2px 0 10px 0;color:#6b7280;font-size:13px;text-align:left;'>VAT Included</div>");
            AppendTotalLine(sb, "Delivery", receipt.DeliveryFee == 0 ? "Free" : "R" + receipt.DeliveryFee.ToString("0.00"), false);
            AppendTotalLine(sb, "Total", "R" + receipt.PaymentTotal.ToString("0.00"), true);
            sb.Append("</div>");

            sb.Append("<div class='footer'>Thank you for shopping with Troika Clothing.<br/>&copy; " + DateTime.Now.Year + " Troika Clothing — All rights reserved.</div>");
            sb.Append("</div>");
            sb.Append("</body></html>");

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
            sb.Append("<h2>Troika Clothing — Order Receipt #" + Html(receipt.ReceiptNumber) + "</h2>");
            sb.Append("<div class='pdf-box'>");
            sb.Append("<div style='margin-bottom:20px;'><strong>Receipt ID:</strong> " + Html(receipt.ReceiptNumber) + "</div>");

            sb.Append("<div class='section-title'>Items</div><table><tr><th>Item</th><th style='text-align:right;'>Amount</th></tr>");
            foreach (ReceiptLineItem item in receipt.Items)
            {
                sb.Append("<tr>");
                sb.Append("<td><strong>" + Html(item.ProductName) + "</strong><br><span style='font-size:12px;'>Qty: " + item.Quantity + " • Unit: R" + item.UnitPrice.ToString("0.00") + "</span></td>");
                sb.Append("<td style='text-align:right;'>R" + item.LineTotal.ToString("0.00") + "</td>");
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            sb.Append("<div class='section-title'>Summary</div><div class='totals'>");
            sb.Append("<div><span>Order date</span><span>" + receipt.DateOfIssue.ToString("yyyy-MM-dd HH:mm") + "</span></div>");
            sb.Append("<div><span>Payment method</span><span>" + Html(receipt.PaymentMethod) + "</span></div>");
            sb.Append("<div><span>Subtotal</span><span>R" + receipt.Subtotal.ToString("0.00") + "</span></div>");
            sb.Append("<div><span>Delivery</span><span>" + (receipt.DeliveryFee == 0 ? "Free" : "R" + receipt.DeliveryFee.ToString("0.00")) + "</span></div>");
            sb.Append("<div class='total-final'><span>Total paid</span><span>R" + receipt.PaymentTotal.ToString("0.00") + "</span></div>");
            sb.Append("<div><span>Estimated delivery</span><span>" + receipt.EstimatedDeliveryDays + " days</span></div>");
            sb.Append("</div>");

            sb.Append("<div class='section-title'>Shipping Address</div><div class='address-box'>");
            sb.Append(Html(receipt.ShippingName) + "<br>" + Html(receipt.StreetAddress) + "<br>" + Html(receipt.Suburb) + "<br>" + Html(receipt.PostCode));
            sb.Append("</div></div>");
            sb.Append("<div class='footer'>Thank you for shopping with Troika Clothing.</div>");
            sb.Append("</body></html>");
            return sb.ToString();
        }

        private static void AppendTotalLine(StringBuilder sb, string label, string value, bool final)
        {
            string style = final
                ? "padding:10px 0;margin-top:8px;border-top:1px solid #eee;font-weight:700;color:#2C5F2D;"
                : "padding:4px 0;";

            sb.Append("<div style='display:flex;justify-content:space-between;align-items:center;" + style + "'>");
            sb.Append("<div style='flex:1;text-align:left;'>" + Html(label) + "</div>");
            sb.Append("<div style='min-width:90px;text-align:right;'>" + Html(value) + "</div>");
            sb.Append("</div>");
        }

        private static string Html(string value)
        {
            return WebUtility.HtmlEncode(value ?? string.Empty);
        }
    }
}
