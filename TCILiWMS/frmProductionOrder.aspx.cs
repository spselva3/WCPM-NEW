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

namespace WCPM
{
    public partial class frmProductionOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
       
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    GetProductionData();
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        private void GetLabelledData()
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTPOFORWEB", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@LINENUMNER",  Session["LineNUmber"]),
                          
                        });
                DataTable dtUserDetails = ds.Tables[0];
                lvLabelled.DataSource = ds.Tables[0];
                lvLabelled.DataBind();
              //  ViewState["exportexcel"] = ds.Tables[0];
                //  Session["LineNUmber"];
            }
            catch (Exception ex)
            {
               // dverrmsg.InnerHtml = ex.Message;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {

                DateTime fromDate = DateTime.ParseExact("09-10-2019",
                                             "d-M-yyyy",
                                             System.Globalization.CultureInfo.InvariantCulture); //09-10-2019

                try
                {
                    fromDate = DateTime.ParseExact(txtFromDate.Text,
                                                "d-M-yyyy",
                                                System.Globalization.CultureInfo.InvariantCulture);

                }
                catch (Exception)
                {


                }
                DateTime toDate = DateTime.ParseExact("09-10-2019",
                                                 "d-M-yyyy",
                                                 System.Globalization.CultureInfo.InvariantCulture);
                try
                {
                    toDate = DateTime.ParseExact(txtToDate.Text,
                                                "d-M-yyyy",
                                                System.Globalization.CultureInfo.InvariantCulture);
                }
                catch (Exception)
                {


                }


                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_GetProductionOrderReport_NewCH", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FLAG", "FIL"),
                   new SqlParameter("@LOTNUMBER", txtLotNUmber.Text),
                   new SqlParameter("@FROMDATWE", fromDate),
                   new SqlParameter("@TODATE", toDate),

                        });
                DataTable dt = ds.Tables[0];

                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();
            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }

        private void GetProductionData()
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_GetProductionOrderReport_NewCH", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FLAG", "ALL"),
                   new SqlParameter("@LOTNUMBER", ""),
                   new SqlParameter("@FROMDATWE",""),
                   new SqlParameter("@TODATE", ""),

                        });
                DataTable dt = ds.Tables[0];
                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();
            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }
    }
}