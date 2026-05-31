using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class UserService
    {
        private readonly IUserRepository _userRepository;

        public UserService() : this(new UserRepository()) { }

        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public string GetCustomerIdByUsername(string username)
        {
            return _userRepository.GetCustomerIdByUsername(username);
        }

        public CustomerAddress GetCustomerAddressForUsername(string username)
        {
            string customerId = GetCustomerIdByUsername(username);
            return string.IsNullOrWhiteSpace(customerId) ? null : _userRepository.GetCustomerAddress(customerId);
        }

        public OperationResult SaveCustomerAddress(string username, string street, string suburb, string postCode)
        {
            string customerId = GetCustomerIdByUsername(username);
            if (string.IsNullOrWhiteSpace(customerId))
                return OperationResult.Fail("Your customer account could not be linked. Please contact support.");

            var address = new CustomerAddress
            {
                CustomerID = customerId,
                StreetAddress = (street ?? string.Empty).Trim(),
                Suburb = (suburb ?? string.Empty).Trim(),
                PostCode = (postCode ?? string.Empty).Trim()
            };

            if (!address.IsComplete)
                return OperationResult.Fail("All address fields are required.");

            _userRepository.SaveCustomerAddress(address);
            return OperationResult.Ok("Address saved! Please click Checkout again to confirm your order.");
        }
    }
}
