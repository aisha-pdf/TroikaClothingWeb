using System.Collections.Generic;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class AdminUserService
    {
        private readonly IUserRepository _userRepository;

        public AdminUserService() : this(new UserRepository()) { }

        public AdminUserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public IList<AdminUserRecord> GetUsers()
        {
            return _userRepository.GetAllRegisterUsers();
        }

        public AdminUserRecord GetProfile(string username)
        {
            return _userRepository.GetRegisterUserByUsername(username);
        }

        public OperationResult UpdateUser(AdminUserRecord user)
        {
            return _userRepository.UpdateRegisterUser(user);
        }
    }
}
