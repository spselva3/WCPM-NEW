<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmCreateNewLines.aspx.cs" Inherits="WCPM.frmCreateNewLines" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>CREATE NEW LINE</title>
    <link rel="shortcut icon" href="images/Icon.ico" />
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
        .auto-style1 {
            height: 32px;
        }
    </style>
    <script type="text/javascript">
        function DisplayDateToday(sender, args) {
            if (sender._selectedDate == null) {
                sender._selectedDate = new Date();
            }
        }
        function ClosePupup() {
           
                if (window.opener != null && !window.opener.closed) {
                 

                 
                    window.opener.location.reload();
                  
                    window.close();
                
                }
            }
            window.onbeforeunload = RefreshParent;
        $(function () {
            $('#txtDateofdelivery').mask("99/99/9999");
            $('#txtDueDate').mask("99/99/9999");
            //$('#inputDueDate').mask("99/99/9999");
            $("#txtDateofdelivery").datepicker(
                {
                    autoSize: true,
                    changeMonth: true,
                    changeYear: true,
                    yearRange: "-15:+80",
                    dateFormat: "dd/mm/yy",
                    minDate: new Date,
                    showOn: "button",
                    buttonText: 'Select Date',
                    buttonImage: "../images/Calendar.png",
                    buttonImageOnly: true,
                    onSelect: function (selected, evnt) {
                        //var date2 = $("#txtDateofdelivery").datepicker('getDate');
                        //date2.setDate(date2.getDate() + 3);
                        var test = $('#txtDateofdelivery').datepicker({ dateFormat: 'dd-mm-yy' }).val();
                        var arr = test.split("/");
                        var dt = new Date(arr[2], arr[1], arr[0]);
                        //alert($("#ddlDestination").val());
                        var AddDays = 0;
                        if ($("#ddlDestination").val() == 'LAT') {
                            AddDays = 1;
                        }
                        else if ($("#ddlDestination").val() == 'FIPL') {
                            AddDays = 30;
                        }
                        else if ($("#ddlDestination").val() == 'CS') {
                            AddDays = 40;
                        }
                        dt.setDate(dt.getDate() + AddDays);
                        var dd = dt.getDate();
                        var mm = dt.getMonth();
                        var y = dt.getFullYear();
                        var someFormattedDate = dd + '/' + mm + '/' + y;
                        //alert(someFormattedDate);
                        $("#txtDueDate").val(someFormattedDate);
                        //$("#inputDueDate").val(someFormattedDate);
                        $("#hdnDutDtval").val(someFormattedDate);
                        //alert($("#hdnDutDtval").val());
                    }
                }
            );
        });
        $(document).ready(function () {
            //called when key is down
            $("#txtNofparts").bind("keydown", function (event) {
                if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
                    // Allow: Ctrl+A
                        (event.keyCode == 65 && event.ctrlKey === true) ||
                    // Allow: home, end, left, right
                        (event.keyCode >= 35 && event.keyCode <= 39)) {
                    // let it happen, don't do anything
                    return;
                } else {
                    // Ensure that it is a number and stop the keypress
                    if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
                        event.preventDefault();
                    }
                }
            });
            $("#txtDueDate").val($("#hdnDutDtval").val());
        });
        function DateValidate(field) {
            var regex = /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/;
            //alert(field.value);
            if (field.value == '__/__/____') {
                return true;
            }
            if (!regex.test(field.value)) {
                alert("Invalid Date.")
                field.focus();
                field.value = "";
                return false;
                //return "Please enter date in dd/MM/yyyy format."
            }
            return true;
        }
        function BindDueDt(value) {
            //alert(value);
            var d = new Date();
            d = value;
            d.setDate(d.getDate() + 50);
            alert(d);
        }
        function ValidateData() {
            //alert($("#ddlPlantCode").text());
            x1 = document.getElementById("txtLineNumber").value;

            // If x is Not a Number or less than one or greater than 10
            if (x1 == "") {
                alert('Please enter the Line Number')
                return false;
            }
            x4 = document.getElementById("txtLineName").value;

            // If x is Not a Number or less than one or greater than 10
            if (x4 == "") {
                alert('Please enter the Line Name')
                return false;
            }
           
            x2 = document.getElementById("txtLineDescription").value;

            // If x is Not a Number or less than one or greater than 10
            if (x2 == "") {
                alert('Please enter the Line Description')
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
            <table width="100%" cellpadding="6" cellspacing="0" border="0">
                <tr>
                    <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                        valign="top">Create New Line</th>
                </tr>
            </table>
            <div>
            </div>
            <div class="right" style="text-align: right">
                <asp:Label ID="lblMessage" runat="server" Text="" Font-Bold="true" ForeColor="Red"></asp:Label>
            </div>
            <div id="detailsMain">
                <table width="100%" cellpadding="6" cellspacing="0" border="0" >
                    <tr>
                        <th align="left">Line ID</th>
                        <th>
                            <asp:TextBox ID="txtLineNumber" runat="server" AutoPostBack="false" Height="22px" align="left" BackColor="White"></asp:TextBox>
                        </th>
                      
                        <th align="left">Line Name</th>
                        <th>
                            <asp:TextBox ID="txtLineName" runat="server" AutoPostBack="false" align="left" BackColor="White"></asp:TextBox>
                        </th>
                    </tr>
                    <tr>
                        <th align="left">Line Description</th>
                         <th>
                            <asp:TextBox ID="txtLineDescription" runat="server" AutoPostBack="false" Height="22px" align="left" BackColor="White"></asp:TextBox>
                        </th>
                       
                        <th>&nbsp;</th>
                        <th>
                            &nbsp;</th>
                    </tr>
                                       
                </table>
                <table>
                    <tr>
                        
                        <th style="padding-left: 325px" class="auto-style1">
                            <asp:Button runat="server" ID="btnsubmit" OnClick="btnsubmit_Click" OnClientClick="if(!ValidateData()) return false;" Text="Create" Height="30px" />
                            &nbsp;&nbsp;
                           <asp:Button runat="server" ID="btnClear" OnClick="btnClear_Click" Text="Clear" Height="30px"  />
                            &nbsp;&nbsp;
                            <asp:Button runat="server" ID="BtnClose" Text="Close" OnClientClick="ClosePupup()" Height="30px"  Width="50px" />
                        </th>
                        
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
