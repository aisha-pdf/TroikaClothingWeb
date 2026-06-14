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

        // Admin/product-maintenance operations added during Phase 2 refactoring.
        IList<Product> GetProductsForAdmin(string statusFilter, string searchText, string sortValue);
        Product GetProductForAdmin(string productId);
        byte[] GetProductImage(string productId);
        string GetNextProductId();
        OperationResult InsertProduct(Product product, byte[] pictureBytes);
        OperationResult UpdateProduct(Product product);
        OperationResult UpdateProductImage(string productId, byte[] pictureBytes);
        OperationResult ToggleProductStatus(string productId);
    }
}
