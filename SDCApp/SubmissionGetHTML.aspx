<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeBehind="SubmissionGetHTML.aspx.cs" Inherits="SDC.SubmissionGetHTML" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <script src="<%: ResolveUrl("~/Scripts/modernizr-2.6.2.js") %>"></script>
    <link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />
    <link rel='stylesheet' href='Transforms/working/sdctemplate.css' type='text/css' />
     <script src="Scripts/angular.js"></script> 
     <script src="Scripts/angular-route.js"></script> 
     <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="Scripts/site.js?ver=1.40"></script>
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
     <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>   
     <script src="https://apis.google.com/js/client:platform.js?onload=startApp" async defer></script>
    <script>
        $(window).on("load", function (e) {
            $('#copyright').text("© " + new Date().getFullYear() + " SDC Application");
        });
    </script>
    <script>
        $(window).on("load", function (e) {
            $('#btnParameters').hide();
            $('#btnRetrieveResponse').hide();
            $('#anotherpackage').hide();
            
           
        });
       


        function startApp() {

            

            gapi.load('auth2', function () {

                $.getJSON('config/server.json', function (data) {
                    id = data.google_client_id;
                    console.log(data.google_client_id);

                    gapi.client.load('plus', 'v1').then(function () {
                        gapi.signin2.render('signin-button', {
                            scope: 'profile',
                            fetch_basic_profile: false
                        });
                        gapi.auth2.init({
                            fetch_basic_profile: false,
                            client_id: id,
                            scope: 'profile'
                        }).then(function () {
                            console.log('init');
                            auth2 = gapi.auth2.getAuthInstance();
                           
                            auth2.isSignedIn.listen(function () {
                                console.log('uuu'+auth2.currentUser.get());
                            });
                            auth2.then(function (resp) {
                                console.log('vvv'+auth2.currentUser.get());
                            });
                        });
                    });
                });
            });

                
        }
         function CAPLogout() {
            console.log('signing out of CAP');

            window.location.href = 'authorize.aspx';
        }
         function GoogleSignout() {

            gapi.auth2.getAuthInstance().signOut();          
            gapi.auth2.getAuthInstance().disconnect();
            //alert("signed out w/o any error");

            $.ajax({
                url: "GoogleCallback.aspx?Signout",
                type: "POST",
                //data: user,
                data: "{email:'" + "hello" + "'}",
                contentType: "application/json",
                success: function (data) {
                    window.location = 'authorize.aspx';

                }

                //alert('now calling authorize.aspx/Registerd again.')
                //var Data = JSON.stringify({ email: profile.getEmail() });
            });
        }

    </script>
    <style>
        /*html {
            margin-left: 20px;
            margin-right: 20px;
            margin-top:20px;
            font-size:11px;
            font-family:Arial;
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

 a {text-decoration:none!important}
    </style>
    <title></title>
</head>
<body>
     <div  ng-app="SDCApp" ng-controller="SDCSubmitCtrl">
         <div ng-include="'header.html'"></div>
         <div>
              <ul class="breadcrumb">
                  <li><a href="submissions.html">Form Receiver</a></li>
                  <li ><a style="color:black" href="#">View Html</a></li>          
             </ul>
          </div>
   

        <div style="clear:both"></div>
         <!--hide the submit button-->
        <input type="hidden" runat="server" id="allowsubmit" value="no"/>
        <textarea runat="server" id="rawxml" style="display:none;width:80%;margin-left:80px;margin-right:80px;background-color:wheat" rows="10"></textarea>
        <div id="content" runat="server">
    
        </div>
    </div>
     <%--<p><span>© 2017 SDC Application</span></p>--%>
   <div id="footer" style="text-align: center;background-color:#333333; margin-top:10px; padding:8px; margin-bottom:20px; color:whitesmoke">
        <span id="copyright" style="font-family:Arial;font-size:12px;display: inline-block;"></span>
    </div>
</body>
</html>