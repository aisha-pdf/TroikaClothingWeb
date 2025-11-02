using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;


namespace TroikaClothingWeb.Admin_Pages
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

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Picture FROM Product WHERE ProductID = @ProductID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ProductID", productId);

                conn.Open();
                object imgObj = cmd.ExecuteScalar();
                conn.Close();

                if (imgObj != DBNull.Value && imgObj != null)
                {
                    byte[] imgData = (byte[])imgObj;

                    context.Response.Cache.SetCacheability(HttpCacheability.Public);
                    context.Response.Cache.SetExpires(DateTime.Now.AddMinutes(30));
                    context.Response.ContentType = "image/jpeg";
                    context.Response.BinaryWrite(imgData);
                }
                else
                {
                    // Return a blank 1x1 pixel if no image exists
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

        public bool IsReusable => false;
    }
}