namespace TroikaClothingWeb.Models
{
    public class PasswordResetRequest
    {
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmPassword { get; set; }
    }
}
