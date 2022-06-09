using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DragonFactory;

namespace WCPM
{
    public partial class frmDashboard_New : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           // Session["LineNUmber"] = 1;
            GetLabelledData();
            lbldatetime.Text = DateTime.Now.ToString();


        }

        private void GetLabelledData()
        {
            try
            {
                lblMonthTotalReels.Text = "00";
                lblMonthTotalWeight.Text = "00";
                lblDayTotalReels.Text = "00";
                lblDayTotalWeight.Text = "00";
                lblTotalReels.Text = "00";
                lblTotalWeight.Text = "00";
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELDETAILSFORDASHBOARD", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@REELID",  "ALL"),
                          
                        });
                DataTable dtUserDetails = ds.Tables[0];
                gvMaterialdetails.DataSource = ds.Tables[0];
                gvMaterialdetails.DataBind();
                //  ViewState["exportexcel"] = ds.Tables[0];
                //  Session["LineNUmber"];
              
                DataSet dsL = MSSQLHelper.ExecSqlDataSet("SP_SELECTFORDASHBOARD", CommandType.StoredProcedure, new List<SqlParameter>()
                {

                    
                 
                });
                if (dsL != null)
                {
                    if (dsL.Tables.Count > 0)
                    {
                        if (dsL.Tables[0].Rows.Count > 0)
                        {
                            lblMonthTotalReels.Text = dsL.Tables[0].Rows[0]["TOTALMONTHREELCOUNT"].ToString();
                        }
                        if (dsL.Tables[3].Rows.Count > 0)
                        {

                            lblMonthTotalWeight.Text = dsL.Tables[3].Rows[0]["MONTHLYWEIGHT"].ToString();
                        }
                        if (dsL.Tables[1].Rows.Count > 0)
                        {


                            lblDayTotalReels.Text = dsL.Tables[1].Rows[0]["TOTALDAYREELCOUNT"].ToString();
                        }
                        if (dsL.Tables[4].Rows.Count > 0)
                        {

                            lblDayTotalWeight.Text = dsL.Tables[4].Rows[0]["DAYWEIGHT"].ToString();
                        }
                        if (dsL.Tables[2].Rows.Count > 0)
                        {

                            lblTotalReels.Text = dsL.Tables[2].Rows[0]["TOTALCOUNT"].ToString();
                        }
                        if (dsL.Tables[5].Rows.Count > 0)
                        {

                            lblTotalWeight.Text = dsL.Tables[5].Rows[0]["TOTALWEIGHT"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }



        protected void gvMaterialdetails_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                gvMaterialdetails.PageIndex = e.NewPageIndex;
                GetLabelledData();
            }
            catch (Exception exe)
            {

            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELDETAILSFORDASHBOARD", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@REELID",  txtSearch.Text),
                          
                        });
            DataTable dtUserDetails = ds.Tables[0];
            gvMaterialdetails.DataSource = ds.Tables[0];
            gvMaterialdetails.DataBind();
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELDETAILSFORDASHBOARD", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@REELID",  "ALL"),
                          
                        });
            DataTable dtUserDetails = ds.Tables[0];
            gvMaterialdetails.DataSource = ds.Tables[0];
            gvMaterialdetails.DataBind();
          
        }

     
    }
}