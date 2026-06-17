using System.Collections.Generic;
using TroikaClothingWeb.Models;

namespace TroikaClothingWeb.Repositories
{
    public interface IWishlistRepository
    {
        bool Exists(string customerId, string productId);
        void Add(string customerId, string productId);
        void Remove(string customerId, string productId);
        IList<WishlistItem> GetByCustomer(string customerId);
        IList<string> GetProductIdsByCustomer(string customerId);
    }
}
