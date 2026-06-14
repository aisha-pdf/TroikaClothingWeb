using System;
using System.Web;
using TroikaClothingWeb.Common;
using TroikaClothingWeb.Services;

namespace TroikaClothingWeb.Admin_Pages
{
    public class ProductImageHandler : IHttpHandler
    {
        private readonly ProductManagementService _productManagementService = ServiceFactory.CreateProductManagementService();

        public void ProcessRequest(HttpContext context)
        {
            string productId = context.Request.QueryString["id"];

            if (string.IsNullOrWhiteSpace(productId))
            {
                WriteBlankImage(context);
                return;
            }

            byte[] imageBytes = _productManagementService.GetProductImage(productId);

            if (imageBytes == null || imageBytes.Length == 0)
            {
                WriteBlankImage(context);
                return;
            }

            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.Cache.SetExpires(DateTime.Now.AddMinutes(30));
            context.Response.ContentType = ImageService.GetMimeTypeFromBytes(imageBytes);
            context.Response.BinaryWrite(imageBytes);
        }

        private static void WriteBlankImage(HttpContext context)
        {
            context.Response.ContentType = "image/png";
            context.Response.BinaryWrite(ImageService.GetTransparentPixelPng());
        }

        public bool IsReusable
        {
            get { return false; }
        }
    }
}
