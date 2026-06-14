namespace TroikaClothingWeb.Models
{
    public class CustomerAddressUpdateRequest
    {
        public string Username { get; set; }
        public string StreetAddress { get; set; }
        public string Suburb { get; set; }
        public string PostCode { get; set; }

        public void TrimAll()
        {
            Username = (Username ?? string.Empty).Trim();
            StreetAddress = (StreetAddress ?? string.Empty).Trim();
            Suburb = (Suburb ?? string.Empty).Trim();
            PostCode = (PostCode ?? string.Empty).Trim();
        }
    }
}
