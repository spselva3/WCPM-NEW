<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReplaceChildReels.aspx.cs" Inherits="WCPM.ReplaceChildReels" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>CREATE NEW USER</title>
    <link rel="shortcut icon" href="images/new_icon.ico" />
    <%--USED FOR POPUP IN SMART LOCATIONS - ON 02-JULY-2013--%>
    <link href="_assets/css/StyleSheet.css" rel="stylesheet" type="text/css" />
    <%--<link href="_assets/css/confirm.css" rel="stylesheet" type="text/css" />--%>
    <script type="text/javascript" src="JqueryScripts/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="JqueryScripts/jquery-ui.js"></script>
    <link href="JqueryScripts/jquery-ui.css" rel="stylesheet" />
    <script type="text/javascript" src="JqueryScripts/jquery.maskedinput.js"></script>
    <script type="text/javascript" src="JqueryScripts/jquery.validationEngine-en.js"></script>
    <script type="text/javascript" src="JqueryScripts/jquery.validationEngine.js"></script>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        * {
            font-family: Arial, sans-serif;
            font-size: 12px;
            background-color: aliceblue;
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

        .auto-style1 {
            height: 32px;
        }
        .auto-style4 {
            width: 676px;
        }
        .auto-style8 {
            width: 99px;
        }
        .auto-style9 {
            width: 49px;
        }
        .auto-style12 {
            width: 79px;
        }
        .auto-style13 {
            width: 54px;
        }
        .auto-style14 {
            width: 46px;
        }
        .auto-style15 {
            width: 254px;
        }
        .auto-style16 {
            width: 270px;
        }
        .auto-style17 {
            width: 263px;
        }
    </style>
    <script type="text/javascript">
        function DisplayDateToday(sender, args) {
            if (sender._selectedDate == null) {
                sender._selectedDate = new Date();
            }
        }
        function ClosePupup() {
            //alert('Sucessfully Created');
            window.close();
            window.opener.location.reload(true); self.close();
            //if (window.opener && !window.opener.closed) {
            //    window.opener.location.reload();
            //}
        }
    </script>
 <%--    <script language=Javascript>
         
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
     </script>--%>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table width="100%" cellpadding="6" cellspacing="0" border="0">
                <tr>
                    <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                        valign="top">Replace Serial No
                    </th>
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
                        <th align="left" class="auto-style8">Serial No</th>
                        <th class="auto-style17">
                            <asp:Label ID="lblSerial" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>
                            <%--<asp:TextBox ID="txtSerial" runat="server" AutoPostBack="false" align="left" BackColor="White"></asp:TextBox>--%>
                        </th>
                         <th align="left" class="auto-style9">Reel ID</th>
                        <th class="auto-style16">
                            <asp:Label ID="lblReel" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>
                            <%--<asp:TextBox ID="txtSerial" runat="server" AutoPostBack="false" align="left" BackColor="White"></asp:TextBox>--%>
                        </th>
                         <th align="left" class="auto-style13">Weight</th>
                        <th>
                            <asp:Label ID="lblWeight" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>
                            <%--<asp:TextBox ID="txtSerial" runat="server" AutoPostBack="false" align="left" BackColor="White"></asp:TextBox>--%>
                        </th>
                        <th align="left" class="auto-style14">Type</th>
                        <th class="auto-style15">
                            <asp:Label ID="lblType" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>
                        </th>
                        <th align="left" class="auto-style12">Machine No</th>
                        <th>
                             <asp:Label ID="lblMachine" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>

                        </th>
                    </tr>
                     <tr>
                         <th align="left" class="auto-style8"></th>
                        <th class="auto-style17">
                           </th>
                        <th align="left" class="auto-style9"></th>
                        <th class="auto-style16">
                           </th>
                        <th align="left" class="auto-style13"></th>
                        <th>
                         </th>
                         </tr>
                     <tr>
                         <th align="left" class="auto-style8"></th>
                        <th class="auto-style17">
                           </th>
                        <th align="left" class="auto-style9"></th>
                        <th class="auto-style16">
                           </th>
                        <th align="left" class="auto-style13"></th>
                        <th>
                         </th>
                         </tr>
                     <tr>
                         <th align="left" class="auto-style8"></th>
                        <th class="auto-style17">
                           </th>
                        <th align="left" class="auto-style9"></th>
                        <th class="auto-style16">
                           </th>
                        <th align="left" class="auto-style13"></th>
                        <th>
                         </th>
                         </tr>
                    <tr>
                        <th align="left" class="auto-style8"> Latest Serial No</th>
                        <th class="auto-style17">
                              <asp:Label ID="lblNewserial" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>  </th>
                          <th align="left" class="auto-style9">Reel ID</th>
                        <th class="auto-style16">
                            <asp:Label ID="lblNewReel" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>
                            <%--<asp:TextBox ID="txtSerial" runat="server" AutoPostBack="false" align="left" BackColor="White"></asp:TextBox>--%>
                        </th>
                         <th align="left" class="auto-style13">Weight</th>
                        <th>
                            <asp:Label ID="lblNewWeight" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label>
                            <%--<asp:TextBox ID="txtSerial" runat="server" AutoPostBack="false" align="left" BackColor="White"></asp:TextBox>--%>
                        </th>
                        <th align="left" class="auto-style14">Type</th>
                        <th class="auto-style15">
                             <asp:Label ID="lblNewType" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label> </th>
                        <th align="left" class="auto-style12">Machine No</th>
                        <th>
                            <asp:Label ID="lblNewMachineNo" runat="server" Text="" ForeColor="#000099" Font-Size="Medium"></asp:Label> </th>
                    </tr>
                     <tr>
                         <th align="left" class="auto-style8"></th>
                        <th class="auto-style17">
                           </th>
                        <th align="left" class="auto-style9"></th>
                        <th class="auto-style16">
                           </th>
                        <th align="left" class="auto-style13"></th>
                        <th>
                         </th>
                         </tr>
                     <tr>
                         <th align="left" class="auto-style8"></th>
                        <th class="auto-style17">
                           </th>
                        <th align="left" class="auto-style9"></th>
                        <th class="auto-style16">
                           </th>
                        <th align="left" class="auto-style13"></th>
                        <th>
                         </th>
                         </tr>
                   
                </table>
                <table class="auto-style4">
                    <tr>
                        <th class="auto-style1"></th>
                        <th style="padding-left: 325px" class="auto-style1">
                            <asp:Button runat="server" ID="btnReplace" OnClick="btnReplace_Click"  Text="Replace" Height="30px" Width="82px" BackColor="#00FFCC" Font-Size="Small" ForeColor="Blue" />
                            &nbsp;&nbsp;
                        
                            </th>
                        <td class="auto-style1">
                        
                            <asp:Button runat="server" ID="BtnClose" Text="Close" OnClientClick="ClosePupup()"  Height="30px" OnClick="BtnClose_Click" Width="79px" BackColor="#FF0066" Font-Size="Small" ForeColor="White"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>

