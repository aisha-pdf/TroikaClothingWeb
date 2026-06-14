using System.Collections.Generic;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class SaleHistoryService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly IUserRepository _userRepository;

        public SaleHistoryService() : this(new OrderRepository(), new UserRepository()) { }

        public SaleHistoryService(IOrderRepository orderRepository, IUserRepository userRepository)
        {
            _orderRepository = orderRepository;
            _userRepository = userRepository;
        }

        public IList<SaleHistoryItem> GetSalesForUsername(string username)
        {
            string customerId = _userRepository.GetCustomerIdByUsername(username);
            return string.IsNullOrWhiteSpace(customerId)
                ? new List<SaleHistoryItem>()
                : _orderRepository.GetSaleHistoryForCustomer(customerId);
        }

        public IList<SaleProductItem> GetProductsForReceipt(string receiptNumber)
        {
            return _orderRepository.GetProductsForReceipt(receiptNumber);
        }
    }
}
