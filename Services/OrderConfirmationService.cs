using System.Threading.Tasks;
using TroikaClothingWeb.Models;
using TroikaClothingWeb.Repositories;

namespace TroikaClothingWeb.Services
{
    public class OrderConfirmationService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly ReceiptEmailService _emailService;
        private readonly ReceiptHtmlBuilder _htmlBuilder;

        public OrderConfirmationService()
            : this(new OrderRepository(), new ReceiptEmailService(), new ReceiptHtmlBuilder())
        {
        }

        public OrderConfirmationService(IOrderRepository orderRepository, ReceiptEmailService emailService, ReceiptHtmlBuilder htmlBuilder)
        {
            _orderRepository = orderRepository;
            _emailService = emailService;
            _htmlBuilder = htmlBuilder;
        }

        public OrderReceipt GetReceipt(string receiptNumber)
        {
            return _orderRepository.GetReceipt(receiptNumber);
        }

        public Task SendReceiptEmailAsync(OrderReceipt receipt)
        {
            return _emailService.SendReceiptEmailAsync(receipt);
        }

        public string BuildDownloadHtml(OrderReceipt receipt)
        {
            return _htmlBuilder.BuildDownloadHtml(receipt);
        }
    }
}
