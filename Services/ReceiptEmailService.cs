using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    /// <summary>
    /// Sends the order-receipt email through the Gmail HTTP API (OAuth2, port 443), so it works from behind
    /// networks that block outbound SMTP. Product images are embedded as inline multipart/related "cid:" parts.
    /// Credentials come from Web.config appSettings (the Gmail* keys).
    /// </summary>
    public class ReceiptEmailService
    {
        private static readonly HttpClient Http = new HttpClient();

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

            string clientId = RequireSetting("GmailClientId");
            string clientSecret = RequireSetting("GmailClientSecret");
            string refreshToken = RequireSetting("GmailRefreshToken");
            string sender = RequireSetting("GmailSenderEmail");

            ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;

            // Per item: assign an inline cid for items that carry an image; collect the matching attachments.
            // imageSrcs stays parallel to receipt.Items so the HTML builder can reference "cid:imgN".
            var imageSrcs = new List<string>();
            var attachments = new List<KeyValuePair<string, byte[]>>();
            IList<ReceiptLineItem> lines = receipt.Items ?? new List<ReceiptLineItem>();
            for (int i = 0; i < lines.Count; i++)
            {
                byte[] img = lines[i].Picture;
                if (img != null && img.Length > 0)
                {
                    string cid = "img" + i;
                    imageSrcs.Add("cid:" + cid);
                    attachments.Add(new KeyValuePair<string, byte[]>(cid, img));
                }
                else
                {
                    imageSrcs.Add(null);
                }
            }

            string html = _htmlBuilder.BuildEmailHtml(receipt, imageSrcs);
            string subject = "Your Troika Clothing Order #" + receipt.ReceiptNumber;

            string accessToken = await GetAccessTokenAsync(clientId, clientSecret, refreshToken);
            string mime = BuildRelatedMime(sender, receipt.CustomerEmail, subject, html, attachments);
            string raw = Base64Url(Encoding.UTF8.GetBytes(mime));

            using (var msg = new HttpRequestMessage(HttpMethod.Post, "https://gmail.googleapis.com/gmail/v1/users/me/messages/send"))
            {
                msg.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                msg.Content = new StringContent("{\"raw\":\"" + raw + "\"}", Encoding.UTF8, "application/json");
                using (var resp = await Http.SendAsync(msg))
                {
                    if (!resp.IsSuccessStatusCode)
                    {
                        string body = await resp.Content.ReadAsStringAsync();
                        throw new InvalidOperationException("Gmail send failed (" + (int)resp.StatusCode + "): " + body);
                    }
                }
            }
        }

        // Trade the refresh token for a fresh access token (valid ~1 hour).
        private static async Task<string> GetAccessTokenAsync(string clientId, string clientSecret, string refreshToken)
        {
            var form = new FormUrlEncodedContent(new Dictionary<string, string>
            {
                { "client_id", clientId },
                { "client_secret", clientSecret },
                { "refresh_token", refreshToken },
                { "grant_type", "refresh_token" }
            });

            using (var resp = await Http.PostAsync("https://oauth2.googleapis.com/token", form))
            {
                string body = await resp.Content.ReadAsStringAsync();
                if (!resp.IsSuccessStatusCode)
                    throw new InvalidOperationException("Token refresh failed (" + (int)resp.StatusCode + "): " + body);

                var m = Regex.Match(body, "\"access_token\"\\s*:\\s*\"([^\"]+)\"");
                if (!m.Success) throw new InvalidOperationException("No access_token in token response.");
                return m.Groups[1].Value;
            }
        }

        private static string RequireSetting(string key)
        {
            string value = ConfigurationManager.AppSettings[key];
            if (string.IsNullOrWhiteSpace(value))
                throw new InvalidOperationException("The email account settings are missing from Web.config ('" + key + "').");
            return value;
        }

        // With images: multipart/related (HTML part + each image as an inline cid part).
        // Without images: a plain HTML message.
        private static string BuildRelatedMime(string from, string to, string subject, string html, List<KeyValuePair<string, byte[]>> images)
        {
            var sb = new StringBuilder();
            sb.Append("From: Troika Clothing <").Append(from).Append(">\r\n");
            sb.Append("To: ").Append(to).Append("\r\n");
            sb.Append("Subject: ").Append(subject).Append("\r\n");
            sb.Append("MIME-Version: 1.0\r\n");

            string htmlPart = "Content-Type: text/html; charset=UTF-8\r\nContent-Transfer-Encoding: base64\r\n\r\n" +
                              WrapBase64(Convert.ToBase64String(Encoding.UTF8.GetBytes(html)));

            if (images.Count == 0)
            {
                sb.Append(htmlPart);
                return sb.ToString();
            }

            string boundary = "troika_" + Guid.NewGuid().ToString("N");
            sb.Append("Content-Type: multipart/related; boundary=\"").Append(boundary).Append("\"\r\n\r\n");
            sb.Append("--").Append(boundary).Append("\r\n").Append(htmlPart).Append("\r\n");
            foreach (var img in images)
            {
                sb.Append("--").Append(boundary).Append("\r\n");
                sb.Append("Content-Type: image/jpeg\r\n");
                sb.Append("Content-Transfer-Encoding: base64\r\n");
                sb.Append("Content-ID: <").Append(img.Key).Append(">\r\n");
                sb.Append("Content-Disposition: inline; filename=\"").Append(img.Key).Append(".jpg\"\r\n\r\n");
                sb.Append(WrapBase64(Convert.ToBase64String(img.Value))).Append("\r\n");
            }
            sb.Append("--").Append(boundary).Append("--");
            return sb.ToString();
        }

        private static string WrapBase64(string b64)
        {
            var sb = new StringBuilder();
            for (int i = 0; i < b64.Length; i += 76)
                sb.Append(b64.Substring(i, Math.Min(76, b64.Length - i))).Append("\r\n");
            return sb.ToString().TrimEnd('\r', '\n');
        }

        private static string Base64Url(byte[] bytes)
        {
            return Convert.ToBase64String(bytes).Replace('+', '-').Replace('/', '_').TrimEnd('=');
        }
    }
}
