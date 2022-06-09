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
    public partial class frmNewHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                    DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                           new SqlParameter("@REELNUMBER",  txtSearch.Text),
                          
                        });

                    DataTable dt = ds.Tables[0];
                    lvLabelled.DataSource = dt;
                    lvLabelled.DataBind();
           

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
   

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                           new SqlParameter("@REELNUMBER",  txtSearch.Text),
                          
                        });
           
                DataTable dt = ds.Tables[0];
                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();
           
        }
    }
}