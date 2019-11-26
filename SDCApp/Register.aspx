<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SDC.Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

     <link href="Content/Site.css?ver=1.3" rel="stylesheet" />
    <link href="Content/Menu.css?ver=1.3" rel="stylesheet" />
    <script src="Scripts/modernizr-2.6.2.js"></script>

    <script src="Scripts/Site.js"></script>

    <link href="https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>


    <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
    <script src="https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>


    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

     <style>
        .ui-widget-header, .ui-state-default, ui-button {
            background: #b9cd6d;
            border: 1px solid #b9cd6d;
            color: #FFFFFF;
            font-weight: bold;
        }
    </style>

    <style>
       
        .headerClass {
            height: 50px;
            font-family: 'Arial Bold', 'Arial';
            font-weight: 700;
            font-style: normal;
            font-size: 14px;
            color: #FFFFFF;
            text-align: center;
            display: table-cell;
        }

        td {
            font-size: 13px;
        }

        .linkClass {
            border: none;
            background: transparent;
            color: blue !important;
            text-decoration: underline;
            font-size: 13px;
        }

        input[type='file'] { /*hides the filename label*/
            color: transparent;
            display: inline-block;
            width: 90px;
        }

        .navigator {
            margin-bottom: 40px;
        }

        #txtSearch {
            font-size: 14px;
            padding: 2px 10px;
            height: 24px;
            width: 500px;
        }


        .tab-title {
            font-family: Arial;
            font-size: 1.4em;
            color: black;
            font-weight: bold;
            margin-top: 10px
        }

        p {
            padding-top: 2px;
        }

        .tab-content {
            background-color: white;
            color: black;
            padding: 5px;
            border-color: grey;
            border-style: solid;
            border-width: thin;
            border-collapse: collapse;
        }

        #bodyContainer {
            background-color: #e9edf7;
            padding: 20px;
        }

        .margin-bot-6 {
            margin-bottom: 6px;
            font-size: 12px;
            font-family: Arial;
        }

        .buttonUpload {
            width: 213px;
            height: 40px;
            background: inherit;
            background-color: rgba(0, 155, 191, 1);
            box-sizing: border-box;
            border-width: 1px;
            border-style: solid;
            border-color: rgba(121, 121, 121, 1);
            border-radius: 5px;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
            box-shadow: none;
            font-family: 'Arial Bold', 'Arial';
            font-weight: 700;
            font-style: normal;
            font-size: 12px;
            color: #FFFFFF;
        }

        /* When the input field gets focus, change its width to 100% */
        input[type=text]:focus {
            width: 80%;
        }

        hr {
            width: 100%;
            margin-left: auto;
            margin-right: auto;
            height: 10px;
            background-color:#D3D3D3;           
            margin-bottom:10px;
            }

        .question{
           
            margin:10px;
            font-family:Arial;
            font-weight:bold;
            font-size:12px;
        }

        input{
            width:500px;
            margin-left:10px;
           
        }
        .info{
            margin:11px;
            font-size:9px;
            color:brown;
        }
    </style>
    <script>
        var user = getUrlParam('User', 'Empty');
        var auth = getUrlParam('authorize');
        
        

        //save to database
        console.log('register:' + user);
        localStorage.setItem("user", encodeURI(user));       
        localStorage.setItem("authenticator", auth);
         alert(document.getElementById("username"));
        document.getElementById("username").textContent = localStorage.getItem('user');
       
    </script>
    
</head>
<body>
    <script src="Scripts/angular.js"></script>
    <script src="Scripts/angular-route.js"></script>
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <div style="float:left;margin:0px;padding:0px">

        <img alt="CAP Logo" src="Images/caplabqualitysolution.gif" />

    </div>
     <div style="float:right">
        <span class="headerRight" style="margin:0px 10px;"  id="username">user name</span>
        <span class="headerRight" style="margin:0px 10px;">|</span>
        <span class="headerRight headerUnderline" style="margin:0px 10px;">Help</span>
        <span class="headerRight" style="margin:0px 10px;">|</span>
        <span class="headerRight headerUnderline" style="margin:0px 10px;" ng-show="authenticator!='google'" onclick="CAPLogout()">Log out</span>
        <span class="headerRight headerUnderline" style="margin:0px 10px;" id="test" ng-show="authenticator=='google'" onclick="GoogleSignout()">Log out</span>

    </div>
    <div style="clear:both" />
    <p class="app-title">SDC Application</p>
    <hr />
    <div style=""></div>
     <div ng-app="SDCApp" ng-controller="UserCtrl">
         
        <form id="form1" runat="server">
            <div>
                <input type="hidden" ng-model="user.userId" id="userid" />
                <div style="margin-top:20px;margin-bottom:20px;margin-left:20px">
                    <p>Thank you for loging in to the SDC application. We would like to know the following details. Please complete the form.</p>
                    <p class="info">*indicates required field</p>
                    <%--<p>User Registration</p>--%>
                <div class="question">*What is the title of your job?</div>
                <input type="text" id="title" ng-model="user.title" />
                <div class="question">*What is your organization/institution name?</div>
                <input type="text" id="aff" ng-model="user.affiliation" />
                <div class="question">Contact Phone Number</div>
                <input type="text" id="phone" ng-model="user.phone" />


                <br />
                </div>
                <div style="margin-top:20px;margin-bottom:20px;margin-left:30px">
                     <button  class="ui-button-text" id="register" ng-click="register($event,user)">SAVE AND CONTINUE</button>
                </div>
               
            </div>
        </form>
    </div>
</body>
</html>
