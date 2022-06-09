using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DragonFactory;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Drawing;

namespace WCPM
{
    public partial class ReplaceChildReels : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    GetReelDetails();

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        private void GetReelDetails()
        {
            try
            {
                string SerialNo = Request.QueryString["Id"];

                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_GETREPLACEREELDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                {
                       new SqlParameter("@Serial", SerialNo),
                });
                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    foreach (DataRow dtrow in dt.Rows)
                    {
                        lblSerial.Text = SerialNo;
                        lblReel.Text = dtrow["REELID"].ToString();
                        lblWeight.Text = dtrow["R_WEIGHT"].ToString();
                        lblType.Text = dtrow["TYPE"].ToString();
                        lblMachine.Text = dtrow["MACHINENO"].ToString();
                        
                    }

                    DataTable dt1 = ds.Tables[1];
                    foreach (DataRow dtrow1 in dt1.Rows)
                    {
                        lblNewReel.Text = dtrow1["R_REELID"].ToString();
                        lblNewWeight.Text = dtrow1["R_WEIGHT"].ToString();
                        lblNewserial.Text = dtrow1["R_REELSNOFORPRINT"].ToString();
                        lblNewType.Text = dtrow1["R_TYPE"].ToString();
                        lblNewMachineNo.Text = dtrow1["R_MACHINENUMBER"].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }
        protected void btnReplace_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(lblNewserial.Text))
                {
                    lblMessage.Text = "Error ,Refresh and Come Again";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }


                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_UPDATENEWSERIALNO", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@OldSerial",  lblSerial.Text),

                            new SqlParameter("@NewSerial",  lblNewserial.Text),
                            new SqlParameter("@NewReel",  lblNewReel.Text),

                        });
                DataTable dt = ds.Tables[0];
                string RESULT = "";
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dt.Rows)
                    {
                        RESULT = dtrow["RESULT"].ToString();
                    }
                }
                if (RESULT == "1")
                {
                    lblMessage.Text = "Serial Number Updated";
                    lblMessage.ForeColor = Color.Green;
                    
                }
                else
                {
                    lblMessage.Text = "Not Updated";
                    lblMessage.ForeColor = Color.Red;
                }
                lblNewReel.Text = string.Empty;
                    
            }
            catch (Exception ex)
            {
                lblMessage.Text = ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void BtnClose_Click(object sender, EventArgs e)
        {

        }
    }
}