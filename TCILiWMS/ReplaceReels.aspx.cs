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
    public partial class ReplaceReels : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    GetDeletedReels();

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        private void GetDeletedReels()
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_GETDELETELIST", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

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
    }
}