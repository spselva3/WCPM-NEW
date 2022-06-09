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
    public partial class frmCreateNewUser : System.Web.UI.Page
    {
        clsbusiness _cls = new clsbusiness();
        string UserID = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {

            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
            
        }
        public void clearAll()
        {
            txtEmpName.Text = string.Empty;
            txtEmpid.Text = string.Empty;
            txtUserame.Text = string.Empty;
            txtPassword.Text = string.Empty;
            ddlRole.SelectedIndex = -1;
            ddlStatus.SelectedIndex = -1;
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            try
            {
                string empName = txtEmpName.Text;
                string empCode = txtEmpid.Text;
                string userName = txtUserame.Text;
                string password = Encryption.EncryptText(txtPassword.Text);
                string designation = ddlRole.SelectedValue;
                string status = ddlStatus.SelectedValue;
                try
                {
              DataSet ds  =MSSQLHelper.ExecSqlDataSet("SP_TBLINSERTLOGINDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@EMPNAME", empName),
                            new SqlParameter("@EMPID",   empCode),
                            new SqlParameter("@DESIGNATION", designation),
                            new SqlParameter("@USERNAME",  userName),
                            new SqlParameter("@PASSWORD",password),
                             new SqlParameter("@STATUS", status)
                        });
              if (ds.Tables.Count > 0)
              {
                  DataTable dt = ds.Tables[0];
                  foreach (DataRow dtrow in dt.Rows)
                  {
                      if (dtrow["RESULT"].ToString() == "1")
                      {
                          clearAll();
                          Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('User created successfully.')", true);
                        //  clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.CREATE_USER, "user created", Session["UserName"].ToString(), Session["LineNUmber"].ToString());

                      }
                      else if (dtrow["RESULT"].ToString() == "2")
                      {
                          clearAll();
                          Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Employee  Id already exists.')", true);
                        //  clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.CREATE_USER, "user created", Session["UserName"].ToString(), Session["LineNUmber"].ToString());

                      }
                      else
                      {
                          Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('User already exists.')", true);
                      }
                  }
              }
                }
                catch (Exception)
                {
                    
                 
                }
             
                
               
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

        protected void BtnClose_Click(object sender, EventArgs e)
        {

        }


    }
}