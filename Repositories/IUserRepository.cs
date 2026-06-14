using System.Collections.Generic;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public interface IUserRepository
    {
        UserAccount GetLoginByUsernameAndPassword(string username, string password);
        string GetCustomerIdByUsername(string username);
        CustomerAddress GetCustomerAddress(string customerId);
        void SaveCustomerAddress(CustomerAddress address);

        bool EmailExists(string email);
        bool UsernameExists(string username);
        void RegisterCustomer(RegisterRequest request);

        CustomerProfileDetails GetCustomerProfileByUsername(string username);
        bool EmailExistsForOtherUser(string email, string username);
        bool EmailExistsForOtherRegisterId(string email, int registerId);
        void UpdateCustomerProfile(CustomerProfileUpdateRequest request);
        void UpdateCustomerAddressByUsername(CustomerAddressUpdateRequest request);
        void DeactivateCustomerAccount(string username);
        void SyncCustomerTablesFromRegisterId(int registerId, string originalEmail);

        // Phase 13/15 repository methods: these remove remaining SqlDataSource usage.
        IList<AdminUserRecord> GetAllRegisterUsers();
        AdminUserRecord GetRegisterUserByUsername(string username);
        OperationResult UpdateRegisterUser(AdminUserRecord user);
        OperationResult ResetPassword(PasswordResetRequest request);
    }
}
