using System;
using System.Collections.Generic;
using System.Web;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class WishlistToggleResult : OperationResult
    {
        public bool Added { get; set; }
        public bool RequiresLogin { get; set; }
    }

    public class WishlistService
    {
        private readonly IWishlistRepository _wishlistRepository;
        private readonly IUserRepository _userRepository;

        public WishlistService() : this(new WishlistRepository(), new UserRepository()) { }

        public WishlistService(IWishlistRepository wishlistRepository, IUserRepository userRepository)
        {
            _wishlistRepository = wishlistRepository;
            _userRepository = userRepository;
        }

        /// <summary>Product IDs the customer has wishlisted, used to pre-fill the heart icons.</summary>
        public HashSet<string> GetWishlistedProductIds(string username)
        {
            var set = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            string customerId = ResolveCustomerId(username);
            if (string.IsNullOrWhiteSpace(customerId)) return set;

            foreach (string id in _wishlistRepository.GetProductIdsByCustomer(customerId))
                set.Add(id);

            return set;
        }

        public IList<WishlistItem> GetWishlistForUsername(string username)
        {
            string customerId = ResolveCustomerId(username);
            if (string.IsNullOrWhiteSpace(customerId)) return new List<WishlistItem>();

            IList<WishlistItem> items = _wishlistRepository.GetByCustomer(customerId);
            foreach (WishlistItem item in items) Prepare(item);
            return items;
        }

        /// <summary>Adds the product if absent, removes it if present.</summary>
        public WishlistToggleResult ToggleForUsername(string username, string productId)
        {
            if (string.IsNullOrWhiteSpace(productId))
                return new WishlistToggleResult { Success = false, Message = "No product was specified." };

            string customerId = ResolveCustomerId(username);
            if (string.IsNullOrWhiteSpace(customerId))
                return new WishlistToggleResult { Success = false, RequiresLogin = true, Message = "Please log in to use your wishlist." };

            if (_wishlistRepository.Exists(customerId, productId))
            {
                _wishlistRepository.Remove(customerId, productId);
                return new WishlistToggleResult { Success = true, Added = false, Message = "Removed from your wishlist." };
            }

            _wishlistRepository.Add(customerId, productId);
            return new WishlistToggleResult { Success = true, Added = true, Message = "Added to your wishlist." };
        }

        public OperationResult RemoveForUsername(string username, string productId)
        {
            if (string.IsNullOrWhiteSpace(productId))
                return OperationResult.Fail("No product was specified.");

            string customerId = ResolveCustomerId(username);
            if (string.IsNullOrWhiteSpace(customerId))
                return OperationResult.Fail("Please log in to use your wishlist.");

            _wishlistRepository.Remove(customerId, productId);
            return OperationResult.Ok("Removed from your wishlist.");
        }

        private string ResolveCustomerId(string username)
        {
            if (string.IsNullOrWhiteSpace(username)) return null;
            return _userRepository.GetCustomerIdByUsername(username);
        }

        // Mirrors ProductService image/detail URL building so the wishlist links resolve
        // through the same product image handler and detail page.
        private static void Prepare(WishlistItem item)
        {
            if (item == null) return;

            item.ImageUrl = item.HasPicture
                ? "~/Public Pages/ProductImageHandler.ashx?id=" + HttpUtility.UrlEncode(item.ProductID) + "&v=" + item.ImageVersion
                : "~/Images/Image_not_available.png";

            item.DetailUrl = "~/Public Pages/ProductDetail.aspx?id=" + HttpUtility.UrlEncode(item.ProductID);
        }
    }
}
