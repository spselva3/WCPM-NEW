<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmLogin.aspx.cs" Inherits="WCPM.frmLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - MTS</title>
    <script lang="javascript">
        window.history.forward(0);
    </script>
    <link rel="shortcut icon" href="images/new_icon.ico" />
    <link id="lnkDashBordHome" href="css/cmsreport.css" rel="Stylesheet" type="text/css" />
    <style type="text/css">
        body {
            color: #222;
            font: 13px Arial Helvetica,arial,sans-serif;
            line-height: 18px;
        }

        .centeralign {
            text-align: center;
            margin-left: auto;
            margin-right: auto;
        }

        hr {
            border-top: 0.5px solid #EBEBEB;
        }

        .content-heading {
            font-weight: bold;
            font-size: 16px;
            color: rgb(116, 116, 116);
            padding-top: 10px;
        }

        a {
            color: #0968b3 !important;
            text-decoration: none;
            cursor: pointer;
        }

            a:hover {
                color: #0968b3 !important;
                text-decoration: underline;
            }
        /* Drop Down */ .dropdown {
            padding: 3px;
            font-size: 12px;
            height: 28px;
        }
        /* Size */ .max-plus {
            width: 300px;
        }

        .max {
            width: 260px;
        }

        .medium-plus {
            width: 200px;
        }

        .medium {
            width: 160px;
        }

        .small-plus {
            width: 150px;
        }

        .small {
            width: 110px;
        }

        .very-small {
            width: 70px;
            text-align: right;
        }

        .small-Numeric {
            width: 110px;
            text-align: right;
        }
        /*  My Form  */ .myform {
            margin: auto auto;
            padding: 14px;
            font-weight: bold;
            width: 416px;
        }

        .myform {
            border: solid 1px rgb(164,194,244);
            background-color: rgb(201,218,248);
        }

            .myform tr td {
                text-align: left;
            }

            .myform a {
                color: #BBB !important;
                text-decoration: none;
            }

                .myform a:hover {
                    color: #4787ED !important;
                }
        /* Button */ .button {
            -webkit-transition: all 0.218s ease 0s;
            -webkit-user-select: none;
            -moz-transition: all 0.218s ease 0s;
            -moz-user-select: none;
            -moz-border-radius: 2px 2px 2px 2px;
            border-radius: 2px 2px 2px 2px;
            cursor: pointer;
            display: inline-block;
            font-weight: bold;
            min-width: 46px;
            min-height: 24px;
            padding: 5px 5px 5px 5px;
            text-align: center;
        }

        .button-blue {
            background-color: #4D90FE;
            background-image: -moz-linear-gradient(center top, #4D90FE, #4787ED);
            background-image: -webkit-linear-gradient(center top, #4D90FE, #4787ED);
            border: 1px solid #3079ED;
            color: #FFFFFF;
            text-shadow: 0 1px rgba(0, 0, 0, 0.1);
        }
        /* TextBox */ input.float {
            text-align: right;
            padding-right: 5px;
            border: 1px solid #c4c4c4;
            font-size: 13px;
            padding: 4px 4px 4px 4px;
            border-radius: 1px;
            -moz-border-radius: 1px;
            -webkit-border-radius: 1px;
            box-shadow: 0px 0px 8px #d9d9d9;
            -moz-box-shadow: 0px 0px 8px #d9d9d9;
            -webkit-box-shadow: 0px 0px 8px #d9d9d9;
        }

            input.float:focus {
                outline: none;
                border: 1px solid #7bc1f7;
                box-shadow: 0px 0px 8px #7bc1f7;
                -moz-box-shadow: 0px 0px 8px #7bc1f7;
                -webkit-box-shadow: 0px 0px 8px #7bc1f7;
            }

        input.twitterTextbox {
            border: 1px solid #c4c4c4;
            height: 16px;
            font-size: 13px;
            padding: 4px 4px 4px 4px;
            border-radius: 1px;
            -moz-border-radius: 1px;
            -webkit-border-radius: 1px;
            box-shadow: 0px 0px 8px #d9d9d9;
            -moz-box-shadow: 0px 0px 8px #d9d9d9;
            -webkit-box-shadow: 0px 0px 8px #d9d9d9;
        }

        .trademark {
            font-size: 15px;
            padding: 10px;
            background-color: rgb(230,101,80);
            color: rgb(243,243,243);
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
        }

        .auto-style1 {
            width: 73px;
        }

        .auto-style2 {
            width: 78px;
        }

        .auto-style3 {
            width: 268435440px;
        }
        .auto-style4 {
            text-decoration: underline;
        }
        .auto-style5 {
            height: 42px;
        }
        .auto-style6 {
            width: 73px;
            height: 38px;
        }
        .auto-style7 {
            width: 268435440px;
            height: 38px;
        }
        .auto-style8 {
            width: 78px;
            height: 38px;
        }
        .auto-style9 {
            height: 38px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centeralign">
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <table class="myform centeralign" cellpadding="5px" style="border-radius: 15px 15px 15px 15px;">
                <thead>
                    <tr>
                        <td colspan="4" style="padding-top: 1px;" class="auto-style1">
                            <img src="images/SignodeLogo.png" style="width: 120px; height: 50px;" alt="Logo" />&nbsp;
                        </td>
                        <td colspan="4" style="padding-top: 1px; text-align: end;">
                            <img src="images/wesco-main-logo.png" style="width: 120px; height: 50px;" alt="Logo" />
                        </td>
                    </tr>
                    <tr>
                        <th colspan="8" align="center" style="padding: 15px; font-family: Arial; font-size: 16px;" class="auto-style4">
                            MATERIAL TRACKING SYSTEM</th>
                    </tr>
                </thead>
                <tbody style="padding-left: 50px;">
                    <tr>
                        <td colspan="4" style="text-align: left;" class="auto-style1">User Name
                        </td>
                        <td class="auto-style3">:
                        </td>
                        <td class="auto-style2" align ="left">
                            <asp:TextBox ID="txtUsername" runat="server" class="twitterTextbox" placeholder="Username" Width="150px"></asp:TextBox>
                        </td>
                        <td style="width: auto;"></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: left;" class="auto-style6">Password
                        </td>
                        <td class="auto-style7">:
                        </td>
                        <td class="auto-style8">
                            <asp:TextBox ID="txtPassword" runat="server" class="twitterTextbox" placeholder="Password" TextMode="Password" Width="150px"></asp:TextBox>
                        </td>
                        <td class="auto-style9"></td>
                    </tr>
                     <tr>
                        <td colspan="4" style="text-align: left;" class="auto-style1">Line No
                        </td>
                        <td class="auto-style3">:
                        </td>
                        <td class="auto-style2">
                           <asp:DropDownList ID="ddlLineNum" runat="server" Width="150px">
                                <asp:ListItem Text="Please Select" Value="Please Select" Selected="True"></asp:ListItem>
                              
                            </asp:DropDownList>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="auto-style5"></td>
                        <td colspan="5" style="padding-left: 25px;" class="auto-style5">
                            <asp:Button ID="btnLogin" runat="server" Text="Login" ValidationGroup="LOGIN" CssClass=" button button-blue"
                                Style="padding: 0px; float: left;" OnClick="btnLogin_Click" Height="30" Width="100" />
                        </td>
                        <td class="auto-style5"></td>
                    </tr>
                    <tr align="center">
                        <td colspan="7" style="color: Red;">
                            <asp:Label ID="lblError" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                        </td>
                    </tr>
                    <tr align="center">
                        <td colspan="7" style="color: Black;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@2020 Signode India Limited.Supply Chain Solutions</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
