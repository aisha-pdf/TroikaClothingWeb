using TroikaClothingWeb.Repositories;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Common
{
    public static class ServiceFactory
    {
        public static ProductService CreateProductService()
        {
            return new ProductService(new ProductRepository());
        }

        public static ProductManagementService CreateProductManagementService()
        {
            return new ProductManagementService(new ProductRepository(), new ProductValidationService());
        }

        public static UserService CreateUserService()
        {
            return new UserService(new UserRepository());
        }

        public static AdminUserService CreateAdminUserService()
        {
            return new AdminUserService(new UserRepository());
        }

        public static CartService CreateCartService()
        {
            return new CartService();
        }

        public static CheckoutService CreateCheckoutService()
        {
            return new CheckoutService(new UserRepository(), new OrderRepository());
        }

        public static CustomerProfileService CreateCustomerProfileService()
        {
            return new CustomerProfileService(new UserRepository(), new CustomerProfileValidationService());
        }

        public static OrderConfirmationService CreateOrderConfirmationService()
        {
            return new OrderConfirmationService(new OrderRepository(), new ReceiptEmailService(), new ReceiptHtmlBuilder());
        }

        public static SaleHistoryService CreateSaleHistoryService()
        {
            return new SaleHistoryService(new OrderRepository(), new UserRepository());
        }

        public static PasswordResetService CreatePasswordResetService()
        {
            return new PasswordResetService(new UserRepository());
        }

        public static ReportService CreateReportService()
        {
            return new ReportService(new ReportRepository());
        }

        public static WishlistService CreateWishlistService()
        {
            return new WishlistService(new WishlistRepository(), new UserRepository());
        }
    }
}
