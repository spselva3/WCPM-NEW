<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmShiftWiseReport.aspx.cs" Inherits="WCPM.frmShiftWiseReport" %>

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
                            <img src="images/download icon.png" width="30px" />
                        </a>
            
    </div>
       

       <table style="width:600px;">
            <tr>
                <th align="left">
                    <asp:Label ID="label1" Text="Enter Date" runat="server"></asp:Label>

                </th>
                <th align="left">
                    <asp:TextBox ID="txtDate" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                    <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" BehaviorID="txtFromDtQuality_CalendarExtender" TargetControlID="txtDate" Format="dd-MM-yyyy" />
                </th>
                 <th align="left">
                  <asp:DropDownList ID="ddlShift" runat="server"  style="height: 21px" >
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="A" Value="A"></asp:ListItem>
                                <asp:ListItem Text="B" Value="B"></asp:ListItem>
                                <asp:ListItem Text="C" Value="C"></asp:ListItem>
                            </asp:DropDownList>

                </th>
                <th align="left">
                    <asp:Button ID="btnSearch" Text="Search" runat="server" OnClick="btnSearch_Click" />
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

    <asp:ListView ID="lvLabelled" runat="server">
        <LayoutTemplate>
            <%--<table class="lamp table-striped table-bordered table-hover table-bordered dataTable" cellpadding="0" cellspacing="0" width="100%" id="inventory">--%>
            <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" style="width: 100%;" id="inventory">
                <thead>
                    <tr>
                       
                        <th>S No.</th>
                       
                        <th>Quality</th>
                      
                        <th>GSM</th>

                        <th>Lot No.</th>
                      
                        <th>Reel Serail Number</th>
                        <th>Width</th>
                        <th>Gross Weight</th>
                    
                        <th>RW. No.</th>
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
                    <td><%# Eval("QUALITY")%></td>
                 
                   
                    <td><%# Eval("GSM")%></td>
                    <td><%# Eval("LOT NUMBER")%></td>
                    <td><%# Eval("REEL SERAIL NUMBER")%></td>
                    <td><%# Eval("SIZE")%></td>
                    <td><%# Eval("GROSS WEIGHT")%></td>
                 
                    <td><%# Eval("RW NO")%></td>
                    <td><%# Eval("TIMESTAMP")%></td>
            
                  
                    
                   
               
            </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <table class="lamp">
               <tr>    <th>S No.</th>
                       
                        <th>Quality</th>
                      
                        <th>GSM</th>

                        <th>Lot No.</th>
                      
                        <th>Reel Serail Number</th>
                        <th>Width</th>
                        <th>Gross Weight</th>
                    
                        <th>RW. No.</th>
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
