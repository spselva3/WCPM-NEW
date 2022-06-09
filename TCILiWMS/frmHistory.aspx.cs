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

namespace WCPM
{
    public partial class frmHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(IsPostBack))
            {
                MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
                DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                           
                          
                        });
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    lvLabelled.DataSource = dt;
                    lvLabelled.DataBind();
                }
                //ListItem stt = new ListItem("Select");
                //ddlLotNUmbers.Items.Add(stt);
                //foreach (DataRow dtrow in dt.Rows)
                //{
                //    ListItem lst=new ListItem(dtrow["R_ROLLID"].ToString());

                //   if (!(ddlLotNUmbers.Items.Contains(lst)))
                //   {
                //       ddlLotNUmbers.Items.Add(lst);
                //   }
                //}
                //ddlLotNUmbers.SelectedIndex = 0;



            }
        }

        //protected void btnGetDetails_Click(object sender, EventArgs e)
        //{
        //    MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
        //    DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTREELSDETAILSFORREPORT", CommandType.StoredProcedure, new List<SqlParameter>()
        //         {
                           
        //                    new SqlParameter("@LOTNUMBER",  ddlLotNUmbers.SelectedItem.ToString()),
                          
        //                });
        //    DataTable dt = ds.Tables[0];
        //    if (dt.Rows.Count > 0)
        //    {
        //        lvLabelled.DataSource = dt;
        //        lvLabelled.DataBind();
        //    }
        //}
    }
}