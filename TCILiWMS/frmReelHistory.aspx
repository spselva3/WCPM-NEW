<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmReelHistory.aspx.cs" Inherits="WCPM.frmReelHistory" %>

<asp:Content ID="UserContentHead" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        * {
            font-family: Arial, sans-serif;
            font-size: 12px;
            background-color: aliceblue;
        }




        div.MaskedDiv {
            visibility: hidden;
            position: absolute;
            left: 0px;
            top: 0px;
            font-family: verdana;
            font-weight: bold;
            padding: 40px;
            z-index: 100;
            background-image: url("~/images/Mask.png"); /* ieWin only stuff url( "~/images/signode_logo_9.jpg" */
            _background-image: none;
            _filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=scale src='~/images/Mask.png' );
        }

        div.ModalPopup {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            font-style: normal;
            background-color: #CCCCCC;
            position: absolute; /* set z-index higher than possible */
            z-index: 10000;
            visibility: hidden;
            color: Black;
            border-style: solid;
            border-color: #999999;
            border-width: 1px;
            width: 50%;
            height: 200px;
        }
    </style>
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

        div.MaskedDiv {
            visibility: hidden;
            position: absolute;
            left: 0px;
            top: 0px;
            font-family: verdana;
            font-weight: bold;
            padding: 40px;
            z-index: 100;
            background-image: url("~/images/Mask.png"); /* ieWin only stuff url( "~/images/signode_logo_9.jpg" */
            _background-image: none;
            _filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=scale src='~/images/Mask.png' );
        }

        div.ModalPopup {
            font-family: Verdana, Arial, Helvetica, sans-serif;
            font-size: 11px;
            font-style: normal;
            background-color: #CCCCCC;
            position: absolute; /* set z-index higher than possible */
            z-index: 10000;
            visibility: hidden;
            color: Black;
            border-style: solid;
            border-color: #999999;
            border-width: 1px;
            width: 50%;
            height: 200px;
        }
    </style>
   
    
   
    <script type="text/javascript">
        function ShowDispatchPlanCreation() {
            var x = screen.width / 2 - 900 / 2;
            var y = screen.height / 2 - 400 / 2;
            //window.open(meh.href, 'sharegplus', 'height=485,width=700,left=' + x + ',top=' + y);
            window.open('frmCreateNewLines.aspx', 'AllCustomers', 'location=1,status=1,resizable=no,scrollbars=2,width=800,height=200,left=' + x + ',top=' + y);
        }
    </script>
    <script src="Javascript/jquery.dataTables.js" type="text/javascript"></script>
    <script src="Javascript/datatables-bs3.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="UserContentBody" ContentPlaceHolderID="rightcontent" runat="server">

    <div>
        <h1 align="middle">REEL HISTORY
        </h1>
    </div>
    <div width ="100%">
        <table>
            <tr>
                <th>
                    <asp:TextBox ID="txtSearch" runat="server">

                    </asp:TextBox>

                </th>
                <th>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="button"  />

                </th>
                

            </tr>

        </table>
     <asp:ListView ID="lvLabelled" runat="server">
        <LayoutTemplate>
            <%--<table class="lamp table-striped table-bordered table-hover table-bordered dataTable" cellpadding="0" cellspacing="0" width="100%" id="inventory">--%>
            <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" style="width: 400px;" id="inventory">
                <thead width="100%">
                    <tr>
                               <th>S No.</th>
                        <th>Production Order</th>
                        <th>Lot Number</th>
                        <th>Size</th>
                        <th>Quality</th>
                        <th>GSM</th>
                        <th>Dia</th>
                        <th>No Of Reels</th>
                        <th>Joints Type</th>
                        <th>MFG Date</th>
                        <th>Shift </th>
                        <th>Machine Number</th>
                        <th>Reel ID</th>
                        <th>Weight</th>
                     
                        <th>Status</th>
                    
                        <th>Action</th>
                        <th>Date Time</th>
                        <th>User</th>
                        <th>Line ID</th>
                    </tr>
                </thead>
                <tbody id="ItemPlaceholder" runat="server" width="100%">
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr>
                 <td><%# Eval("ID")%></td>
                    <td><%# Eval("PRODUCTION ORDER")%></td>
                    <td><%# Eval("LOT NUMBER")%></td>
                    <td><%# Eval("SIZE")%></td>
                    <td><%# Eval("QUALITY")%></td>
                    <td><%# Eval("GSM")%></td>
                    <td><%# Eval("DIA")%></td>
                    <td><%# Eval("NO OF REELS")%></td>
                    <td><%# Eval("NO OF JOINTS")%></td>
                    <td><%# Eval("MFG DATE")%></td>
                    <td><%# Eval("SHIFT")%></td>
                    <td><%# Eval("MACHINE NUMBER")%></td>
                    <td><%# Eval("REEL ID")%></td>
                    <td><%# Eval("WEIGHT")%></td>
                    <td><%# Eval("STATUS")%></td>
                    <td><%# Eval("ACTION")%></td>
                    <td><%# Eval("DATETIME")%></td>
                    <td><%# Eval("USER")%></td>
                    <td><%# Eval("LINE")%></td>
                   
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <table class="lamp">
                <tr>
                       <th>S No.</th>
                        <th>Production Order</th>
                        <th>Lot Number</th>
                        <th>Size</th>
                        <th>Quality</th>
                        <th>GSM</th>
                        <th>Dia</th>
                        <th>No Of Reels</th>
                        <th>Joints Type</th>
                        <th>MFG Date</th>
                        <th>Shift </th>
                        <th>Machine Number</th>
                        <th>Reel ID</th>
                        <th>Weight</th>
                     
                        <th>Status</th>
                    
                        <th>Action</th>
                        <th>Date Time</th>
                        <th>User</th>
                        <th>Line ID</th>
                </tr>
                <tr>
                   <td colspan="15">No Records Found.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:ListView>

    </div>
</asp:Content>
