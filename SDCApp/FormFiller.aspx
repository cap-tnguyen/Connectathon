<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormFiller.aspx.cs" Inherits="SDC.FormFiller" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="<%: ResolveUrl("~/Content/Site.css?ver=1.2") %>" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/Content/Additions.css?ver=1.2") %>" rel="stylesheet" />
	<link href="<%: ResolveUrl("~/Content/Menu.css?ver=1.2") %>" rel="stylesheet" />
    <%--<script src="<%: ResolveUrl("~/Scripts/modernizr-2.6.2.js") %>"></script>--%>

    <link href = "https://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css"
         rel = "stylesheet">
      <script src = "https://code.jquery.com/jquery-1.10.2.js"></script>
      <script src = "https://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

    <%-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> --%>

    <script src="Scripts/angular.js"></script> 
	<script src="Scripts/site.js"></script> 
    <script src="Scripts/angular-route.js"></script> 
    <script src="Scripts/SDCTrancationApp.js?ver=1.40"></script>
    <style>
         
        table, th, td, tr {
			border: none;
			
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

       

    </style>
      <!-- CSS -->
      <style>
         .ui-widget-header,.ui-state-default, ui-button {
            background:#b9cd6d;
            border: 1px solid #b9cd6d;
            color: #FFFFFF;
            font-weight: bold;
         }
      </style>
    <script>
        $(document).ready(function () {
            
            $('.expand-one').click(function () {
                
                $('.content-one').slideToggle('slow');
            });
        });
    </script>

     <!-- dialog Javascript -->
      <script>
          $(function () {
              $("#step-1").dialog({
                  autoOpen: false,
                  modal: true,
                  buttons: [
                      {
                          id: "GoStep2",
                          text: "Next",
                          click: function () {
                              $('#step2-param1').val('hello from ' + $('#txtName').val());
                              $(this).dialog("close");
                             
                              $("#step-2").dialog("open");
                          }
                      },
                     
                      {
                          id: "Step1Cancel",
                          text: "Cancel",
                          click: function () {
                              $(this).dialog("close");
                          }
                      }
                  ]
                
              });

              $("#step-2").dialog({
                  modal: true,
                  autoOpen: false,
                  title: "Confirmation",
                  width: 350,
                  height: 160,
                  buttons: [
                      {
                          id: "GoToStep1",
                          text: "Previous",
                          click: function () {
                              $(this).dialog("close");
                              $("#step-1").dialog("open");
                          }
                      },
                      {
                          id: "GoToStep3",
                          text: "Next",
                          click: function () {
                              $(this).dialog("close");
                              $('#step3-param1').val('hello from Step2');
                              $("#step-3").dialog("open");
                          }
                      },
                     
                    
                      {
                          id: "Cancel",
                          text: "Cancel",
                          click: function () {
                              $(this).dialog('close');
                          }
                      }
                  ]
              });

              $("#step-3").dialog({
                  autoOpen: false,
                  buttons: [
                      {
                          id: "GoToStep2",
                          text: "Previous",
                          click: function () {
                              $(this).dialog("close");
                              $('#step2-param1').html('hello from Step3');
                              $("#step-2").dialog("open");
                          }
                      },
                     
                      {
                          id: "Step3Finish",
                          text: "Finish",
                          click: function () {
                              alert("we are done!")
                              $(this).dialog("close");

                          }
                      },
                      {
                          id: "Cancel",
                          text: "Cancel",
                          click: function () {
                              $(this).dialog('close');
                          }
                      }
                  ],
                  modal: true,
              });

              $("#opener1").click(function () {
                  $("#step-1").dialog("open");
                  return false;
              });
              $("#opener2").click(function () {
                  $("#step-2").dialog("open");
                  return false;
              });
              $("#opener3").click(function () {
                  $("#step-3").dialog("open");
                  return false;
              });
              $("#parameters").click(function () {
                  alert("Step 2: " + $('#step2-param1').val());
                  alert("Step 3: " + $('#step3-param1').val());
                  
                  return false;
              });
          });
      </script>

</head>
<body>
    <form id="form1" runat="server">
    <div ng-app="SDCApp" ng-controller="SDCTransactionCtrl">
    <div ng-include="'header.html'"></div>
    <!--<div class='page-title' style='float:left'>Form Filler</div>-->
     <div style="clear:both"></div>

        <div id="wizard">
             <!--create some dialogs for steps-->
            <div id = "step-1" title = "This is step 1">
                This is 1st step!
                <span>Name</span>
                <input type="text" id="txtName" />
                
            </div>

            <div id = "step-2" title = "This is step 2">
                This is 2nd step!
                <input type="hidden" id="step2-param1"/>                
            </div>

            <div id = "step-3" title = "This is step 3">
                <input type="hidden" id="step3-param1"/>          

                This is 3rd step!
            </div>

           <button id = "opener1">Step 1</button>
           <button id = "opener2">Step 2</button>
           <button id = "opener3">Step 3</button>
           <button id ="parameters">Show Dialog Values</button>
        </div>
       
    
    <div id="formmanagers" runat="server" class="page-section">
        <table>
            <tr>
                <td>Form Manager</td>
                <td>
                    <select style="width:200px; " size="5" id="manager" ng-model="selectedManager">
                        <option data-ng-repeat="x in Managers" value="{{x.Id}}">{{x.Name}}</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Content Format</td>
                <td>
                    <span ng-init="format=1">            
                        <input type="radio" name="chkformat" ng-value="1" ng-model="format" />
                        <label>XML</label>

                        <input type="radio"  name="chkformat" ng-value="2" ng-model="format" />
                        <label>HTML</label>

                        <input type="radio" name="chkformat" ng-value="3" ng-model="format" />
                        <label>URL</label>
                    </span>
                </td>
            </tr>
            
            <tr>
                <td>Select a Form</td>
                <td>
                    <select id="forms"  style="width:200px" ng-model="package">
                        <option data-ng-repeat="x in formslist" value="{{x.item.id}}">{{x.item.id}}</option>
                    </select>
                    <button ID="retrievelist" style="padding:1px;font-size:14;font-weight:bold;margin-top:5px;margin-bottom:5px" ng-click="GetFormslist($event);" >Get Available Forms</button>
                </td>
            </tr>
            <tr>
                <td>Form Receiver(s)</td>
                <td>
                     <select id="receivers" style="width:200px" multiple="multiple" ng-model="selectedReceivers">
                        <option data-ng-repeat="x in Receivers" value="{{x.Id}}">{{x.Name}}</option>
                    </select>
                </td>
            </tr>
        </table>
    </div>
   <div>
        <p class="expand-one"><a href="#" title="Click to open/close pre-pop box"><b>Prepop Data</b></a> </p>
        <div class="content-one" >
            <p>Paste a valid CDA document content here to pre-populate demographics data. Do not include the PrepopData element.</p>
            <textarea ng-model="prepop" style="width:800px" rows="10"></textarea>                    
        </div>
    </div>
        
        <p>If a form list is not available from the selected Form Manager enter a package id below.</p>
        <input ng-model="package" /> 
             
        <button ng-click="GetForm($event, package, format, selectedManager, selectedReceivers, prepop)">Get Form</button>    
        
    </div>
    
    
    </form>
</body>
</html>
