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
    public partial class frmShiftWiseReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {

                //    MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();

                  
                //    DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTPACKEDANDBALANCEDREELS", CommandType.StoredProcedure, new List<SqlParameter>()
                // {
                           
                //   new SqlParameter("@FROMDATE", DateTime.Now),  
                //   new SqlParameter("@TODATE", DateTime.Now),  
                //   new SqlParameter("@FLAG", "ALL"),  
                          
                //        });
                //    DataTable dt = ds.Tables[0];



                //    Session["DT"] = dt;
                //    Session["FileName"] = "Packed Balance  Report";
                //    lvLabelled.DataSource = dt;
                //    lvLabelled.DataBind();

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();

                DateTime fromDate = DateTime.ParseExact(txtDate.Text,
        "d-M-yyyy",
        System.Globalization.CultureInfo.InvariantCulture);
                //string fromDate = txtDate.Text;


                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTDAILYREELSHEET", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                   new SqlParameter("@DATE", fromDate),
                   new SqlParameter("@SHIFT", ddlShift.SelectedValue.ToString()),  
                
                           
                        });
                DataTable dt = ds.Tables[0];



                Session["DT"] = dt;
                Session["FileName"] = "Daily Reel Sheet";
                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();

            }
            catch (Exception EX)
            {
                
              
            }
         

        }
        
    }
}