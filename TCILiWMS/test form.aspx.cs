using DragonFactory;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WCPM
{
    public partial class test_form : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //DataSet ds1 = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELDETAILSFORDASHBOARD", CommandType.StoredProcedure, new List<SqlParameter>()
            //     {
                           
            //                new SqlParameter("@REELID",  "All"),
                          
            //            });
            //DataTable dt = ds1.Tables[0];
            if (Session["DT"] != null)
            {
                string fileNAme = Session["FileName"].ToString();
                DataTable dt = (DataTable)Session["DT"];
                clsExportoExcel.CreateExcelFile(dt, HttpContext.Current.Server.MapPath("~/Files/"+fileNAme+".xlsx"), "Report");
                HttpContext.Current.Response.ContentType = "application/pdf";
                string path = HttpContext.Current.Server.MapPath("~/Files/" + fileNAme + ".xlsx");
                HttpContext.Current.Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileNAme + ".xlsx");
                HttpContext.Current.Response.TransmitFile(HttpContext.Current.Server.MapPath("~/Files/" + fileNAme + ".xlsx"));
                HttpContext.Current.Response.End();
                File.Delete(HttpContext.Current.Server.MapPath("~/Files/" + fileNAme + ".xlsx"));
            }
          
           
        }
    }
}