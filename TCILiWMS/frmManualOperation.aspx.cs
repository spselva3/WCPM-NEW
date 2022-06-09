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
    public partial class frmManualOperation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"].ToString();
            MSSQLHelper.ExecSqlNonQuery("SP_TBLINSERTPRODUCTIONORDERS", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                            new SqlParameter("@PO_PODUCTIONORDER",  txtProductionOrder.Text),
                            new SqlParameter("@PO_ROLLID",  txtLOtNumber.Text),
                            new SqlParameter("@PO_QUALITY", ddlQuality.SelectedValue),
                            new SqlParameter("@PO_GSM",  ddlGsm.SelectedValue),
                            new SqlParameter("@PO_DIA",  dllCoeDia.SelectedValue),
                            new SqlParameter("@PO_SIZE", txtSize.Text),
                            new SqlParameter("@PO_NOOFJOINTS", dllNumberofJoints.SelectedValue),
                            new SqlParameter("@PO_NOOFREELS",  txtNoReels.Text),
                            new SqlParameter("@PO_DATEOFMANUFACTURING", txtMFGGate.Text),
                            new SqlParameter("@PO_SHIFT",  dllShift.SelectedValue),
                            new SqlParameter("@PO_STATUS", "NA"),
                            new SqlParameter("@PO_MACHINENUMBER",  ddlMachineNumber.SelectedValue)
                                            }); 
            Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Production Order created successfully.')", true);
            clearall();
        }
        private void clearall()
        {
            txtProductionOrder.Text = string.Empty;
            txtLOtNumber.Text = string.Empty;
            ddlQuality.SelectedValue = "Please Select";

            ddlGsm.SelectedValue = "Please Select";
            dllCoeDia.SelectedValue = "Please Select";
            txtSize.Text = string.Empty;
            dllNumberofJoints.SelectedValue = "Please Select";
            txtNoReels.Text = string.Empty;
            txtMFGGate.Text = string.Empty;
            dllShift.SelectedValue = "Please Select";
            ddlMachineNumber.SelectedValue = "Please Select";
        }
        protected void btnClear_Click(object sender, EventArgs e)
        {
            clearall();
        }
    }
}