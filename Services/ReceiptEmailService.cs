using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class ReceiptEmailService
    {
        private readonly ReceiptHtmlBuilder _htmlBuilder;

        public ReceiptEmailService()
            : this(new ReceiptHtmlBuilder())
        {
        }

        public ReceiptEmailService(ReceiptHtmlBuilder htmlBuilder)
        {
            _htmlBuilder = htmlBuilder;
        }

        public async Task SendReceiptEmailAsync(OrderReceipt receipt)
        {
            if (receipt == null)
                throw new InvalidOperationException("Receipt details could not be loaded.");

            if (string.IsNullOrWhiteSpace(receipt.CustomerEmail))
                throw new InvalidOperationException("No email address is linked to this order.");

            string fromEmail = ConfigurationManager.AppSettings["GmailEmail"];
            string appPassword = ConfigurationManager.AppSettings["GmailAppPassword"];

            if (string.IsNullOrWhiteSpace(fromEmail) || string.IsNullOrWhiteSpace(appPassword))
                throw new InvalidOperationException("The email account settings are missing from Web.config.");

            using (var message = new MailMessage())
            {
                message.From = new MailAddress(fromEmail, "Troika Clothing");
                message.Subject = "Your Troika Clothing Order #" + receipt.ReceiptNumber;
                message.Body = _htmlBuilder.BuildEmailHtml(receipt);
                message.IsBodyHtml = true;
                message.To.Add(receipt.CustomerEmail);

                using (var smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.Credentials = new NetworkCredential(fromEmail, appPassword);
                    smtp.EnableSsl = true;
                    await smtp.SendMailAsync(message);
                }
            }
        }
    }
}
