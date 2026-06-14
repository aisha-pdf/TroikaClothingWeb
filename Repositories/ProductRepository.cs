using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using TroikaClothingWeb.Data;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public class ProductRepository : IProductRepository
    {
        public IList<Product> GetActiveProducts(ProductSearchCriteria criteria)
        {
            criteria = criteria ?? new ProductSearchCriteria();
            var products = new List<Product>();

            string sql = @"
                SELECT ProductID, ProductName, Description, Category, Price, ProductionTime, Status, Picture
                FROM Product
                WHERE Status = 'Active'";

            if (criteria.HasCategoryFilter)
                sql += " AND Category = @Category";

            if (criteria.HasSearchFilter)
                sql += " AND (ProductName LIKE @Search OR Description LIKE @Search OR Category LIKE @Search)";

            sql += " ORDER BY ProductName";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                if (criteria.HasCategoryFilter)
                    cmd.Parameters.AddWithValue("@Category", criteria.Category);

                if (criteria.HasSearchFilter)
                    cmd.Parameters.AddWithValue("@Search", "%" + criteria.SearchText.Trim() + "%");

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read()) products.Add(MapProduct(reader));
                }
            }

            return products;
        }

        public IList<Product> GetFeaturedProductsByCategory(string category, int limit)
        {
            var products = new List<Product>();

            const string sql = @"
                SELECT TOP (@Limit) ProductID, ProductName, Description, Category, Price, ProductionTime, Status, Picture
                FROM Product
                WHERE Status = 'Active' AND Category = @Category
                ORDER BY ProductName";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Limit", Math.Max(1, limit));
                cmd.Parameters.AddWithValue("@Category", category);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read()) products.Add(MapProduct(reader));
                }
            }

            return products;
        }

        public IList<string> GetCategories()
        {
            var categories = new List<string>();
            const string sql = @"
                SELECT DISTINCT Category
                FROM Product
                WHERE Category IS NOT NULL AND LTRIM(RTRIM(Category)) <> ''
                ORDER BY Category";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read()) categories.Add(reader["Category"].ToString());
                }
            }

            return categories;
        }

        public Product GetActiveProductById(string productId)
        {
            if (string.IsNullOrWhiteSpace(productId)) return null;

            const string sql = @"
                SELECT ProductID, ProductName, Description, Category, Price, ProductionTime, Status, Picture
                FROM Product
                WHERE ProductID = @ProductID AND Status = 'Active'";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ProductID", productId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    return reader.Read() ? MapProduct(reader) : null;
                }
            }
        }

        public IList<Product> GetRelatedProducts(string category, string excludedProductId, int limit = 4)
        {
            var products = new List<Product>();
            if (string.IsNullOrWhiteSpace(category) || string.IsNullOrWhiteSpace(excludedProductId)) return products;

            const string sql = @"
                SELECT TOP (@Limit) ProductID, ProductName, Description, Category, Price, ProductionTime, Status, Picture
                FROM Product
                WHERE Category = @Category AND ProductID <> @ProductID AND Status = 'Active'
                ORDER BY ProductName";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Limit", Math.Max(1, limit));
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@ProductID", excludedProductId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read()) products.Add(MapProduct(reader));
                }
            }

            return products;
        }

        public int GetProductionTime(string productId)
        {
            if (string.IsNullOrWhiteSpace(productId)) return 0;

            object value = Db.ExecuteScalar(
                "SELECT ProductionTime FROM Product WHERE ProductID = @ProductID",
                p => p.AddWithValue("@ProductID", productId));

            int days;
            return value != null && value != DBNull.Value && int.TryParse(value.ToString(), out days) ? days : 0;
        }


        public IList<Product> GetProductsForAdmin(string statusFilter, string searchText, string sortValue)
        {
            var products = new List<Product>();
            string safeSort = GetSafeAdminSort(sortValue);
            bool hasStatus = string.Equals(statusFilter, "Active", StringComparison.OrdinalIgnoreCase) ||
                             string.Equals(statusFilter, "Inactive", StringComparison.OrdinalIgnoreCase);
            bool hasSearch = !string.IsNullOrWhiteSpace(searchText);

            string sql = @"
                SELECT ProductID, ProductName, [Description], Category, Price, ProductionTime, Status, Picture
                FROM Product
                WHERE 1 = 1";

            if (hasStatus)
                sql += " AND Status = @Status";

            if (hasSearch)
                sql += " AND (ProductName LIKE @Q OR [Description] LIKE @Q OR Category LIKE @Q)";

            sql += " ORDER BY " + safeSort;

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                if (hasStatus)
                    cmd.Parameters.AddWithValue("@Status", statusFilter);

                if (hasSearch)
                    cmd.Parameters.AddWithValue("@Q", "%" + searchText.Trim() + "%");

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                        products.Add(MapProduct(reader));
                }
            }

            return products;
        }

        private static string GetSafeAdminSort(string sortValue)
        {
            switch ((sortValue ?? string.Empty).Trim())
            {
                case "ProductName ASC": return "ProductName ASC";
                case "ProductName DESC": return "ProductName DESC";
                case "Price ASC": return "Price ASC";
                case "Price DESC": return "Price DESC";
                case "ProductID DESC": return "ProductID DESC";
                case "ProductID ASC": return "ProductID ASC";
                default: return "ProductID ASC";
            }
        }

        public Product GetProductForAdmin(string productId)
        {
            if (string.IsNullOrWhiteSpace(productId)) return null;

            const string sql = @"
                SELECT ProductID, ProductName, [Description], Category, Price, ProductionTime, Status, Picture
                FROM Product
                WHERE ProductID = @ProductID";

            using (SqlConnection con = Db.CreateConnection())
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ProductID", productId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    return reader.Read() ? MapProduct(reader) : null;
                }
            }
        }

        public byte[] GetProductImage(string productId)
        {
            if (string.IsNullOrWhiteSpace(productId)) return null;

            object value = Db.ExecuteScalar(
                "SELECT Picture FROM Product WHERE ProductID = @ProductID",
                p => p.AddWithValue("@ProductID", productId));

            if (value == null || value == DBNull.Value)
                return null;

            return value as byte[];
        }

        public string GetNextProductId()
        {
            object value = Db.ExecuteScalar("SELECT TOP 1 ProductID FROM Product ORDER BY ProductID DESC");
            string lastId = value == null || value == DBNull.Value ? string.Empty : value.ToString();

            int numberPart = 0;
            if (lastId.StartsWith("P", StringComparison.OrdinalIgnoreCase) && lastId.Length >= 2)
                int.TryParse(lastId.Substring(1), out numberPart);

            numberPart++;
            return "P" + numberPart.ToString("D5");
        }

        public OperationResult InsertProduct(Product product, byte[] pictureBytes)
        {
            const string sql = @"
                INSERT INTO Product(ProductID, ProductName, [Description], Category, ProductionTime, Price, Picture, Status)
                VALUES(@ProductID, @ProductName, @Description, @Category, @ProductionTime, @Price, @Picture, @Status)";

            int rows = Db.ExecuteNonQuery(sql, p =>
            {
                p.AddWithValue("@ProductID", product.ProductID);
                p.AddWithValue("@ProductName", product.ProductName);
                p.AddWithValue("@Description", product.Description);
                p.AddWithValue("@Category", product.Category);
                p.AddWithValue("@ProductionTime", product.ProductionTime);

                SqlParameter priceParameter = p.Add("@Price", SqlDbType.Decimal);
                priceParameter.Precision = 18;
                priceParameter.Scale = 2;
                priceParameter.Value = product.Price;

                p.Add("@Picture", SqlDbType.Image).Value = pictureBytes == null || pictureBytes.Length == 0
                    ? (object)DBNull.Value
                    : pictureBytes;

                p.AddWithValue("@Status", product.Status);
            });

            return rows > 0
                ? OperationResult.Ok("Product added successfully with product ID: " + product.ProductID)
                : OperationResult.Fail("Product could not be added.");
        }

        public OperationResult UpdateProduct(Product product)
        {
            const string sql = @"
                UPDATE Product
                SET ProductName = @ProductName,
                    [Description] = @Description,
                    Category = @Category,
                    ProductionTime = @ProductionTime,
                    Price = @Price,
                    Status = @Status
                WHERE ProductID = @ProductID";

            int rows = Db.ExecuteNonQuery(sql, p =>
            {
                p.AddWithValue("@ProductID", product.ProductID);
                p.AddWithValue("@ProductName", product.ProductName);
                p.AddWithValue("@Description", product.Description);
                p.AddWithValue("@Category", product.Category);
                p.AddWithValue("@ProductionTime", product.ProductionTime);

                SqlParameter priceParameter = p.Add("@Price", SqlDbType.Decimal);
                priceParameter.Precision = 18;
                priceParameter.Scale = 2;
                priceParameter.Value = product.Price;

                p.AddWithValue("@Status", product.Status);
            });

            return rows > 0
                ? OperationResult.Ok("Product updated successfully.")
                : OperationResult.Fail("Product could not be found.");
        }

        public OperationResult UpdateProductImage(string productId, byte[] pictureBytes)
        {
            if (pictureBytes == null || pictureBytes.Length == 0)
                return OperationResult.Ok("No new image was uploaded.");

            const string sql = "UPDATE Product SET Picture = @Picture WHERE ProductID = @ProductID";

            int rows = Db.ExecuteNonQuery(sql, p =>
            {
                p.Add("@ProductID", SqlDbType.VarChar).Value = productId;
                p.Add("@Picture", SqlDbType.Image).Value = pictureBytes;
            });

            return rows > 0
                ? OperationResult.Ok("Product image updated successfully.")
                : OperationResult.Fail("Product image could not be updated because the product was not found.");
        }

        public OperationResult ToggleProductStatus(string productId)
        {
            const string sql = @"
                UPDATE Product
                SET Status = CASE WHEN Status = 'Active' THEN 'Inactive' ELSE 'Active' END
                WHERE ProductID = @ProductID";

            int rows = Db.ExecuteNonQuery(sql, p => p.AddWithValue("@ProductID", productId));

            return rows > 0
                ? OperationResult.Ok("Product status changed successfully.")
                : OperationResult.Fail("Product status could not be changed because the product was not found.");
        }

        private static Product MapProduct(SqlDataReader reader)
        {
            return new Product
            {
                ProductID = reader["ProductID"].ToString(),
                ProductName = reader["ProductName"].ToString(),
                Description = reader["Description"].ToString(),
                Category = reader["Category"].ToString(),
                Price = reader["Price"] == DBNull.Value ? 0m : Convert.ToDecimal(reader["Price"]),
                ProductionTime = reader["ProductionTime"] == DBNull.Value ? 0 : Convert.ToInt32(reader["ProductionTime"]),
                Status = reader["Status"].ToString(),
                HasPicture = reader["Picture"] != DBNull.Value
            };
        }
    }
}
