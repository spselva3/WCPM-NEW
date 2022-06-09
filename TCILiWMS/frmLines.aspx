<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmLines.aspx.cs" Inherits="WCPM.frmLines" %>

<asp:Content ID="UserContentHead" ContentPlaceHolderID="head" runat="server">
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
            window.open('frmCreateNewLines.aspx', 'Create New Lines', 'location=1,status=1,resizable=no,scrollbars=2,width=800,height=200,left=' + x + ',top=' + y);
        } function ShowEditWindow() {
          
          
                var x = screen.width / 2 - 900 / 2;
                var y = screen.height / 2 - 400 / 2;
                //window.open(meh.href, 'sharegplus', 'height=485,width=700,left=' + x + ',top=' + y);
                window.open('frmUpdateLineDetails.aspx', 'Update  Lines', 'location=1,status=1,resizable=no,scrollbars=2,width=800,height=200,left=' + x + ',top=' + y);
        }
    </script>
    <script src="Javascript/jquery.dataTables.js" type="text/javascript"></script>
    <script src="Javascript/datatables-bs3.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="UserContentBody" ContentPlaceHolderID="rightcontent" runat="server">
    <div id="dvgridheading" style="height: 20px;">
        <div class="left" align="left">
            LINE&nbsp;DETAILS
        </div>
        <div class="right">
            <asp:Label ID="lblMessage" runat="server" Text="" Font-Bold="true" ForeColor="Green"></asp:Label>
            <a href="javascript:void(0);" style="text-decoration: none" onclick="javascript:ShowDispatchPlanCreation();">
                <img src="images/plusimage.png" alt="Add Locations" width="30px" /></a>
        </div>
    </div>
    <div id="gridcontainer">
        <asp:ListView ID="lvUserDetails" runat="server"
            OnItemEditing="lvUserDetails_ItemEditing" OnItemUpdating="lvUserDetails_ItemUpdating" OnItemCanceling="lvUserDetails_ItemCanceling" OnItemDataBound="lvUserDetails_ItemDataBound" OnItemCommand="lvUserDetails_ItemCommand">
            <LayoutTemplate>
                <%--<table width="100%" class="lamp" cellpadding="0" cellspacing="0">--%>
                <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" id="inventory" width="100%">
                    <tr>
                        <th>S.No.</th>
                         <th>Line ID</th>
                        <th>Line Name</th>
                        <th>Line Description</th>
                       
                        <th>Date Time</th>
                       

                  
                        <%--     <th>Last Logged From</th>--%>
                        <th colspan="2">Edit</th>
                    </tr>
                    <tr id="ItemPlaceholder" runat="server">
                    </tr>
                </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Container.DataItemIndex + 1%><asp:HiddenField ID="hfUserId" runat="server" Value='<%# Eval("ID") %>' />
                    </td>
                      <td><%# Eval("LOCATION NUMBER")%></td>
                    <td><%# Eval("LOCATION NAME")%></td>
                    <td><%# Eval("DESCRIPTION")%></td>
                  
                    <td><%# Eval("DATE TIME")%></td>

                    
                 
                    <td colspan="2">
                        <asp:Button ID="BtnEdit" Text="Edit" runat="server" CommandName="EditDetails" CommandArgument='<%#Eval("ID") %>' OnClientClick="javascript:ShowEditWindow()" /></td>
                </tr>
            </ItemTemplate>
            <EditItemTemplate>
                <tr>
                    <td><%# Container.DataItemIndex + 1%><asp:HiddenField ID="hfUserId" runat="server" Value='<%# Eval("ID") %>' />
                    </td>
                    <td><%# Eval("EMPNAME")%></td>
                    <td><%# Eval("EMPID")%></td>

                    <td><%# Eval("ROLE")%></td>
                    <td><%# Eval("LOGINUSERNAME")%></td>
                    <td>
                        <asp:TextBox ID="txtDPassword" runat="server" Text='<%# Eval("PASSWORD")%>' BackColor="#ffffff" TextMode="Password" ReadOnly="true" BorderStyle="None" BorderWidth="0"></asp:TextBox></td>
                    <td><%# Eval("CREATEDDATE")%></td>
                    <td><%# Eval("ISLOGGEDIN")%></td>

                    <td><%# Eval("ACTIVEUSER")%></td>
                    <%--  <td><%# Eval("LI_CreatedDate","{0: dd MMM, yyyy hh:mm:ss tt}")%></td>--%>
                    <%-- <td><%# Eval("LI_LastLoggedFrom")%></td>--%>
                    <td colspan="2">
                        <asp:Button ID="BtnEdit" Text="Edit" runat="server" CommandName="Edit" /></td>
                </tr>
            </EditItemTemplate>
        </asp:ListView>
    </div>
    <table>
        <tr>
            <td>
                <asp:DataPager ID="dpinventory" runat="server" PagedControlID="lvUserDetails" PageSize="20"
                    OnPreRender="dpinventory_PreRender">
                    <Fields>
                        <asp:NextPreviousPagerField
                            ButtonType="Button"
                            ShowFirstPageButton="true"
                            ShowNextPageButton="true"
                            ShowPreviousPageButton="false" />
                        <asp:NumericPagerField ButtonType="Button" ButtonCount="7" />
                        <asp:NextPreviousPagerField
                            ButtonType="Button"
                            ShowLastPageButton="true"
                            ShowNextPageButton="false" />
                    </Fields>
                </asp:DataPager>
            </td>
        </tr>
    </table>
</asp:Content>
