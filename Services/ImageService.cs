using System;

namespace TroikaClothingWeb.Services
{
    public static class ImageService
    {
        public static string ToDataUrl(object imageObj, object nameObj, string defaultImageUrl)
        {
            if (imageObj == DBNull.Value || imageObj == null)
                return defaultImageUrl;

            byte[] imageBytes = imageObj as byte[];
            if (imageBytes == null || imageBytes.Length == 0)
                return defaultImageUrl;

            string mimeType = GetMimeType(nameObj == null || nameObj == DBNull.Value ? string.Empty : nameObj.ToString());
            return string.Format("data:{0};base64,{1}", mimeType, Convert.ToBase64String(imageBytes));
        }

        public static string GetMimeType(string fileName)
        {
            string lower = (fileName ?? string.Empty).ToLowerInvariant();
            if (lower.EndsWith(".png")) return "image/png";
            if (lower.EndsWith(".gif")) return "image/gif";
            if (lower.EndsWith(".bmp")) return "image/bmp";
            if (lower.EndsWith(".webp")) return "image/webp";
            return "image/jpeg";
        }
    }
}
