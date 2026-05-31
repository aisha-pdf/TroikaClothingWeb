using System;
using System.Data.SqlClient;
using TroikaClothingWeb.Data;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public class UserRepository : IUserRepository
    {
        public UserAccount GetLoginByUsernameAndPassword(string username, string password)
        {
            const string sql = @"
                SELECT TOP 1 Username, Role, Status
                FROM WebsiteLogin
                WHERE Username = @Username AND Password = @Password";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;

                    return new UserAccount
                    {
                        Username = reader["Username"].ToString(),
                        Role = reader["Role"].ToString(),
                        Status = reader["Status"].ToString()
                    };
                }
            }
        }

        public string GetCustomerIdByUsername(string username)
        {
            if (string.IsNullOrWhiteSpace(username)) return null;

            const string sql = @"
                SELECT c.customerID
                FROM Customer c
                INNER JOIN WebsiteRegister r ON r.Email = c.email
                INNER JOIN WebsiteLogin l ON l.Username = r.Username
                WHERE l.Username = @Username";

            object value = Db.ExecuteScalar(sql, p => p.AddWithValue("@Username", username));
            return value == null || value == DBNull.Value ? null : value.ToString();
        }

        public CustomerAddress GetCustomerAddress(string customerId)
        {
            if (string.IsNullOrWhiteSpace(customerId)) return null;

            const string sql = @"
                SELECT customerID, streetAddress, suburb, postCode
                FROM Customer
                WHERE customerID = @CustomerID";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;

                    return new CustomerAddress
                    {
                        CustomerID = customerId,
                        StreetAddress = reader["streetAddress"].ToString(),
                        Suburb = reader["suburb"].ToString(),
                        PostCode = reader["postCode"].ToString()
                    };
                }
            }
        }

        public void SaveCustomerAddress(CustomerAddress address)
        {
            const string sql = @"
                UPDATE Customer
                SET streetAddress = @StreetAddress,
                    suburb = @Suburb,
                    postCode = @PostCode
                WHERE customerID = @CustomerID";

            Db.ExecuteNonQuery(sql, p =>
            {
                p.AddWithValue("@StreetAddress", address.StreetAddress);
                p.AddWithValue("@Suburb", address.Suburb);
                p.AddWithValue("@PostCode", address.PostCode);
                p.AddWithValue("@CustomerID", address.CustomerID);
            });
        }
    }
}
