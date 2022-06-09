<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmTestMaster.aspx.cs" Inherits="WCPM.frmTestMaster" %>

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






    }
   
     
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="dvgridheading" style="height: 20px;">




        <div id="topcontent">
        
                <div id="locations">
                    <asp:TreeView ID="tvLocationView" Font-Names="Calibri" Font-Size="Small" ShowLines="true"
                        SelectedNodeStyle-Font-Bold="true" SelectedNodeStyle-ForeColor="Green"
                        runat="server" OnSelectedNodeChanged="tvLocationView_SelectedNodeChanged" Width="200px">
                    </asp:TreeView>
                </div>
            
            <div class="left">
                <div id="dvtotalcounts">
                    <div id="TotalCounts" style="width: 533px; margin-top: 138px;">
                        <table class="scorecard" cellpadding="0" cellspacing="0" width="100%" height="100%">
                          
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
                                    <a href="rptWeight.aspx" style="text-decoration: none">
                                        <asp:Label ID="lblTotalWeightforDay" runat="server" Text="0"></asp:Label></a>
                                </td>
                                <td style="border-right: 1px solid #4977AA;">
                                    <a href="rptTransit.aspx" style="text-decoration: none">
                                        <asp:Label ID="lblTotalReelCountforMonth" runat="server" Text="0"></asp:Label></a>
                                </td>
                                <td style="border-right: 1px solid #4977AA;">
                                    <a href="rptOverDue.aspx" style="text-decoration: none">
                                        <asp:Label ID="lblTotalWeightforMonth" runat="server" Text="0"></asp:Label></a>
                                </td>


                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>

    </div>

  


</asp:Content>
