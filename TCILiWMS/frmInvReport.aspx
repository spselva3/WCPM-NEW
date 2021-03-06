<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmInvReport.aspx.cs" Inherits="WCPM.frmInvReport" %>

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
        function ShowDispatchPlanCreation() {
            var x = screen.width / 2 - 900 / 2;
            var y = screen.height / 2 - 400 / 2;
            //window.open(meh.href, 'sharegplus', 'height=485,width=700,left=' + x + ',top=' + y);
            window.open('frmCreateNewWorkOrder.aspx', 'AllCustomers', 'location=1,status=1,resizable=no,statusbar=0,menubar=0,toolbar=0,scrollbars=2,width=800,height=400,left=' + x + ',top=' + y);
        }
    </script>
    <script type="text/javascript">
        function ShowchildReelCreation(Rollid, size) {
            debugger;
            var x = screen.width / 2 - 900 / 2;
            var y = screen.height / 2 - 400 / 2;

            //window.open(meh.href, 'sharegplus', 'height=485,width=700,left=' + x + ',top=' + y);
            window.open("frmGenerateReels.aspx?Id=" + Rollid + "&size=" + size, 'AllCustomers', 'location=1,status=1,resizable=no,scrollbars=2,width=830,height=400,left=' + x + ',top=' + y);
        }
    </script>
   <%-- <script type="text/javascript">
        function ShowNoofJoints(Rollid, size) {
            debugger;
            var x = screen.width / 2 - 900 / 2;
            var y = screen.height / 2 - 400 / 2;

            //window.open(meh.href, 'sharegplus', 'height=485,width=700,left=' + x + ',top=' + y);
            window.open("frmLotnumbersNew.aspx?Id=" + Rollid + "&size=" + size, 'AllCustomers', 'location=1,status=1,resizable=no,scrollbars=2,width=830,height=120,left=' + x + ',top=' + y);
        }
    </script>--%>


    }

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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
     <div class="Middle" align="middle" style="font-size: 25px; color:blue">
            INVENTORY REPORT
        </div>
    <div id="dvgridheading" style="height: 20px;">
        <div>
            &nbsp;</div>
        <div>
        </div>
    <div>

    </div>
        <div>

    </div>





        <%-- <div class="right">
            <a id="A1" style="text-decoration: none" runat="server" onserverclick="HtmlAnchor_Click">
                              <img src="images/download.png" alt="Add Locations" width="30" runat="server" id="imgdownload" /></a>
        </div>--%>
       
    </div>
    <%--<div id="gridcontainer"  style="height: auto; max-height: 300px;">--%>
    <br />

    <asp:ListView ID="lvLabelled" runat="server">
        <LayoutTemplate>
            <%--<table class="lamp table-striped table-bordered table-hover table-bordered dataTable" cellpadding="0" cellspacing="0" width="100%" id="inventory">--%>
            <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" style="width: 100%;" id="inventory">
                <thead>
                    <tr>
                         <th style="width: 10px;">S.No.</th>
                        <th>Reel ID</th>
                       
                        <th>Lot Number</th>
                        <th>Size</th>
                        <th>Quality</th>

                        <th>GSM</th>
                      
                        <th>Shift</th>
                        <th>Machine Number</th>
                        <th>Weight</th>
                        <th>User</th>
                        <th>Status</th>
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
                 
                    <td><%# Eval("LOT NUMBER")%></td>
                    <td><%# Eval("SIZE")%></td>
                    <td><%# Eval("QUALITY")%></td>
                    <td><%# Eval("GSM")%></td>
                    
                    <td><%# Eval("SHIFT")%></td>
                    <td><%# Eval("MACHINE NUMBER")%></td>
                    <td><%# Eval("WEIGHT")%></td>
                    <td><%# Eval("USERNAME")%></td>
                    <td><%# Eval("STATUS")%></td>
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
                      
                        <th>Shift</th>
                        <th>Machine Number</th>
                        <th>Weight</th>
                        <th>User</th>
                        <th>Status</th>
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
</asp:Content>
