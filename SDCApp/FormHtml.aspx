<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormHtml.aspx.cs" Inherits="SDC.FormHtml" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />
     <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <title></title>    
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>   
    

    <style>
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
    <script>
        $(window).on("load", function (e)
        { 
           
           if (localStorage.getItem("authenticator") === 'undefined') {
                  $('#test').hide();
              }
              else {
                  $('#caplogout').hide();
            }

            $('#btnParameters').hide();
            $('#btnRetrieveResponse').hide();

            $('.SubmitButton').hide();  //hide by class
            $('#anotherpackage').hide();
        })
    </script>
</head>
<body>
    
     <script src="Scripts/angular.js"></script> 
     <script src="Scripts/angular-route.js"></script> 
     <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <form id="form1" runat="server">
    <%--<div ng-app="SDCApp" ng-controller="FormHtmlCtrl">  
        <div ng-include="'header.html'"></div> 
        <div id="content" runat="server"></div>
    </div>--%>
      
    </form>

     <p><span>© 2017 SDC Application</span></p>
</body>
</html>
