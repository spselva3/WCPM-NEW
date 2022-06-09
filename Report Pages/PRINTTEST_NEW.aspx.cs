using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TESTWEB
{
    public partial class PRINTTEST_NEW : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DataSet ds = new DataSet();
                BindDataNew(ds);
            }
        }

        private void BindDataNew(DataSet ds)
        {

            try
            {
                DataSet dsDailyQualitySummary = new DataSet();
                StringBuilder strBuild = new StringBuilder();
                DateTime today = DateTime.Today;

                strBuild.Append("<h4>" + " REPORT.</h4>");
                strBuild.Append("<Br/>");


                strBuild.Append("<table style='border-style: none; width:100%; background-color: #FFFFFF; border-color:black' border= '1'>");

                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Lot No</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Size</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Reel No.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Excise No.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>No of Reel</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Gross Wt.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Tare Wt.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Net Wt.</span></td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;font-weight: bold;'><span class='auto-style9' style='width:200px;'>Total Net Wt.</span></td>");
                strBuild.Append("</tr>");

                strBuild.Append("<Br/>");



                //strBuild.Append("<table style='border-style: none; width:100%; background-color: #FFFFFF; border-color:black' border= '1'>");
                //strBuild.Append("<tr>");
                //strBuild.Append("<td class='auto-style1' colspan='3' style=' text-align: Left;'>" + "Quality:WESCO INDIGO CLASSIC" + "</td>");
                //strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: Left;'>" + "Colour: RED" + "</td>");
                //strBuild.Append("<td class='auto-style1' colspan='2' style=' text-align: Left;'>" + "GSM: 57" + "</td>");
                //strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'></td>");
                //strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'></td>");
                //strBuild.Append("</tr>");
                //strBuild.Append("</table>");


                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "3044874" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "88" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "RE2" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "G286062" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "484" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "1.2" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "482.8" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("</tr>");


                strBuild.Append("<tr>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "3044874" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "88" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "RE2" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "G286062" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "484" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "1.2" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "482.8" + "</td>");
                strBuild.Append("<td class='auto-style1' colspan='1' style=' text-align: center;'>" + "" + "</td>");
                strBuild.Append("</tr>");

                strBuild.Append("</table>");
                DynamicDivPrint.InnerHtml = strBuild.ToString();
            }
            catch (Exception ex)
            {

            }
        }

    }
}