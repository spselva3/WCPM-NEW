<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmPackedandBalanced.aspx.cs" Inherits="WCPM.frmPackedandBalanced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  
    <script type="text/javascript" src="javascript/jquery.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#inventory').dataTable({
                "sScrollY": 270,
                "sScrollX": "100%"
            });
        });
    </script>

    <script type="text/javascript">
        function PrintDiv() {
            //alert('HI');
            //document.getElementById("Buttonprint").style.display = "none";
            //document.getElementById("Buttonprint").style.visibility = "hidden";
            //window.print();

            var divContents = document.getElementById("dvContentsPrint").innerHTML;
            var printWindow = window.open('', '', 'height=800,width=800');
            printWindow.document.write('<html><head><title>Packed and Balance Report</title>');
            printWindow.document.write('</head><body >');
            printWindow.document.write(divContents);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>

     <script>
         function callMethod() {

             window.open("test form.aspx");

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
          
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
       <style>
        .btn {
            background-color: DodgerBlue;
            border: none;
            color: white;
            padding: 12px 30px;
            cursor: pointer;
            font-size: 20px;
        }

            /* Darker background on mouse-over */
            .btn:hover {
                background-color: RoyalBlue;
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
      <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="dvgridheading" style="height: 20px;">
         <div class="right">
           <a href="#" id="id123" onclick="callMethod(); ">
                <img src="images/Excel.jpg" width="30px" />
            </a>

            
    </div>
       

       <table style="width:600px;">
            <tr>
                <th align="left">
                    <asp:Label ID="label1" Text="Enter Date" runat="server"></asp:Label>

                </th>
                <th align="left">
                    <asp:TextBox ID="txtFromDate" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" BehaviorID="txtFromDtQuality_CalendarExtender" TargetControlID="txtFromDate" Format="dd-MM-yyyy" />
                </th>
                 <th align="left">
                    <asp:TextBox ID="txtToDate" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" BehaviorID="txtFromDtQuality_CalendarExtender2" TargetControlID="txtToDate" Format="dd-MM-yyyy" />

                </th>
                <th align="left">
                    <asp:ImageButton ID="btnSearchReport" runat="server" ImageUrl="~/images/serch b.png" Height="30Px" Width="30px" OnClientClick="if(!ValidateData1()) return false;" OnClick="btnSearchReport_Click" />
                    
                </th>




            </tr>
        </table>





        <%-- <div class="right">
            <a id="A1" style="text-decoration: none" runat="server" onserverclick="HtmlAnchor_Click">
                              <img src="images/download.png" alt="Add Locations" width="30" runat="server" id="imgdownload" /></a>
        </div>--%>
       
    </div>
    <%--<div id="gridcontainer"  style="height: auto; max-height: 300px;">--%>
    <br />

      <%--<div id="DynamicDivShow" runat="server" style="display: block;  overflow: scroll; height: 500px;">
               
            </div>
        <div id="dvContentsPrint" style="display: block; visibility: hidden;">
            <div id="DynamicDivPrint" runat="server" class="portlet-body"></div>
        </div>--%>

    <asp:ListView ID="lvLabelled" runat="server">
        <LayoutTemplate>
            <%--<table class="lamp table-striped table-bordered table-hover table-bordered dataTable" cellpadding="0" cellspacing="0" width="100%" id="inventory">--%>
            <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" style="width: 400px;" id="inventory">
                <thead>
                    <tr>
                      
                  
                        <th>Lot Number</th>
                     
                        <th>Quality</th>
                           <th>Color Grain</th>
                           <th>GSM</th>
                           <th>Size</th>
                     
                     
                        <th>Total Reels</th>
                        <th>Ordered Quantity</th>
                        <th>Completed Reels</th>
                        <th>Total Quantity</th>
                        <th>Pending Reels</th>

                    
                       
                     
                    </tr>
                </thead>
                <tbody id="ItemPlaceholder" runat="server">
                </tbody>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr>

              
                            <td><%# Eval("PO_ROLLID")%></td>
                
                    <td><%# Eval("PO_QUALITY")%></td>
                    <td><%# Eval("PO_COLOURGRAIN")%></td>
                    <td><%# Eval("PO_GSM")%></td>
                    <td><%# Eval("R_SIZE")%></td>
                    <td><%# Eval("TOTAL REELS")%></td>
                    <td><%# Eval("PO_ORDEREDQTY")%></td>
                    <td><%# Eval("COMPLETED REELS")%></td>
                    <td><%# Eval("TOTAL QTY")%></td>
                    <td><%# Eval("PENDING REELS")%></td>
                    
                    
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
                      <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" style="width: 400px;" id="inventory">
                <thead>
                      <tr>
                      
                  
                        <th>Lot Number</th>
                     
                        <th>Quality</th>
                           <th>Color Grain</th>
                           <th>GSM</th>
                           <th>Size</th>
                     
                     
                        <th>Balance Reels</th>
                    
                       
                     
                    </tr>
                </thead>
                <tbody id="ItemPlaceholder" runat="server">
                </tbody>
            </table>

        </EmptyDataTemplate>
    </asp:ListView>
    <%--</div>--%>
</asp:Content>
