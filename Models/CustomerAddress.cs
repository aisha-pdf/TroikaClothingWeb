namespace TroikaClothingWeb.Models
{
    public class CustomerAddress
    {
        public string CustomerID { get; set; }
        public string StreetAddress { get; set; }
        public string Suburb { get; set; }
        public string PostCode { get; set; }

        public bool IsComplete
        {
            get
            {
                return !string.IsNullOrWhiteSpace(StreetAddress)
                    && !string.IsNullOrWhiteSpace(Suburb)
                    && !string.IsNullOrWhiteSpace(PostCode);
            }
        }

        public string DisplayText
        {
            get { return string.Format("{0}, {1}, {2}", StreetAddress, Suburb, PostCode); }
        }
    }
}
