<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadPackage.aspx.cs" Inherits="SDC.UploadPackage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
	<link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />
    <script src="<%: ResolveUrl("~/Scripts/modernizr-2.6.2.js") %>"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> 
    <script src="Scripts/angular.js"></script> 
    <script src="Scripts/angular-route.js"></script> 
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="<%: ResolveUrl("~/Scripts/Site.js") %>"></script>

    <script>
        $(window).on("load", function (e) {
            $('#copyright').text("© " + new Date().getFullYear() + " SDC Application");
        });
    </script>

    <script>
        function fileSelected() {
           
            var file = document.getElementById('fileToUpload').files[0];
            if (file) {
                var fileSize = 0;
                if (file.size > 1024 * 1024)
                    fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
                else
                    fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
                //alert(file.name);
                document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
                //document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
                //document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
            }
        }

        function uploadFile() {

            if (document.getElementById('fileToUpload').files.length == 0) {
                alert("Please select a file to upload.")
                return;
            }
            if (document.getElementById('packageid').value == '') {
                alert("Please enter package id.");
                return;
            }
            if (document.getElementById('packagename').value == '') {
                alert("Please enter package name.")
                return;
            }

            if (document.getElementById('submiturl').value == '') {
                alert("Please select submit url(s) for this package");
                return;
            }

            if (validationpath == '') {
                alert("Please enter the validation (xsds) path");
                return;
            }

            if (transformpath == '') {
                alert("Please enter the transform (xslt) path");
                return;
            }

            var fd = new FormData();
            fd.append("fileToUpload", document.getElementById('fileToUpload').files[0]);
            fd.append("packageid", document.getElementById('packageid').value);
            fd.append("packagename", document.getElementById('packagename').value);
            fd.append("agencyname", document.getElementById('agencyname').value);

            //get submiturls
            //alert($('#submiturl').val());
            fd.append("submiturl", $('#submiturl').val());
            fd.append("validationpath", document.getElementById('validationpath').value);
            fd.append("transformpath", document.getElementById('transformpath').value);

            var Data = JSON.stringify({ PackageID: document.getElementById('packageid').value });
            //alert('here')

            //check if packageid exists
            $.ajax({

                url: "filereceiver.aspx/PackageExists",
                data: Data,
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    //alert(mydata.d);
                    if (mydata.d == true) {
                        alert("This package id already exists. Adding forms to an existing package is currently not supported.");
                        return;


                    }


                    var xhr = new XMLHttpRequest();
                    xhr.upload.addEventListener("progress", uploadProgress, false);
                    xhr.addEventListener("load", uploadComplete, false);
                    xhr.addEventListener("error", uploadFailed, false);
                    xhr.addEventListener("abort", uploadCanceled, false);
                    xhr.open("POST", "filereceiver.aspx");
                    xhr.send(fd);
                }
            });


        }

        function uploadProgress(evt) {

             $('#message').html("Uploading ...");
            if (evt.lengthComputable) {
                var percentComplete = Math.round(evt.loaded * 100 / evt.total);
                
                //document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
            }
            else {
                //document.getElementById('progressNumber').innerHTML = 'unable to compute';
            }
        }

        function uploadComplete(evt) {
            /* This event is raised when the server send back a response */
            //alert(evt.target.responseText);
            //location.reload(true); //refresh page  by loading data from server (not from cache)
            //do not use reload as that will perform last user action - is a problem if user deleted a row
            //var user = localStorage.getItem("user");
            //window.location = 'Home.html?User=' + user;
            //alert('Upload complete!');
            $('#message').html("Upload complete!");
        }

        function uploadFailed(evt) {
            alert("There was an error attempting to upload the file.");
        }

        function uploadCanceled(evt) {
            alert("The upload has been canceled by the user or the browser dropped the connection.");
        }
    </script>

    <style>

         /*body{
            margin-left:40px;
        }*/

          table, th, td, tr {
			border: none;
			padding:4px;
		}
		
		
		table tr:nth-child(even) {
			background-color: inherit;
			color:black;
			font-weight:normal
		}

		table tr:nth-child(odd) {
			background-color: inherit;
			color:black;
			font-weight:normal
		}

        .file-input-wrapper {
            width: 100px;
            height: 25x;
            overflow: hidden;
            position: relative;
          }
          .file-input-wrapper > input[type="file"] {
            font-size: 20px;
            position: absolute;
            top: 0;
            right: 0;
            opacity: 0;
          }
          .file-input-wrapper > .btn-file-input {
            display: inline-block;
            width: 100px;
            height: 25px;
          }

          .row{
              margin-top:40px;
          }

          .button {
			background-color: #009BBF;
            border-color: #009BBF;
			text-transform: uppercase;
			font-weight: bold;
			/*width:100%;*/
			font-size:0.8em;
			color:white;
			height:20px;
			/*transition: background-color 0.25s ease-out, color 0.25s ease-out;*/
			margin: 10px;
            padding: 2px 8px 2px 8px;
		}

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
             background-color:white!important;
            color: #009BBF!important;
            text-decoration: underline!important;
            font-size: 12px;
        }

 .required{
     color:#b41f28;
     font-family:Arial;
     font-size:11px;
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
    <form id="form1" runat="server">
    <div  ng-app="SDCApp" ng-controller="SDCTransactionCtrl" >
        
      <div ng-include="'header.html'"></div>

        <div style="padding:10px 36px 15px 18px;">
            <div>
            <ul class="breadcrumb">
              <li><a href="formmanager.html">Form Manager</a></li>
              <li><a class="selected" href="#">Upload New Package</a></li>          
            </ul>
           </div>
          <div style="clear:both"></div>
     <div id="uploaddiv" class="pagecontent">          
      <p class="pagetitle">Upload New SDC Package</p>            
      <p class="required"> *indicates required field</p>
       
          <table id="uploadtable" style="border-spacing:0px;">
              <tr style="height:11px; padding:2px;">
                  <td style="text-align:right;vertical-align:top" title="Unique ID for package"><span class="required">*</span>Package ID</td><td><input style="height:14px;width:400px"  type="text" name="packageid" id="packageid" /></td>
              </tr>
              
              <tr style="height:11px;padding:2px;">
                  <td style="text-align:right;vertical-align:top"  title="Friendly name for package"><span class="required">*</span>Package Name</td><td><input style="height:14px;width:400px" type="text" name ="packagename" id="packagename" /></td>
              </tr>
              <tr style="height:11px;padding:2px;">
                  <td style="text-align:right;vertical-align:top"  title="Agency name"><span class="required">*</span>Agency Name</td><td><input style="height:14px;width:400px" type="text" name ="agencyname" id="agencyname" /></td>
              </tr>
              <tr style="height:11px;padding:2px;">
                  <td style="text-align:right;vertical-align:top"  title="Submit Endpoint to be used on Retrieve Form Request when the content format is HTML or URL">*Submit Endpoints</td><td>                      
                       
                      <select id="submiturl" style="width:400px" multiple ="multiple" ng-model="selectedReceivers">
                        <option data-ng-repeat="x in Receivers" value="{{x.Id}}">{{x.Name}}-{{x.Url}}</option>
                      </select>
                      
                  </td>
              </tr>
              <tr style="height:11px;padding:2px;">
                  <td style="text-align:right;vertical-align:top"  title="Folder location of xsd files"><span class="required">*</span>Validation Path</td><td>
                      <select style="width:400px" id="validationpath" ng-model="selectedValidationPath">
                        <option data-ng-repeat="x in ValidationPaths" value="{{x.Id}}">{{x.Path}}</option>
                      </select>
                      </td>
                      
              </tr>
              <tr style="height:11px;padding:2px;">
                  <td style="text-align:right;vertical-align:top"  title="Folder location of xslt file"><span class="required">*</span>Transform Path</td><td>
                      <select style="width:400px" id="transformpath" ng-model="selectedTransformPath">
                        <option data-ng-repeat="x in TransformPaths" value="{{x.Id}}">{{x.Path}}</option>
                      </select>
                  </td>
              </tr>
              <tr>
                  <td style="text-align:right;vertical-align:top"><span class="required">*</span>Package(s):</td>
                  <td>
                      <div style="display:inline" class="file-input-wrapper">
                          <button class="btn-file-input">Browse</button>
                            <input  type="file"  name="fileToUpload"  id="fileToUpload" onchange="fileSelected();"/>
                            
                      </div>
                      <span style="display:inline;color:blue;font-weight:bold" id="message"></span>
                      <div style="margin-top:10px" id="fileName"></div>
                      <%--<div id="fileSize"></div>
                      <div id="fileType"></div>--%>
                  </td>
              </tr>
          </table>
            
       <div class="row">  
           <button class="button" id="upload" onclick="uploadFile();return false;" >SAVE AND SUBMIT</button>
            <a href="FormManager.html" class="linkClass">Cancel</a>
    </div>
    
    </div>
        
        </div>

     

       
    </div>
    </form>
    <div id="footer" style="text-align: center;background-color:#333333; margin-top:10px; padding:8px; margin-bottom:20px; color:whitesmoke">
        <span id="copyright" style="font-family:Arial;font-size:12px;display: inline-block;"></span>
    </div>
</body>
</html>
