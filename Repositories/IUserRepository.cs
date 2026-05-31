using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public interface IUserRepository
    {
        UserAccount GetLoginByUsernameAndPassword(string username, string password);
        string GetCustomerIdByUsername(string username);
        CustomerAddress GetCustomerAddress(string customerId);
        void SaveCustomerAddress(CustomerAddress address);
    }
}
