using System.Collections.Generic;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public interface IOrderRepository
    {
        OrderReceipt GetReceipt(string receiptNumber);
        string CreateOrder(string customerId, string paymentMethod, decimal paymentTotal, IList<CartItem> cart);
        IList<SaleHistoryItem> GetSaleHistoryForCustomer(string customerId);
        IList<SaleProductItem> GetProductsForReceipt(string receiptNumber);
    }
}
