<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCreateNewWorkOrder.aspx.cs" Inherits="WCPM.frmCreateNewWorkOrder" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>  
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>CREATE NEW PRODUCTION ORDER</title>
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
    <style>
        #customers {
            font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

            #customers td, #customers th {
                border: 1px solid #ddd;
                padding: 8px;
            }

            #customers tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            #customers tr:hover {
                background-color: #ddd;
            }

            #customers th {
                padding-top: 12px;
                padding-bottom: 12px;
                /*text-align: left;*/
                background-color: #4CAF50;
                color: white;
            }
    </style>
    <style type="text/css">
        * {
            font-family: Arial, sans-serif;
            font-size: 12px;
            background-color: aliceblue;
        }

        .clickme {
            background-color: #EEEEEE;
            padding: 8px 20px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 5px;
            color: #10a2ff;
            cursor: pointer;
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
            height: 33px;
        }
    </style>
   <script type="text/javascript">
       var isItemSelectedforQCdes = false;
 

       //Handler for AutoCompleter OnClientItemSelected event
       function onItemSelectedQCDes() {
           isItemSelectedforQCdes = true;
       }
       function resetItemSelectedQCDes() {
           isItemSelectedforQCdes = false;
       }
      
  
       //Handler for textbox blur event
       function checkItemSelectedQCDes(txtInput) {

           if (!isItemSelectedforQCdes) {
               txtInput.value = '';

           }
       }
         </script>   
       <script type="text/javascript">
           var isItemSelectedforQCCode = false;
    
           function onItemSelectedQCCode() {
               isItemSelectedforQCCode = true;
           }
           function resetItemSelectedQCCode() {
               isItemSelectedforQCCode = false;
           }
         
           //Handler for textbox blur event
           function checkItemSelectedQCCode(txtInput1) {

               if (!isItemSelectedforQCCode) {
                   txtInput1.value = '';

               }
           }
       </script>
           <script type="text/javascript">    
               var isItemSelectedforColor = false;
               function onItemSelectedColor() {
                   isItemSelectedforColor = true;
               }
               function resetItemSelectedColor() {
                   isItemSelectedforColor = false;
               }

               //Handler for textbox blur event
               function checkItemSelectedColor(txtInput2) {

                   if (!isItemSelectedforColor) {
                       txtInput2.value = '';

                   }
               }
           
       
</script>
     <script src="Scripts/jquery-1.7.1.min.js"></script>  
  
    <script type="text/javascript">

        function UserOrEmailAvailability() { //This function call on text change.             
            $.ajax({
                type: "POST",
                url: "frmCreateNewWorkOrder.aspx/ValidateGsm", // this for calling the web method function in cs code.  
                data: '{GSM: "' + $("#<%=txtGSM.ClientID%>")[0].value + '",lotnumber: "' + $("#<%=txtLOtNumber.ClientID%>")[0].value + '" }',// user name or email value  
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
             
            });
        }

        // function OnSuccess  
        function OnSuccess(response) {
            switch (response.d) {
                case "true":
                   
                    break;
                case "false":
                    alert("Enter Valid GSM");
                    document.getElementById("txtGSM").value = "";
                    break;
            }
        }

    </script>  
  
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
        }
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            } return true;
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
        function ValidateData() {

            //alert($("#ddlPlantCode").text());


            x1 = document.getElementById("txtLOtNumber").value;

            // If x is Not a Number or less than one or greater than 10
            if (x1 == "") {
                alert('Please enter the Lot Number')
                return false;
            }
            if (x1 == 0) {
                alert('Enter Valid Lot Number')
                return false;
            }

            x2 = document.getElementById("txtQuality").value;

            // If x is Not a Number or less than one or greater than 10
            if (x2 == "") {
                alert('Please enter the  Quality ')
                return false;
            }
            var e2 = document.getElementById("txtQualitCode").value;





            if (e2 == "") {
                alert('Please enter the  Quality Code')
                return false;
            }


            x3 = document.getElementById("txtGSM").value;

            // If x is Not a Number or less than one or greater than 10
            if (x3 == "") {
                alert('Please enter the GSM')
                return false;
            }

            x4 = document.getElementById("txtSize").value;

            // If x is Not a Number or less than one or greater than 10
            if (x4 == "") {
                alert('Please enter the Size')
                return false;
            }
            x5 = document.getElementById("txtOrderedQty").value;

            // If x is Not a Number or less than one or greater than 10
            if (x5 == "") {
                alert('Please enter the Ordered Quantity')
                return false;
            }

            // If x is Not a Number or less than one or greater than 10
            return true;
        }

    </script>


