<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmPrefixMaster.aspx.cs" Inherits="WCPM.frmPrefixMaster" %>

<asp:Content ID="UserContentHead" ContentPlaceHolderID="head" runat="server">
    <style>
      .MyImage
{
    height : 1Px;
    width: 1Px;
 
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
            window.open('frmCreateNewUser.aspx', 'AllCustomers', 'location=1,status=1,resizable=no,scrollbars=2,width=800,height=300,left=' + x + ',top=' + y);
        }
    </script>
    <script src="Javascript/jquery.dataTables.js" type="text/javascript"></script>
    <script src="Javascript/datatables-bs3.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="UserContentBody" ContentPlaceHolderID="rightcontent" runat="server">
    <div id="dvgridheading" style="height: 20px;">
        <div class="Middle" align="middle" style="font-size: 25px; color:blue">
           PREFIX MASTER DETAILS
        </div>
        <div class="right">
            <asp:Label ID="lblMessage" runat="server" Text="" Font-Bold="true" ForeColor="Green"></asp:Label>
            &nbsp;</div>
    </div>
    <div id="gridcontainer">
        <asp:ListView ID="lvUserDetails" runat="server"
            OnItemEditing="lvUserDetails_ItemEditing" OnItemUpdating="lvUserDetails_ItemUpdating" OnItemCanceling="lvUserDetails_ItemCanceling" OnItemDataBound="lvUserDetails_ItemDataBound">
            <LayoutTemplate>
                <%--<table width="100%" class="lamp" cellpadding="0" cellspacing="0">--%>
                <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" id="inventory" height="200px" width="100%" >
                    <tr>
                      
                        <th>PREFIX</th>
                      
                        <th colspan="2">Edit</th>
                    </tr>
                    <tr id="ItemPlaceholder" runat="server">
                    </tr>
                </table>
            </LayoutTemplate>
            <ItemTemplate>
                <tr>
                   
                    <td><%# Eval("PREFIX")%></td>
                    
                   
                    <td colspan="2">
                        <asp:Button ID="BtnEdit" Text="Edit" runat="server" CommandName="Edit" /></td>
                  <%--   <a href="#" id="id123" CommandName="Edit" onclick="ShowEditWindow('<%# Eval("ID")%>'); ">
                            <img src="images/edit.png" alt="Add Locations" width="30px" />
                        </a>--%>
                </tr>
            </ItemTemplate>
            <EditItemTemplate>
                <tr>
                   
                   
                    <td>
                        <asp:TextBox ID="txtPrefix" runat="server" MaxLength="12" Text='<%# Eval("PREFIX") %>' Width="100%" Height="100%"></asp:TextBox>
                       
                    
                  
                    <td>
                        <asp:Button ID="btnUpdate" runat="server" Text="Update" CommandName="Update" CausesValidation="true" ValidationGroup="UserUpdate" /></td>
                    <td>
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="Cancel" /></td>
                </tr>
                </tr>
            </EditItemTemplate>
        </asp:ListView>
    </div>
    <table>
        <tr>
            <td>
                &nbsp;</td>
        </tr>
    </table>
</asp:Content>
