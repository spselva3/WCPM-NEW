using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DragonFactory;
using DragonFactory.Utilities;
using System.Data.SqlClient;

namespace WCPM
{
    public partial class frmUpdateLineDetails : System.Web.UI.Page
    {

        string UserID = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                string id = Session["UPDATEID"].ToString();
                // SP_SELECTUSERFORUPDATE
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLINEFORUPDATE", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@ID", id),
                        
                          
                        });
                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    foreach (DataRow dtrow in dt.Rows)
                    {
                
                     //   txtLineId.Text = dtrow["ID"].ToString();
                        txtLineDescription.Text = dtrow["LOCATIONDESCRIPTION"].ToString();
                        txtLineName.Text = dtrow["LOCATIONNAME"].ToString();
                        txtLineNUmber.Text = dtrow["LOCATIONNUMBER"].ToString();
                    }
                }

            }
        }
        public void clearAll()
        {

            //txtLineId.Text = string.Empty;
            txtLineDescription.Text = string.Empty;
            txtLineName.Text = string.Empty;
          //  txtLineNUmber.Text = string.Empty;
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtLineDescription.Text == string.Empty) return;
                if (txtLineName.Text==string.Empty)return;
                string id = Session["UPDATEID"].ToString();
                string lineName = txtLineName.Text;
                string LineDescription = txtLineDescription.Text;
              
                try
                {
                    MSSQLHelper.ExecSqlNonQuery("SP_UPDATELINEDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@ID", id),
                        
                            new SqlParameter("@LOCATIONNAME", lineName),
                            new SqlParameter("@LOCATIONDESCRIPTION",  LineDescription),
                          
                        });
                }
                catch (Exception)
                {


                }

                clearAll();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Line Details Updated Successfully.')", true);
              //  clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.UPDATE_LOCATIONS, "NA", Session["UserName"].ToString(), Session["LineNUmber"].ToString());

            }
            catch (Exception ex)
            {
                string errotSter = "Error :" + ex.Message.ToString();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + errotSter + "')", true);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            clearAll();
        }


    }
}