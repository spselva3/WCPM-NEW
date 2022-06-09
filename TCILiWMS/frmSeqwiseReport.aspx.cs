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
using System.Collections;
using System.Text;

namespace WCPM
{
    public partial class frmSeqwiseReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {

                    //DataSet ds = new DataSet();
                    //BindDataNew(ds);
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        private void BindDataNew(DataTable dt)
        {
            string previousLot = string.Empty;
            string currentLot = string.Empty;
            decimal totalnetweight = 0;
            int reelCount = 0;

            try
            {
                DataSet dsDailyQualitySummary = new DataSet();
                StringBuilder strBuild = new StringBuilder();
                DateTime today = DateTime.Today;

                strBuild.Append("<Br/>");

                strBuild.Append("<h4>");
                strBuild.Append("From Date:  "+txtFromDate.Text+"            "+ "To Date:  " + txtToDate.Text);
                strBuild.Append("</h4>");
              
                strBuild.Append("<table style='border-style: none; width:100%; background-color: #FFFFFF; border-color:black' border= '0'>");
                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Lot No</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Size</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Reel No.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Excise No.</span></td>");

                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Gross Wt.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Tare Wt.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Net Wt.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>ReProcess</span></td>");

                strBuild.Append("</tr>");


                ;


                List<decimal> netVals = new List<decimal>();
                List<string> lotNumbers = new List<string>();
                bool isStartTime = false;
                bool isStartTime1 = false;

                string prevLotno = string.Empty;
                string curLotNum = string.Empty;
                string cursize = string.Empty;
                string prvsie = string.Empty;

                foreach (DataRow dtrow in dt.Rows)
                {







                    currentLot = dtrow["LOT NUMBER"].ToString();
                    cursize = dtrow["SIZE"].ToString();
                    if (currentLot== "2034881")
                    {
                        string str = "";
                    }
                    lotNumbers.Add(cursize);
                    if (currentLot != previousLot)
                    {

                       
                        if (isStartTime)
                        {
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: center;font-weight: bold;'>" + "TOTAL" + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='3' style=' text-align: center;font-weight: bold;'>" + reelCount + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'>" + totalnetweight + "</td>");
                            strBuild.Append("</tr>");
                        }
                        isStartTime = true
                            ;

                      
                        string Quality = "QUALITY: " + dtrow["QUALITY"].ToString();
                        string ColorGrain = "COLOUR: " + dtrow["COLOR"].ToString();
                        string Gsm = "GSM: " + dtrow["GSM"].ToString();
                        strBuild.Append("<tr>");
                        strBuild.Append("<td class='auto-style1' colspan='5' style=' text-align: center;font-weight: bold;'>" + Quality + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: center;font-weight: bold;'>" + ColorGrain + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='3' style=' text-align: center;font-weight: bold;'>" + Gsm + "</td>");
                        strBuild.Append("<tr>");


                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["LOT NUMBER"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["SIZE"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["RW NO"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["REEL SERAIL NUMBER"].ToString() + "</td>");
                        //strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["Footer"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["GROSS WEIGHT"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_TAREWEIGHT"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_NETWEIGHT"].ToString() + "</td>");
                        strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["REPROCESS"].ToString() + "</td>");

                        strBuild.Append("</tr>");




                        previousLot = currentLot;
                        prvsie = cursize;
                        totalnetweight = 0;
                        reelCount = 0;






                    }
                    else
                    {

                        if (cursize != prvsie)
                        {
                                                            strBuild.Append("<tr>");
                                strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: center;font-weight: bold;'>" + "TOTAL" + "</td>");
                                strBuild.Append("<td class='auto-style1' colspan='3' style=' text-align: center;font-weight: bold;'>" + reelCount + "</td>");
                                strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'>" + totalnetweight + "</td>");
                                strBuild.Append("</tr>");
                          
                            //string Quality = "QUALITY: " + dtrow["QUALITY"].ToString();
                            //string ColorGrain = "COLOUR: " + dtrow["COLOR"].ToString();
                            //string Gsm = "GSM: " + dtrow["GSM"].ToString();
                            //strBuild.Append("<tr>");
                            //strBuild.Append("<td class='auto-style1' colspan='5' style=' text-align: center;font-weight: bold;'>" + Quality + "</td>");
                            //strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: center;font-weight: bold;'>" + ColorGrain + "</td>");
                            //strBuild.Append("<td class='auto-style1' colspan='3' style=' text-align: center;font-weight: bold;'>" + Gsm + "</td>");
                            //strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["LOT NUMBER"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["SIZE"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["RW NO"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["REEL SERAIL NUMBER"].ToString() + "</td>");
                            //strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["Footer"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["GROSS WEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_TAREWEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_NETWEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["REPROCESS"].ToString() + "</td>");

                            strBuild.Append("</tr>");
                             prvsie= cursize;
                            reelCount = 0;
                              totalnetweight = 0;

                          

                        }
                        else
                        {
                            strBuild.Append("<tr>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["LOT NUMBER"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["SIZE"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["RW NO"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["REEL SERAIL NUMBER"].ToString() + "</td>");
                            //strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["Footer"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["GROSS WEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_TAREWEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["R_NETWEIGHT"].ToString() + "</td>");
                            strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + dtrow["REPROCESS"].ToString() + "</td>");


                            strBuild.Append("</tr>");
                        }
                        
                    }


                    totalnetweight += decimal.Parse(dtrow["R_NETWEIGHT"].ToString());
                    reelCount++;





                }

                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: center;font-weight: bold;'>" + "TOTAL" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='3' style=' text-align: center;font-weight: bold;'>" + reelCount + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='4' style=' text-align: center;font-weight: bold;'>" + totalnetweight + "</td>");

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
            if (txtToExise.Text.Trim() == "")
            {
                txtToExise.Text = txtFromExise.Text;
            }
            int fromMachineNUmber = 0;
            int toMachineNUmber = 0;
            int.TryParse(txtFromExise.Text, out fromMachineNUmber);
            int.TryParse(txtToExise.Text, out toMachineNUmber);
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTSEQWISEREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FROMDATE", fromDate),
                   new SqlParameter("@TODATE", toDate),
                   new SqlParameter("@FROMREELNUMBER", fromMachineNUmber),
                   new SqlParameter("@TOREELNUMBER", toMachineNUmber),

                        });
            DataTable dt = ds.Tables[0];


            BindDataNew(dt);
            //   Session["DT"] = dt;
            //   Session["FileName"] = "Sequence  Wise Report";
            //lvLabelled.DataSource = dt;
            //lvLabelled.DataBind();


        }
        public DataTable RemoveDuplicateRows(DataTable dTable, string colName)
        {
            Hashtable hTable = new Hashtable();
            ArrayList duplicateList = new ArrayList();

            //Add list of all the unique item value to hashtable, which stores combination of key, value pair.
            //And add duplicate item value in arraylist.
            foreach (DataRow drow in dTable.Rows)
            {
                if (hTable.Contains(drow[colName]))
                    duplicateList.Add(drow);
                else
                    hTable.Add(drow[colName], string.Empty);
            }

            //Removing a list of duplicate items from datatable.
            foreach (DataRow dRow in duplicateList)
                dTable.Rows.Remove(dRow);

            //Datatable which contains unique records will be return as output.
            return dTable;
        }

        protected void btnSearchReport_Click(object sender, ImageClickEventArgs e)
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
            if (txtToExise.Text.Trim() == "")
            {
                txtToExise.Text = txtFromExise.Text;
            }
            int fromMachineNUmber = 0;
            int toMachineNUmber = 0;
            int.TryParse(txtFromExise.Text, out fromMachineNUmber);
            int.TryParse(txtToExise.Text, out toMachineNUmber);
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTSEQWISEREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@FROMDATE", fromDate),
                   new SqlParameter("@TODATE", toDate),
                   new SqlParameter("@FROMREELNUMBER", fromMachineNUmber),
                   new SqlParameter("@TOREELNUMBER", toMachineNUmber),

                        });
            DataTable dt = ds.Tables[0];


            BindDataNew(dt);
            //   Session["DT"] = dt;
            //   Session["FileName"] = "Sequence  Wise Report";
            //lvLabelled.DataSource = dt;
            //lvLabelled.DataBind();

        }
    }
}