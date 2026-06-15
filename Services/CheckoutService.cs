using System;
using System.Collections.Generic;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class CheckoutResult : OperationResult
    {
        public string ReceiptNumber { get; set; }
    }

    public class CheckoutService
    {
        private readonly IUserRepository _userRepository;
        private readonly IOrderRepository _orderRepository;

        public CheckoutService() : this(new UserRepository(), new OrderRepository()) { }

        public CheckoutService(IUserRepository userRepository) : this(userRepository, new OrderRepository()) { }

        public CheckoutService(IUserRepository userRepository, IOrderRepository orderRepository)
        {
            _userRepository = userRepository;
            _orderRepository = orderRepository;
        }

        public bool CustomerHasAddress(string username)
        {
            string customerId = _userRepository.GetCustomerIdByUsername(username);
            if (string.IsNullOrWhiteSpace(customerId)) return false;

            CustomerAddress address = _userRepository.GetCustomerAddress(customerId);
            return address != null && address.IsComplete;
        }

        public CheckoutResult PlaceOrder(string username, string paymentMethod, IList<CartItem> cart)
        {
            if (cart == null || cart.Count == 0)
                return Fail("Your cart is empty.");

            string customerId = _userRepository.GetCustomerIdByUsername(username);
            if (string.IsNullOrWhiteSpace(customerId))
                return Fail("Your customer account could not be linked. Please re-register or contact support.");

            CustomerAddress address = _userRepository.GetCustomerAddress(customerId);
            if (address == null || !address.IsComplete)
                return Fail("Please provide your delivery address before checking out.");

            decimal total = CalculateOrderTotal(cart);

            try
            {
                string receipt = _orderRepository.CreateOrder(customerId, paymentMethod, total, cart);
                return new CheckoutResult { Success = true, Message = "Order placed successfully!", ReceiptNumber = receipt };
            }
            catch (Exception ex)
            {
                return Fail("Checkout failed: " + ex.Message);
            }
        }

        private decimal CalculateOrderTotal(IList<CartItem> cart)
        {
            decimal subtotal = 0m;
            foreach (var item in cart)
                subtotal += item.UnitPrice * item.Quantity;

            return subtotal + DeliveryRates.CalculateFee(subtotal);
        }

        private CheckoutResult Fail(string message)
        {
            return new CheckoutResult { Success = false, Message = message };
        }
    }
}
