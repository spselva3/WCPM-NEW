using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DragonFactory;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Drawing;

namespace WCPM
{
    public partial class frmInvetoryFinal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    GetLabelledData();
                    updateDashBoard("All");
                    TreeNode child = new TreeNode
                    {
                        Text = "WCPM",
                        Value = "WCPM"
                    };
                    tvLocationView.Nodes.Add(child);
                

                    MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                    DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOCATIONDETAILS", CommandType.StoredProcedure, new List<SqlParameter>()
                    {
                    });
                    if (ds.Tables.Count > 0)
                    {
                        DataTable dt = ds.Tables[0];
                        foreach (DataRow dtrow in dt.Rows)
                        {
                            TreeNode child1 = new TreeNode
                            {
                                Text = dtrow["LOCATIONNAME"].ToString(),
                                Value = dtrow["LOCATIONNUMBER"].ToString()
                            };
                          
                            child1.SelectAction = TreeNodeSelectAction.Select;
                            child.ChildNodes.Add(child1);

                        }
                    }
                  
                   
                 
                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        protected void tvLocationView_SelectedNodeChanged(object sender, EventArgs e)
        {
            string at = tvLocationView.SelectedNode.Text;
            string str = tvLocationView.SelectedNode.Value;

            if (str == "WCPM")
            {
             updateDashBoard("All");
            }
            else
            {
              updateDashBoard(str);

            }
        }
        private void updateDashBoard(string linenumber)
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTFORDASHBOARDNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                   new SqlParameter("@LOCATIONNUMBWR", linenumber),  
                          
                        });
                lblTotalReelCountforMonth.Text = ds.Tables[0].Rows[0]["TOTALMONTHREELCOUNT"].ToString();
                lblTotalReelCountforDay.Text = ds.Tables[1].Rows[0]["TOTALDAYREELCOUNT"].ToString();
                if (ds.Tables[3].Rows[0]["MONTHLYWEIGHT"].ToString() == string.Empty)
                {
                    lblTotalWeightforMonth.Text = "0" ;

                }
                else
                {
                    lblTotalWeightforMonth.Text = ds.Tables[3].Rows[0]["MONTHLYWEIGHT"].ToString();

                }
                if (ds.Tables[4].Rows[0]["DAYWEIGHT"].ToString() == string.Empty)
                {
                    lblTotalWeightforDay.Text ="0";
                }
                else
                {
                    lblTotalWeightforDay.Text = ds.Tables[4].Rows[0]["DAYWEIGHT"].ToString();
                }
               
            }
            catch (Exception)
            {
                
             
            }
           
        }
        private void GetLabelledData()
        {
            try
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREPORTFORINVENTORYFINAL", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                   new SqlParameter("@FLAG", "ALL"),  
                   new SqlParameter("@LOTNUMBER", ""),  
                   new SqlParameter("@REELNUMBER", ""),  
                   new SqlParameter("@FROMDATWE",""),  
                   new SqlParameter("@TODATE", ""),  
                          
                        });
                DataTable dt = ds.Tables[0];



                Session["DT"] = dt;
                Session["FileName"] = "Inventory Report";
                lvLabelled.DataSource = dt;
                lvLabelled.DataBind();
            }
            catch (Exception ex)
            {
                // dverrmsg.InnerHtml = ex.Message;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            DateTime fromDate = DateTime.ParseExact("09-10-2019",
 "d-M-yyyy",
 System.Globalization.CultureInfo.InvariantCulture);
                //09-10-2019
            try
            {
                 fromDate = DateTime.ParseExact(txtFromDate.Text,
 "d-M-yyyy",
 System.Globalization.CultureInfo.InvariantCulture);

            }
            catch (Exception)
            {
                
                
            }
            DateTime toDate = DateTime.ParseExact("09-10-2019",
 "d-M-yyyy",
 System.Globalization.CultureInfo.InvariantCulture);
            try
            {
                 toDate = DateTime.ParseExact(txtToDate.Text,
 "d-M-yyyy",
 System.Globalization.CultureInfo.InvariantCulture);
            }
            catch (Exception)
            {
                
               
            }
           
          
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREPORTFORINVENTORYFINAL", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                   new SqlParameter("@FLAG", "FIL"),  
                   new SqlParameter("@LOTNUMBER", txtLotNUmber.Text),  
                   new SqlParameter("@REELNUMBER", txtReelNumber.Text),  
                   new SqlParameter("@FROMDATWE", fromDate),  
                   new SqlParameter("@TODATE", toDate),  
                          
                        });
            DataTable dt = ds.Tables[0];



            Session["DT"] = dt;
            Session["FileName"] = "Inventory Report";
            lvLabelled.DataSource = dt;
            lvLabelled.DataBind();
        }

        protected void btnreprint_Click(object sender, EventArgs e)
        {

            LinkButton LBTN = sender as LinkButton;
            String LineNumber = Session["LineNumber"].ToString();
            string reelId = LBTN.ValidationGroup.ToString();
            int lin = int.Parse(LineNumber);
          MSSQLHelper.ExecSqlNonQuery("SP_INSERTFORPRINTINGFROMWEB", CommandType.StoredProcedure, new List<SqlParameter>()
                 {

                   new SqlParameter("@REELNUMBER",reelId),
                   new SqlParameter("@LINENUMBER", lin),
                   new SqlParameter("@RSN",LBTN.Text ),
             

                        });
         
        }
    }
}