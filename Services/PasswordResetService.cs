using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class PasswordResetService
    {
        private readonly IUserRepository _userRepository;

        public PasswordResetService() : this(new UserRepository()) { }

        public PasswordResetService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public OperationResult ResetPassword(PasswordResetRequest request)
        {
            return _userRepository.ResetPassword(request);
        }
    }
}
