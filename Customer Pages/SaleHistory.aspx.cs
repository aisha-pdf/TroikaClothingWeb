using System;
using System.Collections.Generic;
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
            lblMessage.Text = sales.Count == 0 ? "No sales have been found for your account yet." : string.Empty;
        }

        protected void gvSale_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSale.PageIndex = e.NewPageIndex;
            BindSales();
            RestoreSelectedSale();
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
            BindProductsForReceipt(receiptId);
        }

        private void RestoreSelectedSale()
        {
            if (!string.IsNullOrWhiteSpace(hfSelectedReceipt.Value))
                BindProductsForReceipt(hfSelectedReceipt.Value);
        }

        private void BindProductsForReceipt(string receiptId)
        {
            IList<SaleProductItem> products = _saleHistoryService.GetProductsForReceipt(receiptId);

            foreach (SaleProductItem product in products)
            {
                product.ImageUrl = GetProductImageUrl(product.ProductID);
            }

            lvProductsSold.DataSource = products;
            lvProductsSold.DataBind();

            pnlNoSaleSelected.Visible = false;
            lvProductsSold.Visible = true;
        }

        private void ClearSelectedSale()
        {
            hfSelectedReceipt.Value = string.Empty;
            pnlNoSaleSelected.Visible = true;
            lvProductsSold.Visible = false;
        }

        protected string GetProductImageUrl(object productIdObj)
        {
            if (productIdObj == null)
                return ResolveUrl("~/Images/Image_not_available.png");

            string productId = productIdObj.ToString();
            if (string.IsNullOrWhiteSpace(productId))
                return ResolveUrl("~/Images/Image_not_available.png");

            return ResolveUrl("~/Public Pages/ProductImageHandler.ashx?id=" + Server.UrlEncode(productId));
        }
    }
}
