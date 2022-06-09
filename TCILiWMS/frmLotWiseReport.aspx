<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmLotWiseReport.aspx.cs" Inherits="WCPM.frmLotWiseReport" %>

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


    }
   
<!-- Add icon library -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
    <style>
        .Grid {
            background-color: #fff;
            margin: 5px 0 10px 0;
            border: solid 1px #525252;
            border-collapse: collapse;
            font-family: Calibri;
            color: #474747;
        }

            .Grid td {
                padding: 7px;
                border: solid 1px #c1c1c1;
                font-size: 1.5em;
            }

            .Grid th {
                padding: 4px 2px;
                color: #fff;
                background: #363670 url(Images/grid-header.png) repeat-x top;
                border-left: solid 1px #525252;
                font-size: 1.5em;
            }

            .Grid .alt {
                background: #fcfcfc url(Images/grid-alt.png) repeat-x top;
            }

            .Grid .pgr {
                background: #363670 url(Images/grid-pgr.png) repeat-x top;
            }

                .Grid .pgr table {
                    margin: 6px 0;
                }

                .Grid .pgr td {
                    border-width: 0;
                    padding: 0 6px;
                    border-left: solid 1px #666;
                    font-weight: bold;
                    color: #fff;
                    line-height: 19px;
                    font-size: 2em;
                }

                .Grid .pgr a {
                    color: Gray;
                    text-decoration: none;
                }

                    .Grid .pgr a:hover {
                        color: #000;
                        text-decoration: none;
                    }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
    <div id="dvgridheading" style="height: 20px;">
         <div class="right">
       <%-- <button class="btn" onclick="callMethod()"><i class="fa fa-download"></i>Download</button>--%>
         
              <a href="#" id="id123" onclick="callMethod(); ">
                            <img src="images/download icon.png" width="30px" />
                        </a>
    </div>
        <table style="width: 400px;">
            <tr>
                <th aligh="left">
                    <asp:Label ID="label1" Text="Enter Lot Number" runat="server"></asp:Label>

                </th>
                <th aligh="left">
                    <asp:TextBox ID="txtLotNUmber" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                </th>
                <th aligh="left">
                    <asp:Button ID="btnSearch" Text="Search" runat="server" OnClick="btnSearch_Click" />
                </th>




            </tr>
        </table>
        
    </div>
   
    <%--<div id="gridcontainer"  style="height: auto; max-height: 300px;">--%>
    <br />

    <%--</div>--%>
    <asp:GridView ID="GridView1" runat="server" Width="100%" CssClass="Grid" OnRowDataBound="GridView1_RowDataBound">
    </asp:GridView>
</asp:Content>
