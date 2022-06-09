<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmLotReport.aspx.cs" Inherits="WCPM.frmLotReport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head" runat="server">
    <title>LOT REPORT</title>
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
    <script>
        function callMethod() {

            window.open("test form.aspx");

        }
    </script>
     <style>
        .Grid {
            background-color: #fff;
            margin: 5px 0 10px 0;
            border: solid 1px #525252;
            border-collapse: collapse;
            font-family: Calibri;
            color: #474747;
        }

            .Grid td {
                padding: 7px;
                border: solid 1px #c1c1c1;
                font-size: 1.5em;
            }

            .Grid th {
                padding: 4px 2px;
                color: #fff;
                background: #363670 url(Images/grid-header.png) repeat-x top;
                border-left: solid 1px #525252;
                font-size: 1.5em;
            }

            .Grid .alt {
                background: #fcfcfc url(Images/grid-alt.png) repeat-x top;
            }

            .Grid .pgr {
                background: #363670 url(Images/grid-pgr.png) repeat-x top;
            }

                .Grid .pgr table {
                    margin: 6px 0;
                }

                .Grid .pgr td {
                    border-width: 0;
                    padding: 0 6px;
                    border-left: solid 1px #666;
                    font-weight: bold;
                    color: #fff;
                    line-height: 19px;
                    font-size: 2em;
                }

                .Grid .pgr a {
                    color: Gray;
                    text-decoration: none;
                }

                    .Grid .pgr a:hover {
                        color: #000;
                        text-decoration: none;
                    }
                    .right { float: right; padding-right: 15px;
    margin-bottom: 0px;
    height: 25px;
}
    </style>
   
</head>
<body>
    <form id="form1" runat="server">
         <div class="Middle" align="middle" style="font-size: 25px; color: blue;font-weight: bold;">
           LOT REPORT
               <div class="right">
       <%-- <button class="btn" onclick="callMethod()"><i class="fa fa-download"></i>Download</button>--%>
         
              <a href="#" id="id123" onclick="callMethod(); ">
                            <img src="images/download icon.png" width="30px" />
                        </a>
    </div>
             </div>
      
        <br />
     
      

        <div >
            
             
            <div id="detailsMain">
                <asp:GridView ID="GridView1" runat="server" CssClass="Grid" Width="100%">
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
