<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmLotReportNew.aspx.cs" Inherits="WCPM.frmLotReportNew" %>

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
   <script type="text/javascript">
       function PrintDiv() {
           //alert('HI');
           //document.getElementById("Buttonprint").style.display = "none";
           //document.getElementById("Buttonprint").style.visibility = "hidden";
           //window.print();

           var divContents = document.getElementById("dvContentsPrint").innerHTML;
           var printWindow = window.open('', '', 'height=800,width=800');
           printWindow.document.write('<html><head><title> Lot Wise Report</title>');
           printWindow.document.write('</head><body >');
           printWindow.document.write(divContents);
           printWindow.document.write('</body></html>');
           printWindow.document.close();
           printWindow.print();
       }
    </script>


    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      
    <style>
        .ajax__calendar_container
{
    position: relative;
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
    <div id="dvgridheading" style="height: 20px;">
         <div class="right">
         <a href="#" id="id123" onclick="PrintDiv(); ">
                <img src="images/print.png" width="30px" />
            </a>

    </div>
       <table style="width:450px;">
            <tr>
                <th align="left">
                    Enter Lot Number:</th>
                <th align="left">
                    <asp:TextBox ID="txtLotNUmber" runat="server" AutoCompleteType="Disabled"></asp:TextBox>

                </th>
                 
                <th align="left">
                    <asp:ImageButton ID="btnSearchReport" runat="server" ImageUrl="~/images/serch b.png" Height="30Px" Width="30px" 
                        OnClientClick="if(!ValidateData1()) return false;" OnClick="btnSearchReport_Click" />
<%--                    <asp:Button ID="btnSearch" Text="Search" runat="server" OnClick="btnSearch_Click" />--%>
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

      <div id="DynamicDivShow" runat="server" style="display: block;  overflow: scroll; height: 500px;">
               
            </div>
        <div id="dvContentsPrint" style="display: block; visibility: hidden;">
            <div id="DynamicDivPrint" runat="server" class="portlet-body"></div>
        </div>
    <%--</div>--%>
</asp:Content>
