using System.Collections.Generic;

namespace TroikaClothingWeb.Models
{
    public class ProductValidationResult : OperationResult
    {
        public Dictionary<string, string> FieldErrors { get; private set; }
        public decimal Price { get; set; }
        public int ProductionTime { get; set; }

        public ProductValidationResult()
        {
            FieldErrors = new Dictionary<string, string>();
        }

        public void AddError(string fieldName, string message)
        {
            Success = false;
            FieldErrors[fieldName] = message;
        }

        public static ProductValidationResult Valid(decimal price, int productionTime)
        {
            return new ProductValidationResult
            {
                Success = true,
                Message = "Validation successful.",
                Price = price,
                ProductionTime = productionTime
            };
        }
    }
}
