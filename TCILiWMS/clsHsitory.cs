using DragonFactory;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WCPM
{
      public static class clsHsitory
    {
          public  enum HistoryTransactionCodes
          {
              CREATE_USER,
              UPDATE_USER,
              CREATE_LOCATIONS,
              UPDATE_LOCATIONS,
              IMPORT_DATA,
              CREATE_PRODUCTION_ORDER,
              CREATE_CHILD_REELS,
              PRINT_REPRINT_CHILD_REELS,
              LOGIN,
              LOGOUT

          }
          public static void updateHistory(HistoryTransactionCodes TransactionCode,string remarks,
              string user,string lineNumber,string filename,string status)
          {
              MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
              MSSQLHelper.ExecSqlNonQuery("SP_TBLINSERTHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@TRANSACTIONCODE", TransactionCode.ToString()),
                            new SqlParameter("@REMARKS",   remarks),
                            new SqlParameter("@USER", user),
                            new SqlParameter("@LINENUMBER", lineNumber),
                            new SqlParameter("@FILENAME", filename),
                            new SqlParameter("@STATUS", status),
                          });

          }
    }
}