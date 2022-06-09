<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmRollDetails.aspx.cs" Inherits="WCPM.frmRollDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
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
                height: 80px;
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
    <div>
        <table width="100%" cellpadding="6" cellspacing="0" border="0">
            <tr>
                <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                    valign="top">Generate Reels</th>
            </tr>
        </table>
        <div>
        </div>
        <div class="right" style="text-align: right">
            <asp:Label ID="lblMessage" runat="server" Text="" Font-Bold="true" ForeColor="Red"></asp:Label>
        </div>
        <div id="detailsMain">
            <table width="100%" cellpadding="6" cellspacing="0" border="0">
                <tr>
                    <th>Production Order</th>
                    <th>
                        <asp:TextBox ID="txtProductionOrder" runat="server" AutoPostBack="false" ReadOnly="true"></asp:TextBox>
                    </th>
                    <th></th>
                    <th>Roll ID</th>
                    <th>
                        <asp:TextBox ID="txtRollId" runat="server" AutoPostBack="false"></asp:TextBox>
                    </th>
                </tr>
                <tr>
                    <th>Quality</th>
                    <th>
                        <asp:TextBox ID="txtQuality" runat="server" ReadOnly="true"></asp:TextBox>
                    </th>
                    <th></th>
                    <th>GSM</th>
                    <th>
                        <asp:TextBox ID="txtGsm" runat="server" ReadOnly="true"></asp:TextBox>
                    </th>
                </tr>
                <tr>
                    <th>Dia</th>
                    <th>
                        <asp:TextBox ID="txtDia" runat="server" ReadOnly="true"></asp:TextBox>
                    </th>
                    <th></th>
                    <th>Size</th>
                    <th>

                        <asp:TextBox ID="txtSize" runat="server" ReadOnly="true"></asp:TextBox>
                    </th>
                </tr>
                <th>No of Reels</th>
                <th>
                    <asp:TextBox ID="txtNoOfreels" runat="server" ReadOnly="true"></asp:TextBox>
                </th>
                <th></th>
                <th>No of Joints</th>
                <th>

                    <asp:TextBox ID="txtNoOfJonts" runat="server" ReadOnly="true"></asp:TextBox>
                </th>


            </table>
            <table>
                <tr>
                    <th></th>
                    <th style="padding-left: 325px">
                        <asp:Button runat="server" ID="btnsubmit" OnClick="btnsubmit_Click" OnClientClick="if(!ValidateData()) return false;" Text="Generate Reels" />
                        &nbsp;&nbsp;
                            &nbsp;&nbsp;
                    </th>

                </tr>
            </table>
        </div>
    </div>
    <div>
        <table width="100%" cellpadding="6" cellspacing="0" border="0">
            <tr>
                <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                    valign="top">List of generated reels</th>
            </tr>
        </table>

        <div>
            <table>
                <tr>
                   
                    <th>
                        <asp:ListView ID="lvReelDetails" runat="server">
                            <LayoutTemplate>
                                <%--<table width="100%" class="lamp" cellpadding="0" cellspacing="0">--%>
                                <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" id="inventory">
                                    <tr>
                                        <th>
                                            <asp:CheckBox ID="cbPrintAll" runat="server" />
                                        </th>
                                        <th>S.No.</th>
                                        <th>REEL ID </th>
                                        <th>SIZE</th>
                                      
                                        <th>LOTNUMBER</th>
                                        <th>PRINT</th>
                                       
                                        
                                       
                                    </tr>
                                    <tr id="ItemPlaceholder" runat="server">
                                    </tr>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="cbPrintInd" runat="server" />
                                    </td>
                                    <td><%# Container.DataItemIndex + 1%><asp:HiddenField ID="hfUserId" runat="server" Value='<%# Eval("R_ID") %>' />
                                    </td>
                                    <td><%# Eval("R_REELID")%></td>
                                    <td><%# Eval("R_SIZE")%></td>
                                  
                                    <td><%# Eval("R_ROLLID")%></td>
                                    <td>
                                        <asp:Button ID="btnPrint" Text="Print" runat="server" CommandName='<%# Eval("R_REELID")%>' OnClick="btnPrint_Click1" /></td>
                                   
                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                    </th>

                </tr>
            </table>


        </div>
    </div>
</asp:Content>
