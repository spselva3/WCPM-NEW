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
using System.Threading;
using System.Text;

namespace WCPM
{
    public partial class frmBalacedReels : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {

                  //  Loaddata();
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        //private void Loaddata()
        //{
        //    MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();


        //    DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTBALANCEREELREPORT", CommandType.StoredProcedure, new List<SqlParameter>()
        //    {

        //      new SqlParameter("@FROMDATE", DateTime.Now),
        //      new SqlParameter("@TODATE", DateTime.Now),
        //      new SqlParameter("@FLAG", "ALL"),

        //           });
        //    DataTable dt = ds.Tables[0];



        //    Session["DT"] = dt;
        //    Session["FileName"] = "Balance Reel Report";
        //    lvLabelled.DataSource = dt;
        //    lvLabelled.DataBind();
        //}
        protected void btnSearch_Click(object sender, EventArgs e)
        {

            if (txtFromDate.Text.Trim() == string.Empty) return;
            if (txtToDate.Text.Trim() == string.Empty) return;
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();


            try
            {
                DateTime fromDate = DateTime.ParseExact(txtFromDate.Text,
  "d-M-yyyy",
  System.Globalization.CultureInfo.InvariantCulture);

                DateTime toDate = DateTime.ParseExact(txtToDate.Text,
       "d-M-yyyy",
       System.Globalization.CultureInfo.InvariantCulture);
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTBALANCEREELREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FROMDATE", fromDate),
                   new SqlParameter("@TODATE", toDate),
                 

                        });
                DataTable dt = ds.Tables[0];



                //Session["DT"] = dt;
                //Session["FileName"] = "Balance Reel Report";
                //lvLabelled.DataSource = dt;
                //lvLabelled.DataBind();
            }
            catch (Exception)
            {
                txtFromDate.Text = string.Empty;
                txtToDate.Text = string.Empty;

            }
        }
        private void BindDataNew(DataTable dt)
        {


            try
            {

                StringBuilder strBuild = new StringBuilder();
                DateTime today = DateTime.Today;

                strBuild.Append("<Br/>");


                strBuild.Append("<table style='border-style: none; width:100%; background-color: #FFFFFF; border-color:black' border= '1'>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Lot No</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Quality</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Colour</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>GSM</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Size</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Balance Reels</span></td>");
                
                strBuild.Append("</tr>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; Height:20;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
               
                strBuild.Append("</tr>");

                ;




                foreach (DataRow dtrow in dt.Rows)
                {

                    strBuild.Append("<tr>");
                    strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_ROLLID"].ToString() + "</td>");
                    strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_QUALITY"].ToString() + "</td>");
                    strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_COLOURGRAIN"].ToString() + "</td>");
                    strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_GSM"].ToString() + "</td>");
                    strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                    strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["BALANCE REELS"].ToString() + "</td>");
                   
                    strBuild.Append("</tr>");

                }
                strBuild.Append("<Br/>");
                strBuild.Append("</table>");
                //DynamicDivPrint.InnerHtml = strBuild.ToString();
                //DynamicDivShow.InnerHtml = strBuild.ToString();


            }
            catch (Exception ex)
            {
                string str = ex.Message;
            }
        }
        protected void btnSearchReport_Click(object sender, ImageClickEventArgs e)
        {
            if (txtFromDate.Text.Trim() == string.Empty) return;
            if (txtToDate.Text.Trim() == string.Empty) return;
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();


            try
            {
                DateTime fromDate = DateTime.ParseExact(txtFromDate.Text,
  "d-M-yyyy",
  System.Globalization.CultureInfo.InvariantCulture);

                DateTime toDate = DateTime.ParseExact(txtToDate.Text,
       "d-M-yyyy",
       System.Globalization.CultureInfo.InvariantCulture);
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTBALANCEREELREPORT", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FROMDATE", fromDate),
                   new SqlParameter("@TODATE", toDate),
                   new SqlParameter("@FLAG", "NOTALL"),

                        });
                DataTable dt = ds.Tables[0];


              //  BindDataNew(dt);
                Session["DT"] = dt;
                Session["FileName"] = "Balance Reel Report";
                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();
            }
            catch (Exception)
            {
                txtFromDate.Text = string.Empty;
                txtToDate.Text = string.Empty;

            }

        }
    }
}