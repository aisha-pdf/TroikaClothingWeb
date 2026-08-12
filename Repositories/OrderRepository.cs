using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Data;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public class OrderRepository : IOrderRepository
    {
        public OrderReceipt GetReceipt(string receiptNumber)
        {
            if (string.IsNullOrWhiteSpace(receiptNumber))
                return null;

            OrderReceipt receipt = GetReceiptHeader(receiptNumber.Trim());

            if (receipt == null)
                return null;

            LoadReceiptItems(receipt);
            return receipt;
        }

        public string CreateOrder(string customerId, string paymentMethod, decimal paymentTotal, IList<CartItem> cart)
        {
            if (string.IsNullOrWhiteSpace(customerId))
                throw new ArgumentException("Customer ID is required.", "customerId");

            if (cart == null || cart.Count == 0)
                throw new ArgumentException("Cart cannot be empty.", "cart");

            // South African time, not the host's local time: the Azure worker runs in UTC,
            // which stamped every receipt two hours behind the customer's actual time.
            DateTime now = SaTime.Now;

            using (SqlConnection con = Db.CreateConnection())
            {
                con.Open();

                using (SqlTransaction tx = con.BeginTransaction(IsolationLevel.ReadCommitted))
                {
                    try
                    {
                        string receiptNumber = GenerateNextReceiptNumber(con, tx);

                        InsertSale(con, tx, receiptNumber, now, paymentMethod, paymentTotal, customerId);
                        InsertProductSoldLines(con, tx, receiptNumber, cart);

                        tx.Commit();
                        return receiptNumber;
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }


        public IList<SaleHistoryItem> GetSaleHistoryForCustomer(string customerId)
        {
            var sales = new List<SaleHistoryItem>();

            if (string.IsNullOrWhiteSpace(customerId))
                return sales;

            const string sql = @"
                SELECT receiptNum, paymentTotal, paymentMethod, paymentDate, salesStatus
                FROM Sale
                WHERE CustomerID = @CustomerID
                ORDER BY paymentDate DESC, receiptNum DESC";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        sales.Add(new SaleHistoryItem
                        {
                            ReceiptNum = Convert.ToString(reader["receiptNum"]),
                            PaymentTotal = reader["paymentTotal"] == DBNull.Value ? 0m : Convert.ToDecimal(reader["paymentTotal"]),
                            PaymentMethod = Convert.ToString(reader["paymentMethod"]),
                            PaymentDate = reader["paymentDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(reader["paymentDate"]),
                            SalesStatus = Convert.ToString(reader["salesStatus"])
                        });
                    }
                }
            }

            return sales;
        }

        public IList<SaleProductItem> GetProductsForReceipt(string receiptNumber)
        {
            var items = new List<SaleProductItem>();

            if (string.IsNullOrWhiteSpace(receiptNumber))
                return items;

            const string sql = @"
                SELECT Product.ProductID,
                       Product.ProductName,
                       Product.Description,
                       Product.Price,
                       Product.Category,
                       ProductSold.quantity,
                       ProductSold.clothingSize,
                       ProductSold.colour,
                       DATALENGTH(Product.Picture) AS ImageVersion
                FROM Product
                INNER JOIN ProductSold
                    ON Product.ProductID = ProductSold.ProductID
                WHERE ProductSold.receiptID = @ReceiptNumber
                ORDER BY Product.ProductName";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ReceiptNumber", receiptNumber);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        items.Add(new SaleProductItem
                        {
                            ProductID = Convert.ToString(reader["ProductID"]),
                            ProductName = Convert.ToString(reader["ProductName"]),
                            Description = Convert.ToString(reader["Description"]),
                            Price = reader["Price"] == DBNull.Value ? 0m : Convert.ToDecimal(reader["Price"]),
                            Category = Convert.ToString(reader["Category"]),
                            Quantity = reader["quantity"] == DBNull.Value ? 0 : Convert.ToInt32(reader["quantity"]),
                            ClothingSize = Convert.ToString(reader["clothingSize"]),
                            Colour = Convert.ToString(reader["colour"]),
                            ImageVersion = reader["ImageVersion"] == DBNull.Value ? 0L : Convert.ToInt64(reader["ImageVersion"])
                        });
                    }
                }
            }

            return items;
        }

        private OrderReceipt GetReceiptHeader(string receiptNumber)
        {
            const string sql = @"
                SELECT s.receiptNum, s.dateOfIssue, s.paymentMethod, s.paymentTotal, s.saleChannel, s.salesStatus,
                       c.customerID, c.email, c.streetAddress, c.suburb, c.postCode,
                       rc.name, rc.surname
                FROM Sale s
                LEFT JOIN Customer c ON c.customerID = s.CustomerID
                LEFT JOIN RetailCustomer rc ON rc.customerID = c.customerID
                WHERE s.receiptNum = @ReceiptNumber";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ReceiptNumber", receiptNumber);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                        return null;

                    return new OrderReceipt
                    {
                        ReceiptNumber = Convert.ToString(reader["receiptNum"]),
                        DateOfIssue = Convert.ToDateTime(reader["dateOfIssue"]),
                        PaymentMethod = Convert.ToString(reader["paymentMethod"]),
                        PaymentTotal = Convert.ToDecimal(reader["paymentTotal"]),
                        SaleChannel = Convert.ToString(reader["saleChannel"]),
                        SalesStatus = Convert.ToString(reader["salesStatus"]),
                        CustomerID = Convert.ToString(reader["customerID"]),
                        CustomerEmail = Convert.ToString(reader["email"]),
                        CustomerName = Convert.ToString(reader["name"]),
                        CustomerSurname = Convert.ToString(reader["surname"]),
                        StreetAddress = Convert.ToString(reader["streetAddress"]),
                        Suburb = Convert.ToString(reader["suburb"]),
                        PostCode = Convert.ToString(reader["postCode"])
                    };
                }
            }
        }

        private void LoadReceiptItems(OrderReceipt receipt)
        {
            const string sql = @"
                SELECT ps.ProductID, ps.clothingSize, ps.colour, ps.quantity,
                       p.ProductName, p.Price, p.ProductionTime, p.Picture
                FROM ProductSold ps
                JOIN Product p ON p.ProductID = ps.ProductID
                WHERE ps.receiptID = @ReceiptNumber";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ReceiptNumber", receipt.ReceiptNumber);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int quantity = Convert.ToInt32(reader["quantity"]);
                        decimal unitPrice = Convert.ToDecimal(reader["Price"]);

                        int productionTime = 0;
                        int.TryParse(Convert.ToString(reader["ProductionTime"]), out productionTime);

                        byte[] picture = reader["Picture"] == DBNull.Value ? null : (byte[])reader["Picture"];

                        receipt.Items.Add(new ReceiptLineItem
                        {
                            ProductID = Convert.ToString(reader["ProductID"]),
                            ProductName = Convert.ToString(reader["ProductName"]),
                            ClothingSize = Convert.ToString(reader["clothingSize"]),
                            Colour = Convert.ToString(reader["colour"]),
                            Quantity = quantity,
                            UnitPrice = unitPrice,
                            LineTotal = unitPrice * quantity,
                            ProductionTime = productionTime,
                            Picture = picture
                        });
                    }
                }
            }
        }

        private string GenerateNextReceiptNumber(SqlConnection con, SqlTransaction tx)
        {
            const string sql = @"
                SELECT MAX(CAST(SUBSTRING(receiptNum, 4, 3) AS INT))
                FROM Sale
                WHERE receiptNum LIKE 'R%'";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                object value = cmd.ExecuteScalar();

                int next = 1;
                if (value != null && value != DBNull.Value)
                    next = Convert.ToInt32(value) + 1;

                return "R" + next.ToString("00000");
            }
        }

        private void InsertSale(SqlConnection con, SqlTransaction tx, string receiptNumber, DateTime now, string paymentMethod, decimal paymentTotal, string customerId)
        {
            const string sql = @"
                INSERT INTO Sale
                (receiptNum, dateOfIssue, discount, paymentTotal, paymentMethod, paymentDate, saleChannel, salesStatus, CustomerID)
                VALUES (@ReceiptNum, @DateOfIssue, @Discount, @PaymentTotal, @PaymentMethod, @PaymentDate, @SaleChannel, @SalesStatus, @CustomerID)";

            using (SqlCommand cmd = new SqlCommand(sql, con, tx))
            {
                cmd.Parameters.AddWithValue("@ReceiptNum", receiptNumber);
                cmd.Parameters.AddWithValue("@DateOfIssue", now);
                cmd.Parameters.AddWithValue("@Discount", 0m);
                cmd.Parameters.AddWithValue("@PaymentTotal", paymentTotal);
                cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                cmd.Parameters.AddWithValue("@PaymentDate", now);
                cmd.Parameters.AddWithValue("@SaleChannel", "Website");
                cmd.Parameters.AddWithValue("@SalesStatus", "Placed");
                cmd.Parameters.AddWithValue("@CustomerID", customerId);
                cmd.ExecuteNonQuery();
            }
        }

        private void InsertProductSoldLines(SqlConnection con, SqlTransaction tx, string receiptNumber, IList<CartItem> cart)
        {
            const string sql = @"
                INSERT INTO ProductSold (receiptID, ProductID, clothingSize, colour, quantity)
                VALUES (@ReceiptID, @ProductID, @ClothingSize, @Colour, @Quantity)";

            foreach (var line in cart)
            {
                using (SqlCommand cmd = new SqlCommand(sql, con, tx))
                {
                    cmd.Parameters.AddWithValue("@ReceiptID", receiptNumber);
                    cmd.Parameters.AddWithValue("@ProductID", line.ProductID);
                    cmd.Parameters.AddWithValue("@ClothingSize", string.IsNullOrWhiteSpace(line.ClothingSize) ? (object)DBNull.Value : line.ClothingSize);
                    cmd.Parameters.AddWithValue("@Colour", string.IsNullOrWhiteSpace(line.Colour) ? (object)DBNull.Value : line.Colour);
                    cmd.Parameters.AddWithValue("@Quantity", line.Quantity);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
