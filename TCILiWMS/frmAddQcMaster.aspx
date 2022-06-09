<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmAddQcMaster.aspx.cs" Inherits="WCPM.frmAddQcMaster" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>ADD NEW QC MASTER</title>
    <style type="text/css">
        * {
            font-family: Arial, sans-serif;
            font-size: 12px;
            background-color: aliceblue;
        }
    </style>
    <script type="text/javascript">
        function DisplayDateToday(sender, args) {
            if (sender._selectedDate == null) {
                sender._selectedDate = new Date();
            }
        }
        function ClosePupup() {
            window.close();
            window.opener.location.reload(true); self.close();
        }
        function ValidateData() {

            x1 = document.getElementById("txtMachineNumber").value;
            if (x1 == "") {
                alert('Please enter the Machine Number')
                return false;
            }
            x4 = document.getElementById("txtMachineNumber").value;
            if (x4 > 5) {
                alert('Enter valid Machine Number')
                return false;
            }
            x3 = document.getElementById("txtQcCode").value;

            if (x3 == "") {
                alert('Please enter the Qc Code')
                return false;
            }
            x4 = document.getElementById("txtQcDescription").value;

            if (x4 == "") {
                alert('Please enter the Description')
                return false;
            }
            return true;
        }

    </script>
    <script language="Javascript">
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">

      
                <table width="100%" cellpadding="6" cellspacing="0" border="0">
                    <tr>
                        <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                            valign="top">CREATE NEW QC MASTER</th>
                    </tr>
                </table>
              
                <div class="right" style="text-align: right">
                    <asp:Label ID="lblMessage" runat="server" Text="" Font-Bold="true" ForeColor="Red"></asp:Label>
                </div>
                <div id="detailsMain">
                    <table width="100%" cellspacing="0" border="0">
                        <tr>
                            <th align="left" class="auto-style1">Machine Number</th>

                            <th align="left" class="auto-style1">
                                <asp:TextBox ID="txtMachineNumber" runat="server" onkeypress="return isNumberKey(event)" AutoPostBack="false" Width="150px" Height="16px" BackColor="White"></asp:TextBox>

                            </th>
                            <th class="auto-style1"></th>
                            <th class="auto-style1" align="left">Quality Code</th>
                            <th align="left" class="auto-style1">
                                <asp:TextBox ID="txtQcCode" runat="server" onkeypress="return isNumberKey(event)" AutoPostBack="false" Width="150px" Height="16px" BackColor="White"></asp:TextBox>

                            </th>
                        </tr>
                        <tr colspan="5" align="middle">
                            <th class="auto-style1" align="left">Quality Description</th>
                            <th class="auto-style1" align="left">

                                <asp:TextBox ID="txtQcDescription" runat="server" AutoPostBack="false" Width="150px" Height="16px" BackColor="White"></asp:TextBox>
                            </th>

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
