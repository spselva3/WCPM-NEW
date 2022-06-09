<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmDashBoard.aspx.cs" Inherits="WCPM.frmDashBoard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
    <style type="text/css">
          .mydropdownlist
{
color: #000000;
font-size: 30px;
padding: 5px 10px;
border-radius: 5px;
background-color:#ff8000;
font-weight: bold;
}
    </style>
    <table style="width: 257px">
      
    </table>
    <table>
        <tr>
            <td>
                  <asp:DataList ID="dlprojectdetailsmonth" runat="server" RepeatColumns="1"
                        CellSpacing="6" RepeatLayout="Table" CssClass="mydropdownlist">
                        <ItemTemplate>
                            <table class="table">
                                <tr>
                                    <th colspan="2" align="center">
                                        <b>
                                            <%# Eval("MONTHNAME") %>
                                        </b>
                                    </th>
                                </tr>
                                <%--  <tr>
                                        <td>Description:  
                                        </td>
                                        <td>
                                            <%# Eval("DESCRIPTION")%>  
                                        </td>
                                        </tr>--%>
                                

                               

                                <tr>
                                    <td>Total number of Reels:  
                                    </td>
                                    <td>
                                        <%# Eval("REELCOUNT")%>  
                                    </td>
                                </tr>
                             
                            </table>
                        </ItemTemplate>
                    </asp:DataList>
            </td>
            <td>
                  <asp:DataList ID="dlprojectdetailsDay" runat="server" RepeatColumns="1"
                        CellSpacing="6" RepeatLayout="Table" CssClass="mydropdownlist">
                        <ItemTemplate>
                            <table class="table">
                                <tr>
                                    <th colspan="2" align="center">
                                        <b>
                                            <%# Eval("MONTHNAME") %>
                                        </b>
                                    </th>
                                </tr>
                                <%--  <tr>
                                        <td>Description:  
                                        </td>
                                        <td>
                                            <%# Eval("DESCRIPTION")%>  
                                        </td>
                                        </tr>--%>
                                

                               

                                <tr>
                                    <td>Total number of Reels:  
                                    </td>
                                    <td>
                                        <%# Eval("REELCOUNT")%>  
                                    </td>
                                </tr>
                             
                            </table>
                        </ItemTemplate>
                    </asp:DataList>
            </td>
           
        </tr>
       
    </table>
      <asp:Label ID="lblCurrentMonth" runat="server" Text="Consolidation material Movement - Current Month" ForeColor="#000066" Font-Bold="true" Font-Size="Large"></asp:Label>
          
    
        <asp:Label ID="lblCurrentday" runat="server" Text="Consolidation material Movement - Today" ForeColor="#000066" Font-Bold="true" Font-Size="Large"></asp:Label>
     </asp:Content>
