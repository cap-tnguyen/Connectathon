<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UpdatePackage.aspx.cs" Inherits="SDC.UpdatePackage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   
    <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
	<link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.3") %>" rel="stylesheet" />

    <script src="Scripts/angular.js"></script> 
    <script src="Scripts/angular-route.js"></script> 
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="<%: ResolveUrl("~/Scripts/Site.js") %>"></script>

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
        });
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
         
         input[type="submit"],
         input[type="button"] button {
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
    <div ng-app="SDCApp" ng-controller="SDCTransactionCtrl" >
        
      <div ng-include="'header.html'"></div>

        <div style="padding:10px 36px 15px 18px;">
        
        <div>
              <ul class="breadcrumb">
              <li><a href="formmanager.html">Form Manager</a></li>
              <li ><a style="color:black" href="#">Update Package</a></li>          
              </ul>
         </div>
         <div style="clear:both"></div>
 
            <div class="pagecontent"> 
                 <p class="pagetitle">Update Package - <span id="packagename"></span></p>  
                 <table style="border-spacing:0px">
                  <tr style="height:11px; padding:2px;">
                      <td style="text-align:right;vertical-align:top"><span title="Unique ID for package">Package ID</span></td><td><input runat="server" style="height:14px;width:400px" type="text" name="packageid" id="packageid" /></td>
                  </tr>
                  <tr style="height:11px;padding:2px;">
                      <td style="text-align:right;vertical-align:top"><span title="Friendly name for package">Package Name</span></td><td><input runat="server" style="height:14px;width:400px" type="text" name ="packagename" id="packagename" /></td>
                  </tr>
                  <tr style="height:11px;padding:2px;">
                      <td style="text-align:right;vertical-align:top"><span title="Friendly name for package">Agency Name</span></td><td><input runat="server" style="height:14px;width:400px" type="text" name ="agencyname" id="agencyname" /></td>
                  </tr>
                  <tr style="height:11px;padding:2px;">
                      <td style="text-align:right;vertical-align:top"><span title="Submit Endpoint to be used on Retrieve Form Request when the content format is HTML or URL">Submit Endpoints</span></td><td>                      
                          <%--<asp:DropDownList ClientIDMode="Static" runat="server" name ="submiturl" id="submiturl" />--%>
                                           
                      <%--<asp:DropDownList ClientIDMode="Static" runat="server" name ="submiturl" id="submiturl" />--%>
                      <asp:ListBox runat="server" SelectionMode="Multiple" ID="submiturl" Width="400px" ClientIDMode="Static"></asp:ListBox>
                  </td>
                      
                  </tr>
                  <tr style="height:11px;padding:2px;">
                      <td style="text-align:right;vertical-align:top"><span title="Folder location for xsd files">Validation Path</span></td>
                      <td>
                          <asp:DropDownList style="width:400px" runat="server" ClientIDMode="Static"  name ="validationpath" id="validationpath" />
                          <asp:Button runat="server" CssClass="button" id ="btnValidate" Text="VALIDATE" OnClick="btnValidate_Click" />
                          <div><asp:Label runat="server" ID="lblMsg"></asp:Label></div>
                      </td>
                  </tr>
                  <tr style="height:11px;padding:2px;">
                      <td style="text-align:right;vertical-align:top"><span title="Folder location of xslt file">Transform Path</span></td><td>
                          <asp:DropDownList style="width:400px" runat="server" ClientIDMode="Static"  name ="transformpath" id="transformpath" /></td>
                  </tr>
        </table>

                 <div style="margin-top:20px;margin-bottom:20px;">
             <asp:Label name="lblTitle" ID="lblTitle" runat="server" Font-Names="Arial"  Text="Please update XML and parameters, validate, and save."></asp:Label>
            <textarea id="rawxml" rows="30" style="width:98%;align-content:center" runat="server"></textarea>
        </div>
        <asp:Button ID="btnUpdate" CssClass="button" Text="save and submit" OnClick="btnUpdate_Click" runat="server" />
    
        <a href="FormManager.html" class="linkClass">Cancel</a>
        <asp:Label ID="lblSave" runat="server"></asp:Label>
            </div>
           

        
       
        </div>

      </div>   
        
    </form>

     <div id="footer" style="text-align: center;background-color:#333333; margin-top:10px; padding:8px; margin-bottom:20px; color:whitesmoke">
        <span id="copyright" style="font-family:Arial;font-size:12px;display: inline-block;"></span>
    </div>
    
     <script>
        $(window).on("load", function (e) {
            $('#copyright').text("© " + new Date().getFullYear() + " SDC Application");
            
            $('#packagename').text(getQueryVariable('packageid'));
        });
    </script>
</body>
</html>
