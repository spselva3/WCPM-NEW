<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="frmManualOperation.aspx.cs" Inherits="WCPM.frmManualOperation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 31px;
        }
    </style>
    <script>
        function ValidateData() {
            //alert($("#ddlPlantCode").text());
            if ($("#txtProductionOrder").val() == "") {
                alert("Please enter Production Order.");
                $("#txtProductionOrder").focus();
                return false;
            }
            else if ($("#txtLOtNumber").val() == "") {
                alert("Please enter Lot Number.");
                $("#txtLOtNumber").focus();
                return false;
            }
            else if ($("#ddlQuality").val() == "Please Select") {
                alert("Please select the Quality");
                $("#ddlQuality").focus();
                return false;
            }
            else if ($("#ddlGsm").val() == "Please Select") {
                alert("Please select GSM.");
                $("#ddlGsm").focus();
                return false;
            }
            else if ($("#dllCoeDia").val() == "Please Select") {
                alert("Please select dia.");
                $("#dllCoeDia").focus();
                return false;
            }
            //else if ($("#txtSize").text() == "") {
            //    alert("Please enter  size");
            //    $("#txtSize").focus();
            //    return false;
           // }
            else if ($("#dllNumberofJoints").val() == "Please Select") {
                alert("Please select no of Joints.");
                $("#dllNumberofJoints").focus();
                return false;
            }
            else if ($("#txtNoReels").val() == "") {
                alert("Please enter roles.");
                $("#txtNoReels").focus();
                return false;
            }
            else if ($("#txtMFGGate").val() == "") {
                alert("Please enter MFG Date.");
                $("#txtMFGGate").focus();
                return false;
            }
            else if ($("#dllShift").val() == "Please Select") {
                alert("Please select Shift.");
                $("#dllShift").focus();
                return false;
            }
            else if ($("#ddlMachineNumber").val() == "Please Select") {
                alert("Please select Machine Number.");
                $("#ddlMachineNumber").focus();
                return false;
            }
            return true;
        }
    </script>
   <style type='text/css'>

/* This style will apply on your Button (or any button that has the "YourButtonStyle" CSS Class */
.YourButtonStyle
{
    background: #6cb200;
    color: #0000FF;
    border: 0;
    padding: 10px 15px;
    font-size: 14px;
    display: inline-block;
    text-transform: uppercase;
    margin-bottom: 18px;
}

/* Your Hover style for your button */
.YourButtonStyle:hover
{
    background: #89c33f;
}

</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="rightcontent" runat="server">
     <div>
            <table width="100%" cellpadding="6" cellspacing="0" border="0">
                <tr>
                    <th align="center" style="background-color: #003399; color: White; font-weight: bold;"
                        valign="top">CREATE PRODUCTION ORDER</th>
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
                        <th>Producion Order</th>
                        <th>
                            <asp:TextBox ID="txtProductionOrder" runat="server" AutoPostBack="false"></asp:TextBox>
                        </th>
                        <th></th>
                        <th>Lot Number</th>
                        <th>
                            <asp:TextBox ID="txtLOtNumber" runat="server" AutoPostBack="false"></asp:TextBox>
                        </th>
                    </tr>
                    <tr>
                        <th class="auto-style1">Quality</th>
                         <th class="auto-style1">
                            <asp:DropDownList ID="ddlQuality" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="Quality1" Value="Quality1"></asp:ListItem>
                                <asp:ListItem Text="Quality2" Value="Quality2"></asp:ListItem>
                                <asp:ListItem Text="Quality3 Admin" Value="Quality3"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                        <th class="auto-style1"></th>
                        <th class="auto-style1">GSM</th>
                        <th class="auto-style1">
                                <b>
                            <asp:DropDownList ID="ddlGsm" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="GSM1" Value="GSM1"></asp:ListItem>
                                <asp:ListItem Text="GSM2" Value="GSM2"></asp:ListItem>
                                <asp:ListItem Text="GSM3" Value="GSM3"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                    </tr>
                    <tr>
                        <th>Core/Dia</th>
                        <th>
                                <b>
                            <asp:DropDownList ID="dllCoeDia" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="Dia1" Value="Dia1"></asp:ListItem>
                                <asp:ListItem Text="Dia2" Value="Dia2"></asp:ListItem>
                                <asp:ListItem Text="Dia3" Value="Dia3"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                        <th></th>
                        <th>Size</th>
                        <th>
                             
                                <b>
                            <asp:TextBox ID="txtSize" runat="server" AutoPostBack="false"></asp:TextBox>
                        </th>
                    </tr>
                   
                    <tr>
                        <th>No. of Joints</th>
                        <th>
                                <b>
                            <asp:DropDownList ID="dllNumberofJoints" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                <asp:ListItem Text="3" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                        <th>&nbsp;</th>
                        <th>
                                <b>No. of Reels</th>
                        <th>
                             
                                <b>
                            <asp:TextBox ID="txtNoReels" runat="server" AutoPostBack="false"></asp:TextBox>
                        </th>
                    </tr>
                   
                    <tr>
                        <th>MFG Date</th>
                        <th>
                                <b>
                            <asp:TextBox ID="txtMFGGate" runat="server" AutoPostBack="false"></asp:TextBox>
                        </th>
                        <th>&nbsp;</th>
                        <th>
                                <b>Shift</th>
                        <th>
                             
                                <b>
                            <asp:DropDownList ID="dllShift" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="A" Value="A"></asp:ListItem>
                                <asp:ListItem Text="B" Value="B"></asp:ListItem>
                                <asp:ListItem Text="C" Value="C"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                    </tr>
                   
                    <tr>
                        <th>Machine Number</th>
                        <th>
                                <b>
                            <asp:DropDownList ID="ddlMachineNumber" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select"></asp:ListItem>
                                <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                <asp:ListItem Text="3 " Value="3"></asp:ListItem>
                                <asp:ListItem Text="4" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </th>
                        <th>&nbsp;</th>
                        <th>
                                &nbsp;</th>
                        <th>
                             
                                &nbsp;</th>
                    </tr>
                   
                </table>
                <table>
                    <tr>
                        <th></th>
                        <th style="padding-left: 325px">
                            <asp:Button runat="server" ID="btnsubmit" OnClick="btnsubmit_Click" CssClass="'YourButtonStyle"  OnClientClick="if(!ValidateData()) return false;" Text="Submit" style="height: 26px" />
                            &nbsp;&nbsp;
                           <asp:Button runat="server" ID="btnClear" OnClick="btnClear_Click" Text="Clear" />
                            &nbsp;&nbsp;
                            </th>
                        <td></td>
                    </tr>
                </table>
            </div>
        </div>
</asp:Content>
