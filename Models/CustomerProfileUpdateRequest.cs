namespace TroikaClothingWeb.Models
{
    public class CustomerProfileUpdateRequest
    {
        public string Username { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }

        public void TrimAll()
        {
            Username = (Username ?? string.Empty).Trim();
            Name = (Name ?? string.Empty).Trim();
            Surname = (Surname ?? string.Empty).Trim();
            Email = (Email ?? string.Empty).Trim();
            PhoneNumber = (PhoneNumber ?? string.Empty).Trim();
        }
    }
}
