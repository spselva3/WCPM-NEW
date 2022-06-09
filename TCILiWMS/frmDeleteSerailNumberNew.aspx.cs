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
    public partial class frmDeleteSerailNumberNew : System.Web.UI.Page
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
        private void GetLabelledData()
        {
            try
            {

                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();

                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTALLREELSERIALNUMBERS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@REELSER",txtReelSerialNumber.Text),


                        });
                DataTable dtUserDetails = ds.Tables[0];
                lvLabelled.DataSource = dtUserDetails;
                lvLabelled.DataBind();

            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }

        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            if (Session["ROLE"].ToString().ToUpper() != "ADMIN")
            {
                return;
            }
            ImageButton img = sender as ImageButton;
            string ReelSerialNUmber = img.ValidationGroup.ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_DELETESELECTEDREELSERIAL", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@REELSER",ReelSerialNUmber),


                        });
            CLSDB.UPDATEREELHISTORY(ReelSerialNUmber, "Delete Reel Serial Number", Session["UserName"].ToString(), Session["LineNumber"].ToString());
            GetLabelledData();
        }

        protected void btnSearch_Click(object sender, ImageClickEventArgs e)
        {
            GetLabelledData();
        }
    }
}