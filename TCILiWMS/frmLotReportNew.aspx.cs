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
    public partial class frmLotReportNew : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {

                    Loaddata();
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        private void Loaddata()
        {
            //MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();


            //DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTBALANCEREELREPORT", CommandType.StoredProcedure, new List<SqlParameter>()
            //{

            //  new SqlParameter("@FROMDATE", DateTime.Now),
            //  new SqlParameter("@TODATE", DateTime.Now),
            //  new SqlParameter("@FLAG", "ALL"),

            //       });
            //DataTable dt = ds.Tables[0];



            //Session["DT"] = dt;
            //Session["FileName"] = "Balance Reel Report";
            //lvLabelled.DataSource = dt;
            //lvLabelled.DataBind();
        }
        StringBuilder strBuild = new StringBuilder();
        private void CreateHeader(DataTable dt)
        {

            string LotNumber = string.Empty;
            string Quality = string.Empty;
            string Color = string.Empty;
            string Gsm = string.Empty;

            foreach (DataRow dataRow in dt.Rows)
            {
                LotNumber = "Lot Number:  " + dataRow["PO_ROLLID"].ToString();
                Quality = "Quality:  " + dataRow["PO_QUALITY"].ToString();
                Color = "Color: " + dataRow["PO_COLOURGRAIN"].ToString();
                Gsm = "GSM: " + dataRow["PO_GSM"].ToString();
            }
            strBuild.Append("<table style='border-style: none; width:100%; background-color: #FFFFFF; border-color:black' border= '1'>");
            strBuild.Append("<tr>");
            strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>" + LotNumber + "</span></td>");
            strBuild.Append("</tr>");
            strBuild.Append("<tr>");
            strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>" + Quality + "</span></td>");
            strBuild.Append("</tr>");
            strBuild.Append("<tr>");
            strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>" + Color + "</span></td>");
            strBuild.Append("</tr>");
            strBuild.Append("<tr>");
            strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>" + Gsm + "</span></td>");
            strBuild.Append("</tr>");
            strBuild.Append("<tr>");
            strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center; Height:20;'>" + "" + "</td>");


            strBuild.Append("</tr>");

            ;
        }
        private void BindDataNewforConversion(DataTable dt)
        {


            try
            {




                strBuild.Append("<Br/>");


                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center; font-weight: bold;'>CONVERSION</td>");
             
                strBuild.Append("</tr>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Size(Cm)</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Ordered Qty</td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Date</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Nos</td>");
                strBuild.Append("</tr>");


                string currsize = string.Empty;
                string prevSize = string.Empty;

                bool isHeaderRequired = false;

                int totalReelstemp=0;
                int totalReels = 0; ;

                int ordQty = 0;
                int ordqtytemp = 0;


                foreach (DataRow dtrow in dt.Rows)
                {

                    currsize = dtrow["R_SIZE"].ToString();
                   

                    if (prevSize != currsize)
                    {
                        prevSize = currsize;

                        if (isHeaderRequired)
                        {
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>TOTAL</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>" + ordqtytemp + "</td>");

                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'></td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>" + totalReelstemp+"</td>");
                            strBuild.Append("</tr>");
                            totalReelstemp = 0;
                            ordqtytemp = 0;
                        }
                        isHeaderRequired = true;
                        strBuild.Append("<tr>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_ORDEREDQTY"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["CONVDATE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["total reels"].ToString() + "</td>");
                        strBuild.Append("</tr>");

                    }
                    else
                    {
                        strBuild.Append("<tr>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_ORDEREDQTY"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["CONVDATE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["total reels"].ToString() + "</td>");
                        strBuild.Append("</tr>");
                    }
                    totalReels += int.Parse(dtrow["total reels"].ToString());
                    totalReelstemp += int.Parse(dtrow["total reels"].ToString());
                    ordQty += int.Parse(dtrow["R_ORDEREDQTY"].ToString());
                    ordqtytemp = int.Parse(dtrow["R_ORDEREDQTY"].ToString());
                   // ordQty += ordqtytemp;

                }
                
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>TOTAL</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>" + ordqtytemp + "</td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>" + totalReelstemp + "</td>");
                strBuild.Append("</tr>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>G TOTAL</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>" + TotalOrd + "</td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>" + totalReels + "</td>");
                strBuild.Append("</tr>");
                //strBuild.Append("<Br/>");
                //strBuild.Append("</table>");
                //DynamicDivPrint.InnerHtml = strBuild.ToString();
                //DynamicDivShow.InnerHtml = strBuild.ToString();


            }
            catch (Exception ex)
            {
                string str = ex.Message;
            }
        }

        private void BindDataNewforFinishing(DataTable dt)
        {


            try
            {




           


                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'>FINISHING</td>");

                strBuild.Append("</tr>");


              
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Size(Cm)</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Date</td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Nos</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; font-weight: bold;'>Qty(Kgs)</td>");
                strBuild.Append("</tr>");

                string currsize = string.Empty;
                string prevSize = string.Empty;

                bool isHeaderRequired = false;

                int totalReelstemp = 0;
                int totalReels = 0; ;

                double tweight = 0;
                double tweighttemp = 0;


                foreach (DataRow dtrow in dt.Rows)
                {

                    currsize = dtrow["R_SIZE"].ToString();


                    if (prevSize != currsize)
                    {
                        prevSize = currsize;

                        if (isHeaderRequired)
                        {
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>TOTAL</td>");


                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'></td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalReelstemp + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + tweighttemp + "</td>");
                            strBuild.Append("</tr>");
                            totalReelstemp = 0;
                            tweighttemp = 0;
                        }
                        isHeaderRequired = true;
                        strBuild.Append("<tr>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                     
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["FINDATE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["total reels"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["tweight"].ToString() + "</td>");
                        strBuild.Append("</tr>");

                    }
                    else
                    {
                        
                        strBuild.Append("<tr>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");

                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["FINDATE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["total reels"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["tweight"].ToString() + "</td>");

                        strBuild.Append("</tr>");
                    }
                    totalReels += int.Parse(dtrow["total reels"].ToString());
                    totalReelstemp += int.Parse(dtrow["total reels"].ToString());
                    tweight += double.Parse(dtrow["tweight"].ToString());
                    tweighttemp += double.Parse(dtrow["tweight"].ToString());


                }
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>TOTAL</td>");
             

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalReelstemp + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + tweighttemp + "</td>");
                strBuild.Append("</tr>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>G TOTAL</td>");
            

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalReels + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + tweight + "</td>");
                strBuild.Append("</tr>");
                strBuild.Append("<Br/>");
                strBuild.Append("</table>");
                DynamicDivPrint.InnerHtml = strBuild.ToString();
                DynamicDivShow.InnerHtml = strBuild.ToString();


            }
            catch (Exception ex)
            {
                string str = ex.Message;
            }
        }
        double TotalOrd = 0;
        protected void btnSearchReport_Click(object sender, ImageClickEventArgs e)
        {
            if (txtLotNUmber.Text.Trim() == string.Empty) return;

            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();


            try
            {

                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOTWISEREPORTFINAL", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@LOTNUMBER", txtLotNUmber.Text.Trim()),

                        });

                DataTable dt = ds.Tables[0];
                DataTable dt2 = ds.Tables[1];
                DataTable dt3 = ds.Tables[2];
                DataTable dt4 = ds.Tables[3];
                foreach (DataRow dtrow in dt4.Rows)
                {
                    TotalOrd = double.Parse(dtrow["R_SIZE"].ToString());
                }

                    CreateHeader(dt);
                BindDataNewforConversion(dt2);
                BindDataNewforFinishing(dt3);
            }
            catch (Exception)
            {


            }

        }
    }
}