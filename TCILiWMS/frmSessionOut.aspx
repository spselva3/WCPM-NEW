<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmSessionOut.aspx.cs" Inherits="WCPM.frmSessionOut" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Creative - Bootstrap 3 Responsive Admin Template" />
    <meta name="author" content="GeeksLabs" />
    <meta name="keyword" content="Creative, Dashboard, Admin, Template, Theme, Bootstrap, Responsive, Retina, Minimal" />
    <title>SESSION EXPIRED</title>
    <script lang="javascript">
        window.history.forward(0);
    </script>
    <link rel="shortcut icon" href="images/Icon.ico" />
    <!-- Bootstrap CSS -->
    <link href="Session/css/bootstrap.min.css" rel="stylesheet" />
    <!-- bootstrap theme -->
    <link href="Session/css/bootstrap-theme.css" rel="stylesheet" />
    <!--external css-->
    <!-- font icon -->
    <link href="Session/css/elegant-icons-style.css" rel="stylesheet" />
    <link href="Session/css/font-awesome.min.css" rel="stylesheet" />
    <!-- Custom styles -->
    <link href="Session/css/style.css" rel="stylesheet" />
    <link href="Session/css/style-responsive.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="page-404" style="width: 100%">
            <p class="text-404">SESSION&nbsp; EXPIRED</p>
            <h2>Aww Snap!</h2>
            <p>
                Something went wrong or that page doesn’t exist yet. 
        <br />
                <a href="frmLogin.aspx" style="font-size:larger;font-style:italic;">Return to Login</a>
            </p>
        </div>
    </form>
</body>
</html>
