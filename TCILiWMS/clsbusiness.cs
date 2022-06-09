using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System.Configuration;
using System.IO;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;

namespace WCPM
{

    public class clsbusiness : OracleDBLayer
    {

        public clsbusiness()
        {
          //  ConnStr = ConfigurationManager.AppSettings["cmsCnstr"].ToString();
        }

        #region User Login and Insert
        public DataTable spUSERLOGIN(object P_USER_NAME)
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="P_USER_NAME", Value=P_USER_NAME, Direction= ParameterDirection.Input},
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spHHTUserLogin", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        public DataTable spWEBGetUsersAll()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spWEBGetUsersAll", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        //public void spWEBUpdateUser(string[] UserDtls, string UID)
        //{
        //    try
        //    {
        //        var listParas = new List<OracleParameter>()
        //        { 
        //            new OracleParameter() { ParameterName="P_FIRST_NAME", Value=UserDtls[0], Direction= ParameterDirection.Input},
        //            new OracleParameter() { ParameterName="P_LAST_NAME", Value=UserDtls[1], Direction= ParameterDirection.Input},
        //            new OracleParameter() { ParameterName="P_EMAIL_ID", Value=UserDtls[2], Direction= ParameterDirection.Input},
        //            new OracleParameter() { ParameterName="P_MOBILE_NUMBER", Value=UserDtls[3], Direction= ParameterDirection.Input},
        //            new OracleParameter() { ParameterName="P_USER_NAME", Value=UserDtls[4], Direction= ParameterDirection.Input},
        //            new OracleParameter() { ParameterName="P_PASSWORD", Value=UserDtls[5], Direction= ParameterDirection.Input},
        //            new OracleParameter() { ParameterName="P_USER_STATUS", Value=UserDtls[6], Direction= ParameterDirection.Input},
        //        };
        //        ExecNonQuery("spWEBUpdateUser", CommandType.StoredProcedure, listParas);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public void spWEBInsertUser(string[] UserDtls, string UID)
        {
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_FIRST_NAME", Value=UserDtls[0], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_LAST_NAME", Value=UserDtls[1], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_EMAIL_ID", Value=UserDtls[2], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_MOBILE_NUMBER", Value=UserDtls[3], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_ADDRESS", Value=UserDtls[4], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_USER_ROLE", Value=UserDtls[5], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_USER_NAME", Value=UserDtls[6], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_PASSWORD", Value=UserDtls[7], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_N_R_CARD", Value=UserDtls[8], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_CREATED_BY", Value=UserDtls[9], Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_PLANT", Value=UserDtls[10], Direction= ParameterDirection.Input},
                };
                ExecNonQuery("spWEBInsertUser", CommandType.StoredProcedure, listParas);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Common Event Log

        public void spInsertEventLog(object P_MODULE, object P_PROCEDURENAME, object P_CREATEDBY, object P_DESCRIPTION, object P_METHODNAME)
        {
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_MODULE", Value=P_MODULE, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_PROCEDURENAME", Value=P_PROCEDURENAME, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_CREATEDBY", Value=P_CREATEDBY, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_DESCRIPTION", Value=P_DESCRIPTION, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_METHODNAME", Value=P_METHODNAME, Direction= ParameterDirection.Input},
                };
                ExecNonQuery("spInsertEventLog", CommandType.StoredProcedure, listParas);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable spWEBGetEventLog()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spWEBGetEventLog", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        #endregion

        #region Inventory

        public DataTable spGetPlantLocation()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spGetPlantLocation", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        public DataTable spWEBGetInventoryCount()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spWEBGetInventoryCount", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        public DataTable GetTransactionData(object P_TRANSACTIONTYPE)
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_TRANSACTIONTYPE", Value=P_TRANSACTIONTYPE, Direction= ParameterDirection.Input},
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spWEBGetInventory", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        #endregion

        #region YardMap

        public DataTable spGetYardMap(object P_LOCATION)
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_LOCATION", Value=P_LOCATION, Direction= ParameterDirection.Input},
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spGetYardMap", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        #endregion

        #region Dispatch

        public DataTable spGetDispatchOrders()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spGetDispatchOrders", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        public DataTable spGetDispatchDetails(object P_DELIVERYNO)
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_DELIVERYNO", Value=P_DELIVERYNO, Direction= ParameterDirection.Input},
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spGetDispatchDetails", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        public DataTable spWEBGetStagingArea()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spWEBGetStagingArea", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        public DataTable spGetHostID()
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spGetHostID", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        #endregion


        #region Pick

        public void spWEBInsertWorkOrder(object P_ASSET_ID, object P_WORKORDER_TYPE, object P_SOURCE_ID, object P_UPDATE_BY, object P_UNIT_NAME
            , object P_PRIORITY, object P_DELIVERY_NO,object P_FORKLIFT1,object P_FORKLIFT2)
        {
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_ASSET_ID", Value=P_ASSET_ID, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_WORKORDER_TYPE", Value=P_WORKORDER_TYPE, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_SOURCE_ID", Value=P_SOURCE_ID, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_UPDATE_BY", Value=P_UPDATE_BY, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_UNIT_NAME", Value=P_UNIT_NAME, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_PRIORITY", Value=P_PRIORITY, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_DELIVERY_NO", Value=P_DELIVERY_NO, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_FORKLIFT1", Value=P_FORKLIFT1, Direction= ParameterDirection.Input},
                    new OracleParameter() { ParameterName="P_FORKLIFT2", Value=P_FORKLIFT2, Direction= ParameterDirection.Input},
                };
                //ExecNonQuery("spWEBInsertWorkOrder", CommandType.StoredProcedure, listParas);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable spWEBGetFLAAssetNo(object P_DELIVERYNO)
        {
            DataTable dt = new DataTable();
            try
            {
                var listParas = new List<OracleParameter>()
                { 
                    new OracleParameter() { ParameterName="P_DELIVERYNO", Value=P_DELIVERYNO, Direction= ParameterDirection.Input},
                   new OracleParameter() { ParameterName="OUTPARAM", Direction= ParameterDirection.Output},
                };
                return ExecDataSet("spWEBGetFLAAssetNo", CommandType.StoredProcedure, listParas).Tables[0];
            }
            catch (Exception ex)
            {
                return dt;
            }
        }

        #endregion

    }
}