<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Authorize.aspx.cs" Inherits="SDC.Authorize" %>

<meta name="google-signin-client_id" content="744808901662-ov9v32g8hkjc34sjj5vhmapt0guds49m.apps.googleusercontent.com">
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />

     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <style type="text/css">
        html {
            font-family: Arial;
            font-size: 12px;
            background-color: #E9E9E9;
        }

        table {
            margin: auto;
            font-size: 12px;
        }

        h1 {
            text-align: center;
            font-size: 24px;
        }

        .bg {
            /* The image used */
            /*background-image: url("images/dotsbg.jpg");*/
            background-color: #E9E9E9;
            /* Full height */
            height: 100%;
            /* Center and scale the image nicely */
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }

        div.center {
            width: 500px;
            height: 250px;
            margin-top: 20px;
            background-color: transparent;
            /*position: absolute;*/
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            /*margin: auto;*/
            margin-right: auto;
            margin-left: auto;
        }

        td {
            padding: 5px
        }

        .login {
            border: none;
            background-color: #009BBF;
            width: 50%;
            color: white;
            padding: 4px;
        }

        .ax_default {
            font-family: 'Arial';
            font-weight: 400;
            font-style: normal;
            font-size: 13px;
            color: #333333;
            text-align: center;
            line-height: normal;
        }

        .image {
        }

        #u31_img {
            border-width: 0px;
            width: 276px;
            height: 67px;
        }

        #u32_img {
            border-width: 0px;
            width: 194px;
            height: 65px;
        }

        #u31 {
            border-width: 0px;
            position: absolute;
            left: 314px;
            top: 15px;
            width: 276px;
            height: 67px;
        }

        #u32 {
            border-width: 0px;
            position: absolute;
            left: 629px;
            top: 11px;
            width: 194px;
            height: 65px;
        }

        .margin-bot-6 {
            margin-bottom: 6px;
            font-size: 12px;
            font-family: Arial
        }

        .button {
            background-color: #00549f;
            text-transform: uppercase;
            font-weight: bold;
            width: 100%;
            font-size: 0.8em;
            color: white;
            height: 38px;
            transition: background-color 0.25s ease-out, color 0.25s ease-out;
            margin: 0;
        }

        .buttonLogin{
            font-size:1.2em
        }

            .button:hover {
                background-color: #00396c;
            }

            .labelColumnClass{
                text-align: right;
                width: 13%;
            }

            .inputColumnClass{
                    width: 85%;
            }

            .inputFieldClass{
                width: 100%;
                height: 32px;
                padding: 5px;
            }

            .spanClass{
                float: left;
                font-size: 18px;
                line-height: 18px;
                display: inline-block;
    height: 15px;
    padding-bottom: 10px;

                
            }
        .left{
                         float: left;
                     }
        .right{
                         float: right;
                     }
               
    </style>


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="Scripts/Site.js"></script>
    <script>



        function getUrlParam(parameter, defaultvalue) {
            var urlparameter = defaultvalue;
            if (window.location.href.indexOf(parameter) > -1) {
                urlparameter = getUrlVars()[parameter];
            }
            return urlparameter;
        }

        function signout() {
            window.location = "https://www.google.com/accounts/Logout";
        }

        function saveuserinfo() {
            console.log('in saveuserinfo');
            var t = document.getElementById("tokenid").value;
            console.log(t);
            sessionStorage.setItem("token", t);

        }

        function AnotherFunction()
    {
        alert("This is another function");
    }
        //$( window ).unload(function() {
        //    alert( "Handler for .unload() called.");
        //});

        function onSignIn(googleUser) {



            $('#googleauth').hide();
            var profile = googleUser.getBasicProfile();
            $('#lblMessage').val("Google authentication sucessful with user email:' + profile.getEmail() + '. Please wait while the application logs you in ...")
            var id_token = googleUser.getAuthResponse().id_token;
            var user = new Object();
            user.ID = profile.getId();
            user.Name = profile.getName();
            user.Email = profile.getEmail();
            user.Token = id_token;
            console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
            console.log('Name: ' + profile.getName());
            console.log('Image URL: ' + profile.getImageUrl());
            console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.

            var encodedUrl = encodeURI(profile.getEmail());
            //$.ajax({
            //    url: "GoogleCallback.aspx",
            //    type: "POST",
            //    //data: user,
            //    data: "{email:'" + "hello" + "'}",
            //    contentType: "application/json",
            //    success: function (data) {
            //        alert('Google sign in - success');

            //        //alert('now calling authorize.aspx/Registerd again.')
            //        //var Data = JSON.stringify({ email: profile.getEmail() });

            //        //$.ajax({
            //        //    url: "ServerProcess.aspx/Download",
            //        //    type: "POST",
            //        //    dataType: "json",
            //        //    data: Data,
            //        //    contentType: "application/json; charset=utf-8",
            //        //    success: function (data) {
            //        //        console.log(data);
            //        //        alert('Successfylly called Registered');
            //        //    },
            //        //    function(err) { alert(err.get_message()); }
            //        //})

            //        localStorage.setItem("user", profile.getEmail());
            //        localStorage.setItem("authenticator", "google");

            //        window.location = "home.html?User=" + encodedUrl+"&authorize=google";





            //    },
            //    error: function (XMLHttpRequest, textStatus, errorThrown) {
            //        alert(textStatus);
            //    }
            //});

            $.ajax({
                type: "POST",
                url: "GoogleCallback.aspx/Authorize",
                data: "{email:'" + profile.getEmail() + "',token:'" + id_token + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {

                    //console.log(msg);
                    if (msg.d != "1") {
                        alert("You are authenticated but not registered. Click ok to Register.")
                        window.location = "register.aspx";
                    }
                    else {
                        alert("You are authenticated and registered. Click Ok to proceed to the home page.");
                        window.location = "home.html?User=" + encodedUrl + "&authorize=google";
                    }
                }
            });

        }
    </script>
