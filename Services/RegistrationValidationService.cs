using System.Text.RegularExpressions;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class RegistrationValidationService
    {
        public OperationResult Validate(RegisterRequest request)
        {
            if (request == null)
                return OperationResult.Fail("Registration details are missing.");

            request.TrimAll();

            if (string.IsNullOrWhiteSpace(request.Name) ||
                string.IsNullOrWhiteSpace(request.Surname) ||
                string.IsNullOrWhiteSpace(request.Email) ||
                string.IsNullOrWhiteSpace(request.PhoneNumber) ||
                string.IsNullOrWhiteSpace(request.Username) ||
                string.IsNullOrWhiteSpace(request.Password))
            {
                return OperationResult.Fail("All fields except address are required.");
            }

            if (!Regex.IsMatch(request.Name, @"^[A-Za-z\s'-]{2,50}$"))
                return OperationResult.Fail("Name must only contain letters and must be 2 to 50 characters.");

            if (!Regex.IsMatch(request.Surname, @"^[A-Za-z\s'-]{2,50}$"))
                return OperationResult.Fail("Surname must only contain letters and must be 2 to 50 characters.");

            if (!Regex.IsMatch(request.Email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
                return OperationResult.Fail("Invalid email address.");

            if (!Regex.IsMatch(request.PhoneNumber, @"^0[0-9]{9}$"))
                return OperationResult.Fail("Phone number must be 10 digits and start with 0.");

            if (!Regex.IsMatch(request.Username, @"^[A-Za-z0-9]{6}$"))
                return OperationResult.Fail("Username must be exactly 6 letters or numbers.");

            if (request.Password.Length < 6 || request.Password.Length > 8 ||
                !Regex.IsMatch(request.Password, @"[A-Z]") ||
                !Regex.IsMatch(request.Password, @"[a-z]") ||
                !Regex.IsMatch(request.Password, @"[0-9]") ||
                !Regex.IsMatch(request.Password, @"[!@#$%^&*(),.?""{}|<>]"))
            {
                return OperationResult.Fail("Password must be 6 to 8 characters long and include an uppercase letter, lowercase letter, number, and special character.");
            }

            bool anyAddressEntered =
                !string.IsNullOrWhiteSpace(request.StreetAddress) ||
                !string.IsNullOrWhiteSpace(request.Suburb) ||
                !string.IsNullOrWhiteSpace(request.PostCode);

            bool fullAddressEntered =
                !string.IsNullOrWhiteSpace(request.StreetAddress) &&
                !string.IsNullOrWhiteSpace(request.Suburb) &&
                !string.IsNullOrWhiteSpace(request.PostCode);

            if (anyAddressEntered && !fullAddressEntered)
                return OperationResult.Fail("If you add a delivery address, street address, suburb, and post code must all be completed.");

            if (!string.IsNullOrWhiteSpace(request.PostCode) && !Regex.IsMatch(request.PostCode, @"^[0-9]{4}$"))
                return OperationResult.Fail("Post code must be exactly 4 digits.");

            return OperationResult.Ok();
        }
    }
}
