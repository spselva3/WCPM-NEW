using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using DragonFactory;
using System.IO;
using System.Net.Sockets;
using System.Threading.Tasks;
using System.Drawing;
using System.Diagnostics;
using System.Net.NetworkInformation;
using TraceTool;
using Newtonsoft.Json;
using System.Web.UI.HtmlControls;

namespace WCPM
{
    public partial class frmGenerateReels : System.Web.UI.Page
    {
        protected override void OnPreRender(EventArgs e)
        {
            ViewState["update"] = Session["update"];
        }
        protected void Page_Load(object sender, EventArgs e)
        {



            if (!IsPostBack)
            {
                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
                if (Session["ROLE"].ToString() == "ADMIN")
                {
                    btnDeletesel.Enabled = true;

                }
                else
                {
                    btnDeletesel.Enabled = false;
                }

                string ID = Request.QueryString["Id"];
                string Size = Request.QueryString["size"];
                string[] difSizes = Size.Split('X');
                if (difSizes.Count() > 1)
                {
                    lblSelectSizes.Visible = true;
                    ddlSizes.Visible = true;
                    foreach (string str in difSizes)
                    {
                        ddlSizes.Items.Add(str.Trim());
                    }
                }
                // ID="ROL1";

                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTROLLETAILSFORWEB", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@ROLLID",  ID),
                            new SqlParameter("@SIZE",  Size),

                        });
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {

                    foreach (DataRow dtrow in dt.Rows)
                    {

                        txtLotNumber.Text = dtrow["PO_ROLLID"].ToString();
                        txtQuality.Text = dtrow["PO_QUALITY"].ToString();
                        txtGsm.Text = dtrow["PO_GSM"].ToString();

                        txtSize.Text = dtrow["PO_SIZE"].ToString();
                        txtQualityCode.Text = dtrow["PO_QULAITYCODE"].ToString();
                        txtRemarks.Text = dtrow["PO_REMARKS"].ToString();
                        txtLotPrefix.Text = dtrow["PO_LOTPREFIX"].ToString();
                    }
                }
                if (ds.Tables.Count > 1)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        lvReelDetails.DataSource = ds.Tables[1];
                        lvReelDetails.DataBind();



                    }
                    Imagebutton1.Visible = true;
                    btnDeletesel.Visible = true;
                }
            }
        }

        WinTrace PritnTRace = new WinTrace("Printer Trace", "Printer Trace");
        private void printLabel(DataTable dt, string reelid)
        {

            string reelId = string.Empty;
            string lotNum = string.Empty;
            string quality = string.Empty;
            string size = string.Empty;
            string gsm = string.Empty;
            string mfg = string.Empty;
            string shift = string.Empty;
            foreach (DataRow dtrow in dt.Rows)
            {
                reelId = dtrow["REELID"].ToString();
                lotNum = dtrow["LOT NO"].ToString();
                quality = dtrow["QUALITY"].ToString();
                size = dtrow["SIZE"].ToString();
                gsm = dtrow["GSM"].ToString();
                mfg = dtrow["MFG"].ToString();
                shift = dtrow["SHIFT"].ToString();
            }

            reelId = reelId.Replace(@"\", @"-");

            clsJsonDataforBarcode cls = new clsJsonDataforBarcode();
            cls.reelId = reelId;


            cls.lotNumber = lotNum; ;
            cls.quality = quality;
            cls.size = size;
            cls.gsm = gsm;
            cls.mfgData = mfg;
            cls.shift = shift;

            string output = JsonConvert.SerializeObject(cls);
            try
            {
                TcpClient Cleint;
                NetworkStream stream1;
                //Cleint = new TcpClient();
                //string ip = ConfigurationManager.AppSettings["LabelPrinterIP"];
                //int port = Int32.Parse(ConfigurationManager.AppSettings["LabelPrinterPOrt"]);
                //Cleint.Connect(ip, port);
                //stream1 = Cleint.GetStream();
                string str = File.ReadAllText(ConfigurationManager.AppSettings["LabelPrnFilePath"]);
                str = str.Replace("varreelid", reelId);
                str = str.Replace("varlotnumber", lotNum);
                str = str.Replace("varquality", quality);
                str = str.Replace("varsize", size);
                str = str.Replace("vargsm", gsm);
                str = str.Replace("varmfgData", mfg);
                str = str.Replace("varshift", shift);
                str = str.Replace("varlineBarcode", reelId);
                str = str.Replace("var2dbar", output);
                str = str.Replace("VarlineData", reelId);
                byte[] strbyte = System.Text.Encoding.ASCII.GetBytes(str);
                //      stream1.Write(strbyte, 0, strbyte.Length);
                _IsPrinting = false;
                lblMessage.Text = "Printing Success";
                lblMessage.ForeColor = Color.Green;
                MSSQLHelper.ExecSqlNonQuery("SP_UPDATEPRINTCOUNT", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@REELNUMBER",reelid),
                            new SqlParameter("@USER",Session["UserName"])

                        });
            }
            catch (Exception ex)
            {
                PritnTRace.Send(ex.ToString());
                _IsPrinting = false;
                lblMessage.Text = "Printing Failed";
                lblMessage.ForeColor = Color.Red;

            }
        }
        protected void btnPrint_Click1(object sender, EventArgs e)
        {

            if (_IsPrinting) return;
            _IsPrinting = true;
            Button btn = sender as Button;
            if (!isPingable(ConfigurationManager.AppSettings["LabelPrinterIP"]))
            {
                lblMessage.Text = "Printer No Connected";
                lblMessage.ForeColor = Color.Red;
                return;
            }


            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@REELID", btn.CommandName)


                        });
            DataTable dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                //Task.Factory.StartNew(() =>
                //{
                //    printLabel(dt);
                //});
                printLabel(dt, btn.CommandName);



            }



        }
        private bool isPingable(string ip)
        {
            try
            {
                Ping myPing = new Ping();
                PingReply reply = myPing.Send(ip, 1000);
                if (reply.Status == IPStatus.Success)
                {
                    return true;

                }
                else
                {
                    return false;
                }

            }
            catch
            {
                return false;
            }
        }
        private bool _IsPrinting = false;
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            createChildReels();
        }

        protected void cbPrintAll_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox cbp = sender as CheckBox;

            foreach (ListViewItem row in lvReelDetails.Items)
            {
                CheckBox cb = (CheckBox)row.FindControl("cbPrintind");
                if (cb != null)
                {

                    if (cbp.Checked == true)
                    {
                        if (cb.Enabled)
                            cb.Checked = true;

                    }
                    else
                    {
                        cb.Checked = false;
                    }
                }
            }
        }
        private void createChildReels()
        {
            int numberOfReels = 0;
            int.TryParse(txtNoOfReels.Text, out numberOfReels);
            if (txtLotNumber.Text.Trim() == string.Empty && txtSize.Text.Trim() == string.Empty)
            {
                return;
            }

            string Size = string.Empty;
            if (ddlSizes.Visible)
            {
                if (ddlSizes.SelectedItem.ToString().ToLower() == "please select")
                {
                    return;
                }
                Size = ddlSizes.SelectedItem.ToString();
            }
            else
            {
                Size = txtSize.Text;
            }
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_CREATECHILDREELS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@NOOFREELS",  numberOfReels),
                            new SqlParameter("@LOTNUMBER",   txtLotNumber.Text),
                            new SqlParameter("@SIZE",  Size.Trim()),
                            new SqlParameter("@USER",  Session["UserName"] ),
                            new SqlParameter("@MACHINENUMBER",   Session["LineNUmber"] ),
                            new SqlParameter("@ACTUALSIZE",   Request.QueryString["size"] ),


                        });
            Imagebutton1.Visible = true;
            btnDeletesel.Visible = true;

            DataTable dt = ds.Tables[0];
            lvReelDetails.DataSource = dt;
            lvReelDetails.DataBind();
            ViewState["NoOfReels"] = numberOfReels;
            txtNoOfReels.Text = string.Empty;
        }
        protected void lvLabelled_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                ListViewDataItem dataitem = (ListViewDataItem)e.Item;
                //Get the Name values
                decimal policyid = (decimal)DataBinder.Eval(dataitem.DataItem, "R_NOOFPRINTS");
                bool isDeleted = (bool)DataBinder.Eval(dataitem.DataItem, "R_FLAGTODELETE");
                // if value is "Name4" then change the color or Row

                if (policyid > 0)
                {


                    //Change the Back ground color
                    HtmlTableRow abc = e.Item.FindControl("_itemrow") as HtmlTableRow;

                    abc.Attributes.Add("style", "color:Red");

                }
                else
                {
                    HtmlTableRow abc = e.Item.FindControl("_itemrow") as HtmlTableRow;

                    abc.Attributes.Add("style", "color:Green");
                }
                if (!isDeleted)
                {
                    HtmlTableRow abc = e.Item.FindControl("_itemrow") as HtmlTableRow;
                    abc.Attributes.Add("style", "text-decoration: line-through");
                    CheckBox cb = (CheckBox)e.Item.FindControl("cbPrintind");
                    cb.Enabled = false;

                }



            }
        }
        protected void btnPrintAll_Click(object sender, EventArgs e)
        {

        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (txtFromReelNumber.Text.Trim() == string.Empty)
            {
                Response.Write("<script>alert('Enter Proper Reel Number')</script>");
                return;
            }

            if (txtToReelNumber.Text.Trim() == string.Empty)
            {
                Response.Write("<script>alert('Enter Proper Reel Number')</script>");
                return;
            }
            int fromreelNumber = int.Parse(txtFromReelNumber.Text);
            int toreelnumber = int.Parse(txtToReelNumber.Text);
            if (fromreelNumber > toreelnumber)
            {
                Response.Write("<script>alert('From Reel Number should not be greater than to Reel Number')</script>");
                txtToReelNumber.Text = string.Empty;
                txtFromReelNumber.Text = string.Empty;
                return;
            }
           

            if (Session["update"].ToString() == ViewState["update"].ToString())
            {


                string size = string.Empty;
                if (ddlSizes.Visible)
                {
                    size = ddlSizes.SelectedItem.Value;
                }
                else
                {
                    size = txtSize.Text;
                }
          
                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_DELETECHILDREELS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@FROMREELNUMBER",fromreelNumber),
                            new SqlParameter("@TOREELNUMBER", toreelnumber),
                            new SqlParameter("@LOTNUMBER", txtLotNumber.Text),
                            new SqlParameter("@SIZE", size.Trim()),
                              new SqlParameter("@LINENUMBER", Session["LineNUmber"].ToString()),
                              new SqlParameter("@USER", Session["UserName"].ToString()),


                        }); ;









                createChildReels();
            }
            else
            {

            }
        }
    

        protected void btnsubmit_Click(object sender, ImageClickEventArgs e)
        {
            createChildReels();
        }

        protected void ddlSizes_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlSizes.SelectedValue == "Please select") return;
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTCHILDREELS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {


                            new SqlParameter("@ROLLID",   txtLotNumber.Text),


                            new SqlParameter("@SIZE",   ddlSizes.SelectedValue.Trim() ),


                        });
            Imagebutton1.Visible = true;
            btnDeletesel.Visible = true;

            DataTable dt = ds.Tables[0];
            lvReelDetails.DataSource = dt;
            lvReelDetails.DataBind();
        }

        protected void btnPrintAll_Click(object sender, ImageClickEventArgs e)
        {

        }

        protected void lvReelDetails_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void Imagebutton1_Click(object sender, ImageClickEventArgs e)
        {
            if (txtFromReelNumber.Text.Trim() == string.Empty)
            {
                Response.Write("<script>alert('Enter Proper Reel Number')</script>");
                return;
            }

            if (txtToReelNumber.Text.Trim() == string.Empty)
            {
                Response.Write("<script>alert('Enter Proper Reel Number')</script>");
                return;
            }
            int fromreelNumber = int.Parse(txtFromReelNumber.Text);
            int toreelnumber = int.Parse(txtToReelNumber.Text);
            if (fromreelNumber>toreelnumber)
            {
                Response.Write("<script>alert('From Reel Number should not be greater than to Reel Number')</script>");
                txtToReelNumber.Text = string.Empty;
                txtFromReelNumber.Text = string.Empty;
                return;
            }
            int limit= int.Parse(ConfigurationManager.AppSettings["PrintLimit"].ToString());
            if (toreelnumber-fromreelNumber>limit)
            {
                Response.Write("<script>alert('Print Limit Exeeded')</script>");
                return;
            }

            if (Session["update"].ToString() == ViewState["update"].ToString())
            {


                string size = string.Empty;
                if (ddlSizes.Visible)
                {
                    size = ddlSizes.SelectedItem.Value;
                }
                else
                {
                    size = txtSize.Text;
                }

                Session["update"] = Server.UrlEncode(System.DateTime.Now.ToString());
             DataSet ds=   MSSQLHelper.ExecSqlDataSet("SP_SELECTFORREELPRINTING", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@FROMREELNUMBER",fromreelNumber),
                            new SqlParameter("@TOREELNUMBER", toreelnumber),
                            new SqlParameter("@LOTNUMBER", txtLotNumber.Text),
                            new SqlParameter("@SIZE", size.Trim()),
                              new SqlParameter("@LINENUMBER", Session["LineNUmber"].ToString()),
                              new SqlParameter("@USER", Session["UserName"].ToString()),


                        }); ;





                //MSSQLHelper.ExecSqlDataSet("SP_INSERTFORLABELPRINTING", CommandType.StoredProcedure, new List<SqlParameter>()
                // {

                //            new SqlParameter("@LINENUMBER", Session["LineNUmber"].ToString()),
                //            new SqlParameter("@REELNUMBER", "")


                //        }); ;

                         //
                
               // CLSDB.UPDATEREELHISTORY("", "PRINT", Session["UserName"].ToString(), Session["LineNUmber"].ToString());




               
                createChildReels();
            }
            else
            {

            }
        }

        protected void btnSaveRemarks_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_UPDATEREMARKSFORLOT", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                            new SqlParameter("@ROLLID",  txtLotNumber.Text),
                            new SqlParameter("@SIZE",  txtSize.Text),
                            new SqlParameter("@REMARKS",  txtRemarks.Text),

                        });
                DataTable dt = ds.Tables[0];
                string RESULT = "";
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dt.Rows)
                    {
                         RESULT = dtrow["RESULT"].ToString();
                    }
                }
                if (RESULT == "1")
                {
                    lblMessage.Text = "Remarks Updated";
                    lblMessage.ForeColor = Color.Green;
                    BtneditRemarkk.Visible = true;
                    btnSaveRemarks.Visible = false;
                    txtRemarks.ReadOnly = true;
                }
                else
                {
                    lblMessage.Text = "Not Updated";
                    lblMessage.ForeColor = Color.Red;
                }


            }
            catch (Exception ex)
            {
                lblMessage.Text = ex.Message;
                lblMessage.ForeColor = Color.Red;

            }
        }

        protected void BtneditRemarkk_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                if (Session["ROLE"].ToString().ToUpper() != "ADMIN")
                {
                    return;
                }
                BtneditRemarkk.Visible = false;
                btnSaveRemarks.Visible = true;
                txtRemarks.ReadOnly = false;


            }
            catch (Exception ex)
            {
                lblMessage.Text = ex.Message;
                lblMessage.ForeColor = Color.Red;

            }

        }

        protected void BtneditRemarkk_Click1(object sender, ImageClickEventArgs e)
        {

        }

        protected void btnSaveRemarks_Click1(object sender, ImageClickEventArgs e)
        {
            
        }




        //protected void txtUndo_Click(object sender, EventArgs e)
        //{
        //    if (ViewState["NoOfReels"] != null)
        //    {
        //        int nuofReels = int.Parse(ViewState["NoOfReels"].ToString());

        //        DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_DELEETCHILDREELS", CommandType.StoredProcedure, new List<SqlParameter>()
        //         {
        //                    new SqlParameter("@NOOFREELS",  nuofReels),
        //                    new SqlParameter("@ROLLID",  txtLotNumber.Text),
        //                    new SqlParameter("@SIZE",  txtSize.Text),


        //                });
        //        DataTable dt = ds.Tables[0];
        //        lvReelDetails.DataSource = dt;
        //        lvReelDetails.DataBind();
        //    }
        //}


    }
}