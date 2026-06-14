using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class CustomerProfileService
    {
        private readonly IUserRepository _userRepository;
        private readonly CustomerProfileValidationService _validationService;

        public CustomerProfileService()
            : this(new UserRepository(), new CustomerProfileValidationService())
        {
        }

        public CustomerProfileService(IUserRepository userRepository, CustomerProfileValidationService validationService)
        {
            _userRepository = userRepository;
            _validationService = validationService;
        }

        public CustomerProfileDetails GetProfile(string username)
        {
            return _userRepository.GetCustomerProfileByUsername(username);
        }

        public OperationResult UpdateProfile(CustomerProfileUpdateRequest request)
        {
            var validation = _validationService.ValidateProfile(request);
            if (!validation.Success)
                return validation;

            request.TrimAll();

            if (_userRepository.EmailExistsForOtherUser(request.Email, request.Username))
            {
                return OperationResult.Fail(
                    "This email address is already associated with another account. Please use a different email address.");
            }

            _userRepository.UpdateCustomerProfile(request);
            return OperationResult.Ok("Your account details have been updated successfully.");
        }

        public OperationResult UpdateAddress(CustomerAddressUpdateRequest request)
        {
            var validation = _validationService.ValidateAddress(request);
            if (!validation.Success)
                return validation;

            _userRepository.UpdateCustomerAddressByUsername(request);
            return OperationResult.Ok("Your address has been updated successfully.");
        }

        public OperationResult CloseAccount(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return OperationResult.Fail("Your login session could not be identified. Please log in again.");

            _userRepository.DeactivateCustomerAccount(username);
            return OperationResult.Ok("Your account has been closed. To reactivate your account, please contact support.");
        }
    }
}
