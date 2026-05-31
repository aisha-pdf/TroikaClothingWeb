using System;
using System.Web.SessionState;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class AuthService
    {
        private readonly IUserRepository _userRepository;

        public AuthService() : this(new UserRepository()) { }

        public AuthService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public OperationResult Login(HttpSessionState session, string username, string password)
        {
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
                return OperationResult.Fail("Please enter your username and password.");

            var user = _userRepository.GetLoginByUsernameAndPassword(username.Trim(), password.Trim());
            if (user == null || !string.Equals(user.Username, username.Trim(), StringComparison.Ordinal))
                return OperationResult.Fail("Invalid username or password.");

            if (!string.Equals(user.Status, "Active", StringComparison.OrdinalIgnoreCase))
                return OperationResult.Fail("Your account is not active. Please contact the administrator.");

            session["Username"] = user.Username;
            session["Role"] = user.Role;
            return OperationResult.Ok();
        }

        public static bool IsInRole(HttpSessionState session, string role)
        {
            return session != null
                && session["Role"] != null
                && string.Equals(session["Role"].ToString(), role, StringComparison.OrdinalIgnoreCase);
        }

        public static bool IsLoggedIn(HttpSessionState session)
        {
            return session != null && session["Username"] != null;
        }

        public static string Username(HttpSessionState session)
        {
            return session == null ? null : session["Username"] as string;
        }
    }
}
