using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using TroikaClothingWeb.Data;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class CheckoutResult : OperationResult
    {
        public string ReceiptNumber { get; set; }
    }

    public class CheckoutService
    {
        private readonly IUserRepository _userRepository;

        public CheckoutService() : this(new UserRepository()) { }

        public CheckoutService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public bool CustomerHasAddress(string username)
        {
            string customerId = _userRepository.GetCustomerIdByUsername(username);
            if (string.IsNullOrWhiteSpace(customerId)) return false;

            CustomerAddress address = _userRepository.GetCustomerAddress(customerId);
            return address != null && address.IsComplete;
        }

        public CheckoutResult PlaceOrder(string username, string paymentMethod, IList<CartItem> cart)
        {
            if (cart == null || cart.Count == 0)
                return Fail("Your cart is empty.");

            string customerId = _userRepository.GetCustomerIdByUsername(username);
            if (string.IsNullOrWhiteSpace(customerId))
                return Fail("Your customer account could not be linked. Please re-register or contact support.");

            CustomerAddress address = _userRepository.GetCustomerAddress(customerId);
            if (address == null || !address.IsComplete)
                return Fail("Please provide your delivery address before checking out.");

            decimal subtotal = 0m;
            foreach (var item in cart)
                subtotal += item.UnitPrice * item.Quantity;

            decimal delivery = subtotal > 500m ? 0m : 80m;
            decimal total = subtotal + delivery;
            DateTime now = DateTime.Now;
            string receipt = GenerateNextReceiptNumber();

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction(System.Data.IsolationLevel.ReadCommitted))
                {
                    try
                    {
                        using (SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO Sale
                            (receiptNum, dateOfIssue, discount, paymentTotal, paymentMethod, paymentDate, saleChannel, salesStatus, CustomerID)
                            VALUES (@ReceiptNum, @DateOfIssue, @Discount, @PaymentTotal, @PaymentMethod, @PaymentDate, @SaleChannel, @SalesStatus, @CustomerID)", con, tx))
                        {
                            cmd.Parameters.AddWithValue("@ReceiptNum", receipt);
                            cmd.Parameters.AddWithValue("@DateOfIssue", now);
                            cmd.Parameters.AddWithValue("@Discount", 0m);
                            cmd.Parameters.AddWithValue("@PaymentTotal", total);
                            cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                            cmd.Parameters.AddWithValue("@PaymentDate", now);
                            cmd.Parameters.AddWithValue("@SaleChannel", "Website");
                            cmd.Parameters.AddWithValue("@SalesStatus", "Placed");
                            cmd.Parameters.AddWithValue("@CustomerID", customerId);
                            cmd.ExecuteNonQuery();
                        }

                        foreach (var line in cart)
                        {
                            using (SqlCommand cmd = new SqlCommand(@"
                                INSERT INTO ProductSold (receiptID, ProductID, clothingSize, colour, quantity)
                                VALUES (@ReceiptID, @ProductID, @ClothingSize, @Colour, @Quantity)", con, tx))
                            {
                                cmd.Parameters.AddWithValue("@ReceiptID", receipt);
                                cmd.Parameters.AddWithValue("@ProductID", line.ProductID);
                                cmd.Parameters.AddWithValue("@ClothingSize", string.IsNullOrWhiteSpace(line.ClothingSize) ? (object)DBNull.Value : line.ClothingSize);
                                cmd.Parameters.AddWithValue("@Colour", string.IsNullOrWhiteSpace(line.Colour) ? (object)DBNull.Value : line.Colour);
                                cmd.Parameters.AddWithValue("@Quantity", line.Quantity);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        tx.Commit();
                        return new CheckoutResult { Success = true, Message = "Order placed successfully!", ReceiptNumber = receipt };
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        return Fail("Checkout failed: " + ex.Message);
                    }
                }
            }
        }

        private string GenerateNextReceiptNumber()
        {
            object value = Db.ExecuteScalar(@"
                SELECT MAX(CAST(SUBSTRING(receiptNum, 4, 3) AS INT))
                FROM Sale
                WHERE receiptNum LIKE 'R%'");

            int next = 1;
            if (value != null && value != DBNull.Value)
                next = Convert.ToInt32(value) + 1;

            return "R" + next.ToString("00000");
        }

        private CheckoutResult Fail(string message)
        {
            return new CheckoutResult { Success = false, Message = message };
        }
    }
}
