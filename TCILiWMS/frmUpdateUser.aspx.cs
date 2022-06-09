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
    public partial class frmUpdateUser : System.Web.UI.Page
    {

        string UserID = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {

           
            
            if (!IsPostBack)
            {

                string id = Request.QueryString["data"];
                // SP_SELECTUSERFORUPDATE
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTUSERFORUPDATE", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@ID", id),
                        
                          
                        });
                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];
                    foreach (DataRow dtrow in dt.Rows)
                    {
                        txtEmpid.Text = dtrow["EMPID"].ToString();
                        txtEmpName.Text = dtrow["EMPNAME"].ToString();
                        txtUserame.Text = dtrow["LOGINUSERNAME"].ToString();
                        ddlRole.SelectedValue = dtrow["ROLE"].ToString();
                     //   ddlStatus.SelectedValue = dtrow["ACTIVEUSER"].ToString();
                        ddlStatus.Text = dtrow["ACTIVEUSER"].ToString();
                        //[PASSWORD]
                        ViewState["OldPassword"] = Encryption.DecryptText(dtrow["PASSWORD"].ToString());
                    }
                }
            }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        public void clearAll()
        {
            txtEmpName.Text = string.Empty;
         //   txtUserame.Text = string.Empty;
            txtConfirmedPassword.Text = string.Empty;
            txtNewPassword.Text = string.Empty;
            txtOldPassword.Text = string.Empty;
            ddlRole.SelectedIndex = -1;
            ddlStatus.SelectedIndex = -1;
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtEmpName.Text == string.Empty)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please enter the Employee Name')", true);
                    return;
                }
                if (ddlRole.SelectedValue == "Please Select")
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select the User Role')", true);
                    return;
                }
                if (txtOldPassword.Text == string.Empty)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please Enter the Old Password')", true);
                    return;
                }
                if (txtNewPassword.Text == string.Empty)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please Enter the New Password')", true);
                    return;
                }

                if (ddlStatus.SelectedValue == "Please Select")
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please select the status')", true);
                    return;
                }
                if (ViewState["OldPassword"].ToString() != txtOldPassword.Text)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Wrong Password!')", true);
                    return;
                }
                if (txtNewPassword.Text != txtConfirmedPassword.Text)
                {
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Password did not match!')", true);
                    return;
                }
                    string id = Request.QueryString["data"];
                string userName = txtUserame.Text;
                string password = Encryption.EncryptText(txtConfirmedPassword.Text);
                string designation = ddlRole.SelectedItem.ToString();
                string status = ddlStatus.SelectedValue;
                try
                {
                    MSSQLHelper.ExecSqlNonQuery("SP_TBLUPDATELOGINDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                                                       new SqlParameter("@ID", id),
                        
                            new SqlParameter("@DESIGNATION", designation),
                            new SqlParameter("@USERNAME",  userName),
                            new SqlParameter("@PASSWORD",password),
                             new SqlParameter("@STATUS", status)
                        });
                }
                catch (Exception)
                {


                }

                clearAll();
                Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('User Details updated successfully.')", true);
              //  clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.UPDATE_USER, "user logged in succssfully", Session["UserName"].ToString(), Session["LineNUmber"].ToString());

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

        protected void BtnClose_Click1(object sender, EventArgs e)
        {

        }


    }
}