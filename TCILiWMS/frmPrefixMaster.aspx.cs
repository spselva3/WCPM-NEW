using DragonFactory;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WCPM
{
    public partial class frmPrefixMaster : System.Web.UI.Page
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
                    GetmasterList();
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }

        #region GetAllUsers()

        private void GetmasterList()
        {

            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTPREFIXMASTER", CommandType.StoredProcedure, new List<SqlParameter>()
            {
            new SqlParameter("@NEWPREFIX", ""),
                    new SqlParameter("@FLAG",  "SELECT"),
                
                });

            DataTable dtUserDetails = ds.Tables[0];
            lvUserDetails.DataSource = dtUserDetails;
            lvUserDetails.DataBind();
        }
        #endregion

        protected void dpinventory_PreRender(object sender, EventArgs e)
        {
            GetmasterList();
        }

        #region lvUserDetails_ItemEditing(object sender, ListViewEditEventArgs e)

        protected void lvUserDetails_ItemEditing(object sender, ListViewEditEventArgs e)
        {
            lvUserDetails.EditIndex = e.NewEditIndex;
            GetmasterList();
        }

        #endregion


        #region lvUserDetails_ItemUpdating(object sender, ListViewUpdateEventArgs e)

        protected void lvUserDetails_ItemUpdating(object sender, ListViewUpdateEventArgs e)
        {
            ListViewItem item = lvUserDetails.Items[e.ItemIndex];

           
         

      
            string[] UserDtls = new string[1];
            //Find Local Server
            TextBox txtPrefix = (TextBox)(lvUserDetails.Items[e.ItemIndex].FindControl("txtPrefix"));
            UserDtls[0] = txtPrefix.Text.Trim();

            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTPREFIXMASTER", CommandType.StoredProcedure, new List<SqlParameter>()
            {
            new SqlParameter("@NEWPREFIX",  UserDtls[0] ),
                    new SqlParameter("@FLAG",  "UPDATE"),
                
                });

           
            lvUserDetails.EditIndex = -1;
            GetmasterList();
            lblMessage.Text = "Success : Records Updated";
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
            GetmasterList();
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
    }
}