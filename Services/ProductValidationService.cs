using System.Globalization;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class ProductValidationService
    {
        public ProductValidationResult Validate(ProductSaveRequest request)
        {
            decimal price;
            int productionTime;
            var result = new ProductValidationResult
            {
                Success = true,
                Message = "Validation successful."
            };

            if (request == null)
            {
                result.AddError("Product", "Invalid product data.");
                result.Message = "Invalid product data.";
                return result;
            }

            if (string.IsNullOrWhiteSpace(request.ProductID))
                result.AddError("ProductID", "Product ID is required.");

            if (string.IsNullOrWhiteSpace(request.ProductName))
                result.AddError("ProductName", "Product name is required.");

            if (string.IsNullOrWhiteSpace(request.Description))
                result.AddError("Description", "Description is required.");

            if (string.IsNullOrWhiteSpace(request.Category))
                result.AddError("Category", "Category is required.");

            if (!int.TryParse(request.ProductionTimeText, out productionTime))
            {
                result.AddError("ProductionTime", "Production time must be a whole number.");
            }
            else if (productionTime < 0)
            {
                result.AddError("ProductionTime", "Production time cannot be negative.");
            }

            if (!decimal.TryParse(request.PriceText, NumberStyles.Any, CultureInfo.InvariantCulture, out price))
            {
                result.AddError("Price", "Enter a valid price, for example 199.99.");
            }
            else if (price <= 0)
            {
                result.AddError("Price", "Price must be greater than zero.");
            }

            if (string.IsNullOrWhiteSpace(request.Status))
                result.AddError("Status", "Status is required.");

            result.Price = price;
            result.ProductionTime = productionTime;

            if (!result.Success)
                result.Message = "Please correct the highlighted fields.";

            return result;
        }
    }
}