</head>

<body onbeforeunload="saveuserinfo()">



    <form id="form1" runat="server">

        <input type="hidden" val="test" id="tokenid" runat="server" />

        <div class="center">

            <div style="display: inline">
                <div style="display: inline; float: left">
                    <a href='https://www.cap.org/' id="logobox" style="display: inline">
                        <img id="u31_img" src="Images/CAPLogo.PNG" alt="The College of American Pathologists" />
                    </a>
                </div>

                <div style="display: inline; float: right">
                    <a href='https://www.healthit.gov/' id="logobox1">
                        <img id="u32_img" src='./Images/hhsIT.PNG' alt="Health IT.gov" />
                    </a>
                </div>
                <div style="clear: both">
                </div>

                <div style="background-color: #D2D2D2;">
                    <asp:Login ID="Login1" ClientIDMode="Static" runat="server"  style="width: calc(100% - 20px); margin:10px; border-collapse:collapse;" OnAuthenticate="Login1_Authenticate" FailureText="Login failed. Please try again." FailureTextStyle-ForeColor="Red">
                        <LayoutTemplate>
                            <table style="width:100%">
                                <tr>
                                    <td>
                                        <div style="text-align: center; font-weight: 400; font-size: 22px; color: #666666">Log in to SDC</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="text-align: center">Are you a licensed CAP eCC user? Login with your CAP eCC credentials</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table style="width:100%">
                                            <tr>
                                                <td class="labelColumnClass"><b>User ID:</b></td>
                                                <td class="inputColumnClass">
                                                    <asp:TextBox class="inputFieldClass" ClientIDMode="Static" ID="UserName" runat="server"></asp:TextBox>
                                                    <%--<asp:requiredfieldvalidator id="UserNameRequired" runat="server" placeholder="your user id" value="Enter User Name" ControlToValidate="UserName" ForeColor="Red" Text="*"></asp:requiredfieldvalidator>--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="labelColumnClass"><b>Password:</b></td>
                                                <td class="inputColumnClass">
                                                    <asp:TextBox class="inputFieldClass" ClientIDMode="Static" ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                                    <%--<asp:requiredfieldvalidator id="PasswordRequired" runat="server" placeholder="your password" value="Enter Password" ControlToValidate="Password" Text="*"></asp:requiredfieldvalidator>--%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center">
                                        <asp:Button ID="Login" CssClass="button margin-bot-6 buttonLogin" CommandName="Login" runat="server" Text="LOG IN &nbsp;&nbsp;&nbsp; &#xbb;">
                                            
                                        </asp:Button>
                                        </font>
                                          
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="text-align: center; padding-top: 20px">
                                            <span class="spanClass left">................</span>
                                            <span class="spanClass" style="font-size:12px;float:none;">Don’t have CAP eCC credentials, log in with</span>
                                            <span class="spanClass right">...............</span>
                                            </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%--<asp:Button ID="GoogleLogin" CssClass="g-signin2"  runat="server" Text="Google Login" OnClick="GoogleLogin_Click" />--%>
                                        <div style="text-align: center;">
                                            <asp:ImageButton ImageUrl="~/Images/GoogleSignin.png" runat="server" OnClick="GoogleLogin_Click" />
                                        </div>
                                        <%-- <div style="width:30%;margin:0 auto" >
                                            <div class="g-signin2" data-onsuccess="onSignIn"></div>  
                                            </div>  --%>
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <asp:Literal ID="FailureText" runat="server"></asp:Literal></td>
                                </tr>
                            </table>

                        </LayoutTemplate>

                        <ValidatorTextStyle ForeColor="Red" />
                    </asp:Login>

                </div>

                <div id="forgotPassword" style="text-align: center; margin-top: 20px">
                    <div style="text-align: center; font-weight: 400; font-size: 22px; color: #666666">Forgot your CAP eCC user ID or password? </div>
                    <div style="padding-top: 10px">
                        <span>Contact CAP at </span>
                        <a href="mailto:someone@yoursite.com?subject=<Subject>">capecc@cap.org</a>
                        <span> or call at  847-832-7700. </span>
                    </div>


                </div>



            </div>


        </div>
    </form>

</body>
</html>


