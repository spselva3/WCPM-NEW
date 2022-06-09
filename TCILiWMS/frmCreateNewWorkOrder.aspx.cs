using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using DragonFactory;
using System.IO;
using System.Net.Sockets;
using System.Net;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Drawing;


namespace WCPM
{
    public partial class frmCreateNewWorkOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (Session["ROLE"].ToString() == "ADMIN")
                {
                    btnsubmit.Enabled = true;
                    btnClear.Enabled = true;
                }
                else
                {
                    btnsubmit.Enabled = false;
                    btnClear.Enabled = false;
                }
               
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
            
        }
        [System.Web.Services.WebMethod]
        public static string ValidateGsm(string GSM, string lotnumber)
        {
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_VALIDATEGSM", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            
                            new SqlParameter("@LOTNUMBER",  lotnumber),
                            new SqlParameter("@GSM",  GSM),
                                                                      });
            DataTable dt = ds.Tables[0];
            string retval = string.Empty;
            foreach (DataRow dtrow in dt.Rows)
            {
                if (dtrow["RESULT"].ToString() == "1")
                {
                    retval = "true";
                }
                else
                {
                    retval = "false";
                }
            }

            return retval;
        }
        [System.Web.Script.Services.ScriptMethod()]
        [System.Web.Services.WebMethod]
        public static List<string> GetSearch(string prefixText)
        {

            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTQUALITYDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            
                            new SqlParameter("@QCDESCRIPTION",  prefixText),
                            new SqlParameter("@QCCODE",  ""),
                            new SqlParameter("@FLAG",  "QCDESC"),
                                                      new SqlParameter("@COLOR",  ""),

                           
                                            });


            List<string> Output = new List<string>();
            foreach (DataRow dtrow in ds.Tables[0].Rows)
            {
                Output.Add(dtrow["QCMASTER_DESCRIPTION"].ToString());
            }
            return Output;
        }
        [System.Web.Script.Services.ScriptMethod()]
        [System.Web.Services.WebMethod]
        public static List<string> GetQcCode(string prefixText)
        {

            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTQUALITYDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            
                            new SqlParameter("@QCDESCRIPTION", ""  ),
                            new SqlParameter("@QCCODE",  prefixText),
                            new SqlParameter("@FLAG",  "QCCODE"),
                            new SqlParameter("@COLOR",  ""),
                           
                                            });


            List<string> Output = new List<string>();
            foreach (DataRow dtrow in ds.Tables[0].Rows)
            {
                Output.Add(dtrow["QCMASTER_QCCODE"].ToString());
            }
            return Output;
        }
        [System.Web.Script.Services.ScriptMethod()]
        [System.Web.Services.WebMethod]
        public static List<string> GetColor(string prefixText)
        {

            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTQUALITYDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            
                            new SqlParameter("@QCDESCRIPTION", ""  ),
                            new SqlParameter("@QCCODE", "" ),
                            new SqlParameter("@FLAG",  "COLOR"),
                            new SqlParameter("@COLOR",  prefixText),
                           
                                            });


            List<string> Output = new List<string>();
            foreach (DataRow dtrow in ds.Tables[0].Rows)
            {
                Output.Add(dtrow["C_COLOR"].ToString());
            }
            return Output;
        }
       
        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            try
            {
                //   Session["UserName"] = "ADMIN";

                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_TBLINSERTPRODUCTIONORDERS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            
                            new SqlParameter("@PO_ROLLID",  txtLotPrefix.Text.ToUpper()+txtLOtNumber.Text),
                            new SqlParameter("@PO_QUALITY", txtQuality.Text),
                            new SqlParameter("@PO_GSM",  txtGSM.Text),
                                                      new SqlParameter("@PO_SIZE", txtSize.Text.ToUpper()),
                                                 new SqlParameter("@PO_REMARKS",txtRemarks.Text),
                            new SqlParameter("@PO_QUALITYCODE",txtQualitCode.Text),
                            new SqlParameter("@LOTPREFOX", txtLotPrefix.Text.ToUpper()),
                                             
                            new SqlParameter("@USER",  Session["UserName"]),
                            new SqlParameter("@COLORGRAIN",  txtcolorGrain.Text),
                            new SqlParameter("@ORDEREDQTY",  txtOrderedQty.Text)
                                            });

                string result = string.Empty;
                foreach (DataRow dtrow in ds.Tables[0].Rows)
                {
                    result = dtrow["RESULT"].ToString();

                }
                if (result == "1")
                {
                    lblMessage.Text = "Lot Number Creation Success.";
                    lblMessage.ForeColor = Color.Green;

                  //  Page.ClientScript.RegisterStartupScript(this.GetType(), "alert1", "alert('Lot Number Creation Success.')", true);
                }
                else
                {
                    lblMessage.Text = "Lot Number Creation Failed. Duplicate Record Found.";
                    lblMessage.ForeColor = Color.Red;

                  //  Page.ClientScript.RegisterStartupScript(this.GetType(), "alert2", "alert('Lot Number Creation Failed. Duplicate Record Found.')", true);


                }

            


                clearall();
            }
            catch (Exception EX)
            {

                string str = EX.Message;
            }


        }
        private void clearall()
        {


            txtLOtNumber.Text = string.Empty;
            txtQualitCode.Text = string.Empty;
            txtQuality.Text = string.Empty;
            txtcolorGrain.Text = string.Empty;
            txtGSM.Text = string.Empty;
            txtLotPrefix.Text = string.Empty;
            txtRemarks.Text = string.Empty;
            txtOrderedQty.Text = string.Empty;
            txtSize.Text = string.Empty;


        }
        protected void btnClear_Click(object sender, EventArgs e)
        {
            clearall();
        }


        protected void btnAddLotNumbers_Click(object sender, EventArgs e)
        {



        }
    }
}