using System;
using System.Collections.Generic;
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
                SELECT TOP 1
                       l.Username,
                       l.Role,
                       l.Status AS LoginStatus,
                       r.Status AS RegisterStatus,
                       c.status AS CustomerStatus
                FROM WebsiteLogin l
                LEFT JOIN WebsiteRegister r ON r.Username = l.Username
                LEFT JOIN Customer c ON c.email = r.Email
                WHERE l.Username = @Username
                  AND l.Password = @Password";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;

                    string role = reader["Role"].ToString();
                    string loginStatus = reader["LoginStatus"] == DBNull.Value ? string.Empty : reader["LoginStatus"].ToString();
                    string registerStatus = reader["RegisterStatus"] == DBNull.Value ? string.Empty : reader["RegisterStatus"].ToString();
                    string customerStatus = reader["CustomerStatus"] == DBNull.Value ? string.Empty : reader["CustomerStatus"].ToString();

                    bool loginActive = IsActive(loginStatus);
                    bool isCustomer = string.Equals(role, "Customer", StringComparison.OrdinalIgnoreCase);

                    bool allLinkedCustomerRecordsActive = true;

                    if (isCustomer)
                    {
                        allLinkedCustomerRecordsActive =
                            IsActive(registerStatus) &&
                            IsActive(customerStatus);
                    }

                    return new UserAccount
                    {
                        Username = reader["Username"].ToString(),
                        Role = role,
                        Status = loginActive && allLinkedCustomerRecordsActive ? "Active" : "Inactive"
                    };
                }
            }
        }

        public string GetCustomerIdByUsername(string username)
        {
            if (string.IsNullOrWhiteSpace(username)) return null;

            const string sql = @"
                SELECT TOP 1 c.customerID
                FROM WebsiteRegister r
                INNER JOIN Customer c ON LOWER(LTRIM(RTRIM(c.email))) = LOWER(LTRIM(RTRIM(r.Email)))
                WHERE r.Username = @Username";

            object value = Db.ExecuteScalar(sql, p => p.AddWithValue("@Username", username.Trim()));
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

        public bool EmailExists(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            const string sql = @"
                SELECT COUNT(*)
                FROM
                (
                    SELECT Email AS EmailAddress FROM WebsiteRegister
                    UNION ALL
                    SELECT email AS EmailAddress FROM Customer
                ) ExistingEmails
                WHERE LOWER(LTRIM(RTRIM(EmailAddress))) = LOWER(LTRIM(RTRIM(@Email)))";

            object value = Db.ExecuteScalar(sql, p => p.AddWithValue("@Email", email.Trim()));
            return Convert.ToInt32(value) > 0;
        }

        public bool UsernameExists(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return false;

            const string sql = @"
                SELECT COUNT(*)
                FROM
                (
                    SELECT Username FROM WebsiteLogin
                    UNION ALL
                    SELECT Username FROM WebsiteRegister
                ) ExistingUsernames
                WHERE LOWER(LTRIM(RTRIM(Username))) = LOWER(LTRIM(RTRIM(@Username)))";

            object value = Db.ExecuteScalar(sql, p => p.AddWithValue("@Username", username.Trim()));
            return Convert.ToInt32(value) > 0;
        }

        public void RegisterCustomer(RegisterRequest request)
        {
            if (request == null)
                throw new ArgumentNullException("request");

            request.TrimAll();

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();

                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string newCustomerId = GenerateNextCustomerId(con, tx);

                        InsertWebsiteRegister(con, tx, request);
                        InsertWebsiteLogin(con, tx, request);
                        InsertCustomer(con, tx, request, newCustomerId);
                        InsertRetailCustomer(con, tx, request, newCustomerId);

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        private string GenerateNextCustomerId(SqlConnection con, SqlTransaction tx)
        {
            const string sql = @"
                SELECT TOP (1) customerID
                FROM Customer
                ORDER BY customerID DESC";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                object value = cmd.ExecuteScalar();

                if (value == null || value == DBNull.Value)
                    return "C001";

                string lastId = value.ToString();
                int numberPart = 0;

                if (lastId.StartsWith("C", StringComparison.OrdinalIgnoreCase) && lastId.Length >= 2)
                    int.TryParse(lastId.Substring(1), out numberPart);

                numberPart++;
                return "C" + numberPart.ToString("D3");
            }
        }

        private void InsertWebsiteRegister(SqlConnection con, SqlTransaction tx, RegisterRequest request)
        {
            const string sql = @"
                INSERT INTO WebsiteRegister(Name, Surname, Email, Username, Password, Status, PhoneNumber)
                VALUES (@Name, @Surname, @Email, @Username, @Password, 'Active', @PhoneNumber)";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Name", request.Name);
                cmd.Parameters.AddWithValue("@Surname", request.Surname);
                cmd.Parameters.AddWithValue("@Email", request.Email);
                cmd.Parameters.AddWithValue("@Username", request.Username);
                cmd.Parameters.AddWithValue("@Password", request.Password);
                cmd.Parameters.AddWithValue("@PhoneNumber", request.PhoneNumber);
                cmd.ExecuteNonQuery();
            }
        }

        private void InsertWebsiteLogin(SqlConnection con, SqlTransaction tx, RegisterRequest request)
        {
            const string sql = @"
                INSERT INTO WebsiteLogin(Username, Password, Role, Status)
                VALUES (@Username, @Password, 'Customer', 'Active')";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Username", request.Username);
                cmd.Parameters.AddWithValue("@Password", request.Password);
                cmd.ExecuteNonQuery();
            }
        }

        private void InsertCustomer(SqlConnection con, SqlTransaction tx, RegisterRequest request, string customerId)
        {
            const string sql = @"
                INSERT INTO Customer (customerID, email, status, phoneNum, streetAddress, suburb, postCode)
                VALUES (@CustomerID, @Email, 'Active', @PhoneNumber, @StreetAddress, @Suburb, @PostCode)";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                cmd.Parameters.AddWithValue("@Email", request.Email);
                cmd.Parameters.AddWithValue("@PhoneNumber", request.PhoneNumber);
                cmd.Parameters.AddWithValue("@StreetAddress", string.IsNullOrWhiteSpace(request.StreetAddress) ? (object)DBNull.Value : request.StreetAddress);
                cmd.Parameters.AddWithValue("@Suburb", string.IsNullOrWhiteSpace(request.Suburb) ? (object)DBNull.Value : request.Suburb);
                cmd.Parameters.AddWithValue("@PostCode", string.IsNullOrWhiteSpace(request.PostCode) ? (object)DBNull.Value : request.PostCode);
                cmd.ExecuteNonQuery();
            }
        }

        private void InsertRetailCustomer(SqlConnection con, SqlTransaction tx, RegisterRequest request, string customerId)
        {
            const string sql = @"
                INSERT INTO RetailCustomer (customerID, name, surname)
                VALUES (@CustomerID, @Name, @Surname)";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                cmd.Parameters.AddWithValue("@Name", request.Name);
                cmd.Parameters.AddWithValue("@Surname", request.Surname);
                cmd.ExecuteNonQuery();
            }
        }

        public CustomerProfileDetails GetCustomerProfileByUsername(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return null;

            const string sql = @"
                SELECT TOP 1
                       c.customerID,
                       r.Name,
                       r.Surname,
                       r.Email,
                       r.Username,
                       r.Password,
                       r.PhoneNumber,
                       c.streetAddress,
                       c.suburb,
                       c.postCode,
                       c.status
                FROM WebsiteRegister r
                LEFT JOIN Customer c ON LOWER(LTRIM(RTRIM(c.email))) = LOWER(LTRIM(RTRIM(r.Email)))
                WHERE r.Username = @Username";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Username", username.Trim());
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read()) return null;

                    return new CustomerProfileDetails
                    {
                        CustomerID = reader["customerID"] == DBNull.Value ? string.Empty : reader["customerID"].ToString(),
                        Name = reader["Name"].ToString(),
                        Surname = reader["Surname"].ToString(),
                        Email = reader["Email"].ToString(),
                        Username = reader["Username"].ToString(),
                        Password = reader["Password"].ToString(),
                        PhoneNumber = reader["PhoneNumber"].ToString(),
                        StreetAddress = reader["streetAddress"] == DBNull.Value ? string.Empty : reader["streetAddress"].ToString(),
                        Suburb = reader["suburb"] == DBNull.Value ? string.Empty : reader["suburb"].ToString(),
                        PostCode = reader["postCode"] == DBNull.Value ? string.Empty : reader["postCode"].ToString(),
                        Status = reader["status"] == DBNull.Value ? string.Empty : reader["status"].ToString()
                    };
                }
            }
        }

        public bool EmailExistsForOtherUser(string email, string username)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            const string sql = @"
                DECLARE @CurrentCustomerID VARCHAR(20);

                SELECT TOP 1 @CurrentCustomerID = c.customerID
                FROM WebsiteRegister r
                INNER JOIN Customer c ON LOWER(LTRIM(RTRIM(c.email))) = LOWER(LTRIM(RTRIM(r.Email)))
                WHERE r.Username = @Username;

                SELECT
                    (
                        SELECT COUNT(*)
                        FROM WebsiteRegister
                        WHERE LOWER(LTRIM(RTRIM(Email))) = LOWER(LTRIM(RTRIM(@Email)))
                          AND Username <> @Username
                    )
                    +
                    (
                        SELECT COUNT(*)
                        FROM Customer
                        WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(LTRIM(RTRIM(@Email)))
                          AND (@CurrentCustomerID IS NULL OR customerID <> @CurrentCustomerID)
                    )";

            object value = Db.ExecuteScalar(sql, p =>
            {
                p.AddWithValue("@Email", email.Trim());
                p.AddWithValue("@Username", (username ?? string.Empty).Trim());
            });

            return Convert.ToInt32(value) > 0;
        }

        public bool EmailExistsForOtherRegisterId(string email, int registerId)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            const string sql = @"
                DECLARE @CurrentCustomerID VARCHAR(20);

                SELECT TOP 1 @CurrentCustomerID = c.customerID
                FROM WebsiteRegister r
                INNER JOIN Customer c ON LOWER(LTRIM(RTRIM(c.email))) = LOWER(LTRIM(RTRIM(r.Email)))
                WHERE r.ID = @RegisterID;

                SELECT
                    (
                        SELECT COUNT(*)
                        FROM WebsiteRegister
                        WHERE LOWER(LTRIM(RTRIM(Email))) = LOWER(LTRIM(RTRIM(@Email)))
                          AND ID <> @RegisterID
                    )
                    +
                    (
                        SELECT COUNT(*)
                        FROM Customer
                        WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(LTRIM(RTRIM(@Email)))
                          AND (@CurrentCustomerID IS NULL OR customerID <> @CurrentCustomerID)
                    )";

            object value = Db.ExecuteScalar(sql, p =>
            {
                p.AddWithValue("@Email", email.Trim());
                p.AddWithValue("@RegisterID", registerId);
            });

            return Convert.ToInt32(value) > 0;
        }

        public void UpdateCustomerProfile(CustomerProfileUpdateRequest request)
        {
            if (request == null)
                throw new ArgumentNullException("request");

            request.TrimAll();

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();

                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string customerId = GetCustomerIdByUsername(con, tx, request.Username);

                        if (string.IsNullOrWhiteSpace(customerId))
                            throw new InvalidOperationException("Customer account could not be found.");

                        UpdateWebsiteRegister(con, tx, request);
                        UpdateCustomerTable(con, tx, request, customerId);
                        UpdateRetailCustomer(con, tx, request, customerId);

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        public void UpdateCustomerAddressByUsername(CustomerAddressUpdateRequest request)
        {
            if (request == null)
                throw new ArgumentNullException("request");

            request.TrimAll();

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();

                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string customerId = GetCustomerIdByUsername(con, tx, request.Username);

                        if (string.IsNullOrWhiteSpace(customerId))
                            throw new InvalidOperationException("Customer account could not be found.");

                        const string sql = @"
                            UPDATE Customer
                            SET streetAddress = @StreetAddress,
                                suburb = @Suburb,
                                postCode = @PostCode
                            WHERE customerID = @CustomerID";

                        using (SqlCommand cmd = new SqlCommand(sql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@StreetAddress", request.StreetAddress);
                            cmd.Parameters.AddWithValue("@Suburb", request.Suburb);
                            cmd.Parameters.AddWithValue("@PostCode", request.PostCode);
                            cmd.Parameters.AddWithValue("@CustomerID", customerId);
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        public void DeactivateCustomerAccount(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                throw new ArgumentException("Username is required.", "username");

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();

                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string customerId = GetCustomerIdByUsername(con, tx, username);

                        if (string.IsNullOrWhiteSpace(customerId))
                            throw new InvalidOperationException("Customer account could not be found.");

                        ExecuteInTransaction(con, tx,
                            "UPDATE Customer SET status = 'Inactive' WHERE customerID = @CustomerID",
                            cmd => cmd.Parameters.AddWithValue("@CustomerID", customerId));

                        ExecuteInTransaction(con, tx,
                            "UPDATE WebsiteRegister SET Status = 'Inactive' WHERE Username = @Username",
                            cmd => cmd.Parameters.AddWithValue("@Username", username.Trim()));

                        ExecuteInTransaction(con, tx,
                            "UPDATE WebsiteLogin SET Status = 'Inactive' WHERE Username = @Username",
                            cmd => cmd.Parameters.AddWithValue("@Username", username.Trim()));

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        public void SyncCustomerTablesFromRegisterId(int registerId, string originalEmail)
        {
            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();

                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        const string findSql = @"
                            SELECT TOP 1 ID, Name, Surname, Email, PhoneNumber
                            FROM WebsiteRegister
                            WHERE ID = @RegisterID";

                        string name = string.Empty;
                        string surname = string.Empty;
                        string newEmail = string.Empty;
                        string phoneNumber = string.Empty;

                        using (SqlCommand cmd = new SqlCommand(findSql, con, tx))
                        {
                            cmd.Parameters.AddWithValue("@RegisterID", registerId);

                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (!reader.Read())
                                    return;

                                name = reader["Name"].ToString();
                                surname = reader["Surname"].ToString();
                                newEmail = reader["Email"].ToString();
                                phoneNumber = reader["PhoneNumber"].ToString();
                            }
                        }

                        string customerId = GetCustomerIdByEmail(con, tx, originalEmail);

                        if (string.IsNullOrWhiteSpace(customerId))
                            customerId = GetCustomerIdByEmail(con, tx, newEmail);

                        if (string.IsNullOrWhiteSpace(customerId))
                        {
                            tx.Commit();
                            return;
                        }

                        ExecuteInTransaction(con, tx,
                            @"UPDATE Customer
                              SET email = @Email,
                                  phoneNum = @PhoneNumber
                              WHERE customerID = @CustomerID",
                            cmd =>
                            {
                                cmd.Parameters.AddWithValue("@Email", newEmail);
                                cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
                                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                            });

                        ExecuteInTransaction(con, tx,
                            @"UPDATE RetailCustomer
                              SET name = @Name,
                                  surname = @Surname
                              WHERE customerID = @CustomerID",
                            cmd =>
                            {
                                cmd.Parameters.AddWithValue("@Name", name);
                                cmd.Parameters.AddWithValue("@Surname", surname);
                                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                            });

                        tx.Commit();
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        private string GetCustomerIdByUsername(SqlConnection con, SqlTransaction tx, string username)
        {
            const string sql = @"
                SELECT TOP 1 c.customerID
                FROM WebsiteRegister r
                INNER JOIN Customer c ON LOWER(LTRIM(RTRIM(c.email))) = LOWER(LTRIM(RTRIM(r.Email)))
                WHERE r.Username = @Username";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Username", (username ?? string.Empty).Trim());
                object value = cmd.ExecuteScalar();
                return value == null || value == DBNull.Value ? null : value.ToString();
            }
        }

        private string GetCustomerIdByEmail(SqlConnection con, SqlTransaction tx, string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return null;

            const string sql = @"
                SELECT TOP 1 customerID
                FROM Customer
                WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(LTRIM(RTRIM(@Email)))";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Email", email.Trim());
                object value = cmd.ExecuteScalar();
                return value == null || value == DBNull.Value ? null : value.ToString();
            }
        }

        private void UpdateWebsiteRegister(SqlConnection con, SqlTransaction tx, CustomerProfileUpdateRequest request)
        {
            const string sql = @"
                UPDATE WebsiteRegister
                SET Name = @Name,
                    Surname = @Surname,
                    Email = @Email,
                    PhoneNumber = @PhoneNumber
                WHERE Username = @Username";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Name", request.Name);
                cmd.Parameters.AddWithValue("@Surname", request.Surname);
                cmd.Parameters.AddWithValue("@Email", request.Email);
                cmd.Parameters.AddWithValue("@PhoneNumber", request.PhoneNumber);
                cmd.Parameters.AddWithValue("@Username", request.Username);
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdateCustomerTable(SqlConnection con, SqlTransaction tx, CustomerProfileUpdateRequest request, string customerId)
        {
            const string sql = @"
                UPDATE Customer
                SET email = @Email,
                    phoneNum = @PhoneNumber
                WHERE customerID = @CustomerID";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Email", request.Email);
                cmd.Parameters.AddWithValue("@PhoneNumber", request.PhoneNumber);
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdateRetailCustomer(SqlConnection con, SqlTransaction tx, CustomerProfileUpdateRequest request, string customerId)
        {
            const string sql = @"
                UPDATE RetailCustomer
                SET name = @Name,
                    surname = @Surname
                WHERE customerID = @CustomerID";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@Name", request.Name);
                cmd.Parameters.AddWithValue("@Surname", request.Surname);
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                cmd.ExecuteNonQuery();
            }
        }

        private void ExecuteInTransaction(SqlConnection con, SqlTransaction tx, string sql, Action<SqlCommand> configure)
        {
            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                configure(cmd);
                cmd.ExecuteNonQuery();
            }
        }


        public IList<AdminUserRecord> GetAllRegisterUsers()
        {
            var users = new List<AdminUserRecord>();

            const string sql = @"
                SELECT ID, Name, Surname, Email, Username, PhoneNumber, Status
                FROM WebsiteRegister
                ORDER BY ID";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        users.Add(MapAdminUserRecord(reader));
                    }
                }
            }

            return users;
        }

        public AdminUserRecord GetRegisterUserByUsername(string username)
        {
            if (string.IsNullOrWhiteSpace(username))
                return null;

            const string sql = @"
                SELECT TOP 1 ID, Name, Surname, Email, Username, PhoneNumber, Status
                FROM WebsiteRegister
                WHERE Username = @Username";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Username", username.Trim());
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    return reader.Read() ? MapAdminUserRecord(reader) : null;
                }
            }
        }

        public OperationResult UpdateRegisterUser(AdminUserRecord user)
        {
            if (user == null || user.ID <= 0)
                return OperationResult.Fail("The selected user could not be identified.");

            if (EmailExistsForOtherRegisterId(user.Email, user.ID))
                return OperationResult.Fail("This email address is already associated with another account. Please use a different email address.");

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        string originalEmail = GetRegisterEmailById(con, tx, user.ID);

                        const string updateRegisterSql = @"
                            UPDATE WebsiteRegister
                            SET Name = @Name,
                                Surname = @Surname,
                                Email = @Email,
                                PhoneNumber = @PhoneNumber
                            WHERE ID = @ID";

                        ExecuteInTransaction(con, tx, updateRegisterSql, cmd =>
                        {
                            cmd.Parameters.AddWithValue("@ID", user.ID);
                            cmd.Parameters.AddWithValue("@Name", (user.Name ?? string.Empty).Trim());
                            cmd.Parameters.AddWithValue("@Surname", (user.Surname ?? string.Empty).Trim());
                            cmd.Parameters.AddWithValue("@Email", (user.Email ?? string.Empty).Trim());
                            cmd.Parameters.AddWithValue("@PhoneNumber", (user.PhoneNumber ?? string.Empty).Trim());
                        });

                        string customerId = null;
                        if (!string.IsNullOrWhiteSpace(originalEmail))
                            customerId = GetCustomerIdByEmail(con, tx, originalEmail);

                        if (string.IsNullOrWhiteSpace(customerId))
                            customerId = GetCustomerIdByEmail(con, tx, user.Email);

                        if (!string.IsNullOrWhiteSpace(customerId))
                        {
                            const string updateCustomerSql = @"
                                UPDATE Customer
                                SET email = @Email,
                                    phoneNum = @PhoneNumber
                                WHERE customerID = @CustomerID";

                            ExecuteInTransaction(con, tx, updateCustomerSql, cmd =>
                            {
                                cmd.Parameters.AddWithValue("@Email", (user.Email ?? string.Empty).Trim());
                                cmd.Parameters.AddWithValue("@PhoneNumber", (user.PhoneNumber ?? string.Empty).Trim());
                                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                            });

                            const string updateRetailSql = @"
                                UPDATE RetailCustomer
                                SET name = @Name,
                                    surname = @Surname
                                WHERE customerID = @CustomerID";

                            ExecuteInTransaction(con, tx, updateRetailSql, cmd =>
                            {
                                cmd.Parameters.AddWithValue("@Name", (user.Name ?? string.Empty).Trim());
                                cmd.Parameters.AddWithValue("@Surname", (user.Surname ?? string.Empty).Trim());
                                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                            });
                        }

                        tx.Commit();
                        return OperationResult.Ok("User updated successfully.");
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        public OperationResult ResetPassword(PasswordResetRequest request)
        {
            if (request == null)
                return OperationResult.Fail("Please enter your email, phone number, and new password.");

            string email = (request.Email ?? string.Empty).Trim();
            string phone = (request.PhoneNumber ?? string.Empty).Trim();
            string newPassword = request.NewPassword ?? string.Empty;
            string confirmPassword = request.ConfirmPassword ?? string.Empty;

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(phone) ||
                string.IsNullOrWhiteSpace(newPassword) || string.IsNullOrWhiteSpace(confirmPassword))
                return OperationResult.Fail("Please complete all password reset fields.");

            if (!string.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
                return OperationResult.Fail("The new password and confirmation password do not match.");

            if (newPassword.Length < 6 || newPassword.Length > 8 ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, @"[A-Z]") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, @"[a-z]") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, @"[0-9]") ||
                !System.Text.RegularExpressions.Regex.IsMatch(newPassword, @"[!@#$%^&*(),.?""{}|<>]"))
            {
                return OperationResult.Fail("Password must be 6 to 8 characters long and include an uppercase letter, lowercase letter, number, and special character.");
            }

            const string matchSql = @"
                SELECT COUNT(*)
                FROM WebsiteRegister
                WHERE Email = @Email AND PhoneNumber = @PhoneNumber";

            object matchValue = Db.ExecuteScalar(matchSql, p =>
            {
                p.AddWithValue("@Email", email);
                p.AddWithValue("@PhoneNumber", phone);
            });

            int matches = matchValue == null || matchValue == DBNull.Value ? 0 : Convert.ToInt32(matchValue);
            if (matches <= 0)
                return OperationResult.Fail("No account was found with that email address and phone number.");

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction())
                {
                    try
                    {
                        const string updateRegisterSql = @"
                            UPDATE WebsiteRegister
                            SET Password = @Password
                            WHERE Email = @Email AND PhoneNumber = @PhoneNumber";

                        ExecuteInTransaction(con, tx, updateRegisterSql, cmd =>
                        {
                            cmd.Parameters.AddWithValue("@Password", confirmPassword);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@PhoneNumber", phone);
                        });

                        const string updateLoginSql = @"
                            UPDATE WebsiteLogin
                            SET Password = @Password
                            WHERE Username IN (
                                SELECT Username
                                FROM WebsiteRegister
                                WHERE Email = @Email AND PhoneNumber = @PhoneNumber
                            )";

                        ExecuteInTransaction(con, tx, updateLoginSql, cmd =>
                        {
                            cmd.Parameters.AddWithValue("@Password", confirmPassword);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@PhoneNumber", phone);
                        });

                        tx.Commit();
                        return OperationResult.Ok("Password reset successfully. You can now log in with your new password.");
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        private static AdminUserRecord MapAdminUserRecord(SqlDataReader reader)
        {
            return new AdminUserRecord
            {
                ID = reader["ID"] == DBNull.Value ? 0 : Convert.ToInt32(reader["ID"]),
                Name = Convert.ToString(reader["Name"]),
                Surname = Convert.ToString(reader["Surname"]),
                Email = Convert.ToString(reader["Email"]),
                Username = Convert.ToString(reader["Username"]),
                PhoneNumber = Convert.ToString(reader["PhoneNumber"]),
                Status = Convert.ToString(reader["Status"])
            };
        }

        private string GetRegisterEmailById(SqlConnection con, SqlTransaction tx, int registerId)
        {
            const string sql = "SELECT TOP 1 Email FROM WebsiteRegister WHERE ID = @ID";
            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@ID", registerId);
                object value = cmd.ExecuteScalar();
                return value == null || value == DBNull.Value ? null : Convert.ToString(value);
            }
        }

        private bool IsActive(string status)
        {
            return string.Equals((status ?? string.Empty).Trim(), "Active", StringComparison.OrdinalIgnoreCase);
        }
    }
}
