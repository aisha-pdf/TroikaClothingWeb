using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace TroikaClothingWeb.Public_Pages
{
    /// <summary>
    /// Summary description for ProductImageHandler
    /// </summary>
    public class ProductImageHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string productId = context.Request.QueryString["id"];
            if (string.IsNullOrEmpty(productId))
                return;

            string connStr = System.Configuration.ConfigurationManager
                                .ConnectionStrings["LoginConnectionString"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT Picture FROM Product WHERE ProductID = @ProductID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ProductID", productId);
                        conn.Open();
                        object imgObj = cmd.ExecuteScalar();
                        conn.Close();

                        if (imgObj != DBNull.Value && imgObj != null)
                        {
                            byte[] imgData = (byte[])imgObj;

                            // Detect the file type based on the header bytes
                            string contentType = GetImageMimeType(imgData);

                            context.Response.Cache.SetCacheability(HttpCacheability.Public);
                            context.Response.Cache.SetExpires(DateTime.Now.AddMinutes(30));

                            context.Response.ContentType = contentType;
                            context.Response.BinaryWrite(imgData);
                        }
                        else
                        {
                            // fallback 1x1 transparent PNG
                            context.Response.ContentType = "image/png";
                            context.Response.BinaryWrite(new byte[] {
                        137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,
                        0,0,0,1,0,0,0,1,8,6,0,0,0,31,21,196,137,
                        0,0,0,12,73,68,65,84,8,153,99,0,1,0,0,5,0,1,
                        13,10,26,10,0,0,0,0,73,69,78,68,174,66,96,130
                    });
                        }
                    }
                }
            }
            catch
            {
                context.Response.StatusCode = 500;
            }
        }

        // Helper method to detect image type
        private string GetImageMimeType(byte[] imageBytes)
        {
            if (imageBytes.Length > 3 && imageBytes[0] == 255 && imageBytes[1] == 216 && imageBytes[2] == 255)
                return "image/jpeg"; // JPG
            if (imageBytes.Length > 8 && imageBytes[0] == 137 && imageBytes[1] == 80 && imageBytes[2] == 78)
                return "image/png";  // PNG
            if (imageBytes.Length > 5 && imageBytes[0] == 71 && imageBytes[1] == 73 && imageBytes[2] == 70)
                return "image/gif";  // GIF
            return "application/octet-stream"; // Unknown
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}