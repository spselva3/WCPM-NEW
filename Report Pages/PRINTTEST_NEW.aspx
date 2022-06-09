<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="PRINTTEST_NEW.aspx.cs" Inherits="TESTWEB.PRINTTEST_NEW" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        function PrintDiv() {
            //alert('HI');
            //document.getElementById("Buttonprint").style.display = "none";
            //document.getElementById("Buttonprint").style.visibility = "hidden";
            //window.print();

            var divContents = document.getElementById("dvContentsPrint").innerHTML;
            var printWindow = window.open('', '', 'height=800,width=800');
            printWindow.document.write('<html><head><title>Finishing House Reel Entry Report</title>');
            printWindow.document.write('</head><body >');
            printWindow.document.write(divContents);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>
    


    <div class="portlet portlet-blue">
        <div class="portlet-heading">
            <div class="portlet-title">
                <h4>Summary</h4>

            </div>
            <div class="clearfix" style="padding-top: 5px;">
                <input type="button" onclick="PrintDiv();" value="Print" style="float: left;" />
            </div>
        </div>
       
        <div id="dvContentsPrint" style="display: block; visibility: hidden;">
            <div id="DynamicDivPrint" runat="server" class="portlet-body"></div>
        </div>
    </div>


</asp:Content>
