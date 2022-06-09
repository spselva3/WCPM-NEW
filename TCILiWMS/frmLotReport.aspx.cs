using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DragonFactory;
using DragonFactory.Utilities;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing;

namespace WCPM
{
    public partial class frmLotReport : System.Web.UI.Page
    {
     
        protected void Page_Load(object sender, EventArgs e)
        {
            string lotNumber = Request.QueryString["lot"];
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOTWISEREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                   new SqlParameter("@LOTNUMBER", lotNumber),  
                          
                        });
            DataTable dt = ds.Tables[0];
            DataTable dt2 = ds.Tables[1];
            DataTable dt3 = ds.Tables[2];

            dt.Merge(dt2);
            dt.Columns.Remove("R_ROLLID");
            //foreach (DataRow dtr in dt3.Rows)
            //{
            //    if (dtr["RESULT"].ToString() == "0")
            //    {
            //        foreach (DataRow dtrow in dt.Rows)
            //        {
            //            if (dtrow["SIZE"].ToString() == "TOTAL")
            //            {
            //                if (dtrow["R_ORDEREDQTY"].ToString() != "")
            //                    dtrow["R_ORDEREDQTY"] = 0;
            //            }
            //        }
            //    }
            //}
            dt.Columns["DATE TIME"].SetOrdinal(1);
            Session["DT"] = dt;
            Session["FileName"] = "Lot Wise Report";
            GridView1.DataSource = dt;
            GridView1.DataBind();
            // GridView1.Columns[4].HeaderText = "ORDER QTY";
            foreach (GridViewRow row in GridView1.Rows)
            {
                if (row.Cells[0].Text.Trim() == "TOTAL")
                {
                    row.BackColor = Color.LightSeaGreen;
                    row.ForeColor = Color.White;
                }
                if (row.Cells[0].Text.Trim() == "G TOTAL")
                {
                    row.BackColor = Color.LightSlateGray;
                    row.ForeColor = Color.White;
                }
            }

        }
     
    

    


    }
}