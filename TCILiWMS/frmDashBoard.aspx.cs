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
    public partial class frmDashBoard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(IsPostBack))
            {
                string sMonth = DateTime.Now.ToString("MM");
                        DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTMONTHWISEREPORTFORDASHBOARD", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                            new SqlParameter("@MONTHNUMBER",  sMonth),
                          
                          
                        });

            DataTable dt = ds.Tables[0];
            dlprojectdetailsmonth.DataSource = dt;
            dlprojectdetailsmonth.DataBind();
            }
        }
    }

      
    
}