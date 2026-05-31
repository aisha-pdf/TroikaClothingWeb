using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace TroikaClothingWeb.Data
{
    /// <summary>
    /// Centralised database access helper.
    /// Keeps connection string access and common ADO.NET boilerplate out of Web Forms pages.
    /// </summary>
    public static class Db
    {
        public const string LoginConnectionName = "LoginConnectionString";
        public const string ReportsConnectionName = "ReportsConnectionString";

        public static SqlConnection CreateConnection(string connectionName = LoginConnectionName)
        {
            ConnectionStringSettings setting = ConfigurationManager.ConnectionStrings[connectionName];
            if (setting == null)
                throw new InvalidOperationException("Missing connection string: " + connectionName);

            return new SqlConnection(setting.ConnectionString);
        }

        public static DataTable ExecuteDataTable(string sql, Action<SqlParameterCollection> addParameters = null, string connectionName = LoginConnectionName)
        {
            using (SqlConnection con = CreateConnection(connectionName))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
            {
                addParameters?.Invoke(cmd.Parameters);
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
        }

        public static object ExecuteScalar(string sql, Action<SqlParameterCollection> addParameters = null, string connectionName = LoginConnectionName)
        {
            using (SqlConnection con = CreateConnection(connectionName))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                addParameters?.Invoke(cmd.Parameters);
                con.Open();
                return cmd.ExecuteScalar();
            }
        }

        public static int ExecuteNonQuery(string sql, Action<SqlParameterCollection> addParameters = null, string connectionName = LoginConnectionName)
        {
            using (SqlConnection con = CreateConnection(connectionName))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                addParameters?.Invoke(cmd.Parameters);
                con.Open();
                return cmd.ExecuteNonQuery();
            }
        }
    }
}
