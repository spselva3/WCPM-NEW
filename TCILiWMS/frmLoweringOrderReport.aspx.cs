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
using System.Text;

namespace WCPM
{
    public partial class frmLoweringOrderReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        private void BindDataNew(DataTable dt)
        {

            try
            {
                decimal totalWeight = 0;
                decimal TotalTareWeight = 0;
                decimal TotalNetWeight = 0;
                int totalcount = 0;
                decimal PtotalWeight = 0;
                decimal PTotalTareWeight = 0;
                decimal PTotalNetWeight = 0;
                int Ptotalcount = 0;
                StringBuilder strBuild = new StringBuilder();
                int counter = 1;

                strBuild.Append("<Br/>");


                strBuild.Append("<table style='border-style: none; width:100%; background-color: #FFFFFF; border-color:black' border= '1'>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Lot No</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Quality</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Color</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>GSM</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Size</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Total Reels</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Gross Weight</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Tare Rate</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Tare Weight</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Net Weight</span></td>");
                strBuild.Append("</tr>");
                int header = 0;
                int footer = 0;
                bool isAsigned = false;
                ;

                string PrevQc = string.Empty;
                string CurrQc = string.Empty;
                bool isFirstTime = false;
                foreach (DataRow dtrow in dt.Rows)
                {

                  
                   
                    CurrQc = dtrow["PO_QUALITY"].ToString();
                   

                    if (CurrQc!=PrevQc)

                    {
                        PrevQc = CurrQc;
                        if (isFirstTime)
                        {
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='5' style=' text-align: center;font-weight: bold;'>TOTAL</td>");

                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalcount + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalWeight + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");



                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + TotalTareWeight + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + TotalNetWeight + "</td>");


                            strBuild.Append("</tr>");
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; Height:20;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");

                            strBuild.Append("</tr>");
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_ROLLID"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_QUALITY"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_COLOURGRAIN"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_GSM"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TOTAL REELS"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["GROSS WEIGHT"].ToString() + " </td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TARE RATE"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TARE WEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["NET WEIGHT"].ToString() + "</td>");
                            strBuild.Append("</tr>");
                            totalWeight = 0;
                            TotalTareWeight = 0;
                            totalcount = 0;
                            TotalNetWeight = 0;

                        }
                        else
                        {
                           
                          
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_ROLLID"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_QUALITY"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_COLOURGRAIN"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_GSM"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TOTAL REELS"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["GROSS WEIGHT"].ToString() + " </td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TARE RATE"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TARE WEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["NET WEIGHT"].ToString() + "</td>");
                            strBuild.Append("</tr>");
                        }
                        isFirstTime = true;
                    }
                    else
                    {
                        strBuild.Append("<tr>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_ROLLID"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_QUALITY"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_COLOURGRAIN"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["PO_GSM"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_SIZE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TOTAL REELS"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["GROSS WEIGHT"].ToString() + " </td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TARE RATE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["TARE WEIGHT"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["NET WEIGHT"].ToString() + "</td>");
                        strBuild.Append("</tr>");
                    }
                    
                  
                     
                    

                    counter++;
                    totalWeight += decimal.Parse(dtrow["GROSS WEIGHT"].ToString());
                    TotalTareWeight += decimal.Parse(dtrow["TARE WEIGHT"].ToString());
                    totalcount += int.Parse(dtrow["TOTAL REELS"].ToString());
                    PtotalWeight += decimal.Parse(dtrow["GROSS WEIGHT"].ToString());
                    PTotalTareWeight += decimal.Parse(dtrow["TARE WEIGHT"].ToString());
                    Ptotalcount += int.Parse(dtrow["TOTAL REELS"].ToString());
                    TotalNetWeight += decimal.Parse(dtrow["NET WEIGHT"].ToString());
                    PTotalNetWeight += decimal.Parse(dtrow["NET WEIGHT"].ToString());

                   
                }


                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='5' style=' text-align: center;font-weight: bold;'>TOTAL</td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalcount + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + totalWeight + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");



                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + TotalTareWeight + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + TotalNetWeight + "</td>");


                strBuild.Append("</tr>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center; Height:20;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");

                strBuild.Append("</tr>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='5' style=' text-align: center;font-weight: bold;'>GRAND TOTAL</td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + Ptotalcount + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + PtotalWeight + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");



                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + PTotalTareWeight + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'>" + PTotalNetWeight + "</td>");


                strBuild.Append("</tr>");

                strBuild.Append("<Br/>");






               
                strBuild.Append("</table>");
                DynamicDivPrint.InnerHtml = strBuild.ToString();
                DynamicDivShow.InnerHtml = strBuild.ToString();


            }
            catch (Exception ex)
            {

            }
        }
        protected void btnSearchReport_Click(object sender, ImageClickEventArgs e)
        {
            if (txtFromDate.Text.Trim() == "") return;
            if (txtToDate.Text.Trim() == "") return;
            if (ddlFromShift.SelectedIndex == 0) return;
            if (ddlToShift.SelectedIndex == 0) return;

           
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();

            DateTime fromDate = DateTime.ParseExact(txtFromDate.Text,
    "d-M-yyyy",
    System.Globalization.CultureInfo.InvariantCulture);

            DateTime toDate = DateTime.ParseExact(txtToDate.Text,
   "d-M-yyyy",
   System.Globalization.CultureInfo.InvariantCulture);

            if (ddlFromShift.SelectedValue == "C")
            {
                fromDate= fromDate.AddHours(23);
            }
            else if (ddlFromShift.SelectedValue == "A")
            {
                fromDate=fromDate.AddHours(7);
            }
            else if (ddlFromShift.SelectedValue == "B")
            {
       
                fromDate= fromDate.AddHours(15);
            }


            if (ddlToShift.SelectedValue == "C")
            {
                toDate = toDate.AddDays(1);
                toDate = toDate.AddHours(7);
            }
            else if (ddlToShift.SelectedValue == "A")
            {
                toDate= toDate.AddHours(15);
            }
            else if (ddlToShift.SelectedValue == "B")
            {
               
                toDate=toDate.AddHours(23);
            }

            if (txtToMachineNUmber.Text.Trim() == "")
            {
                txtToMachineNUmber.Text = txtFromMachineNUmber.Text;
            }
            int fromMachineNUmber = 0;
            int toMachineNUmber = 0;
            int.TryParse(txtFromMachineNUmber.Text, out fromMachineNUmber);
            int.TryParse(txtToMachineNUmber.Text, out toMachineNUmber);
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOWERINGORDERREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FROMDATE", fromDate),
                   new SqlParameter("@TODATE", toDate),
                   new SqlParameter("@FROMMACHINENUMBER", fromMachineNUmber),
                   new SqlParameter("@TOMACHINENUMBER", toMachineNUmber),

                        });
            DataTable dt = ds.Tables[0];
            BindDataNew(dt);


            //   Session["DT"] = dt;
            //   Session["FileName"] = "Lowering Order Report";
            //lvLabelled.DataSource = dt;
            //lvLabelled.DataBind();


        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (txtFromDate.Text.Trim() == "") return;
            if (txtToDate.Text.Trim() == "") return;
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();

            DateTime fromDate = DateTime.ParseExact(txtFromDate.Text,
    "d-M-yyyy",
    System.Globalization.CultureInfo.InvariantCulture);

            DateTime toDate = DateTime.ParseExact(txtToDate.Text,
   "d-M-yyyy",
   System.Globalization.CultureInfo.InvariantCulture);
            if (txtToMachineNUmber.Text.Trim() == "")
            {
                txtToMachineNUmber.Text = txtFromMachineNUmber.Text;
            }
            int fromMachineNUmber = 0;
            int toMachineNUmber = 0;
            int.TryParse(txtFromMachineNUmber.Text, out fromMachineNUmber);
            int.TryParse(txtToMachineNUmber.Text, out toMachineNUmber);
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOWERINGORDERREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FROMDATE", fromDate),
                   new SqlParameter("@TODATE", toDate),
                   new SqlParameter("@FROMMACHINENUMBER", fromMachineNUmber),
                   new SqlParameter("@TOMACHINENUMBER", toMachineNUmber),

                        });
            DataTable dt = ds.Tables[0];
            BindDataNew(dt);


            //   Session["DT"] = dt;
            //   Session["FileName"] = "Lowering Order Report";
            //lvLabelled.DataSource = dt;
            //lvLabelled.DataBind();


        }

    }
}