<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmtest123.aspx.cs" Inherits="WCPM.frmtest123" %>

<!DOCTYPE html>

<html>
<head>
    <title>First AngularJS Application</title>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.16/angular.min.js"></script>
</head>
<body ng-app >
    <h1>First AngularJS Application</h1>

    Enter Numbers to Multiply: 
    <input type="text" ng-model="Num1" /> x <input type="text" ng-model="Num2" /> 
    = <span>{{Num1 + Num2}}</span>  
</body>
</html>
