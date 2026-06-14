using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class RegistrationService
    {
        private readonly IUserRepository _userRepository;
        private readonly RegistrationValidationService _validationService;

        public RegistrationService()
            : this(new UserRepository(), new RegistrationValidationService())
        {
        }

        public RegistrationService(IUserRepository userRepository, RegistrationValidationService validationService)
        {
            _userRepository = userRepository;
            _validationService = validationService;
        }

        public OperationResult RegisterCustomer(RegisterRequest request)
        {
            OperationResult validation = _validationService.Validate(request);

            if (!validation.Success)
                return validation;

            request.TrimAll();

            if (_userRepository.EmailExists(request.Email))
            {
                return OperationResult.Fail(
                    "This email address is already associated with an existing account. Please use a different email address.");
            }

            if (_userRepository.UsernameExists(request.Username))
            {
                return OperationResult.Fail(
                    "This username is already associated with an existing account. Please choose a different username.");
            }

            _userRepository.RegisterCustomer(request);
            return OperationResult.Ok("Registration successful!");
        }
    }
}
