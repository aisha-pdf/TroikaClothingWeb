using System;
using System.Collections.Generic;
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

        private static Product MapProduct(SqlDataReader reader)
        {
            return new Product
            {
                ProductID = reader["ProductID"].ToString(),
                ProductName = reader["ProductName"].ToString(),
                Description = reader["Description"].ToString(),
                Category = reader["Category"].ToString(),
                Price = Convert.ToDecimal(reader["Price"]),
                ProductionTime = reader["ProductionTime"] == DBNull.Value ? 0 : Convert.ToInt32(reader["ProductionTime"]),
                Status = reader["Status"].ToString(),
                HasPicture = reader["Picture"] != DBNull.Value
            };
        }
    }
}
