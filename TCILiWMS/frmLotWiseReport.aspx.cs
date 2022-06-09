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
    public partial class frmLotWiseReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                  //  GetLabelledData();

                }
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }
        

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            DataSet ds = MSSQLHelper.ExecSqlDataSet("SP_SELECTLOTWISEREPORTNEW", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                   new SqlParameter("@LOTNUMBER", txtLotNUmber.Text),  
                          
                        });
            DataTable dt = ds.Tables[0];
            DataTable dt2 = ds.Tables[1];
            DataTable dt3 = ds.Tables[2];

            dt.Merge(dt2);
            dt.Columns.Remove("R_ROLLID");
            foreach (DataRow dtr in dt3.Rows)
            {
                if (dtr["RESULT"].ToString() == "0")
                {
                    foreach (DataRow dtrow in dt.Rows)
                    {
                        if (dtrow["SIZE"].ToString() == "TOTAL")
                        {
                            if (dtrow["R_ORDEREDQTY"].ToString() != "")
                                dtrow["R_ORDEREDQTY"] = 0;
                        }
                    }
                }
            }
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
                    row.BackColor = Color.Green;
                    row.ForeColor = Color.White;
                }
                if (row.Cells[0].Text.Trim() == "G TOTAL")
                {
                    row.BackColor = Color.Brown;
                    row.ForeColor = Color.White;
                }
            }

        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }
    }
}