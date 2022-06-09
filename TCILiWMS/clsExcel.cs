using System.Data;
using System.Drawing;
using System.IO;
using System.Windows;
using OfficeOpenXml;
using OfficeOpenXml.Style;





namespace WCPM
{
    static class clsExportoExcel
    {
   

        public static DataTable DataViewAsDataTable(DataView dv)
        {
            DataTable dt = dv.Table.Clone();
            foreach (DataRowView drv in dv)
                dt.ImportRow(drv.Row);
            return dt;
        }

        public static void CreateExcelFile(DataTable tbl, string filePath, string worksheetName)
        {
            FileInfo newFile = new FileInfo(filePath);
            //Check for existance of file  
            if (newFile.Exists)
            {
                newFile.Delete();  // ensures we create a new workbook
                newFile = new FileInfo(filePath);
            }

            using (ExcelPackage pck = new ExcelPackage(newFile))
            {
                ExcelWorksheet ws = pck.Workbook.Worksheets.Add(worksheetName);
                ws.Cells["A1"].LoadFromDataTable(tbl, true);
               
                using (var range = ws.Cells[1, 1, 1, tbl.Columns.Count])
                {
                    range.Style.Font.Bold = true;
                    range.AutoFitColumns();
                    range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                    range.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.DarkBlue);
                    range.Style.Font.Color.SetColor(System.Drawing.Color.White);
                    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                }
                ws.Column(16).Width = 20;
                for (int i = 0; i < tbl.Columns.Count; i++)
                {
                    if (tbl.Columns[i].ColumnName.ToLower().Contains("time"))
                    {
                        //using (var range = ws.Cells["A:A"])
                        using (var range = ws.Cells[((char)('A' + (char)(i % 27))) + ":" + ((char)('A' + (char)(i % 27)))])
                        {
                            range.Style.Numberformat.Format = "dd-MM-yyyy HH:mm:ss";
                        }
                    }
                }
                for (int i = 0; i < tbl.Columns.Count; i++)
                {
                    if (tbl.Columns[i].ColumnName.ToLower().Contains("date"))
                    {
                        //using (var range = ws.Cells["A:A"])
                        using (var range = ws.Cells[((char)('A' + (char)(i % 27))) + ":" + ((char)('A' + (char)(i % 27)))])
                        {
                            range.Style.Numberformat.Format = "dd-MM-yyyy HH:mm:ss";
                        }
                    }
                }
                

                //Save the file.
                pck.Save();
            }
        }

     
        public static void CreateOrAppendExcelFile(DataTable tbl, string filePath, string worksheetName)
        {
            FileInfo newFile = new FileInfo(filePath);

            string startPoint;
            //Check for existance of file  
            if (newFile.Exists)
            {
                //newFile.Delete();  // ensures we create a new workbook
                newFile = new FileInfo(filePath);
                startPoint = "E1";
            }
            else
            {
                startPoint = "A1";
            }

            using (ExcelPackage pck = new ExcelPackage(newFile))
            {
                ExcelWorksheet ws;
                if (startPoint == "A1")
                {
                    ws = pck.Workbook.Worksheets.Add(worksheetName);
                    ws.Cells["A1"].LoadFromDataTable(tbl, true);
                    using (var range = ws.Cells[1, 1, 1, tbl.Columns.Count])
                    {
                        range.Style.Font.Bold = true;
                        range.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        range.Style.Fill.BackgroundColor.SetColor(Color.DarkBlue);
                        range.Style.Font.Color.SetColor(Color.White);
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    }
                }
                else
                {
                    ws = pck.Workbook.Worksheets[1];
                    ws.Cells[ws.Dimension.End.Row + 1, 1].LoadFromDataTable(tbl, false);
                }

                //SET GENERAL FORMATTING FOR ALL
                for (int i = 1; i <= ws.Dimension.End.Column; i++)
                {
                    ws.Column(i).Style.Numberformat.Format = "General";
                }

                // FOR DATETIME
                for (int i = 0; i < tbl.Columns.Count; i++)
                {
                    if (tbl.Columns[i].ColumnName.ToLower().Contains("time"))
                    {
                        //using (var range = ws.Cells["A:A"])
                        using (var range = ws.Cells[((char)('A' + (char)(i % 27))) + ":" + ((char)('A' + (char)(i % 27)))])
                        {
                            range.Style.Numberformat.Format = "dd-MM-yyyy HH:mm:ss";
                        }
                    }
                }
                for (int i = 0; i < tbl.Columns.Count; i++)
                {
                    if (tbl.Columns[i].ColumnName.ToLower().Contains("date"))
                    {
                        //using (var range = ws.Cells["A:A"])
                        using (var range = ws.Cells[((char)('A' + (char)(i % 27))) + ":" + ((char)('A' + (char)(i % 27)))])
                        {
                            range.Style.Numberformat.Format = "dd-MM-yyyy HH:mm:ss";
                        }
                    }
                }

                //SET WIDTH
                for (int i = 1; i <= ws.Dimension.End.Column; i++)
                {
                    ws.Column(i).AutoFit();
                }



                //CONDITIONAL FORMATTTING
                ws.ConditionalFormatting.RemoveAll();

                //string resultColumn = "E";
                //for (int i = 0; i < tbl.Columns.Count; i++)
                //{
                //    if (tbl.Columns[i].ColumnName.ToLower().Contains("result"))
                //    {
                //        resultColumn = ((char)('A' + (char)(i % 27))).ToString();
                //    }
                //}

                //ExcelAddress formatRangeAddress = new ExcelAddress(ws.Dimension.Address);
                //string statement = "$" + resultColumn + "1=\"FAIL\"";
                //var cond1 = ws.ConditionalFormatting.AddExpression(formatRangeAddress);


                //cond1.Style.Fill.PatternType = ExcelFillStyle.Solid;
                //cond1.Style.Fill.BackgroundColor.Color = Color.Red;
                //cond1.Style.Font.Color.Color = Color.White;
                //cond1.Style.Font.Bold = true;

                //cond1.Formula = statement;


                //Save the file.
                pck.Save();
            }
        }
    }
}
