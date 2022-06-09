using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DragonFactory;
using System.Data.SqlClient;
using System.Configuration;
using DragonFactory.Utilities;


namespace WCPM
{
    public partial class frmReelHistory : System.Web.UI.Page
    {
        clsbusiness _cls = new clsbusiness();
        string UserID = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                UserID = Session["UserName"].ToString();
                if (!IsPostBack)
                {

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
          //  if (txtSearch.Text.Trim() == string.Empty) return;
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                           new SqlParameter("@REELNUMBER",  txtSearch.Text),
                          
                        });
            if (ds.Tables.Count > 0)
            {
                DataTable dt = ds.Tables[0];
                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();
            }
        }

        #region GetAllUsers()


        #endregion





        #region GetLocations()





        #endregion

        #region lvUserDetails_ItemCanceling(object sender, ListViewCancelEventArgs e)

        /// <summary>
        /// For Users Listview item cancelling
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


    }

}
        #endregion
