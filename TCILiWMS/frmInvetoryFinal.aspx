<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmInvetoryFinal.aspx.cs" Inherits="WCPM.frmInvetoryFinal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript" src="javascript/jquery.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#inventory').dataTable({
                "sScrollY": 250,
                "sScrollX": "100%"
            });
        });
    </script>
    <script type="text/javascript">
        function ShowchildReelCreation(Rollid) {
            debugger;
            var x = screen.width / 2 - 900 / 2;
            var y = screen.height / 2 - 400 / 2;

            //window.open(meh.href, 'sharegplus', 'height=485,width=700,left=' + x + ',top=' + y);
            window.open("frmLotReport.aspx?lot=" + Rollid, 'AllCustomers', 'location=1,status=1,resizable=no,scrollbars=2,width=830,height=400,left=' + x + ',top=' + y);
        }
    </script>
    <style type="text/css">
        * {
            font-family: Arial, sans-serif;
            font-size: 12px;
        }

        table.lamp {
            padding: 0px;
            border: 1px solid #d4d4d4;
            overflow: hidden;
            white-space: nowrap;
        }

            table.lamp th {
                color: white;
                background-color: #666;
                padding: 10px;
                padding-left: 10px;
                text-align: left;
                cursor: pointer;
                *cursor: hand;
            }

            table.lamp td {
                padding: 4px;
                padding-left: 10px;
                background-color: #ffffff;
            }

        table.scorecard {
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            padding: 0px;
            overflow: hidden;
            white-space: nowrap;
        }

            table.scorecard th {
                color: #000;
                background-color: #fff;
                padding: 10px;
                padding-left: 10px;
                text-align: center;
                font-size: 20px;
                height: 33px;
                border-right: 1px solid #4977AA;
                border-bottom: 1px solid #4977AA;
            }

                table.scorecard th span {
                    color: #000;
                    background-color: #fff;
                    padding: 10px;
                    padding-left: 10px;
                    text-align: center;
                    font-size: 20px;
                    height: 33px;
                }

                table.scorecard th.data {
                    color: #000;
                    background-color: #fff;
                    padding: 10px;
                    padding-left: 10px;
                    text-align: center;
                    font-size: 20px;
                    height: 20px;
                    border-right: 1px solid #4977AA;
                    border-bottom: 1px solid #4977AA;
                    font-size: 15px;
                }

            table.scorecard td, table.scorecard td span {
                padding: 4px;
                padding-left: 10px;
                text-align: center;
                background-color: #ffffff;
                font-size: 20px;
                font-weight: bold;
                height: 46px;
                font-size: 30px;
            }

        rightsss {
            background-color: blue;
            height: 40% !important;
            width: 50% !important;
            float: left !important;
        }

        left {
            background-color: red !important;
            height: 40% !important;
            width: 50% !important;
            float: left !important;
            /*background-color: Red; height: 40%; width: 50%; float: left*/
        }

        #rightcontent_divright {
            background-color: blue;
            height: 22% !important;
            width: 50% !important;
            float: left !important;
        }

        #rightcontent_divleft {
            background-color: red !important;
            height: 22% !important;
            width: 50% !important;
            float: left !important;
            /*background-color: Red; height: 40%; width: 50%; float: left*/
        }

        div #TotalCounts {
            height: 150px !important;
            margin-top: 19px;
        }

        div #locations {
            height: 150px !important;
        }

        #inventory_wrapper {
            margin-top: -25px !important;
        }

        .auto-style1 {
            width: 5px;
        }
    </style>
    <script type="text/javascript" src="javascript/jquery.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div id="topcontent">
        <div class="left1">
            <div id="locations">
                <asp:TreeView ID="tvLocationView" Font-Names="Calibri" Font-Size="Small" ShowLines="true"
                    SelectedNodeStyle-Font-Bold="true" SelectedNodeStyle-ForeColor="Green"
                    runat="server" OnSelectedNodeChanged="tvLocationView_SelectedNodeChanged" Width="200px">
                </asp:TreeView>
            </div>
        </div>
        <div class="left">
            <div id="dvtotalcounts">
                <div id="TotalCounts" style="width: 533px; margin-top: 20px;">
                    <table class="scorecard" cellpadding="0" cellspacing="0" width="100%" height="100%">
                        <%--<tr>
                            <th colspan="5" style="border-right: none;">
                                <asp:Label ID="lblHeading" runat="server" Text="WCPM"></asp:Label>
                            </th>
                        </tr>--%>
                        <tr>
                            <th class="data" style="width: 50%;" colspan="2">Day
                            </th>
                            <th class="data" style="width: 50%;" colspan="2">Month
                            </th>

                        </tr>
                        <tr>
                            <th class="data1">Total Reels

                            </th>
                            <th class="data1">Total Weight

                            </th>
                            <th class="data1">Total Reels

                            </th>
                            <th class="data1">Total Weight

                            </th>
                        </tr>
                        <tr>
                            <td style="border-right: 1px solid #4977AA;">
                                <asp:Label ID="lblTotalReelCountforDay" runat="server" Text="0"></asp:Label>
                            </td>
                            <td style="border-right: 1px solid #4977AA;">

                                <asp:Label ID="lblTotalWeightforDay" runat="server" Text="0"></asp:Label></a>
                            </td>
                            <td style="border-right: 1px solid #4977AA;">

                                <asp:Label ID="lblTotalReelCountforMonth" runat="server" Text="0"></asp:Label></a>
                            </td>
                            <td style="border-right: 1px solid #4977AA;">

                                <asp:Label ID="lblTotalWeightforMonth" runat="server" Text="0"></asp:Label></a>
                            </td>


                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>


    <table border="0" cellpadding="0" cellspacing="3" width="100%">
        <tr>
            <td>Lot Number&nbsp; </td>
            <td>:</td>
            <td>
                <asp:TextBox ID="txtLotNUmber" runat="server" Width="70px" Style="padding-left: 2px;" AutoCompleteType="Disabled"></asp:TextBox>&nbsp;&nbsp;
            </td>
            <td><span>Reel Id</span></td>
            <td class="auto-style1">:</td>
            <td>
                <asp:TextBox ID="txtReelNumber" runat="server" Width="70px" Style="padding-left: 2px;" AutoCompleteType="Disabled"></asp:TextBox>&nbsp;&nbsp;
                    
            </td>
            <td><span>From Date</span></td>
            <td>:</td>
            <td>
                <asp:TextBox ID="txtFromDate" runat="server" Width="70px" Style="padding-left: 2px;" AutoCompleteType="Disabled"></asp:TextBox>&nbsp;&nbsp;
                  <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" BehaviorID="txtFromDate_CalendarExtender" TargetControlID="txtFromDate" Format="dd-MM-yyyy" />
            </td>

            <td><span>To Date</span></td>
            <td>:</td>
            <td>
                <asp:TextBox ID="txtToDate" runat="server" Width="70px" ToolTip="Eg. 01-Dec-13" Style="padding-left: 2px;" AutoCompleteType="Disabled"></asp:TextBox>
                <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" BehaviorID="txtToDate_CalendarExtender" TargetControlID="txtToDate" Format="dd-MM-yyyy" />

            </td>

            <%--<td>Shift</td>
                <td>:</td>
                <td>
                    <asp:DropDownList ID="ddlShifts" runat ="server"></asp:DropDownList>
                     <asp:RequiredFieldValidator ID="rfvShifts" runat="server" ErrorMessage="*" ControlToValidate="ddlShifts"
                        ForeColor="Red" ValidationGroup="loc" InitialValue="Select"></asp:RequiredFieldValidator>
                </td>--%>
            <td>
                <asp:Button ID="btnSearch" runat="server" Text=" Search " ValidationGroup="loc" OnClick="btnSearch_Click" />


            </td>
        </tr>
    </table>
    <br />
    <br />



    <asp:ListView ID="lvLabelled" runat="server">
        <LayoutTemplate>
            <%--<table class="lamp table-striped table-bordered table-hover table-bordered dataTable" cellpadding="0" cellspacing="0" width="100%" id="inventory">--%>
            <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" id="inventory">
                <thead>
                    <tr>
                        <th style="width: 10px;">S.No.</th>
                        <th>Reel ID</th>

                        <th>Lot Number</th>
                        <th>Size</th>
                        <th>Quality</th>

                        <th>GSM</th>
                        <th>Reel Serial Number</th>

                        <th>Shift</th>
                        <th>Machine Number</th>
                        <th>Weight</th>
                        <th>Status</th>
                        <th>User</th>
                        <th>Time Stamp</th>

                    </tr>
                </thead>


                <tbody id="ItemPlaceholder" runat="server">
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr>
                <td><%# Eval("ID")%></td>
                <td><%# Eval("REEL ID")%></td>
           <%--   <td><%# Eval("LOT NUMBER")%></td>--%>

                <td>
                     <%# Eval("LOT NUMBER")%>
                   <%-- <a href="#" id="id123" onclick="ShowchildReelCreation('<%# Eval("LOT NUMBER")%>'); ">
                        <%# Eval("LOT NUMBER")%>
                    </a>--%>
                </td>
             
                <td><%# Eval("SIZE")%></td>
                <td><%# Eval("QUALITY")%></td>
                <td><%# Eval("GSM")%></td>
             
                 <td>
                     <asp:LinkButton runat="server" ID="btnreprint" Text='  <%# Eval("RSN")%>' OnClick="btnreprint_Click" ValidationGroup='<%# Eval("REEL ID")%>'></asp:LinkButton>
                 </td>
                <td><%# Eval("SHIFT")%></td>
                <td><%# Eval("MACHINE NUMBER")%></td>
                <td><%# Eval("WEIGHT")%></td>
                   <td><%# Eval("STATUS")%></td>
                <td><%# Eval("USERNAME")%></td>
             
                <td><%# Eval("TIME STAMP")%></td>

            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <table class="lamp">
                <tr>
                    <th style="width: 10px;">S.No.</th>
                    <th>Reel ID</th>

                    <th>Lot Number</th>
                    <th>Size</th>
                    <th>Quality</th>

                    <th>GSM</th>
                         <th>Reel Serial Number</th>
                    <th>Shift</th>
                    <th>Machine Number</th>
                    <th>Weight</th>
                      <th>Status</th>
                    <th>User</th>
                  
                    <th>Time Stamp</th>

                </tr>
                <tr>
                    <td colspan="15">No Records Found.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:ListView>
    <%--</div>--%>
    <%--</div>--%>
</asp:Content>
