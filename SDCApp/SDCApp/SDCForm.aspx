<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SDCForm.aspx.cs" Inherits="SDC.SDCForm" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server"> 
        <title></title> 
       
        <link href="~/Content/Site.css?ver=1.2" rel="stylesheet" />
        <link href="~/Content/Menu.css?ver=1.3" rel="stylesheet" />
        <link rel='stylesheet' href='Transforms/working/sdctemplate.css' type='text/css' />
        <script src="Scripts/angular.js"></script> 
        <script src="Scripts/angular-route.js"></script> 
        <script src="Scripts/SDCTrancationApp.js?ver=1.48"></script>
        <script src="Scripts/site.js?ver=1.40"></script>

        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <script type="text/javascript" src="Transforms/working/sdctemplate.js?ver=14"></script>
      

  <script type="text/javascript">

      //there are two logout links - one for CAP logout and the other for Google logout
      //we need to make one invisible
      //check localstorage to see how the user is logged in and turn off 
      
      if (localStorage.getItem("authenticator") === 'undefined') {
          $('#test').hide();
      }
      else {
          $('#caplogout').hide();
      }


      
     
	
      $(document).ready(function () {	
        
          $("#btnParameters").click(function () {
              $("#options").toggle();
          });

          $("#btnRetrieveResponse").click(function(){
		        $("#responsedata").toggle();
	      });
	
         

          //$("#btnRetrieveResponse").click();

          //$("#btnParameters").click();

		toggle_mustImplement();	
	    toggle_metadata();
	    toggle_id();
			   
	      //support toggle
	    $(".collapsable").click(function(){
		    $(this).siblings().toggle();
		    $(this).toggleClass("HeaderGroup collapsed");									
              });	

		  var toggle_all = true;
		  $(".collapse_all_control").click(function(){
				$(".collapsable_q").each(function(){
					if ($(this).siblings().is( ":visible" ) && toggle_all === true) {
						$(this).siblings().toggle(false);
						$(this).toggleClass("Question collapsed_q");
					} else if (!$(this).siblings().is( ":visible" ) && toggle_all === false) {
						$(this).siblings().toggle(true);
						$(this).toggleClass("Question collapsed_q");
					}
				});
					
				$(".collapsable").each(function(){
					if ($(this).siblings().is( ":visible" ) && toggle_all === true) {
						$(this).siblings().toggle(false);
						$(this).toggleClass("HeaderGroup collapsed");
					} else if (!$(this).siblings().is( ":visible" ) && toggle_all === false) {
						$(this).siblings().toggle(true);
						$(this).toggleClass("HeaderGroup collapsed");
					}
				});
					
				if (toggle_all) {
					toggle_all = false;
				} else {
					toggle_all = true;
				}
			});
				
			$(".collapsable").click(function(){
				$(this).siblings().toggle();
				$(this).toggleClass("HeaderGroup collapsed");									
			});	
				
			var toggle_section = true;
			$(".collapse_control").click(function(){
				$(".collapsable").each(function(){
					if ($(this).siblings().is( ":visible" ) && toggle_section === true) {
						$(this).siblings().toggle(false);
						$(this).toggleClass("HeaderGroup collapsed");
					} else if (!$(this).siblings().is( ":visible" ) && toggle_section === false) {
						$(this).siblings().toggle(true);
						$(this).toggleClass("HeaderGroup collapsed");
					}
				});
					
				if (toggle_section) {
					toggle_section = false;
				} else {
					toggle_section = true;
				}
			});
				
			var toggle_question  = true;
			$(".collapse_q_control").click(function(){
				$(".collapsable_q").each(function(){
					if ($(this).siblings().is( ":visible" ) && toggle_question === true) {
						$(this).siblings().toggle(false);
						$(this).toggleClass("Question collapsed_q");
					} else if (!$(this).siblings().is( ":visible" ) && toggle_question === false) {
						$(this).siblings().toggle(true);
						$(this).toggleClass("Question collapsed_q");
					}
				});
					
				if (toggle_question)
					toggle_question = false;
				else
					toggle_question = true;
			});
				
			//support toggle - sections
			$(".collapsable").click(function(){
				$(this).siblings().toggle();
				$(this).toggleClass("HeaderGroup collapsed");									
			});	

			// support toggle - questions
			$(".collapsable_q").click(function(){
				$(this).siblings().toggle();
				$(this).toggleClass("Question collapsed_q");									
			});	
		});  //document.ready
	

      

        function test()
        {
            alert(document.getElementById("response"));
        }
       
    </script>
    <style>
            .steps.selected {
                background-color:white;
                font-weight:bold;
               
            }

          .steps{
              float:left;
              display:inline;
               margin-right: 4px;
               margin-top:8px;
               background-color:lightgray;
               height:20px;
               font-family:Arial;
               font-size:12px;
               padding:4px;
               cursor:pointer;
               
          }
          
          a {text-decoration:none}

           a.linkClass {
            border: none;
            background: transparent;
            color: blue !important;
            text-decoration: underline;
            font-size: 12px;
        }
    </style>
 </head>
        <body>
             
            <form>     
                <div id="header" runat="server">
       
               </div>
            </form>
    <div ng-init="refreshForms=1" ng-app="SDCApp" ng-controller="SDCTransactionCtrl">
        
        <div ng-include="'header.html'"></div>    
        <div id='step1' class='steps' onclick="window.location.href='formfillerstep2.html'"><strong> Step 1: Select Package ></strong></div>
        <div id='step2' class='steps  selected' onclick="javascript:closeMessageData()"><strong> Step 2: Submit Package to Receiver ></strong></div>
        <div id='step3' class='steps' ><strong> Step 3: Confirmation </strong></div>
       
         <br />
         <br />
         <br />
         <br />
        <div style="clear:both"></div>
            <div id="submitmsg" runat="server">
                  
            </div>
        <a id='anotherpackage' class="linkClass"  href="formfillerstep2.html">Select another package</a>
        </div>

        </body>
    </html>