using System.Web.UI;

namespace TroikaClothingWeb.Controls
{
    public partial class PageMessage : UserControl
    {
        public void ShowSuccess(string message)
        {
            Show(message, "troika-page-message troika-page-message-success");
        }

        public void ShowError(string message)
        {
            Show(message, "troika-page-message troika-page-message-error");
        }

        public void ShowInfo(string message)
        {
            Show(message, "troika-page-message troika-page-message-info");
        }

        public void Clear()
        {
            lblMessage.Text = string.Empty;
            pnlMessage.Visible = false;
        }

        private void Show(string message, string cssClass)
        {
            lblMessage.Text = message;
            pnlMessage.CssClass = cssClass;
            pnlMessage.Visible = !string.IsNullOrWhiteSpace(message);
        }
    }
}
