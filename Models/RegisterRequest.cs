namespace TroikaClothingWeb.Models
{
    public class RegisterRequest
    {
        public string Name { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string StreetAddress { get; set; }
        public string Suburb { get; set; }
        public string PostCode { get; set; }

        public void TrimAll()
        {
            Name = (Name ?? string.Empty).Trim();
            Surname = (Surname ?? string.Empty).Trim();
            Email = (Email ?? string.Empty).Trim();
            PhoneNumber = (PhoneNumber ?? string.Empty).Trim();
            Username = (Username ?? string.Empty).Trim();
            Password = (Password ?? string.Empty).Trim();
            StreetAddress = (StreetAddress ?? string.Empty).Trim();
            Suburb = (Suburb ?? string.Empty).Trim();
            PostCode = (PostCode ?? string.Empty).Trim();
        }
    }
}
