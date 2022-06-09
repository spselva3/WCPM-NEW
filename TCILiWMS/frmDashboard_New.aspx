<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmDashboard_New.aspx.cs" Inherits="WCPM.frmDashboard_New" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>SIGNODE - MATERIAL TRACKING SYSTEM</title>
    <link rel="shortcut icon" href="images/Icon.ico" />
    <%--<meta http-equiv="refresh" content="5" />--%><%--<link id="lnkDashBordHome" href="css/cmsreport.css" rel="Stylesheet" type="text/css" />--%>
    <script src="javascript/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="javascript/jquery1.9.1.min.js" type="text/javascript"></script>
    <link href="new/style.css" rel="stylesheet" />

    <!--Loading bootstrap css-->

    <link type="text/css" rel="stylesheet" href="styles/font-awesome.min.css" />
    <link type="text/css" rel="stylesheet" href="styles/bootstrap.min.css" />
    <link type="text/css" rel="stylesheet" href="styles/animate.css" />
    <link type="text/css" rel="stylesheet" href="styles/all.css" />
    <link type="text/css" rel="stylesheet" href="styles/main.css" />
    <link type="text/css" rel="stylesheet" href="styles/style-responsive.css" />
    <link type="text/css" rel="stylesheet" href="styles/zabuto_calendar.min.css" />
    <link type="text/css" rel="stylesheet" href="styles/pace.css" />
    <link type="text/css" rel="stylesheet" href="styles/jquery.news-ticker.css" />
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <style>
        label {
            color: #B4886B;
            font-weight: bold;
            display: block;
            width: 150px;
            float: left;
        }
    </style>
    <style>
        .clickme {
            background-color: #EEEEEE;
            padding: 8px 20px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 5px;
            color: #10a2ff;
            cursor: pointer;
        }

        .mydatagrid {
            width: 80%;
            border: solid 2px black;
            min-width: 80%;
        }

        .header {
            background-color: #646464;
            font-family: Arial;
            color: White;
            border: none 0px transparent;
            height: 25px;
            text-align: center;
            font-size: 16px;
        }



        .rows {
            background-color: #fff;
            font-family: Arial;
            font-size: 14px;
            color: #000;
            min-height: 25px;
            text-align: left;
            border: none 0px transparent;
        }

            .rows:hover {
                background-color: #ff8000;
                font-family: Arial;
                color: #fff;
                text-align: left;
            }

        .selectedrow {
            background-color: #ff8000;
            font-family: Arial;
            color: #fff;
            font-weight: bold;
            text-align: left;
        }

        .mydatagrid a /** FOR THE PAGING ICONS  **/ {
            background-color: Transparent;
            padding: 5px 5px 5px 5px;
            color: #fff;
            text-decoration: none;
            font-weight: bold;
        }



            .mydatagrid a:hover /** FOR THE PAGING ICONS  HOVER STYLES**/ {
                background-color: #000;
                color: #fff;
            }

        .mydatagrid span /** FOR THE PAGING ICONS CURRENT PAGE INDICATOR **/ {
            background-color: #c9c9c9;
            color: #000;
            padding: 5px 5px 5px 5px;
        }

        .pager {
            background-color: #646464;
            font-family: Arial;
            color: White;
            height: 30px;
            text-align: left;
        }



        .mydatagrid td {
            padding: 5px;
        }

        .mydatagrid th {
            padding: 5px;
        }
    </style>
    <style type="text/css">
        .cssPager span {
            background-color: #4f6b72;
            font-size: 18px;
        }

        .cssPager td {
            padding-left: 4px;
            padding-right: 4px;
        }
    </style>
    <script type="text/javascript">
        function Search_Gridview(strKey, strGV) {
            debugger;
            var strData = strKey.value.toLowerCase().split(" ");
            var tblData = document.getElementById(strGV);
            var rowData;

            for (var i = 1; i < tblData.rows.length; i++) {
                rowData = tblData.rows[i].innerHTML;
                var styleDisplay = 'none';
                for (var j = 0; j < strData.length; j++) {
                    if (rowData.toLowerCase().indexOf(strData[j]) >= 0)
                        styleDisplay = '';
                    else {
                        styleDisplay = 'none';
                        break;
                    }
                }
                tblData.rows[i].style.display = styleDisplay;
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="wrapper">
            <nav class="navbar-top" role="navigation">
                <div class="nav-top">
                    <ul class="nav navbar-left">
                        <li>
                            <img src="images/signode_logo_4.jpg" alt="Signode" width="180" style="padding-top: 2px; height: 48px;" />
                        </li>
                    </ul>
                    <div class="navbar-brand">
                        <a style="text-align: center; padding-left: 200px; font-size: 21px; text-decoration: none;">MATERIAL TRACKING SYSTEM</a>
                    </div>
                    <ul class="nav navbar-right">
                        <li class="dropdown">
                            <img src="images/wesco-main-logo.png" alt="Signode" width="100" style="padding-top: 2px; height: 48px;" />
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
        <div>
            <div class="page-title-breadcrumb" style="background-color: lightgoldenrodyellow; height: 50px;">
                <div class="page-header pull-left">
                    <div class="page-title" style="padding-bottom: 5px;">
                    </div>
                </div>
                <ol class="breadcrumb page-breadcrumb pull-right" style="color: darkblue; font-size: 20px; font-weight: bold;">
                    <asp:Label ID="lblname1" runat="server"></asp:Label>
                    <i class="fa fa-user"></i><i class="fa fa-caret-down"></i>
                </ol>
                <div class="clearfix">
                </div>
            </div>
            <div style="height: 3px; background-color: #20bfd5;"></div>

            <div class="row" style="margin-left: -25px;" id="menu">
                <div class="col-lg-12">
                    <div class="col-lg-12" style="background-color: #20bfd5">
                        <%--<div class="col-lg-1 col-sm-6">
                                 </div>--%>
                    </div>
                </div>
            </div>


        </div>




        <table style="width: 100%;">
            <tr style="background-color: white">
                <td colspan="3" style="padding-top: 5px; padding-bottom: 5px">
                    <a href="frmProductionOrder.aspx">
                        <asp:Image ID="imgBack" runat="server" ImageUrl="~/images/BackbtnDashboard.jpg" Height="35px" Width="35px"
                            ToolTip="Back" />
                        <asp:Label ID="lbldatetime" runat="server" Text="" CssClass="label "></asp:Label>
                    </a>
                </td>
            </tr>

            <%--  <tr>
                <td colspan="3" style="padding-top: 5px"></td>
            </tr>--%>
            <tr>
                <td style="padding-left: 10px;">
                    <table style="border-radius: 15px 15px 15px 15px; background-color: #be2424; width: 350px; height: 130px;">
                        <tr>
                            <td style="text-align: center" colspan="2">
                                <asp:Label ID="Label4" runat="server" Text="DAY" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: center">
                                <asp:Label ID="Label11" runat="server" Text="No of Reels" ForeColor="White" Font-Bold="True" Font-Size="X-Large"></asp:Label>
                            </td>
                            <td style="text-align: center">
                                <asp:Label ID="Label12" runat="server" Text="Weight" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <asp:Label ID="lblDayTotalReels" runat="server" Text="32" ForeColor="White" Font-Bold="True" Font-Size="Large"></asp:Label>
                            </td>
                            <td style="text-align: center">
                                <asp:Label ID="lblDayTotalWeight" runat="server" Text="34.236" ForeColor="White" Font-Bold="True" Font-Size="Large"></asp:Label>
                            </td>

                        </tr>

                    </table>
                </td>

                <td style="padding-left: 10px;">
                    <table style="border-radius: 15px 15px 15px 15px; background-color: #1875ce; width: 350px; height: 130px;">
                        <tr>
                            <td style="text-align: center" colspan="2">
                                <asp:Label ID="Label2" runat="server" Text="MONTH" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: center">
                                <asp:Label ID="Label6" runat="server" Text="No. of Reels" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                            <td style="text-align: center">
                                <asp:Label ID="Label8" runat="server" Text="Weight" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <asp:Label ID="lblMonthTotalReels" runat="server" Text="220" ForeColor="White" Font-Bold="True" Font-Size="Large"></asp:Label>
                            </td>
                            <td style="text-align: center">
                                <asp:Label ID="lblMonthTotalWeight" runat="server" Text="3435.234" ForeColor="White" Font-Bold="True" Font-Size="Large"></asp:Label>
                            </td>
                        </tr>

                    </table>
                </td>

                <td style="padding-left: 10px;">
                    <table style="border-radius: 15px 15px 15px 15px; background-color: #ff6a00; width: 350px; height: 130px;">
                        <tr>
                            <td style="text-align: center" colspan="2">
                                <asp:Label ID="Label5" runat="server" Text="TOTAL" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <asp:Label ID="Label15" runat="server" Text="No of Reels" ForeColor="White" Font-Bold="True" Font-Size="X-Large"></asp:Label>
                            </td>
                            <td style="text-align: center">
                                <asp:Label ID="Label16" runat="server" Text="Weight" ForeColor="White" Font-Bold="true" Font-Size="X-Large"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center">
                                <asp:Label ID="lblTotalReels" runat="server" Text="3355" ForeColor="White" Font-Bold="True" Font-Size="Large"></asp:Label>
                            </td>
                            <td style="text-align: center">
                                <asp:Label ID="lblTotalWeight" runat="server" Text="6565.23" ForeColor="White" Font-Bold="True" Font-Size="Large"></asp:Label>
                            </td>
                        </tr>

                    </table>
                </td>
            </tr>

        </table>
        <br />

        SEARCH:
         <br />
        <table>
            <tr>
                <td>
                    <asp:TextBox ID="txtSearch" runat="server" Font-Size="20px" onkeyup="Search_Gridview(this, 'gvMaterialdetails')" Height="30px" CssClass="clickme"></asp:TextBox>

                </td>
                <td>
                    <asp:Button ID="btnSearch" Text="Search in all pages" OnClick="btnSearch_Click" runat="server" Height="31px" CssClass="clickme" />

                    <td>
                        <asp:Button ID="btnRefresh" Text="Refresh" OnClick="btnRefresh_Click" runat="server" Height="31px" CssClass="clickme" />

                    </td>
            </tr>

        </table>

        <br />
        <br />

        <asp:GridView ID="gvMaterialdetails" runat="server" AutoGenerateColumns="False"
            OnPageIndexChanging="gvMaterialdetails_PageIndexChanging"
            Height="100%" Width="100%" CellPadding="5" CellSpacing="5" BorderStyle="Solid"
            ShowHeaderWhenEmpty="True" EmptyDataText="No Records Found" Font-Size="Medium"
            Font-Names="Calibri" AllowPaging="True" PageSize="10" ForeColor="Red">
            <FooterStyle BackColor="#CCCCCC" />
            <HeaderStyle BackColor="White" Font-Bold="True" ForeColor="Black" CssClass="mydatagrid" />

            <%--   <PagerSettings Mode="Numeric" PageButtonCount="4" PreviousPageText="Previous"
                NextPageText="Next" FirstPageText="First" LastPageText="Last" Position="TopAndBottom" />--%>

            <PagerSettings Mode="Numeric" Position="Bottom" />


            <PagerStyle CssClass="cssPager" Font-Bold="True" ForeColor="Maroon" HorizontalAlign="Center" Font-Size="Medium" />
            <RowStyle BackColor="White" />
            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="Gray" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#383838" />
            <Columns>
                <%-- <asp:TemplateField HeaderText="S.No">
                    <ItemTemplate>
                        <%# Container .DataItemIndex +1 %>
                    </ItemTemplate>
                </asp:TemplateField>--%>

                <asp:TemplateField HeaderText="SERIALNUMBER">
                    <ItemTemplate>
                        <asp:Label ID="lblpartno" runat="server" Text='<%#Eval("SERIALNUMBER") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="REELID">
                    <ItemTemplate>
                        <asp:Label ID="lblpartdes" runat="server" Text='<%#Eval("REELID") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="SIZE">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("SIZE") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="LOTNUMBER">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("LOTNUMBER") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="CREATEDDATETIME">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("CREATEDDATETIME") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="NO OF PRINTS">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("NO_OF_PRINTS") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="USER">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("USER") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="WEIGHT">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("WEIGHT") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="LINENUMBER">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("LINENUMBER") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="WEIGHT CAPTURED DATE">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("WEIGHT_CAPTURED_DATE") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="WEIGHT CAPTURED USER">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("WEIGHT_CAPTURED_USER") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="PRODUCTION ORDER">
                    <ItemTemplate>
                        <asp:Label ID="lblstatus" runat="server" Text='<%#Eval("PRODUCTION_ORDER") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
            <HeaderStyle BackColor="#4D92C1" ForeColor="White" />

        </asp:GridView>



    </form>
</body>
</html>
