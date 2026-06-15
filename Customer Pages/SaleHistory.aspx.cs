using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Sale_Pages
{
    public partial class SaleHistory : CustomerPage
    {
        private readonly SaleHistoryService _saleHistoryService = ServiceFactory.CreateSaleHistoryService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindSales();
                ClearSelectedSale();
            }
        }

        private void BindSales()
        {
            IList<SaleHistoryItem> sales = _saleHistoryService.GetSalesForUsername(CurrentUsername);
            gvSale.DataSource = sales;
            gvSale.DataBind();

            bool hasSales = sales.Count > 0;
            lblMessage.Text = hasSales ? string.Empty : "You haven't placed any orders yet.";

            pnlStats.Visible = hasSales;
            if (hasSales)
            {
                lblStatOrders.Text = sales.Count.ToString();
                lblStatSpent.Text = "R" + sales.Sum(s => s.PaymentTotal).ToString("N2");
                lblStatLatest.Text = sales.Max(s => s.PaymentDate).ToString("dd MMM yyyy");
            }
        }

        protected void gvSale_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvSale.SelectedIndex < 0 || gvSale.SelectedDataKey == null)
            {
                ClearSelectedSale();
                return;
            }

            string receiptId = Convert.ToString(gvSale.SelectedDataKey.Value);
            if (string.IsNullOrWhiteSpace(receiptId))
            {
                ClearSelectedSale();
                return;
            }

            hfSelectedReceipt.Value = receiptId;
            BindSaleDetail(receiptId);
        }

        protected void gvSale_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSale.PageIndex = e.NewPageIndex;
            gvSale.SelectedIndex = -1;
            BindSales();

            // Keep the chosen order's detail visible after paging, and re-highlight its card
            // if it happens to be on the new page (SelectedRowStyle follows SelectedIndex).
            if (!string.IsNullOrWhiteSpace(hfSelectedReceipt.Value))
            {
                for (int i = 0; i < gvSale.Rows.Count; i++)
                {
                    if (string.Equals(Convert.ToString(gvSale.DataKeys[i].Value), hfSelectedReceipt.Value, StringComparison.OrdinalIgnoreCase))
                    {
                        gvSale.SelectedIndex = i;
                        break;
                    }
                }
                BindSaleDetail(hfSelectedReceipt.Value);
            }
        }

        private void BindSaleDetail(string receiptId)
        {
            SaleHistoryItem header = _saleHistoryService.GetSalesForUsername(CurrentUsername)
                .FirstOrDefault(s => string.Equals(s.ReceiptNum, receiptId, StringComparison.OrdinalIgnoreCase));

            IList<SaleProductItem> products = _saleHistoryService.GetProductsForReceipt(receiptId);
            foreach (SaleProductItem product in products)
                product.ImageUrl = GetProductImageUrl(product.ProductID, product.ImageVersion);

            lvProductsSold.DataSource = products;
            lvProductsSold.DataBind();

            lblSelectedReceipt.Text = receiptId;
            lblSelectedCount.Text = products.Count + (products.Count == 1 ? " item" : " items");

            decimal subtotal = products.Sum(p => p.LineTotal);
            decimal total = header != null ? header.PaymentTotal : subtotal;
            decimal delivery = total - subtotal;

            lblSelectedSubtotal.Text = "R" + subtotal.ToString("N2");
            lblSelectedDelivery.Text = delivery > 0.005m ? "R" + delivery.ToString("N2") : "Free";
            lblSelectedTotal.Text = "R" + total.ToString("N2");

            if (header != null)
            {
                lblSelectedDate.Text = header.PaymentDate.ToString("dd MMM yyyy, HH:mm");
                lblSelectedPayment.Text = header.PaymentMethod;
                lblSelectedStatus.Text = header.SalesStatus;
                lblSelectedStatus.CssClass = "sale-status-badge " + GetStatusCssClass(header.SalesStatus);
            }
            else
            {
                lblSelectedDate.Text = "—";
                lblSelectedPayment.Text = "—";
                lblSelectedStatus.Text = string.Empty;
                lblSelectedStatus.CssClass = "sale-status-badge status-neutral";
            }

            pnlSaleDetail.Visible = true;
            pnlNoSaleSelected.Visible = false;
        }

        private void ClearSelectedSale()
        {
            hfSelectedReceipt.Value = string.Empty;
            pnlSaleDetail.Visible = false;
            pnlNoSaleSelected.Visible = true;
        }

        // Maps a sale status to a badge colour class. Unknown values fall back to neutral.
        protected string GetStatusCssClass(object status)
        {
            string value = (status == null ? string.Empty : status.ToString()).Trim().ToLowerInvariant();
            switch (value)
            {
                case "completed":
                case "delivered":
                case "paid":
                    return "status-success";
                case "cancelled":
                case "canceled":
                case "refunded":
                    return "status-danger";
                case "processing":
                case "shipped":
                    return "status-warning";
                case "placed":
                case "pending":
                    return "status-info";
                default:
                    return "status-neutral";
            }
        }

        protected string GetProductImageUrl(object productIdObj, long imageVersion)
        {
            if (productIdObj == null)
                return ResolveUrl("~/Images/Image_not_available.png");

            string productId = productIdObj.ToString();
            if (string.IsNullOrWhiteSpace(productId))
                return ResolveUrl("~/Images/Image_not_available.png");

            return ResolveUrl("~/Public Pages/ProductImageHandler.ashx?id=" + Server.UrlEncode(productId) + "&v=" + imageVersion);
        }
    }
}
