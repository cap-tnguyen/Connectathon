<%@ Page EnableEventValidation="false" ValidateRequest="false" Language="C#" AutoEventWireup="true" CodeBehind="GetXML.aspx.cs" Inherits="SDC.GetXML" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="<%: ResolveUrl("~/Scripts/Site.js") %>"></script>
    <style>
        /*body{
            margin-left:40px;
        }*/
          /* Style the list */
 ul.breadcrumb{
            margin:0px;
            /*padding:10px 36px 15px 18px;*/
            background-color:white;
        }

/* Display list items side by side */
ul.breadcrumb li {
  display: inline;
  font-size: 12px;
  
}

li a{
    display:inline;
    background-color:white!important;
}
 /*Add a slash symbol (/) before/behind each list item*/ 
ul.breadcrumb li+li:before {
  padding: 8px;
  color: black;
  content: "\003E";
}

/* Add a color to all links inside the list */
ul.breadcrumb li a {
  color: #009BBF;
  text-decoration: none;
  padding:4px;
}

 ul.breadcrumb li a.selected{
         
            color: black;
           cursor:auto;
        }

/* Add a color on mouse-over */
ul.breadcrumb li a:hover {
  /*color: #01447e;
  text-decoration: underline;*/
   background-color:white!important;
}

a.linkClass {
            border: none;
            background: transparent;
            color: #009BBF!important;
            text-decoration: underline;
            font-size: 12px;
        }

 .pagetitle{
     font-family:Arial;
     font-size:18px;
     font-weight:bold;
 }

 .pagecontent{
     margin-top:30px;
 }
    </style>


</head>
<body>
    <script src="Scripts/angular.js"></script> 
    <script src="Scripts/angular-route.js"></script> 
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script>
        function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) { return pair[1]; }
    }
    return (false);
        }

        $(window).on("load", function (e) {
            $('#copyright').text("© " + new Date().getFullYear() + " SDC Application");
             $('#packagename').text(getQueryVariable('PackageId'));
        });
    </script>
    <div  ng-app="SDCApp" ng-controller="SDCTransactionCtrl">
    <div ng-include="'header.html'"></div> 

<div style="padding:10px 36px 15px 18px;">
    <div >
          <ul class="breadcrumb">
              <li><a href="formmanager.html">Form Manager</a></li>
              <li ><a class="selected" href="#">View XML Package</a></li>          
          </ul>
     </div>
    <div class="pagecontent">
         <p class="pagetitle">View XML Package - <span id="packagename"></span></p> 
        <form id="form1" runat="server">
        <div>
            <textarea id="rawxml" rows="40" style="width:90%;align-content:center;margin-top:10px" runat="server"></textarea>
        </div>
      
    </form>
      <br />
    <a class="linkClass" href="formmanager.html"><< Back to Form Manager</a> 
    </div>
      
</div>
              
     
     <br/>
    
         
      <div id="footer" style="text-align: center;background-color:#333333; margin-top:10px; padding:8px; margin-bottom:20px; color:whitesmoke">
        <span id="copyright" style="font-family:Arial;font-size:12px;display: inline-block;"></span>
    </div>
</body>
</html>
