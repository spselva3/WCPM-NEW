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

namespace WCPM
{
    public partial class frmTestMaster : System.Web.UI.Page
    {
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
                //lblTotalReelCountforMonth.Text = ds.Tables[0].Rows[0]["TOTALMONTHREELCOUNT"].ToString();
                //lblTotalReelCountforDay.Text = ds.Tables[1].Rows[0]["TOTALDAYREELCOUNT"].ToString();
                //lblTotalWeightforMonth.Text = ds.Tables[3].Rows[0]["MONTHLYWEIGHT"].ToString();
                //lblTotalWeightforDay.Text = ds.Tables[4].Rows[0]["DAYWEIGHT"].ToString();
            }
            catch (Exception)
            {


            }

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
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

     
        
    }
}