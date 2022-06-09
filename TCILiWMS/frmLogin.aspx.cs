using System;
using System.Collections.Generic;
using System.Data;
using DragonFactory.Utilities;
using System.Net;
using System.Data.SqlClient;
using DragonFactory;
using System.Configuration;
using System.IO;
using Newtonsoft.Json;
using System.Globalization;
using System.Net.NetworkInformation;
using System.Linq;
using System.Management;
using System.Web;
namespace WCPM
{
    public partial class frmLogin : System.Web.UI.Page
    {
        clsbusiness _cls = new clsbusiness();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               // checkforValidLicense();
                txtUsername.Focus();
                string hostName = Dns.GetHostName(); // Retrive the Name of HOST  
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOCATIONDETAILSNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                {
                });
                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];

                    foreach (DataRow dtrow in dt.Rows)
                    {

                        ddlLineNum.Items.Add(dtrow["LOCATIONNUMBER"].ToString());



                    }
                }


            }
        }
        private bool checkforValidLicense()
        {
          

            clsEncryption.hashKey = "@signode";
            string txt = File.ReadAllText(ConfigurationManager.AppSettings["LicensePath"]);
            string str = clsEncryption.DecryptText(txt);
            clsJsonData clsjson = JsonConvert.DeserializeObject<clsJsonData>(str);
            string fromdate = clsjson.fromdate;
            //string todate = clsjson.todate;
            string todate = "01-08-2019";
            string cust = clsjson.custmername;
            //03-08-2019
            string inputFormat = "dd-MM-yyyy";
            DateTime toresult = DateTime.ParseExact(todate,
            inputFormat, CultureInfo.InvariantCulture);
            List<string> lstLicMacIds = clsjson.deviceMacIds;
            if (DateTime.Now >= toresult)
            {
                return false;
            }
            else
            {
                ManagementObjectSearcher objMOS = new ManagementObjectSearcher("Select * FROM Win32_NetworkAdapterConfiguration");
                ManagementObjectCollection objMOC = objMOS.Get();

                bool result = false;
                List<string> lstMacAdss = new List<string>();
                foreach (ManagementObject objMO in objMOC)
                {
                    object tempMacAddrObj = objMO["MacAddress"];
                    object ipads = objMO["IPAddress"];
                    if (tempMacAddrObj == null) //Skip objects without a MACAddress
                    {
                        continue;
                    }
                    lstMacAdss.Add(tempMacAddrObj.ToString());


                    objMO.Dispose();
                }
                foreach (string item in lstMacAdss)
                {
                    if (lstLicMacIds.Contains(item))
                        result = true;
                }
                return result;
            }

        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string str = string.Format("javascript:ShowchildReelCreation(~/frmGenerateReels.aspx?Id={0})",
                    HttpUtility.UrlEncode("PO_ROLLID".ToString()));
            string PWD = Encryption.EncryptText("ADMIN");

            try
            {
                if (txtUsername.Text.Trim() == "")
                {
                    lblError.Text = "Please enter User Name.";
                    return;
                }
                if (txtPassword.Text.Trim() == "")
                {
                    lblError.Text = "Please Enter  Password.";
                    return;
                }
                if (ddlLineNum.SelectedValue == "Please Select")
                {
                    lblError.Text = "Please select line Number";
                    return;
                }




                DataTable dtLogin = DBLayer.spUserMasterSelect(txtUsername.Text);
                if (dtLogin.Rows.Count > 0)
                {

                    Session["ROLE"] = dtLogin.Rows[0]["ROLE"].ToString();
                  
                    string str1 = dtLogin.Rows[0]["ACTIVEUSER"].ToString();
                    if (dtLogin.Rows[0]["ACTIVEUSER"].ToString().ToUpper() != "TRUE")
                    {
                        lblError.Text = "Invalid  User!";
                        txtPassword.Text = "";
                        txtPassword.Focus();
                        return;
                    }
                    
                    if (dtLogin.Rows[0]["PASSWORD"].ToString() != Encryption.EncryptText(txtPassword.Text))
                    {
                        lblError.Text = "Wrong Password!";
                        txtPassword.Text = "";
                        txtPassword.Focus();
                        return;
                    }
                    //Session["UserName"] = dtLogin.Rows[0]["UserName"].ToString();
                    //Session["UserRole"] = dtLogin.Rows[0]["UserRole"].ToString();
                    Session["UserName"] = txtUsername.Text;
                    Session["LineNUmber"] = ddlLineNum.SelectedValue;
                    MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                    MSSQLHelper.ExecSqlNonQuery("SP_UPDATELOGINSTATUS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                          
                            new SqlParameter("@USER",Session["UserName"]),
                            new SqlParameter("@STATUS",true),
                          
                        });

                    MSSQLHelper.ExecSqlNonQuery("SP_UPDATELASTLOGEEDINTIME", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            new SqlParameter("@USER",Session["UserName"]),

                        });
                    // clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.LOGIN, "user logged in succssfully", Session["UserName"].ToString(), Session["LineNUmber"].ToString());
                    //  Response.Redirect("frmReport.aspx");
                    Response.Redirect("frmInvetoryFinal.aspx");
                    // Server.Transfer("frmReports.aspx");
                }
                else
                {
                    lblError.Text = "Invalid Username.";
                    txtUsername.Text = "";
                    txtPassword.Text = "";
                    txtUsername.Focus();
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message.ToString();
            }
        }
    }
}