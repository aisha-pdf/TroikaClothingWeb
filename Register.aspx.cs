using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace TroikaClothingWeb
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string surname = txtSurname.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phoneNum = txtPhoneNum.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
           

            string street = txtStreet.Text.Trim();
            string suburb = txtSuburb.Text.Trim();
            string postCode = txtPostCode.Text.Trim();

            // --- Validation logic ---
            if (string.IsNullOrEmpty(name) ||
                string.IsNullOrEmpty(surname) ||
                string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(phoneNum) ||
                string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(password))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "All fields except address are required.";
                return;
            }

            // Validate email format
            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid email address.";
                return;
            }

            //Phone number must be 10 digits
            if (phoneNum.Length != 10)
            {
                lblMessage.ForeColor= System.Drawing.Color.Red;
                lblMessage.Text = "Phone number must be 10 digits";
                return;
            }

            // Username must be exactly 6 characters
            if (username.Length != 6)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Username must be exactly 6 characters long.";
                return;
            }

            // Password for only numbers?
            // Password must be exactly 8 digits (only numbers)
            //if (password.Length != 8 || !password.All(char.IsDigit))
            //{
            //    lblMessage.ForeColor = System.Drawing.Color.Red;
            //    lblMessage.Text = "Password must be 8 digits (numbers only).";
            //    return;
            //}
            //Updated password validation
            if (password.Length < 8 ||
                !Regex.IsMatch(password, @"[A-Z]") ||
                !Regex.IsMatch(password, @"[a-z]") ||
                !Regex.IsMatch(password, @"[0-9]") ||
                !Regex.IsMatch(password, @"[!@#$%^&*(),.?""{}|<>]"))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Password must be at least 8 characters long and include an uppercase letter, lowercase letter, number, and special character.";
                return;
            }


            string cs = ConfigurationManager.ConnectionStrings["LoginConnectionString"].ConnectionString;

            // --- Check if email already exists ---
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                using (SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM Customer WHERE email = @Email", con))
                {
                    check.Parameters.AddWithValue("@Email", email);
                    int exists = (int)check.ExecuteScalar();
                    if (exists > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "An account with this email already exists.";
                        return;
                    }
                }
            }

            try
            {
                // --- Insert into WebsiteRegister and WebsiteLogin ---
                RegisterDataSource.Insert();
                InsertLoginDS.Insert();

                // --- Generate new CustomerID ---
                string newCustomerID = GenerateNextCustomerID();

                // --- Insert into Customer + RetailCustomer ---
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlTransaction tx = con.BeginTransaction();

                    try
                    {
                        // Insert into Customer (address optional)
                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO Customer (customerID, email, status, phoneNum, streetAddress, suburb, postCode)
                            VALUES (@id, @em, 'Active', '', @street, @suburb, @post)", con, tx))
                        {
                            cmd.Parameters.AddWithValue("@id", newCustomerID);
                            cmd.Parameters.AddWithValue("@em", email);
                            cmd.Parameters.AddWithValue("@street", string.IsNullOrEmpty(street) ? (object)DBNull.Value : street);
                            cmd.Parameters.AddWithValue("@suburb", string.IsNullOrEmpty(suburb) ? (object)DBNull.Value : suburb);
                            cmd.Parameters.AddWithValue("@post", string.IsNullOrEmpty(postCode) ? (object)DBNull.Value : postCode);
                            cmd.ExecuteNonQuery();
                        }

                        // Insert into RetailCustomer
                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO RetailCustomer (customerID, name, surname)
                            VALUES (@id, @name, @surname)", con, tx))
                        {
                            cmd.Parameters.AddWithValue("@id", newCustomerID);
                            cmd.Parameters.AddWithValue("@name", name);
                            cmd.Parameters.AddWithValue("@surname", surname);
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                        lblMessage.Text = "Database error: " + ex.Message;
                        return;
                    }
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Registration successful!";
                Response.Redirect("Login.aspx");
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Registration failed: " + ex.Message;
            }
        }

        // --- Generate CustomerID in format CUS000 ---
        private string GenerateNextCustomerID()
        {
            DataView dv = (DataView)SqlDsLastID.Select(DataSourceSelectArguments.Empty);

            if (dv != null && dv.Count > 0)
            {
                string lastID = dv[0]["customerID"].ToString();  // get last CustomerID
                int numberPart = 0;

                // Check it starts with "C" and has at least one more character
                if (lastID.StartsWith("C", StringComparison.OrdinalIgnoreCase) && lastID.Length >= 2)
                {
                    int.TryParse(lastID.Substring(1), out numberPart);  // parse the numeric part
                }

                numberPart++;  // increment
                string newID = "C" + numberPart.ToString("D3");  // format with 3 digits
                return newID;
            }

            // Default if no customers exist yet
            return "C001";
        }
    }
}


//old registration code

//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text.RegularExpressions;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace TroikaClothingWeb
//{
//    public partial class Register : System.Web.UI.Page
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {

//        }

//        protected void btnRegister_Click(object sender, EventArgs e)
//        {
//            string name = txtName.Text.Trim();
//            string surname = txtSurname.Text.Trim();
//            string email = txtEmail.Text.Trim();
//            string username = txtUsername.Text.Trim();
//            string password = txtPassword.Text.Trim();

//            // --- Validation logic ---
//            if (string.IsNullOrEmpty(name) ||
//                string.IsNullOrEmpty(surname) ||
//                string.IsNullOrEmpty(email) ||
//                string.IsNullOrEmpty(username) ||
//                string.IsNullOrEmpty(password))
//            {
//                lblMessage.ForeColor = System.Drawing.Color.Red;
//                lblMessage.Text = "All fields are required.";
//                return;
//            }

//            // Validate email format
//            if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
//            {
//                lblMessage.ForeColor = System.Drawing.Color.Red;
//                lblMessage.Text = "Invalid email address.";
//                return;
//            }

//            // Username must be exactly 6 characters
//            if (username.Length != 6)
//            {
//                lblMessage.ForeColor = System.Drawing.Color.Red;
//                lblMessage.Text = "Username must be exactly 6 characters long.";
//                return;
//            }

//            // Password must be exactly 8 digits (only numbers)
//            if (password.Length != 8)
//            {
//                lblMessage.ForeColor = System.Drawing.Color.Red;
//                lblMessage.Text = "Password must be 8 digits.";
//                return;
//            }

//            // --- Registration successful ---
//            RegisterDataSource.Insert();
//            SqlDataSource1.Insert();
//            lblMessage.ForeColor = System.Drawing.Color.Green;
//            lblMessage.Text = "Registration successful!";
//            Response.Redirect("Login.aspx");

//        }
//    }
//}