using DragonFactory;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WCPM
{
    public static  class CLSDB
    {

        public static void UPDATEREELHISTORY(string reelid, string action, string user, string line)
        {
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_INSERTREELHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@REELID", reelid),
                            new SqlParameter("@ACTION",action),
                            new SqlParameter("@USER", user),
                            new SqlParameter("@LINE", line)
                          
                                                    
                        }); 
        }
    }
}