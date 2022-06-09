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
    public partial class frmUsers : System.Web.UI.Page
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
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTUSERFORWEB", CommandType.StoredProcedure, new List<SqlParameter>());

            DataTable dtUserDetails = ds.Tables[0];
            lvUserDetails.DataSource = dtUserDetails;
            lvUserDetails.DataBind();
        }
        #endregion

        protected void dpinventory_PreRender(object sender, EventArgs e)
        {
            GetAllUsers();
        }

        #region lvUserDetails_ItemEditing(object sender, ListViewEditEventArgs e)

        protected void lvUserDetails_ItemEditing(object sender, ListViewEditEventArgs e)
        {
            lvUserDetails.EditIndex = e.NewEditIndex;
            GetAllUsers();
        }

        #endregion

        protected void lvUserDetails_ItemCommand(object sender, ListViewCommandEventArgs e)
        {

            //if (e.CommandName.Contains("EditDetails"))
            //{
               
            //        string id = e.CommandArgument.ToString();


            //        string strPopup = "<script language='javascript' ID='script1'>"


            //        + "window.open('frmUpdateUser.aspx?data=" + HttpUtility.UrlEncode(id.ToString())

            //        + "','new window', 'top=90, left=200, width=800, height=200, dependant=no, location=0, alwaysRaised=no, menubar=no, resizeable=no, scrollbars=n, toolbar=no, status=no, center=yes')"

            //        + "</script>";

            //        ScriptManager.RegisterStartupScript((Page)HttpContext.Current.Handler, typeof(Page), "Script1", strPopup, false);

                
            //}



        }
        #region lvUserDetails_ItemUpdating(object sender, ListViewUpdateEventArgs e)

        protected void lvUserDetails_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        {
            //ListViewItem item = lvUserDetails.Items[e.ItemIndex];

            //HiddenField hfUserId = (HiddenField)item.FindControl("hfUserId");
            ////  HiddenField hfStatusId = (HiddenField)item.FindControl("hfStatusId");

            //int Uid = Convert.ToInt32(hfUserId.Value);
            //string[] UserDtls = new string[7];
            ////Find Local Server
            //TextBox txtEmpName = (TextBox)(lvUserDetails.Items[e.ItemIndex].FindControl("txtEmpName"));
            //UserDtls[0] = txtEmpName.Text.Trim();
            //TextBox txtEmpID = (TextBox)(lvUserDetails.Items[e.ItemIndex].FindControl("txtEmpID"));
            //UserDtls[1] = txtEmpID.Text.Trim();
            //TextBox txtDesignation = (TextBox)(lvUserDetails.Items[e.ItemIndex].FindControl("txtDesignation"));
            //UserDtls[2] = txtDesignation.Text.Trim();
            //TextBox txtUserName = (TextBox)(lvUserDetails.Items[e.ItemIndex].FindControl("txtUserName"));
            //UserDtls[3] = txtUserName.Text.Trim();
            //TextBox txtPassword = (TextBox)(lvUserDetails.Items[e.ItemIndex].FindControl("txtPassword"));
            //UserDtls[4] = txtPassword.Text.Trim();
            //DropDownList ddlUStatus = (DropDownList)(lvUserDetails.Items[e.ItemIndex].FindControl("ddlUStatus"));
            //UserDtls[5] = ddlUStatus.SelectedValue;


            //MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"];
            //MSSQLHelper.ExecSqlNonQuery("SP_UPDATEUSERDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
            //            {
            //                new SqlParameter("@ID",  Uid),
            //                new SqlParameter("@EMPNAME",  UserDtls[0]),
            //                new SqlParameter("@EMPID",   UserDtls[1]),
            //                new SqlParameter("@ROLE",  UserDtls[2]),
            //                new SqlParameter("@USERNAME",   UserDtls[3]),
            //                new SqlParameter("@PASSWORD", Encryption.EncryptText(UserDtls[4])),
            //                                           new SqlParameter("@STATUS",  UserDtls[5])
            //            });

            //lvUserDetails.EditIndex = -1;
            //GetAllUsers();
            //lblMessage.Text = "Success :Records Updated";
        }

        #endregion

        #region GetLocations()



        private void GetLocations()
        {
            try
            {
                DropDownList ddlLocation = (DropDownList)lvUserDetails.InsertItem.FindControl("ddlLocation");

                //var Locations = clsbusiness.GetPlantLocations();
                //ddlLocation.DataSource = Locations.Where(x => x.ParentPlantCode != "0");
                //ddlLocation.DataValueField = "PlantCode";
                //ddlLocation.DataTextField = "PlantName";
                //ddlLocation.DataBind();
                //ddlLocation.Items.Insert(0, new ListItem(" Select ", "-1"));
            }
            catch (Exception ex)
            {
                lblMessage.Text = "<b><font color=red>" + ex.Message + "</font></b>";
            }
        }

        #endregion

        #region lvUserDetails_ItemCanceling(object sender, ListViewCancelEventArgs e)

        /// <summary>
        /// For Users Listview item cancelling
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void lvUserDetails_ItemCanceling(object sender, ListViewCancelEventArgs e)
        {
            lvUserDetails.EditIndex = -1;
            GetAllUsers();
            // GetLocations();
        }

        #endregion

        public void clearAll(ListViewInsertEventArgs e)
        {
            //Find Usercode
            TextBox txtUserCode = (TextBox)e.Item.FindControl("txtUserCode");
            txtUserCode.Text = "";
            //Find Usertype
            DropDownList ddlUserType = (DropDownList)e.Item.FindControl("ddlUserType");
            ddlUserType.SelectedIndex = -1;
            //Find Username
            TextBox txtUsername = (TextBox)e.Item.FindControl("txtUsername");
            txtUsername.Text = "";
            //Find Password
            TextBox txtPassword = (TextBox)e.Item.FindControl("txtPassword");
            txtPassword.Text = "";
            //Find First Name
            TextBox txtFirstname = (TextBox)e.Item.FindControl("txtFirstname");
            txtFirstname.Text = "";
            //Find Last Name
            TextBox txtLastName = (TextBox)e.Item.FindControl("txtLastName");
            txtLastName.Text = "";
            //Find Email
            TextBox txtEmail = (TextBox)e.Item.FindControl("txtEmail");
            txtEmail.Text = "";
            //Find Phone
            TextBox txtPhone = (TextBox)e.Item.FindControl("txtPhone");
            txtPhone.Text = "";
            //Find Location
            DropDownList ddlLocation = (DropDownList)e.Item.FindControl("ddlLocation");
            ddlLocation.SelectedIndex = 0;
            //Find Status
            DropDownList ddlStatus = (DropDownList)e.Item.FindControl("ddlStatus");
            ddlStatus.SelectedIndex = -1;
        }
        protected void lvUserDetails_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            TextBox _txtDPassword = (TextBox)e.Item.FindControl("txtDPassword");
            TextBox _txtUPassword = (TextBox)e.Item.FindControl("txtUPassword");
            if (_txtUPassword != null)
            {
                _txtUPassword.Attributes.Add("value", _txtUPassword.Text);
            }
            if (_txtDPassword != null)
            {
                _txtDPassword.Attributes.Add("value", _txtDPassword.Text);
            }

        }

        protected void lvUserDetails_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}