using System.Text.RegularExpressions;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Services
{
    public class CustomerProfileValidationService
    {
        private static readonly Regex NameRegex = new Regex(@"^[A-Za-z\s'-]{2,50}$", RegexOptions.Compiled);
        private static readonly Regex EmailRegex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$", RegexOptions.Compiled);
        private static readonly Regex PhoneRegex = new Regex(@"^0[0-9]{9}$", RegexOptions.Compiled);
        private static readonly Regex PostCodeRegex = new Regex(@"^[0-9]{4}$", RegexOptions.Compiled);

        public OperationResult ValidateProfile(CustomerProfileUpdateRequest request)
        {
            if (request == null)
                return OperationResult.Fail("We could not read your account details. Please refresh the page and try again.");

            request.TrimAll();

            if (string.IsNullOrWhiteSpace(request.Username))
                return OperationResult.Fail("Your login session could not be identified. Please log out, log in again, and retry.");

            if (!NameRegex.IsMatch(request.Name))
                return OperationResult.Fail("First name must be 2 to 50 characters and may only contain letters, spaces, hyphens, or apostrophes.");

            if (!NameRegex.IsMatch(request.Surname))
                return OperationResult.Fail("Surname must be 2 to 50 characters and may only contain letters, spaces, hyphens, or apostrophes.");

            if (!EmailRegex.IsMatch(request.Email))
                return OperationResult.Fail("Please enter a valid email address, for example name@example.com.");

            if (!PhoneRegex.IsMatch(request.PhoneNumber))
                return OperationResult.Fail("Phone number must be 10 digits and start with 0, for example 0821234567.");

            return OperationResult.Ok();
        }

        public OperationResult ValidateAddress(CustomerAddressUpdateRequest request)
        {
            if (request == null)
                return OperationResult.Fail("We could not read your address details. Please refresh the page and try again.");

            request.TrimAll();

            if (string.IsNullOrWhiteSpace(request.Username))
                return OperationResult.Fail("Your login session could not be identified. Please log out, log in again, and retry.");

            if (string.IsNullOrWhiteSpace(request.StreetAddress))
                return OperationResult.Fail("Please enter your street address.");

            if (request.StreetAddress.Length > 100)
                return OperationResult.Fail("Street address cannot be longer than 100 characters. Please shorten it and try again.");

            if (string.IsNullOrWhiteSpace(request.Suburb))
                return OperationResult.Fail("Please enter your suburb.");

            if (request.Suburb.Length > 50)
                return OperationResult.Fail("Suburb cannot be longer than 50 characters. Please shorten it and try again.");

            if (!PostCodeRegex.IsMatch(request.PostCode))
                return OperationResult.Fail("Postal code must be exactly 4 digits, for example 4001.");

            return OperationResult.Ok();
        }
    }
}
