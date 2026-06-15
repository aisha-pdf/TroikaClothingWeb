using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class ProductService
    {
        private readonly IProductRepository _productRepository;

        public ProductService() : this(new ProductRepository()) { }

        public ProductService(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public IList<Product> SearchProducts(ProductSearchCriteria criteria)
        {
            return PrepareProducts(_productRepository.GetActiveProducts(criteria));
        }

        public IList<Product> GetFeaturedProductsByCategory(string category, int limit)
        {
            return PrepareProducts(_productRepository.GetFeaturedProductsByCategory(category, limit));
        }

        public IList<string> GetCategories()
        {
            return _productRepository.GetCategories();
        }

        public Product GetProductById(string productId)
        {
            var product = _productRepository.GetActiveProductById(productId);
            return PrepareProduct(product);
        }

        public IList<Product> GetRelatedProducts(string category, string excludedProductId, int limit = 4)
        {
            return PrepareProducts(_productRepository.GetRelatedProducts(category, excludedProductId, limit));
        }

        public string CalculateEstimatedDelivery(IEnumerable<CartItem> cart)
        {
            int maxProductionDays = 0;

            foreach (var item in cart ?? Enumerable.Empty<CartItem>())
            {
                maxProductionDays = Math.Max(maxProductionDays, _productRepository.GetProductionTime(item.ProductID));
            }

            return string.Format("{0} days (Production + 1 week)", maxProductionDays + 7);
        }

        private IList<Product> PrepareProducts(IList<Product> products)
        {
            foreach (var product in products) PrepareProduct(product);
            return products;
        }

        private Product PrepareProduct(Product product)
        {
            if (product == null) return null;
            product.ImageUrl = BuildImageUrl(product.ProductID, product.HasPicture, product.ImageVersion);
            product.ImagePath = product.ImageUrl;
            product.DetailUrl = "~/Public Pages/ProductDetail.aspx?id=" + HttpUtility.UrlEncode(product.ProductID);
            return product;
        }

        private static string BuildImageUrl(string productId, bool hasPicture, long imageVersion)
        {
            if (!hasPicture) return "~/Images/Image_not_available.png";
            return "~/Public Pages/ProductImageHandler.ashx?id=" + HttpUtility.UrlEncode(productId) + "&v=" + imageVersion;
        }
    }
}
