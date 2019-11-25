<%@ Page EnableEventValidation="false" ValidateRequest="false" Language="C#" AutoEventWireup="true" CodeBehind="GetHTML.aspx.cs" Inherits="SDC.GetHTML" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function toggleviewxml() {
            var f = document.getElementById("rawxml");
            if (f.style.display == "none") {
                f.style.display = "block";
                document.getElementById("linkxml").innerText = "Hide Xml";
            }
            else {
                f.style.display = "none";
                document.getElementById("linkxml").innerText = "Show Xml";
            }
        }
    </script>    

</head>
<body>
    <nav style="font-size:smaller;">
    <a id="linkxml" href="#" onclick="toggleviewxml()">Show Xml</a>
    <br />
    </nav>
    <!--hide the submit button-->
    <input type="hidden" runat="server" id="allowsubmit" value="no"/>
    <textarea runat="server" id="rawxml" style="display:none;width:92%;margin-left:100px;margin-right:auto;background-color:wheat" rows="10"></textarea>
    <div id="content" runat="server">
    
    </div>
   
</body>
</html>
