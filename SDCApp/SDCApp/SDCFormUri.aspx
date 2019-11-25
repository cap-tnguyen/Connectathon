<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeBehind="SDCFormUri.aspx.cs" Inherits="SDC.GetFormUri" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/Content/Additions.css?ver=1.2") %>" rel="stylesheet" />
     <link href="<%: ResolveUrl("~/Content/menu.css?ver=1.26") %>" rel="stylesheet" />
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> 
    <script src="Scripts/angular.js"></script> 
    <script src="Scripts/angular-route.js"></script> 
    
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="Scripts/site.js?ver=1.40"></script>
    <title></title>
    <style>
         a.linkClass {
            border: none;
            background: transparent;
            color: blue !important;
            text-decoration: underline;
            font-size: 13px;
        }
    </style>
</head>
    
<body>
    <div ng-app="SDCApp" ng-controller="SDCTransactionCtrl">
        <div ng-include="'header.html'"></div>
    </div>
    <form id="form1" runat="server">
        <div id="urldiv" style="margin-top:20px" runat="server">

        </div>
    
    </form>
</body>
</html>
