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


namespace WCPM
{
    public partial class frmAddQcMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
               
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
            
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {

            try
            {
               // Session["UserName"] = "ADMIN";

                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_TBLINSERTQCMASTERDATA", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            
                            new SqlParameter("@QCMASTER_MCNO",  txtMachineNumber.Text),
                            new SqlParameter("@QCMASTER_QCCODE", txtQcCode.Text),
                            new SqlParameter("@QCMASTER_DESCRIPTION",  txtQcDescription.Text)
               
                     
                                                                });

                string result = string.Empty;
                foreach (DataRow dtrow in ds.Tables[0].Rows)
                {
                    result = dtrow["RESULT"].ToString();

                }
                if (result == "1")
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Master QC Data Added Successfully')", true);

                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Duplicate Qc Code')", true);

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

            txtMachineNumber.Text = string.Empty;
            txtQcCode.Text = string.Empty;
            txtQcDescription.Text = string.Empty;


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