using System.Collections.Generic;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public interface IProductRepository
    {
        IList<Product> GetActiveProducts(ProductSearchCriteria criteria);
        IList<Product> GetFeaturedProductsByCategory(string category, int limit);
        IList<string> GetCategories();
        Product GetActiveProductById(string productId);
        IList<Product> GetRelatedProducts(string category, string excludedProductId, int limit = 4);
        int GetProductionTime(string productId);
    }
}
