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
    public partial class frmCreateNewLines : System.Web.UI.Page
    {
        clsbusiness _cls = new clsbusiness();
        string UserID = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        public void clearAll()
        {
            txtLineDescription.Text = string.Empty;
            txtLineName.Text = string.Empty;
            txtLineNumber.Text = string.Empty;

        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string lineNumber = txtLineNumber.Text;
                string lineName = txtLineName.Text;
                string lineDescription = txtLineDescription.Text;
         
                try
                {
                  DataSet ds=  MSSQLHelper.ExecSqlDataSet("SP_TBLINSERTLINEDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@LINENUMBER", lineNumber),
                            new SqlParameter("@LINENAME",   lineName),
                            new SqlParameter("@LINEDESCRIPTION", lineDescription),
                          });

                  if (ds.Tables.Count > 0)
                  {
                      DataTable dt = ds.Tables[0];
                      foreach (DataRow dtrow in dt.Rows)
                      {
                          if (dtrow["RESULT"].ToString() == "1")
                          {
                              clearAll();
                              Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Line created successfully.')", true);
                            //  clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.CREATE_LOCATIONS, "NA", Session["UserName"].ToString(), Session["LineNUmber"].ToString());

                          }
                          else
                          {
                              Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Line number  already exists.')", true);
                          }
                      }
                  }
                }
                catch (Exception)
                {
                    
                 
                }
             
                //clearAll();
                //Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Location created successfully.')", true);
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