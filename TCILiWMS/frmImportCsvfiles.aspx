<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmImportCsvfiles.aspx.cs" Inherits="WCPM.frmImportCsvfiles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="FileContent" ContentPlaceHolderID="rightcontent" runat="server">


    <style id="cssStyle" type="text/css" media="all">
        .Cntrl1 {
            background-color: #abcdef;
            color: red;
            border: 1px solid #AB00CC;
            font: Arial, sans-serif;
            padding: 1px 4px;
            font-family: Palatino Linotype, Arial, Helvetica, sans-serif;
        }
    </style>
     <style type="text/css">
        * {
            font-family: Arial, sans-serif;
            font-size: 12px;
              background-color:aliceblue;
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

    <div id="Importfiles" style="height: 20px;">
        <div class="left">
        </div>

        <div id="Div1" style="height: 20px;">
            <div class="right">

                <asp:Label ID="lblErrorMessage" runat="server" Height="101px" Width="293px" Font-Size="Medium" Text="" Font-Names="Arial, sans-serif;" Visible="false" />


            </div>
        </div>
        <table>
            <tr>
                <td>
                    <asp:Label ID="lblfileUpload" Text="File Upload:" runat="server" Height="35px" Font-Names="Arial, sans-serif" />

                    <asp:FileUpload ID="FileUploader" runat="server" Height="35px" Font-Names="Arial, sans-serif" />
                    <%--  <asp:Button ID="btnChooseFile" runat="server" Text="Choose file" OnClick="btnChooseFile_Click" />--%>
                </td>
                 <td>
                   
                        <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click" Height="35px" Width="119px" Font-Names="Arial, sans-serif;" />

                </td>

            </tr>
          
        </table>
        <div>
            Imported  History
        </div>
         <div id="gridcontainer" style="height: auto; max-height: 300px;">
        <asp:ListView ID="lvInventory" runat="server">
            <LayoutTemplate>
                <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" cellpadding="0" cellspacing="0" width="100%" id="inventory">
                    <thead>
                        <tr>
                            <th style="width: 10px;">S.No.
                            </th>
                            <th>File Name 
                            </th>  
                            <th>Status 
                            </th>
                              <th>User 
                            </th>
                            <th>Date Time
                            </th>
                            <th>Line Number
                            </th>
                         
                        </tr>
                    </thead>
                    <tbody id="ItemPlaceholder" runat="server">
                    </tbody>
                </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr>
                    <td style="text-align: center;">
                        <%# Container.DataItemIndex + 1%>.
                    </td>
                    <td>
                        <%# Eval("H_FILENAME")%>
                    </td>
                      <td>
                        <%# Eval("H_STATUS")%>
                    </td>
                      <td>
                        <%# Eval("USER")%>
                    </td>
                    <td>
                        <%# Eval("DATETIME")%>
                    </td>
                    <td>
                        <%# Eval("LOCATIONNUMBER")%>
                    </td>
               
                    

                </tr>
            </ItemTemplate>
            <EmptyDataTemplate>
                <table class="lamp" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <th style="width: 10px;">S.No.
                            </th>
                            <th>User 
                            </th>
                            <th>Date Time
                            </th>
                            <th>Line Number
                            </th>
                         
                    </tr>
                    <tr>
                        <td colspan="11">No Records Found.
                        </td>
                    </tr>
                </table>
            </EmptyDataTemplate>
        </asp:ListView>
    </div>



       
    </div>


</asp:Content>

