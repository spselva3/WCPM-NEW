using DragonFactory;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WCPM
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
           
                TreeNode child = new TreeNode
                {
                    Text = "WCPM",
                    Value = "WCPM"
                };
             //   tvLocationView.Nodes.Add(child);
                

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
    }
}