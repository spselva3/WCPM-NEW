<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
   <title>Custom TreeView</title>
    <style type="text/css">
        .tree {}
    </style>
</head>
<body>
   <form id="form1" runat="server">
   <div id="container">
           <asp:TreeView ID="tvLocationView" Font-Names="Calibri" Font-Size="Small" ShowLines="true" NodeStyle-CssClass="treeNode"
    SelectedNodeStyle-Font-Bold="true" SelectedNodeStyle-ForeColor="Green"
                    runat="server" Width="150px">
                   
                </asp:TreeView>
       <asp:Button ID="ttxt" runat="server" Text="Sample" />
      <asp:SiteMapDataSource ID="siteSource" 
                             runat="server" 
                             ShowStartingNode="true"  />
   </div>
   </form>
</body>
</html>
