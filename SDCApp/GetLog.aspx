<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetLog.aspx.cs" Inherits="SDC.GetLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />
    <title></title>
    <script src="Scripts/angular.js"></script>
    <script src="Scripts/angular-route.js"></script>
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="Scripts/site.js?ver=1.36"></script>
    <style>
        html {
            margin-left: 20px;
            margin-right: 20px;
            margin-top: 20px;
            font-size: 11px;
            font-family: Arial;
        }

        table, th, td, tr {
            border: none;
        }


            table tr:nth-child(even) {
                background-color: inherit;
                color: black;
                font-weight: normal
            }

            table tr:nth-child(odd) {
                background-color: inherit;
                color: black;
                font-weight: normal
            }

        

         input[type="submit"],
         input[type="button"] button {
			background-color: #009BBF;
			text-transform: uppercase;
			font-weight: bold;
			/*width:100%;*/
			font-size:0.8em;
			color:white;
			height:38px;
			transition: background-color 0.25s ease-out, color 0.25s ease-out;
			margin: 0;
		}
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>

    <script>
        $(window).on("load", function (e) {
            $('#copyright').text("© " + new Date().getFullYear() + " SDC Application");
        });
    </script>

    <script>

      
        $(window).on('load', function () {
           // $('#back').
            if (document.referrer.indexOf("Transaction") >= 0) {
                $("#back").attr("href", "TransactionLog.html");
                $('#back').text("Transaction Log");
            }
            else {
                $("#back").attr("href", "Submissions.html");
                $('#back').text("Form Receiver");
            }
        });

        function decode() {
            var xmlDoc = $.parseXML($('#messagearea').val());

            var $xml = $(xmlDoc);
            var htmlNode = $xml.find("HTMLPackage");
            var base64 = '';
            var file = 'download.txt';

            if (htmlNode.length == 1 & $('#base64area').val() == '') {

                file = $xml.find("SDCPackage").attr('packageID') + '.html';
                base64 = htmlNode.text();
                base54 = base64.replace('/r/n', '');
            }
            else {
                base64 = $('#base64area').val();
            }

            //decode
            try {
                //atob does not work 
                //$('#base64area').val(atob(base64));
               
                 // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
                 base64 = base64.replace(/[^A-Za-z0-9\+\/\=]/g, "");
                $('#base64area').val(b64DecodeUnicode(base64));
            }
            catch (err) {
                alert(err.message + '/r/n' + base64);
            }


            $('#link').show();
            //add the click event and update href for download
            document.getElementById('link').onclick = function (code) {
                if (window.navigator.msSaveOrOpenBlob) {
                   
                    var fileData = [$('#base64area').val()];
                    blobObject = new Blob(fileData);
                    window.navigator.msSaveOrOpenBlob(blobObject, file);
                }
                else {
                    this.href = 'data:text/plain;charset=utf-8,'
                    + encodeURIComponent($('#base64area').val());
                
                this.download = file;
                }


                
            }



        }

        function xb64DecodeUnicode(input) {
     var output = "";
     var chr1, chr2, chr3 = "";
     var enc1, enc2, enc3, enc4 = "";
     var i = 0;
            var keyStr = "ABCDEFGHIJKLMNOP" +
               "QRSTUVWXYZabcdef" +
               "ghijklmnopqrstuv" +
               "wxyz0123456789+/" +
               "=";

     // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
     var base64test = /[^A-Za-z0-9\+\/\=]/g;
     if (base64test.exec(input)) {
        alert("There were invalid base64 characters in the input text.\n" +
              "Valid base64 characters are A-Z, a-z, 0-9, '+', '/',and '='\n" +
              "Expect errors in decoding.");
     }
     input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

     do {
        enc1 = keyStr.indexOf(input.charAt(i++));
        enc2 = keyStr.indexOf(input.charAt(i++));
        enc3 = keyStr.indexOf(input.charAt(i++));
        enc4 = keyStr.indexOf(input.charAt(i++));

        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;

        output = output + String.fromCharCode(chr1);

        if (enc3 != 64) {
           output = output + String.fromCharCode(chr2);
        }
        if (enc4 != 64) {
           output = output + String.fromCharCode(chr3);
        }

        chr1 = chr2 = chr3 = "";
        enc1 = enc2 = enc3 = enc4 = "";

     } while (i < input.length);

     return unescape(output);
  }


        
        function b64DecodeUnicode(str) {

            
            return decodeURIComponent(Array.prototype.map.call(atob(str), function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
            }).join(''))
        }

    </script>
</head>
<body>
    <div ng-app="SDCApp" ng-controller="TransactionsCtrl">
        <div ng-include="'header.html'"></div>
        <div>
          <ul class="breadcrumb">
          <li><a id="back" href="submissions.html">Form Receiver</a></li>
          <li ><a style="color:black" href="#">View Xml</a></li>          
        </ul>
         </div>
        <div style="clear:both"></div>
        <form id="form1" runat="server">
            <div style="width: 100%;margin-top:20px">
                <table>
                    <tr>
                        <td style="width:100px">Transaction Id:</td>
                        <td><span runat="server" id="id"></span></td>
                    </tr>
                    <tr>
                        <td>Transaction Type:</td>
                        <td><span runat="server" id="type"></span></td>
                    </tr>
                    <tr>

                        <td colspan="2"><p>Message</p>

                            <textarea runat="server" style="width: 100%;" rows="20" id="messagearea"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><p style="font-weight:bold">Base64 Decoder: Enter base64 string below to decode, 
                            or leave empty to decode base64-encoded HTMLPackage content if included in RetrieveFormResponse above.</p>
                            <textarea runat="server" style="width: 100%;" rows="20" id="base64area"></textarea>
                            <br />
                            <button id="btndecode" onclick="decode();return false;">Decode Base64</button>
                            <a href="#" id="link" style="display: none; margin-left: 20px" download="code.txt">Download</a>
                        </td>

                    </tr>
                </table>

            </div>
        </form>
    </div>
      <div id="footer" style="text-align: center;background-color:#333333; margin-top:10px; padding:8px; margin-bottom:20px; color:whitesmoke">
        <span id="copyright" style="font-family:Arial;font-size:12px;display: inline-block;"></span>
    </div>
</body>
</html>
