<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeBehind="SubmissionGetXML.aspx.cs" Inherits="SDC.SubmissionGetXML" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />
    
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <title></title>
     <script src="Scripts/angular.js"></script> 
     <script src="Scripts/angular-route.js"></script> 
     <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="Scripts/site.js?ver=1.36"></script>
     <script src="https://code.jquery.com/jquery-1.10.2.js"></script>

     <script>
        $(window).on("load", function (e) {
            $('#copyright').text("© " + new Date().getFullYear() + " SDC Application");
        });
    </script>
    
    <style>
        html {
            margin-left: 20px;
            margin-right: 20px;
            margin-top:20px;
            font-size:11px;
            font-family:Arial;
        }
                 /* Style the list */
/*ul.breadcrumb {
  padding: 10px 16px;
  list-style: none;
  background-color: #eee;
}*/

/* Display list items side by side */
ul.breadcrumb li {
  display: inline;
  font-size: 12px;
}

li a{
    display:inline;
}
 /*Add a slash symbol (/) before/behind each list item*/ 
ul.breadcrumb li+li:before {
  padding: 8px;
  color: black;
  content: "\003E";
}

/* Add a color to all links inside the list */
ul.breadcrumb li a {
  color: #0275d8;
  text-decoration: none;
  padding:4px;
}

/* Add a color on mouse-over */
ul.breadcrumb li a:hover {
  color: #01447e;
  text-decoration: underline;
}
    </style>
    
</head>
<body>
     <div  ng-app="SDCApp" ng-controller="SDCSubmitCtrl">
      <div ng-include="'header.html'"></div>
      <div>
          <ul class="breadcrumb">
          <li><a href="submissions.html">Form Receiver</a></li>
          <li ><a style="color:black" href="#">View Xml</a></li>          
        </ul>
    </div>
         <div style="clear:both"></div>
    <form id="form1" runat="server">

    <div style="width:100%;margin-top:20px">
        <textarea id="rawxml" rows="40" style="width:90%;align-content:center" runat="server"></textarea>
    </div>
        
        <%--<asp:Button ID="close" runat="server" Text="Close" OnClientClick="window.close();return false;" />--%>
    </form>
          <div id="footer" style="text-align: center;background-color:#333333; margin-top:10px; padding:8px; margin-bottom:20px; color:whitesmoke">
            <span id="copyright" style="font-family:Arial;font-size:12px;display: inline-block;"></span>
        </div>
</body>
</html>