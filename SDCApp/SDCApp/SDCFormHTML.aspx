<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SDCFormHTML.aspx.cs" Inherits="SDC.SDCFormHTML" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <title></title>
    
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <%--<link href="<%: ResolveUrl("~/Content/Additions.css?ver=1.2") %>" rel="stylesheet" />--%>
     <link href="<%: ResolveUrl("~/Content/menu.css?ver=1.26") %>" rel="stylesheet" />
    <link rel='stylesheet' href='Transforms/working/sdctemplate.css?ver=1' type='text/css' />
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> 
    <script src="Scripts/angular.js"></script> 
    <script src="Scripts/angular-route.js"></script> 
    
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="Scripts/site.js?ver=1.40"></script>

    <script type="text/javascript">
        
        var url = window.location.href;
        var arguments = url.split('&')[2].split('=');
        var receivers = arguments[1];
        
        $.ajax({
            type: "POST",
            url: 'Services/FormManager.asmx/GetReceiverUrls',
          
            data: "receiverids=" + receivers,
            dataType: "text",
            success: function (msg) {
               
                var xmlDoc = $.parseXML(msg);
                $myxml = $(xmlDoc);
                if ($myxml.find("string").text()!="")
                    $('#submiturl').val($myxml.find("string").text());
                
            },
            error: function (xhr, msg) { alert(msg + '\n' + xhr.responseText); }
        });
       
    </script>
    <style>
       /*
        .error{
            color:red;
        }

       
        .chkChoice td 
        { 
            padding-right: 20px; 
        }
        
        
        table, th, td {
            border: none;
            border-collapse: collapse;
            padding-top: 4px;
            padding-bottom:4px;
            padding-left: 10px;
            
        }

          
      */
         a.linkClass {
            border: none;
            background: transparent;
            color: blue !important;
            text-decoration: underline;
            font-size: 13px;
        }

         .steps.selected {
                background-color:white;
                font-weight:bold;
               
            }

          .steps {
            float: left;
            display: inline;
            margin-right: 4px;
            margin-top: 8px;
            background-color: lightgray;
            height: 20px;
            font-family: Arial;
            font-size: 12px;
            padding: 4px;
             cursor:pointer;
        }
       a {
           text-decoration: none;
       }
    </style>
        
    </head>

  <body>
      <div ng-app="SDCApp" ng-controller="SDCTransactionCtrl">
        <div ng-include="'header.html'"></div>
        <div id='step1' class='steps' onclick="window.location.href='formfillerstep2.html'"><strong> Step 1: Select Package ></strong></div>
        <div id='step2' class='steps selected'><strong> Step 2: Submit Package to Receiver ></strong></div>
        <div id='step3' class='steps'><strong> Step 3: Confirmation</strong></div>
          <br />
          <br />
           <br />
          <br />
        <form>
        
        </form>
        <div id="content" runat ="server">
                    <!--place holder for form-->
        </div>
          <a class="linkClass" id='anotherpackage' href="formfillerstep2.html">Select another package</a>
        <div id="submitmsg" runat="server"></div>
      </div>
    
    
    
   
 
</body>

</html>
