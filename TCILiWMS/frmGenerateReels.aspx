<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmGenerateReels.aspx.cs" Inherits="WCPM.frmGenerateReels" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
     <script type="text/javascript" src="javascript/jquery.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#inventory').dataTable({
                "sScrollY": 250,
                "sScrollX": "100%"
            });
        });
    </script>
    <script language=Javascript>
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
        function ValidateData() {

            //alert($("#ddlPlantCode").text());


            x1 = document.getElementById("txtNoOfReels").value;

            // If x is Not a Number or less than one or greater than 10
            if (x1 == "") {
                alert('Please enter the No of Reels to Generate')
                return false;
            }
            return true;
        }
   </script>
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
    <style>
         .button {  
    background-color: #4CAF50;   
    border: none;  
    color: white;  
    padding: 15px 32px;  
    text-align: center;  
    text-decoration: none;  
    display: inline-block;  
    font-size: 14px;  
    margin: 4px 2px;  
    cursor: pointer;  
    }
        .auto-style1 {
            width: 62px;
        }
    </style>
 

<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
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
                        <th>Lot Number</th>
                        <th>
                            <asp:TextBox ID="txtLotNumber" runat="server" AutoPostBack="false" ReadOnly="true" BackColor="White"></asp:TextBox>
                        </th>
                        <th class="auto-style1"></th>
                        <th>Lot Prefix</th>
                        <th>
                            <asp:TextBox ID="txtLotPrefix" runat="server" AutoPostBack="false" BackColor="White" ReadOnly="true"></asp:TextBox>
                        </th>
                    </tr>
                    <tr>
                        <th>Quality</th>
                        <th>
                            <asp:TextBox ID="txtQuality" runat="server" ReadOnly="true" BackColor="White" ></asp:TextBox>
                        </th>
                        <th class="auto-style1"></th>
                        <th>Quality Code</th>
                        <th>
                            <asp:TextBox ID="txtQualityCode" runat="server" ReadOnly="true" BackColor="White" ></asp:TextBox>
                        </th>
                    </tr>
                    <tr>
                        <th>GSM</th>
                        <th>
                            <asp:TextBox ID="txtGsm" runat="server" ReadOnly="true" BackColor="White" ></asp:TextBox>
                        </th>
                        <th class="auto-style1"></th>
                        <th>Size</th>
                        <th>

                            <asp:TextBox ID="txtSize" runat="server" ReadOnly="true" BackColor="White"></asp:TextBox>
                            <asp:Label ID="lblSelectSizes" Text="Select Size" runat="server" Visible="False"></asp:Label>
                            <asp:DropDownList ID="ddlSizes" runat="server" Visible="False" OnSelectedIndexChanged="ddlSizes_SelectedIndexChanged" style="height: 21px" AutoPostBack="true">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                    </tr>
                    <th>Remarks</th>
                    <th>
                        <asp:TextBox ID="txtRemarks" runat="server" ReadOnly="True" BackColor="White"></asp:TextBox>
                    </th>
                    <th class="auto-style1">
                                                     
                        <asp:imagebutton ID="btnSaveRemarks" runat="server" Width="30px" Height="30px"  align="middle" OnClick="btnSaveRemarks_Click" Visible="false" ImageUrl="~/images/s2.png"/>
                     <asp:imagebutton ID="BtneditRemarkk" runat="server" Width="30px" Height="30px"  align="middle" OnClick="BtneditRemarkk_Click" Visible="true" ImageUrl="~/images/edit2.png"/>
                           
                    </th>

                    <th>No of Reels</th>
                    <th>

                        <asp:TextBox ID="txtNoOfReels" runat="server" BackColor="White" onkeypress="return isNumberKey(event)"></asp:TextBox>
                    </th>


                </table>
                <table>
                    <tr>
                        <th></th>
                        <th style="padding-left: 325px">
                            <asp:imagebutton runat="server" ID="btnsubmit"
                                OnClick="btnsubmit_Click" Width="60px" Height="40px" OnClientClick="if(!ValidateData()) return false;" Text="Generate Reels" ImageUrl="~/images/paper reels.png" />
                            &nbsp;&nbsp;
                            &nbsp;&nbsp;
                        </th>
                        <th>

                        </th>
                        <th>
                            &nbsp;</th>
                    </tr>
                </table>
                <table>
                    <tr>
                        <th>
                        From Reel Number
                        </th>
                        <th>
                            <asp:TextBox ID="txtFromReelNumber" runat="server" BackColor="White" onkeypress="return isNumberKey(event)"></asp:TextBox>
                        </th>
                         <th>
                         To Reel Number
                        </th>
                        <th>
                            <asp:TextBox ID="txtToReelNumber" runat="server" BackColor="White" onkeypress="return isNumberKey(event)"></asp:TextBox>
                        </th>
                        <th>
                            <asp:imagebutton ID="Imagebutton1" runat="server" Width="40px" Height="40px"  align="middle" OnClick="Imagebutton1_Click" Visible="false" ImageUrl="~/images/printer-circle-blue-512.png"/>

                        </th>
                          <th>
                                                     <asp:imagebutton ID="btnDeletesel" runat="server" Width="40px" Height="40px"  align="middle" OnClick="btnDelete_Click" Visible="false" ImageUrl="~/images/trash-512.png"/>
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

            <div style="clear:left;">
                <table>
                    <tr>

                        <th>
                            <asp:ListView ID="lvReelDetails" runat="server" OnItemDataBound="lvLabelled_ItemDataBound" OnSelectedIndexChanged="lvReelDetails_SelectedIndexChanged">
                                <LayoutTemplate>
                                    <%--<table width="100%" class="lamp" cellpadding="0" cellspacing="0">--%>
                                    <table class="lamp table-striped table-bordered table-hover table-bordered dataTable" style="width: 775Px;" id="inventory">
                                        <tr>
                                          <%-- <th>  <asp:CheckBox ID="cbPrintAll" runat="server" OnCheckedChanged="cbPrintAll_CheckedChanged" AutoPostBack="true"/></th>--%>
                                            <th>S.No.</th>
                                            <th>Reel Id </th>
                                            <th>Size</th>
                                            <th>No Of Prints</th>
                                            <th>Time Stamp</th>
                                          



                                        </tr>
                                        <tr id="ItemPlaceholder" runat="server" style="width: 200Px" >
                                        </tr>
                                    </table>
                                </LayoutTemplate>
                                <ItemTemplate >
                                    <tr runat="server" id="_itemrow" >
                                         <%-- <td align="left">  <asp:CheckBox ID="cbPrintind" runat="server" ValidationGroup='<%# Eval("R_REELID")%>'/></td>--%>
                                        <td align="left"><%# Container.DataItemIndex + 1%><asp:HiddenField ID="hfUserId" runat="server" Value='<%# Eval("R_ID") %>' />
                                        </td>
                                        <td align="left"><%# Eval("R_REELID")%></td>
                                        <td align="left"><%# Eval("R_SIZE")%></td>
                                        <td align="left"><%# Eval("R_NOOFPRINTS")%></td>
                                        <td align="left"><%# Eval("R_DATETIME")%></td>
                                      <%--  <td>
                                            <asp:Button ID="btnPrint" Text='<%# (int.Parse(Eval("R_NOOFPRINTS").ToString())>0)?"Reprint":"Print"%>' runat="server" CommandName='<%# Eval("R_REELID")%>' OnClick="btnPrint_Click1" /></td>--%>

                                    </tr>
                                </ItemTemplate>
                            </asp:ListView>
                        </th>
                     

                    </tr>
                    <tr>

                       
                               <th>
                                
                         
                         
                        </th>
                      

                    </tr>
                </table>

            </div>
    </form>
</body>
</html>
