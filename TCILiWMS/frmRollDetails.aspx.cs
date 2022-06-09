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

namespace WCPM
{
    public partial class frmRollDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                string ID = Request.QueryString["Id"];
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTROLLETAILSFORWEB", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@ROLLID",  ID),
                          
                        });
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {

                    foreach (DataRow dtrow in dt.Rows)
                    {
                        txtProductionOrder.Text = dtrow["PO_PODUCTIONORDER"].ToString();
                        txtRollId.Text = dtrow["PO_ROLLID"].ToString();
                        txtQuality.Text = dtrow["PO_QUALITY"].ToString();
                        txtGsm.Text = dtrow["PO_GSM"].ToString();
                        txtDia.Text = dtrow["PO_DIA"].ToString();
                        txtSize.Text = dtrow["PO_SIZE"].ToString();
                        txtNoOfreels.Text = dtrow["PO_NOOFREELS"].ToString();
                        txtNoOfJonts.Text = dtrow["PO_NOOFJOINTS"].ToString();

                    }
                }

            }

        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            int numberOfReels = 0;
            int.TryParse(txtNoOfreels.Text, out numberOfReels);
            if (txtRollId.Text.Trim() == string.Empty && txtSize.Text.Trim() == string.Empty)
            {
                return;
            }
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_CREATECHILDREELS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@NOOFREELS",  numberOfReels),
                            new SqlParameter("@LOTNUMBER",   txtRollId.Text),
                            new SqlParameter("@SIZE",  txtSize.Text),
                            new SqlParameter("@USER",  Session["UserName"] )
                          
                        });
          //  clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.CREATE_CHILD_REELS, "Child Reels are created for lot number  " + txtRollId.Text, Session["UserName"].ToString(), Session["LineNUmber"].ToString());

            DataTable dt = ds.Tables[0];
            lvReelDetails.DataSource = dt;
            lvReelDetails.DataBind();
        }



        protected void BtnClose_Click(object sender, EventArgs e)
        {

        }


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
            try
            {
                TcpClient Cleint;
                NetworkStream stream1;
                Cleint = new TcpClient();
                string ip = ConfigurationManager.AppSettings["LabelPrinterIP"];
                int port = Int32.Parse(ConfigurationManager.AppSettings["LabelPrinterPOrt"]);
                Cleint.Connect(ip, port);
                stream1 = Cleint.GetStream();
                string str = File.ReadAllText(ConfigurationManager.AppSettings["LabelPrnFilePath"]);
                str = str.Replace("D1", reelId);
                str = str.Replace("D2", lotNum);
                str = str.Replace("D3", quality);
                str = str.Replace("D4", size);
                str = str.Replace("D5", gsm);
                str = str.Replace("D6", mfg);
                str = str.Replace("D7", shift);
                str = str.Replace("D8", mfg);
                str = str.Replace("DX", reelId);
                str = str.Replace("D9", mfg);

                byte[] strbyte = System.Text.Encoding.ASCII.GetBytes(str);

                stream1.Write(strbyte, 0, strbyte.Length);

                _IsPrinting = false;
                lblMessage.Text = "Printing Success";
                lblMessage.ForeColor = Color.Green;
                MSSQLHelper.ExecSqlNonQuery("SP_UPDATEPRINTCOUNT", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                       
                            new SqlParameter("@REELNUMBER",reelid)
                                                    
                        });
             //   clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.PRINT_REPRINT_CHILD_REELS, "Printing Success for child reel  " + reelid, Session["UserName"].ToString(), Session["LineNUmber"].ToString());
            }
            catch (Exception)
            {

                _IsPrinting = false;
                lblMessage.Text = "Printing Failed";
                lblMessage.ForeColor = Color.Red;

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
    }
}