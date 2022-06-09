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
    public partial class frmQualityMaster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    GetLabelledData();

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
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTQCMASTERDATA", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                 
                          
                        });
                DataTable dt = ds.Tables[0];

                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();

                //  ViewState["exportexcel"] = ds.Tables[0];
                //  Session["LineNUmber"];
            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }
    }
}