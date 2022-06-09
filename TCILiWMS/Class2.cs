using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WCPM
{
    public class CommonDL
    {
        SqlConnection con = new SqlConnection();
        public static string ConnectionString
        {

            get { return ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString(); }
        }

        public static SqlParameter CreateParameter(string ParameterName, DbType type, object value)
        {
            SqlParameter par = new SqlParameter();
            par.ParameterName = ParameterName;
            par.DbType = type;
            par.Value = value;

            return par;
        }
    }
}