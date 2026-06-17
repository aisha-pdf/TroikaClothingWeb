using System;
using System.Collections.Generic;
using System.Data;
using TroikaClothingWeb.Data;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public class WishlistRepository : IWishlistRepository
    {
        public bool Exists(string customerId, string productId)
        {
            object value = Db.ExecuteScalar(
                "SELECT COUNT(1) FROM Wishlist WHERE customerID = @CustomerID AND ProductID = @ProductID",
                p =>
                {
                    p.AddWithValue("@CustomerID", customerId);
                    p.AddWithValue("@ProductID", productId);
                });

            return value != null && value != DBNull.Value && Convert.ToInt32(value) > 0;
        }

        public void Add(string customerId, string productId)
        {
            Db.ExecuteNonQuery(
                "INSERT INTO Wishlist (customerID, ProductID) VALUES (@CustomerID, @ProductID)",
                p =>
                {
                    p.AddWithValue("@CustomerID", customerId);
                    p.AddWithValue("@ProductID", productId);
                });
        }

        public void Remove(string customerId, string productId)
        {
            Db.ExecuteNonQuery(
                "DELETE FROM Wishlist WHERE customerID = @CustomerID AND ProductID = @ProductID",
                p =>
                {
                    p.AddWithValue("@CustomerID", customerId);
                    p.AddWithValue("@ProductID", productId);
                });
        }

        public IList<WishlistItem> GetByCustomer(string customerId)
        {
            var items = new List<WishlistItem>();

            const string sql = @"
                SELECT w.ProductID, w.dateAdded, p.ProductName, p.Category, p.Price, p.Status,
                       CAST(CASE WHEN p.Picture IS NULL THEN 0 ELSE 1 END AS bit) AS HasPicture,
                       DATALENGTH(p.Picture) AS ImageVersion
                FROM Wishlist w
                INNER JOIN Product p ON p.ProductID = w.ProductID
                WHERE w.customerID = @CustomerID
                ORDER BY w.dateAdded DESC, w.wishID DESC";

            DataTable table = Db.ExecuteDataTable(sql, p => p.AddWithValue("@CustomerID", customerId));

            foreach (DataRow row in table.Rows)
            {
                items.Add(new WishlistItem
                {
                    ProductID = row["ProductID"].ToString(),
                    ProductName = row["ProductName"].ToString(),
                    Category = row["Category"].ToString(),
                    Price = row["Price"] == DBNull.Value ? 0m : Convert.ToDecimal(row["Price"]),
                    Status = row["Status"].ToString(),
                    DateAdded = row["dateAdded"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(row["dateAdded"]),
                    HasPicture = row["HasPicture"] != DBNull.Value && Convert.ToBoolean(row["HasPicture"]),
                    ImageVersion = row["ImageVersion"] == DBNull.Value ? 0L : Convert.ToInt64(row["ImageVersion"])
                });
            }

            return items;
        }

        public IList<string> GetProductIdsByCustomer(string customerId)
        {
            var ids = new List<string>();

            DataTable table = Db.ExecuteDataTable(
                "SELECT ProductID FROM Wishlist WHERE customerID = @CustomerID",
                p => p.AddWithValue("@CustomerID", customerId));

            foreach (DataRow row in table.Rows)
                ids.Add(row["ProductID"].ToString());

            return ids;
        }
    }
}
