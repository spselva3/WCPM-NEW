using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using Microsoft.VisualBasic;
using System.Linq;
using System;
using System.Collections;
using System.Xml.Linq;
using System.Configuration;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;


namespace WCPM
{
    public class OracleDBLayer
    {
        public string ConnStr
        {
            get;
            set;
        }

        #region ExecNonQuery
        public int ExecNonQuery(string strSQL, CommandType cmdType)
        {
            return ExecNonQuery(strSQL, cmdType, null);
        }
        public int ExecNonQuery(string strSQL, CommandType cmdType, List<OracleParameter> ListSqlParams)
        {
            OracleConnection Conn = new OracleConnection(ConnStr);
            OracleCommand cmd = new OracleCommand();
            try
            {
                getOraclePara(ListSqlParams, cmd);
                cmd.CommandType = cmdType;
                cmd.Connection = Conn;
                cmd.CommandTimeout = 120;
                Conn.Open();
                cmd.CommandText = strSQL;
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                }
                cmd.Dispose();
            }
            return 0;
        }
        #endregion

        #region ExecScalar
        public object ExecScalar(string strSQL, CommandType cmdtype, List<OracleParameter> ListSqlParams)
        {
            OracleConnection Conn = new OracleConnection(ConnStr);

            OracleCommand cmd = new OracleCommand();

            try
            {
                getOraclePara(ListSqlParams, cmd);
                cmd.CommandType = cmdtype;

                cmd.Connection = Conn;
                Conn.Open();
                cmd.CommandText = strSQL;
                cmd.CommandTimeout = 120;
                return cmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                }
                cmd.Dispose();
            }
            return null;
        }

        public object ExecScalar(string strSQL, CommandType cmdtype)
        {
            OracleConnection Conn = new OracleConnection(ConnStr);
            OracleCommand cmd = new OracleCommand();
            try
            {
                cmd.CommandType = cmdtype;
                cmd.Connection = Conn;
                Conn.Open();
                cmd.CommandText = strSQL;
                cmd.CommandTimeout = 120;
                return cmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                }
                cmd.Dispose();
            }
            return null;
        }
        #endregion

        #region ExecDataReader

        public static void getOraclePara_New(List<OracleParameter> parameters, OracleCommand cmd)
        {
            if (parameters != null)
            {
                cmd.Parameters.AddRange(parameters.ToArray());
            }
        }

        public static OracleDataReader ExecDataReader_New(string strSQL, CommandType cmdtype, List<OracleParameter> ListSqlParams)
        {
            OracleConnection Conn = new OracleConnection(ConfigurationManager.AppSettings["cmsCnstr"].ToString());
            OracleCommand cmd = new OracleCommand();
            try
            {
                getOraclePara_New(ListSqlParams, cmd);
                cmd.CommandType = cmdtype;
                cmd.Connection = Conn;
                Conn.Open();
                cmd.CommandText = strSQL;
                cmd.CommandTimeout = 120;
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                }
                cmd.Dispose();
            }
            return null;
        }



        public OracleDataReader ExecDataReader(string strSQL, CommandType cmdtype, List<OracleParameter> ListSqlParams)
        {
            OracleConnection Conn = new OracleConnection(ConnStr);
            OracleCommand cmd = new OracleCommand();
            try
            {
                getOraclePara(ListSqlParams, cmd);
                cmd.CommandType = cmdtype;
                cmd.Connection = Conn;
                Conn.Open();
                cmd.CommandText = strSQL;
                cmd.CommandTimeout = 120;
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                }
                cmd.Dispose();
            }
            return null;
        }
        public OracleDataReader ExecDataReader(string strSQL, CommandType cmdtype)
        {
            return ExecDataReader(strSQL, cmdtype, null);
        }
        #endregion

        #region ExecSqlDataSet
        public DataSet ExecDataSet(string strSQL, CommandType cmdtype)
        {
            return ExecDataSet(strSQL, cmdtype, null);
        }

        public DataSet ExecDataSet(string strSQL, CommandType cmdtype, List<OracleParameter> ListSqlParams)
        {
            DataSet ds = new DataSet("DataSet");
            ExecDataSet(ds, strSQL, cmdtype, ListSqlParams);
            return ds;
        }

        public void ExecDataSet(DataSet ds, string strSQL, CommandType cmdtype, List<OracleParameter> ListSqlParams)
        {
            OracleConnection Conn = new OracleConnection(ConnStr);
            OracleCommand cmd = new OracleCommand();
            OracleDataAdapter da = new OracleDataAdapter();
            try
            {
                getDatasetOraclePara(ListSqlParams, cmd);

                cmd.CommandType = cmdtype;
                cmd.Connection = Conn;
                cmd.CommandText = strSQL;
                cmd.CommandTimeout = 120;
                da.SelectCommand = cmd;
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                }
                cmd.Dispose();
            }
        }

        private void getOraclePara(List<OracleParameter> parameters, OracleCommand cmd)
        {
            if (parameters != null)
            {
                cmd.Parameters.AddRange(parameters.ToArray());
            }
        }

        private void getDatasetOraclePara(List<OracleParameter> parameters, OracleCommand cmd)
        {
            if (parameters != null)
            {
                OracleParameter sqlPara;
                int iListCount = System.Convert.ToInt32(parameters.Count);
                if (iListCount > 0)
                {
                    for (var iCount = 0; iCount <= iListCount - 1; iCount++)
                    {
                        if (iCount == iListCount - 1)
                        {
                            sqlPara = new OracleParameter();
                            string paramName = parameters[iCount].ToString();
                            cmd.Parameters.Add(paramName, OracleDbType.RefCursor).Direction = ParameterDirection.Output;
                        }
                        else
                        {
                            sqlPara = new OracleParameter();
                            sqlPara = parameters[iCount];
                            cmd.Parameters.Add(sqlPara);
                        }
                    }
                }

            }
        }
        #endregion

        #region ExecSqlRow
        public DataRow ExecuteSqlRow(string strSQL, CommandType cmdtype, List<OracleParameter> ListSqlParams)
        {
            OracleConnection Conn = new OracleConnection(ConnStr);
            OracleCommand cmd = new OracleCommand();
            OracleDataAdapter oDataAdapter = new OracleDataAdapter();
            DataTable oDataTable = new DataTable();
            try
            {
                getOraclePara(ListSqlParams, cmd);
                cmd.CommandType = cmdtype;
                cmd.Connection = Conn;
                Conn.Open();
                cmd.CommandText = strSQL;
                cmd.CommandTimeout = 120;
                oDataAdapter.Fill(oDataTable);
                cmd.Parameters.Clear();
                if (oDataTable.Rows.Count == 0)
                {
                    return null;
                }
                else
                {
                    DataRow oRow = oDataTable.Rows[0];
                    return oRow;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn.State != ConnectionState.Closed)
                {
                    Conn.Close();
                    Conn.Dispose();
                    oDataAdapter = null;
                }
            }
            return null;
        }
        #endregion

    }

}


