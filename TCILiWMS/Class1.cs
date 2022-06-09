using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace WCPM
{
    public class DBLayer
    {

        #region User Login

        public static DataTable spUserMasterSelect(string UserName)
        {

            try
            {
                string strProcedureName = "SP_TBLLOGINSELECTUSER";
                SqlParameter parUserName = CommonDL.CreateParameter("@LI_UserName", DbType.String, UserName);
                SqlParameter[] par = { parUserName };
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void InsertUser(string[] UserDtls, string UID)
        {
            try
            {
                string strProcedureName = "InsertUser";

                SqlParameter parUSER_ROLE = CommonDL.CreateParameter("@USER_ROLE", DbType.String, UserDtls[0]);
                SqlParameter parUSER_LOGIN_NAME = CommonDL.CreateParameter("@USER_LOGIN_NAME", DbType.String, UserDtls[1]);
                SqlParameter parUSER_LOGIN_PASSWORD = CommonDL.CreateParameter("@USER_LOGIN_PASSWORD", DbType.String, UserDtls[2]);
                SqlParameter parUSER_FIRST_NAME = CommonDL.CreateParameter("@USER_FIRST_NAME", DbType.String, UserDtls[3]);
                SqlParameter parUSER_EMAIL = CommonDL.CreateParameter("@USER_EMAIL", DbType.String, UserDtls[4]);
                SqlParameter parUSER_PHONE = CommonDL.CreateParameter("@USER_PHONE", DbType.String, UserDtls[5]);
                SqlParameter parCREATED_BY = CommonDL.CreateParameter("@CREATED_BY", DbType.String, UserDtls[6]);
                SqlParameter parIS_ACTIVE = CommonDL.CreateParameter("@ISACTIVE", DbType.String, UserDtls[7]);

                SqlParameter[] par = { parUSER_ROLE, parUSER_LOGIN_NAME, parUSER_LOGIN_PASSWORD, parUSER_FIRST_NAME, parUSER_EMAIL, parUSER_PHONE, parCREATED_BY, parIS_ACTIVE };

                SqlHelper.ExecuteNonQuery(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par);

            }
            catch (Exception ex)
            {
                //CommonDL.InsertExceptionDetails(ex, UserID);
                throw ex;
            }
        }

        public static void spManualUpdateSlipNo(string SLIPNO, string DIVISION, string TRANSACTION)
        {
            try
            {
                string strProcedureName = "spManualUpdateSlipNo";

                SqlParameter parSLIPNO = CommonDL.CreateParameter("@SLIPNO", DbType.String, SLIPNO);
                SqlParameter parDIVISION = CommonDL.CreateParameter("@DIVISION", DbType.String, DIVISION);
                SqlParameter parTRANSACTION = CommonDL.CreateParameter("@TRANSACTION", DbType.String, TRANSACTION);
                SqlParameter[] par = { parSLIPNO, parDIVISION, parTRANSACTION };
                SqlHelper.ExecuteNonQuery(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par);

            }
            catch (Exception ex)
            {
                //CommonDL.InsertExceptionDetails(ex, UserID);
                throw ex;
            }
        }

        public static void UpdateUser(string[] UserDtls, string UID)
        {
            try
            {
                string strProcedureName = "UpdateUser";

                SqlParameter parUSER_ROLE = CommonDL.CreateParameter("@USER_ROLE", DbType.String, UserDtls[0]);
                SqlParameter parUSER_LOGIN_NAME = CommonDL.CreateParameter("@USER_LOGIN_NAME", DbType.String, UserDtls[1]);
                SqlParameter parUSER_LOGIN_PASSWORD = CommonDL.CreateParameter("@USER_LOGIN_PASSWORD", DbType.String, UserDtls[2]);
                SqlParameter parUSER_FIRST_NAME = CommonDL.CreateParameter("@USER_FIRST_NAME", DbType.String, UserDtls[3]);
                SqlParameter parUSER_EMAIL = CommonDL.CreateParameter("@USER_EMAIL", DbType.String, UserDtls[4]);
                SqlParameter parUSER_PHONE = CommonDL.CreateParameter("@USER_PHONE", DbType.String, UserDtls[5]);
                SqlParameter parCREATED_BY = CommonDL.CreateParameter("@CREATED_BY", DbType.String, UserDtls[6]);
                SqlParameter parIS_ACTIVE = CommonDL.CreateParameter("@ISACTIVE", DbType.String, UserDtls[7]);

                SqlParameter[] par = { parUSER_ROLE, parUSER_LOGIN_NAME, parUSER_LOGIN_PASSWORD, parUSER_FIRST_NAME, parUSER_EMAIL, parUSER_PHONE, parCREATED_BY, parIS_ACTIVE };

                SqlHelper.ExecuteNonQuery(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par);

            }
            catch (Exception ex)
            {
                //CommonDL.InsertExceptionDetails(ex, UserID);
                throw ex;
            }
        }

        #endregion

        #region Hardware confifiguaration

        public static void spUpdateHardwareDetails(string LOCATION, string RFID1IP, int RFID1PORT, string RFID2IP, int RFID2PORT
            , string RFID3IP, int RFID3PORT, string PLCIP, int PCLPORT, string LEDDISPLAY1IP, int LEDDISPLAY1PORT, string LEDDISPLAY2IP
            , int LEDDISPLAY2PORT, string WEIGHBRIDGE1IP, int WEIGHBRIDGE1PORT, string WEIGHBRIDGE2IP, int WEIGHBRIDGE2PORT
            , string MAXWEIGHT, string MINIMUMWEIGHT, int AUTOSAVETIMER, int BOOMBARRIER)
        {
            try
            {
                string strProcedureName = "spUpdateHardwareDetails";

                SqlParameter parLOCATION = CommonDL.CreateParameter("@LOCATION", DbType.String, LOCATION);
                SqlParameter parRFID1IP = CommonDL.CreateParameter("@RFID1IP", DbType.String, RFID1IP);
                SqlParameter parRFID1PORT = CommonDL.CreateParameter("@RFID1PORT", DbType.Int32, RFID1PORT);
                SqlParameter parRFID2IP = CommonDL.CreateParameter("@RFID2IP", DbType.String, RFID2IP);
                SqlParameter parRFID2PORT = CommonDL.CreateParameter("@RFID2PORT", DbType.Int32, RFID2PORT);
                SqlParameter parRFID3IP = CommonDL.CreateParameter("@RFID3IP", DbType.String, RFID3IP);
                SqlParameter parRFID3PORT = CommonDL.CreateParameter("@RFID3PORT", DbType.Int32, RFID3PORT);
                SqlParameter parPLCIP = CommonDL.CreateParameter("@PLCIP", DbType.String, PLCIP);
                SqlParameter parPCLPORT = CommonDL.CreateParameter("@PCLPORT", DbType.Int32, PCLPORT);
                SqlParameter parLEDDISPLAY1IP = CommonDL.CreateParameter("@LEDDISPLAY1IP", DbType.String, LEDDISPLAY1IP);
                SqlParameter parLEDDISPLAY1PORT = CommonDL.CreateParameter("@LEDDISPLAY1PORT", DbType.Int32, LEDDISPLAY1PORT);
                SqlParameter parLEDDISPLAY2IP = CommonDL.CreateParameter("@LEDDISPLAY2IP", DbType.String, LEDDISPLAY2IP);
                SqlParameter parLEDDISPLAY2PORT = CommonDL.CreateParameter("@LEDDISPLAY2PORT", DbType.Int32, LEDDISPLAY2PORT);
                SqlParameter parWEIGHBRIDGE1IP = CommonDL.CreateParameter("@WEIGHBRIDGE1IP", DbType.String, WEIGHBRIDGE1IP);
                SqlParameter parWEIGHBRIDGE1PORT = CommonDL.CreateParameter("@WEIGHBRIDGE1PORT", DbType.Int32, WEIGHBRIDGE1PORT);
                SqlParameter parWEIGHBRIDGE2IP = CommonDL.CreateParameter("@WEIGHBRIDGE2IP", DbType.String, WEIGHBRIDGE2IP);
                SqlParameter parWEIGHBRIDGE2PORT = CommonDL.CreateParameter("@WEIGHBRIDGE2PORT", DbType.Int32, WEIGHBRIDGE2PORT);
                SqlParameter parMAXWEIGHT = CommonDL.CreateParameter("@MAXWEIGHT", DbType.String, MAXWEIGHT);
                SqlParameter parMINIMUMWEIGHT = CommonDL.CreateParameter("@MINIMUMWEIGHT", DbType.String, MINIMUMWEIGHT);
                SqlParameter parAUTOSAVETIMER = CommonDL.CreateParameter("@AUTOSAVETIMER", DbType.Int32, AUTOSAVETIMER);
                SqlParameter parBOOMBARRIER = CommonDL.CreateParameter("@BOOMBARRIER", DbType.Int32, BOOMBARRIER);
                SqlParameter[] par = { parLOCATION, parRFID1IP, parRFID1PORT, parRFID2IP, parRFID2PORT, parRFID3IP, parRFID3PORT, parPLCIP, parPCLPORT
                                    ,parLEDDISPLAY1IP,parLEDDISPLAY1PORT,parLEDDISPLAY2IP,parLEDDISPLAY2PORT,parWEIGHBRIDGE1IP,parWEIGHBRIDGE1PORT,
                                     parWEIGHBRIDGE2IP,parWEIGHBRIDGE2PORT,parMAXWEIGHT,parMINIMUMWEIGHT,parAUTOSAVETIMER,parBOOMBARRIER};
                SqlHelper.ExecuteNonQuery(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Reports

        public static DataTable spGetMaterilWiseMovment(object TRANSACTIONTYPE, object FROM, object TO)
        {

            try
            {
                string strProcedureName = "spGetMaterilWiseMovment";
                SqlParameter parTRANSACTIONTYPE = CommonDL.CreateParameter("@TRANSACTIONTYPE", DbType.String, TRANSACTIONTYPE);
                SqlParameter parFROM = CommonDL.CreateParameter("@FROM", DbType.String, FROM);
                SqlParameter parTO = CommonDL.CreateParameter("@TO", DbType.String, TO);
                SqlParameter[] par = { parTRANSACTIONTYPE, parFROM, parTO };
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spGetUserMaster()
        {
            try
            {
                string strProcedureName = "spGetUserMaster";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spTBLDEVISIONMASTERSelect()
        {
            try
            {
                string strProcedureName = "spTBLDEVISIONMASTERSelect";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spGetHardwareConfigurationDetails()
        {
            try
            {
                string strProcedureName = "spGetHardwareConfigurationDetails";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spGetMateriaMaster()
        {
            try
            {
                string strProcedureName = "spGetMateriaMaster";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spGetTATReport()
        {
            try
            {
                string strProcedureName = "spGetTATReport";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion

        #region Weighment

        public static DataTable spGetMaterialMovmentTypeWeb(object MATERIALREQUESTNO, object TRUCKID)
        {
            try
            {
                string strProcedureName = "spGetMaterialMovmentTypeWeb";
                SqlParameter parReq = CommonDL.CreateParameter("@MATERIALREQUESTNO", DbType.String, MATERIALREQUESTNO);
                SqlParameter parTruck = CommonDL.CreateParameter("@TRUCKID", DbType.String, TRUCKID);
                SqlParameter[] par = { parReq, parTruck };
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName, par).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spGetExceptionReport()
        {
            try
            {
                string strProcedureName = "spGetExceptionReport";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable spGetMaterialWeighmentWeb()
        {
            try
            {
                string strProcedureName = "spGetMaterialWeighmentWeb";
                return SqlHelper.ExecuteDataset(CommonDL.ConnectionString, CommandType.StoredProcedure, strProcedureName).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion
    }
}