</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div>
                <table width="100%" cellpadding="6" cellspacing="0" border="0">
                    <tr>
                        <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                            valign="top">CREATE LOT NUMBER</th>
                    </tr>
                </table>
                <div>
                </div>
                <div class="right" style="text-align: right">
                    <asp:Label ID="lblMessage" runat="server" Text="" Font-Bold="true" ForeColor="Red"></asp:Label>
                </div>
                <div id="detailsMain">
                    <table width="100%" cellspacing="0" border="0">
                        <tr>
                            <th align="left">Lot. No</th>

                            <th align="left">
                                <asp:TextBox ID="txtLOtNumber" runat="server" AutoPostBack="false" Width="150px" Height="16px" BackColor="White" ></asp:TextBox>
                            </th>
                            <th></th>
                            <th class="auto-style1" align="left">Lot. Prefix</th>
                            <th align="left">
                                <asp:TextBox ID="txtLotPrefix" runat="server" AutoPostBack="false" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                            </th>
                        </tr>
                        <tr>
                            <th class="auto-style1" align="left">Quality</th>
                            <th class="auto-style1" align="left">

                                <asp:TextBox ID="txtQuality" runat="server" AutoPostBack="false" onblur="checkItemSelectedQCDes(this)" onfocus="resetItemSelectedQCDes()" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                                <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
                                </asp:ScriptManager>
                                <asp:AutoCompleteExtender ServiceMethod="GetSearch" MinimumPrefixLength="3" OnClientItemSelected="onItemSelectedQCDes" CompletionInterval="10"
                                    EnableCaching="true"  CompletionSetCount="10" TargetControlID="txtQuality" ID="AutoCompleteExtender1"
                                    runat="server" FirstRowSelected="false"></asp:AutoCompleteExtender>
                            </th>
                            <th class="auto-style1"></th>
                            <th class="auto-style1" align="left">Quality Code</th>
                            <th class="auto-style1" align="left">

                                <asp:TextBox ID="txtQualitCode" runat="server" AutoPostBack="false" onblur="checkItemSelectedQCCode(this)" onfocus=" resetItemSelectedQCCode()" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                                
                               <%--   <asp:AutoCompleteExtender ServiceMethod="GetQcCode"  MinimumPrefixLength="1" OnClientItemSelected="onItemSelectedQCCode" CompletionInterval="10"
                                    EnableCaching="false" CompletionSetCount="10" TargetControlID="txtQualitCode" ID="AutoCompleteExtender2"
                                    runat="server" FirstRowSelected="false"></asp:AutoCompleteExtender>--%>
                                  <asp:AutoCompleteExtender ServiceMethod="GetQcCode" MinimumPrefixLength="3" OnClientItemSelected="onItemSelectedQCCode" CompletionInterval="10"
                                    EnableCaching="false"  CompletionSetCount="10" TargetControlID="txtQualitCode" ID="AutoCompleteExtender2"
                                    runat="server" FirstRowSelected="false"></asp:AutoCompleteExtender>
                            </th>
                        </tr>
                        <tr>
                            <th align="left">GSM</th>
                            <th align="left">

                                <b>
                                    <asp:TextBox ID="txtGSM" runat="server" AutoPostBack="false" Width="150px" Height="16px" onchange="UserOrEmailAvailability()" onkeypress="return isNumberKey(event)" BackColor="White"></asp:TextBox>
                            </th>
                            <th></th>
                            <th class="auto-style1" align="left">Size</th>
                            <th align="left">

                                <b>
                                    <asp:TextBox ID="txtSize" runat="server" AutoPostBack="false" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                                    <br /></th>
                        </tr>
                        <tr>
                            <th align="left">Color Grain</th>
                            <th align="left">

                                <b>
                                    <asp:TextBox ID="txtcolorGrain" runat="server" AutoPostBack="false"  onblur="checkItemSelectedColor(this)" onfocus="resetItemSelectedColor()" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                                     <asp:AutoCompleteExtender ServiceMethod="GetColor"  MinimumPrefixLength="3" OnClientItemSelected="onItemSelectedColor" CompletionInterval="10"
                                    EnableCaching="false" CompletionSetCount="10" TargetControlID="txtcolorGrain" ID="AutoCompleteExtender3"
                                    runat="server" FirstRowSelected="false"></asp:AutoCompleteExtender>
                            </th>
                            <th></th>
                            <th class="auto-style1" align="left">Remarks</th>
                            <th align="left">

                                <b>
                                    <asp:TextBox ID="txtRemarks" runat="server" AutoPostBack="false" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                                    <br /></th>
                        </tr>
                          <tr>
                            <th align="left">Ordered Qty</th>
                            <th align="left">

                                <b>
                                    <asp:TextBox ID="txtOrderedQty" runat="server" AutoPostBack="false"   Width="150px" Height="16px" BackColor="White" onkeypress="return isNumberKey(event)"></asp:TextBox>
                                   
                            </th>
                            <th></th>
                            <th class="auto-style1" align="left">&nbsp;</th>
                            <th align="left">

                                <b>
                                    <br /></th>
                        </tr>
                        <tr>
                            <td colspan="5">


                                <table style="width: 100%">
                                    <tr>

                                        <th style="padding-left: 325px" align="left">
                                            <asp:Button runat="server" ID="btnsubmit" OnClick="btnsubmit_Click" class="button button4" OnClientClick="if(!ValidateData()) return false;" Text="Create" Height="27px" />
                                            &nbsp;&nbsp;
                           <asp:Button runat="server" ID="btnClear" OnClick="btnClear_Click" Text="Reset" class="button button4" Height="27px" />
                                            &nbsp;&nbsp;
                              <asp:Button runat="server" ID="btnClose" OnClientClick="ClosePupup()" class="button button4" Text="Close" Height="27px" />
                                            &nbsp;&nbsp
                                        </th>


                                    </tr>
                                </table>
                </div>
    </form>
</body>
</html>
