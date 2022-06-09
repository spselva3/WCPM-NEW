using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using DragonFactory;
using System.Configuration;


namespace WCPM
{
    public partial class Master : System.Web.UI.MasterPage
    {
        string UserID;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] != null)
            {
                if (!IsPostBack)
                {
                    lblLoginName.Text = Session["UserName"].ToString();
                    lblmenutimestamp.Text = DateTime.Now.ToString("dd MMM, yyyy hh:mm tt");
                }
                RptModulelist.DataSource = GetDataSource();
                RptModulelist.DataBind();
            }
            else
            {
                Response.Redirect("frmSessionOut.aspx");
            }
        }

        private ArrayList GetDataSource()
        {
            ArrayList GroupModuleList = new ArrayList();
            ArrayList SubGroupModuleList = new ArrayList();
            ArrayList CategoriesList = new ArrayList();
            ArrayList ReportsList = new ArrayList();
            ArrayList Dashboard = new ArrayList();
            ArrayList EmptyList = new ArrayList();
            ArrayList Integration = new ArrayList();

            ArrayList arraydashboard = new ArrayList();

            CategoriesList.Add(new { Name = "USERS", Items = EmptyList });
            CategoriesList.Add(new { Name = "TARE_WEIGHT_MASTER", Items = EmptyList });
            CategoriesList.Add(new { Name = "QC_MASTER", Items = EmptyList });
            CategoriesList.Add(new { Name = "COLOR_MASTER", Items = EmptyList });
            CategoriesList.Add(new { Name = "GSM_MASTER", Items = EmptyList });
            if (Session["UserName"].ToString().ToUpper() == "ADMIN")
            {
                CategoriesList.Add(new { Name = "PREFIX_MASTER", Items = EmptyList });

            }
        

            Integration.Add(new { Name = "CONVERSIONHOUSE", Items = EmptyList });
            Integration.Add(new { Name = "DELETEREELS", Items = EmptyList });
            Integration.Add(new { Name = "REPLACE-REELS", Items = EmptyList });

            //Dashboard.Add(new { Name = "DAILY_REEL_SHEET", Items = EmptyList });
            Dashboard.Add(new { Name = "INVENTORY_REPORT", Items = EmptyList });
            Dashboard.Add(new { Name = "HISTORY", Items = EmptyList });
          //  Dashboard.Add(new { Name = "LOT_WISE_REPORT", Items = EmptyList });
            Dashboard.Add(new { Name = "BALANCE_REEL_REPORT", Items = EmptyList });
            Dashboard.Add(new { Name = "PACKED_REPORT", Items = EmptyList });
            Dashboard.Add(new { Name = "LOWERING_REPORT", Items = EmptyList });
            Dashboard.Add(new { Name = "SEQ_WISE_REPORT", Items = EmptyList });
            Dashboard.Add(new { Name = "LOTREPORT", Items = EmptyList });
          
            SubGroupModuleList.Add(new { Name = "CATEGORIES", Categories = CategoriesList });
         
            SubGroupModuleList.Add(new { Name = "TRANSACTIONS", Categories = Integration });

            SubGroupModuleList.Add(new { Name = "REPORT", Categories = Dashboard });
        



            GroupModuleList.Add(new { GroupName = "WCPM", Categories = SubGroupModuleList });
            return GroupModuleList;
        }

        protected void RptItemslist_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                Repeater RptSubItemlist = (Repeater)e.Item.FindControl("RptSubItemlist");
                if (RptSubItemlist != null)
                {
                    string SubClickedItem = Request.QueryString["name"];
                    RptSubItemlist.Visible = (RptSubItemlist.Items.Count > 0) ? true : false;
                }
            }
        }

        protected void Unnamed_ServerClick(object sender, EventArgs e)
        {
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            MSSQLHelper.ExecSqlNonQuery("SP_UPDATELOGINSTATUS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                          
                            new SqlParameter("@USER",Session["UserName"]),
                            new SqlParameter("@STATUS",false),
                          
                        });
           // clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.LOGOUT, "user logged in succssfully", Session["UserName"].ToString(), Session["LineNUmber"].ToString());

            Response.Redirect("frmlogin.aspx");
        }
    }
}