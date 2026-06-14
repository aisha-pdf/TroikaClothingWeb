using System;
using System.Collections.Generic;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class ProductManagementService
    {
        private readonly IProductRepository _productRepository;
        private readonly ProductValidationService _validationService;

        private static readonly HashSet<string> AllowedSortOptions = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "ProductName ASC",
            "ProductName DESC",
            "Price ASC",
            "Price DESC",
            "ProductID DESC",
            "ProductID ASC"
        };

        public ProductManagementService() : this(new ProductRepository(), new ProductValidationService()) { }

        public ProductManagementService(IProductRepository productRepository, ProductValidationService validationService)
        {
            _productRepository = productRepository;
            _validationService = validationService;
        }

        public ProductListCommand BuildProductListCommand(string statusFilter, string searchText, string sortValue)
        {
            string safeSort = AllowedSortOptions.Contains(sortValue ?? string.Empty) ? sortValue : "ProductID ASC";
            bool hasStatus = statusFilter == "Active" || statusFilter == "Inactive";
            bool hasSearch = !string.IsNullOrWhiteSpace(searchText);

            string sql = "SELECT ProductID, ProductName, [Description], Category, ProductionTime, Price, Picture, Status FROM Product";
            sql += hasStatus ? " WHERE Status = @Status" : " WHERE 1=1";

            if (hasSearch)
                sql += " AND (ProductName LIKE @Q OR [Description] LIKE @Q)";

            sql += " ORDER BY " + safeSort;

            return new ProductListCommand
            {
                CommandText = sql,
                HasStatusParameter = hasStatus,
                Status = statusFilter,
                HasSearchParameter = hasSearch,
                SearchPattern = hasSearch ? "%" + searchText.Trim() + "%" : null
            };
        }


        public IList<Product> GetProductsForAdmin(string statusFilter, string searchText, string sortValue)
        {
            return _productRepository.GetProductsForAdmin(statusFilter, searchText, sortValue);
        }

        public Product GetProductForAdmin(string productId)
        {
            return _productRepository.GetProductForAdmin(productId);
        }

        public byte[] GetProductImage(string productId)
        {
            return _productRepository.GetProductImage(productId);
        }

        public string GetNextProductId()
        {
            return _productRepository.GetNextProductId();
        }

        public OperationResult ToggleProductStatus(string productId)
        {
            if (string.IsNullOrWhiteSpace(productId))
                return OperationResult.Fail("Product ID is required.");

            return _productRepository.ToggleProductStatus(productId);
        }

        public OperationResult AddProduct(ProductSaveRequest request)
        {
            ProductValidationResult validation = _validationService.Validate(request);
            if (!validation.Success)
                return validation;

            var product = CreateProductFromRequest(request, validation);
            return _productRepository.InsertProduct(product, request.PictureBytes);
        }

        public OperationResult UpdateProduct(ProductSaveRequest request)
        {
            ProductValidationResult validation = _validationService.Validate(request);
            if (!validation.Success)
                return validation;

            var product = CreateProductFromRequest(request, validation);
            OperationResult updateResult = _productRepository.UpdateProduct(product);

            if (!updateResult.Success)
                return updateResult;

            if (request.HasNewPicture)
                return _productRepository.UpdateProductImage(request.ProductID, request.PictureBytes);

            return OperationResult.Ok("Product updated successfully.");
        }

        private static Product CreateProductFromRequest(ProductSaveRequest request, ProductValidationResult validation)
        {
            return new Product
            {
                ProductID = (request.ProductID ?? string.Empty).Trim(),
                ProductName = (request.ProductName ?? string.Empty).Trim(),
                Description = (request.Description ?? string.Empty).Trim(),
                Category = (request.Category ?? string.Empty).Trim(),
                ProductionTime = validation.ProductionTime,
                Price = validation.Price,
                Status = (request.Status ?? string.Empty).Trim()
            };
        }
    }
}
