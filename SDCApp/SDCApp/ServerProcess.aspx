<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServerProcess.aspx.cs" Inherits="SDC.ServerProcess" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <title></title>

    <script>
  function resizeIframe(obj) {
    obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
  }
</script>
    <script>
              

        $(document).on("click", "#btnDownload", function () {
           
            $.ajax({
                type: "POST",
                url: "ServerProcess.aspx/Download",
                data: "{filename:'" + "hello" + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    // Do something interesting here.
                    alert("success");
                }
            });
        });
    </script>
</head>
<body>

    <form id="form1" runat="server">
    This Frame expands to show an entire page below.   
        <br />
             <iframe style="border:none;" onload="resizeIframe(this)"  id="pageholderFrame"></iframe>        
       
        <div>
            <button id="btnEcho">Test</button>
             <button id="btnDownload">Test</button>
        </div>
    </form>
</body>
</html>
