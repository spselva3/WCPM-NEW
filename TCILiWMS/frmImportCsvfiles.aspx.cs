using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using OfficeOpenXml;
using System.IO;
using System.Drawing;
using DragonFactory;
using System.Data.SqlClient;




namespace WCPM
{
    public partial class frmImportCsvfiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!(Page.IsPostBack))
            {
                GetAllImportHisttory();
            }
        }
        private void GetAllImportHisttory()
        {
            DataSet ds1 = MSSQLHelper.ExecSqlDataSet("SP_SELECTHISTORY", CommandType.StoredProcedure, new List<SqlParameter>()
                 {
                           
                                                    
                        });
            if (ds1.Tables.Count > 1)
            {
                DataTable dt = ds1.Tables[1]; 
                lvInventory.DataSource = ds1.Tables[1];
                lvInventory.DataBind();
            }
        }
    //    private void Importexcelfiles()
    //    {
    //        DataTable dtHeader = null;
           
    //        ExcelPackage pkg = new ExcelPackage(FileUploader.FileContent);
    //        foreach (OfficeOpenXml.ExcelWorksheet worksheets in pkg.Workbook.Worksheets)
    //        {
    //            try
    //            {
    //                dtHeader = GetWorksheetAsDataTable(worksheets);
    //            }
    //            catch (Exception)
    //            {

    //            }

    //            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"];
    //            if (dtHeader.Rows.Count > 0)
    //            {
    //                foreach (DataRow dtrow in dtHeader.Rows)
    //                {
    //                    dtrow["Production Order"].ToString();


    //                    DataTable dt = MSSQLHelper.ExecSqlDataSet("SP_TBLINSERTPRODUCTIONORDERS", CommandType.StoredProcedure, new List<SqlParameter>()
    //                    {
                           
    //                    new SqlParameter("@PO_PODUCTIONORDER" ,  dtrow["Production Order"].ToString()),
    //new SqlParameter("@PO_ROLLID" ,  dtrow["Lot No / Roll ID"].ToString()),
    //new SqlParameter("@PO_QUALITY" ,  dtrow["Quality"].ToString()),
    //new SqlParameter("@PO_GSM" ,  dtrow["GSM"].ToString()),
    //new SqlParameter("@PO_DIA" ,  dtrow["Core / Dia"].ToString()),
    //new SqlParameter("@PO_SIZE" ,  dtrow["Size / Width (cm)"].ToString()),
    //new SqlParameter("@PO_NOOFJOINTS" ,  dtrow["No. of joints"].ToString()),
    //new SqlParameter("@PO_NOOFREELS" ,  dtrow["No. of Reels"].ToString()),
    //new SqlParameter("@PO_DATEOFMANUFACTURING"  ,  dtrow["Date of Manufacturing"].ToString()),
    //new SqlParameter("@PO_SHIFT" ,  dtrow["Shift"].ToString()),
    //new SqlParameter("@PO_STATUS"  ,  "PENDING"),
    //new SqlParameter("@PO_MACHINENUMBER" ,  dtrow["Machine Number"].ToString()),
    //   new SqlParameter("@PO_JUMBOID",  '0'),
    //       new SqlParameter("@USER",  Session["UserName"])
    //                    }).Tables[0];
    //                    foreach (DataRow dtr in dt.Rows)
    //                    {
    //                      //  lblErrorMessage.Text = dtr["RESULT"].ToString();
    //                        if (dtr["RESULT"].ToString().Contains("DUPLICATE ROLL ID FOUND"))
    //                        {
    //                           // lblErrorMessage.ForeColor = Color.Red;
    //        //                  i  ViewState["FileName"] = FileUploader.FileName;
    //        //ViewState["FileNameForHistory"] = String.Empty;

                               

    //                            if (ViewState["FileName"].ToString() != ViewState["FileNameForHistory"].ToString())
    //                            {
    //                                ViewState["FileNameForHistory"] = ViewState["FileName"];
    //                                clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.IMPORT_DATA, "NA",
    //                                    Session["UserName"].ToString(), Session["LineNUmber"].ToString(),
    //                                    ViewState["FileName"].ToString(), "Atempt to Upload duplicate records");
    //                            }


    //                        }
    //                        else
    //                        {
    //                          //  lblErrorMessage.ForeColor = Color.Green;

    //                            if (ViewState["FileName"].ToString() != ViewState["FileNameForHistory"].ToString())
    //                            {
    //                                ViewState["FileNameForHistory"] = ViewState["FileName"];
    //                                clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.IMPORT_DATA, "NA",
    //                                    Session["UserName"].ToString(), Session["LineNUmber"].ToString(),
    //                                    ViewState["FileName"].ToString(), "File Upload Success");
    //                            }

    //                        }

    //                    }

    //                }

    //            }

    //        }
    //    }
        private void Importexcelfiles()
        {
            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"];
            DataTable dtHeader = null;
       


           
                ExcelPackage pkg = new ExcelPackage(FileUploader.FileContent);
                try
                {


                    foreach (OfficeOpenXml.ExcelWorksheet worksheets in pkg.Workbook.Worksheets)
                    {
                        try
                        {
                            dtHeader = GetWorksheetAsDataTable(worksheets);
                            MSSQLHelper.SqlCon = ConfigurationManager.AppSettings["dbPharmaTracConnectionString"];
                            if (dtHeader.Rows.Count > 0)
                            {
                                foreach (DataRow dtrow in dtHeader.Rows)
                                {



                                    DataTable dt = MSSQLHelper.ExecSqlDataSet("SP_TBLINSERTPRODUCTIONORDERS", CommandType.StoredProcedure, new List<SqlParameter>()
                        {
                        new SqlParameter("@PO_ROLLID" ,  dtrow["Lot Number"].ToString()),
    new SqlParameter("@PO_QUALITY" ,  dtrow["Quality Name "].ToString()),
    new SqlParameter("@PO_GSM" ,  dtrow["GSM"].ToString()),
    new SqlParameter("@LOTPREFOX" ,  dtrow["Lot Prefix "].ToString()),
    new SqlParameter("@PO_QUALITYCODE" ,  dtrow["Quality Code"].ToString()),
    new SqlParameter("@PO_SIZE" ,  dtrow["Size"].ToString()),
    new SqlParameter("@PO_REMARKS" ,  dtrow["Remarks"].ToString()),
  
  
           new SqlParameter("@USER",  "By Win Service")
                        }).Tables[0];

                                }
                            }
                        }
                        catch (Exception ex)
                        {
                           // WriteToFile("Exception in Importing Excel file is  " + ex.Message + "  " + DateTime.Now);
                        }


                    }
                  //  moveFileToBackUpFolder(file.Name, _inputFilePath);
                }
                catch (Exception)
                {


                }
            }
        
        private void moveFileToBackUpFolder(string filename, string _inputFilePath)
        {
            try
            {
                string sourcePath = _inputFilePath;
                string targetPath = _inputFilePath + "\\Backup Files";

                string sourceFile = Path.Combine(sourcePath, filename);
                string destFile = Path.Combine(targetPath, filename);

                if (!Directory.Exists(targetPath))
                {
                    Directory.CreateDirectory(targetPath);
                }

                File.Move(sourceFile, destFile);
            }
            catch (Exception ex)
            {


            }


        }
        private static IEnumerable<DataColumn> GetDataColumns(ExcelWorksheet worksheet)
        {
            return GatherColumnNames(worksheet).Select(x => new DataColumn(x));
        }

        private static IEnumerable<string> GatherColumnNames(ExcelWorksheet worksheet)
        {
            var columns = new List<string>();

            var i = 1;
            var j = 1;
            var columnName = worksheet.Cells[i, j].Value;
            while (columnName != null)
            {
                columns.Add(GetUniqueColumnName(columns, columnName.ToString()));
                j++;
                columnName = worksheet.Cells[i, j].Value;
            }

            return columns;
        }

        private static string GetUniqueColumnName(IEnumerable<string> columnNames, string columnName)
        {
            var colName = columnName;
            var i = 1;
            while (columnNames.Contains(colName))
            {
                colName = columnName + i.ToString();
                i++;
            }
            return colName;
        }
        private static int GetTableDepth(ExcelWorksheet worksheet, int headerOffset)
        {
            var i = 1;
            var j = 1;
            var cellValue = worksheet.Cells[i + headerOffset, j].Value;
            while (cellValue != null)
            {
                i++;
                cellValue = worksheet.Cells[i + headerOffset, j].Value;
            }

            return i - 1; //subtract one because we're going from rownumber (1 based) to depth (0 based)
        }

        public static DataTable GetWorksheetAsDataTable(ExcelWorksheet worksheet)
        {
            var dt = new DataTable(worksheet.Name);
            dt.Columns.AddRange(GetDataColumns(worksheet).ToArray());
            var headerOffset = 1; //have to skip header row
            var width = dt.Columns.Count;
            var depth = GetTableDepth(worksheet, headerOffset);
            for (var i = 1; i <= depth; i++)
            {
                var row = dt.NewRow();
                for (var j = 1; j <= width; j++)
                {
                    var currentValue = worksheet.Cells[i + headerOffset, j].Value;

                    //have to decrement b/c excel is 1 based and datatable is 0 based.
                    row[j - 1] = currentValue == null ? null : currentValue.ToString();
                }

                dt.Rows.Add(row);
            }

            return dt;
        }
        private bool validateImportedFileType(string filType)
        {
            
            string fileExtension = Path.GetExtension(FileUploader.PostedFile.FileName.ToString());
            //if (fileExtension == ".xls" || fileExtension == ".xlsx")
            if (fileExtension == filType)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        protected void btnUpload_Click(object sender, EventArgs e)
        {
            ViewState["FileName"] = FileUploader.FileName;
            ViewState["FileNameForHistory"] = String.Empty;

            if (FileUploader.HasFile)
            {
                if (validateImportedFileType(".csv") || validateImportedFileType(".xlsx"))
                {

                    Importexcelfiles();
                    GetAllImportHisttory();
                }
                else
                {
                    clsHsitory.updateHistory(clsHsitory.HistoryTransactionCodes.IMPORT_DATA, "NA", Session["UserName"].ToString(), Session["LineNUmber"].ToString(), FileUploader.FileName, "Attempt to upload Invalid File");

                    lblErrorMessage.Text = "Invalid file";
                    lblErrorMessage.ForeColor = Color.Red;
                    GetAllImportHisttory();
                }
            }
            else
            {

                lblErrorMessage.Text = "No file Choosen";
                lblErrorMessage.ForeColor = Color.Red;

            }
        }

    }
}