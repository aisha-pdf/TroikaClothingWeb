using System;

namespace TroikaClothingWeb.Services
{
    public static class ImageService
    {
        private static readonly byte[] TransparentPixelPngBytes = new byte[]
        {
            137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,
            0,0,0,1,0,0,0,1,8,6,0,0,0,31,21,196,137,
            0,0,0,12,73,68,65,84,8,153,99,0,1,0,0,5,0,1,
            13,10,26,10,0,0,0,0,73,69,78,68,174,66,96,130
        };

        public static byte[] GetTransparentPixelPng()
        {
            return TransparentPixelPngBytes;
        }

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

        public static string GetMimeTypeFromBytes(byte[] imageBytes)
        {
            if (imageBytes == null || imageBytes.Length == 0)
                return "image/png";

            if (imageBytes.Length > 3 && imageBytes[0] == 255 && imageBytes[1] == 216 && imageBytes[2] == 255)
                return "image/jpeg";

            if (imageBytes.Length > 8 && imageBytes[0] == 137 && imageBytes[1] == 80 && imageBytes[2] == 78)
                return "image/png";

            if (imageBytes.Length > 5 && imageBytes[0] == 71 && imageBytes[1] == 73 && imageBytes[2] == 70)
                return "image/gif";

            if (imageBytes.Length > 11 && imageBytes[0] == 82 && imageBytes[1] == 73 && imageBytes[2] == 70 && imageBytes[8] == 87 && imageBytes[9] == 69 && imageBytes[10] == 66 && imageBytes[11] == 80)
                return "image/webp";

            return "application/octet-stream";
        }
    }
}
