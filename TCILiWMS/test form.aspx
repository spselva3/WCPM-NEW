<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test form.aspx.cs" Inherits="WCPM.test_form" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        table#t01 {
            width: 100%;
            background-color: #f1f1c1;
        }
        </style>
</head>

<body>
    <form id="form1" runat="server">
        <div>
           <div id="topcontent">
        <div class="left">
            <div id="locations">
            </div>
        </div>
    </div>
              <div class="left">
        <div id="dvtotalcounts">
        </div>
    </div>
      

        </div>
    </form>
</body>
</html>
