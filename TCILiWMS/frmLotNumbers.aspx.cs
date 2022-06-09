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
    public partial class frmLotNumbers : System.Web.UI.Page
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
                    GetAllUsers();
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }

        #region GetAllUsers()

        private void GetAllUsers()
        {
            string ID = Request.QueryString["Id"];
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_LOTNUMBERS", CommandType.StoredProcedure, new List<SqlParameter>()
            {
                    new SqlParameter("@LOTNUMER", ID)
            }   );

            DataTable dtUserDetails = ds.Tables[0];
            lvUserDetails.DataSource = dtUserDetails;
            lvUserDetails.DataBind();
        }
        #endregion

        protected void dpinventory_PreRender(object sender, EventArgs e)
        {

        }

        #region lvUserDetails_ItemEditing(object sender, ListViewEditEventArgs e)

        #endregion
    }
}