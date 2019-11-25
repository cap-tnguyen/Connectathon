var xmlDoc;

$(document).ready(function () {

    jQuery.support.cors = true;
    //save original xml in jquery variable  
    var xmlstring = $("#rawxml").val();   //server puts original xml in #rawxml
    xmlDoc = $.parseXML(xmlstring);
    $xml = $(xmlDoc);

});


function sayHello(name) {
    alert("sayHello function in javascripts says - hello, " + name);
    return window.external.ShowMessage("If you can see this message sayHello successfully called ShowMessage function in this desktop client app.");


}

var repeat = 1;
//adds a new repeat of a section
function addSection(obj) {
    //obj is btnAdd

    //we need to clone table, so get table
    var td = obj.parentElement;
    var table = td.parentElement  //tr
                   .parentElement  //tbody
                   .parentElement //table
    
    var sectionGuid = table.parentElement.id;

    var max = table.parentElement.firstChild.value;  //maxcardinality
    
    var textboxes = td.getElementsByTagName("input");  //get hidden input, radio buttons, checkboxes and input text boxes


    

    var newtable = table.cloneNode(true);    

    newtable.id = table.id;   
    repeat = +repeat + 1;


    //make the remove button visible 
    //and hide the add button on the previous section
    obj.nextSibling.style.visibility = "visible";
    obj.style.visibility = "hidden";    

    var trace = 0;
    var newname;
    var i;
    var parentGuid;
    var ID;

    //add the new repeat
    try {
        parentsection = table.parentElement;
        //append newtable after setting properties of individual elements
        //parentsection.appendChild(newtable);  //add new table - note that table.id is the same for new table
        

        //find parentGuid
        for (i = 0; i < textboxes.length; i++) {
            if (textboxes[i].type == "hidden") {
                var components = textboxes[i].name.split(":");
                parentId = components[1];

                //remove repeat indicator if exists from Guid
                if (parentId.indexOf(",") > 0)
                    parentId = parentId.substring(0, parentId.indexOf(","));
                break;
            }
            
        }

        /*add a new section node in xml by cloning the section with instanceGuid = parentGuid
        since there will be repeat sections with the same instanceGuid, take the last instance
        and clone it*/

        var $sectionCurrent = $xml.find('Section[ID="' + parentId.substring(1) + '"]:last');
               
        sectionid = $sectionCurrent.attr('ID');
        var $sectionNew = $sectionCurrent.clone(true);

        //iterate through textboxes and assign new unique ids to them
        for (i = 0; i < textboxes.length; i++) {

            if (textboxes[i].type == "hidden" || textboxes[i].type == "text" || textboxes[i].type=="radio") {

                oldname = textboxes[i].name;

                if(textboxes[i].id=="maxcardinality")
                      continue;

                if(textboxes[i].name=="")
                {
                    alert("error: a " + textboxes[i].type + " box without name is found at " + i);
                    continue;
                }

                var components = oldname.split(":");
                var newguid = generateGuid();

                //if (i == 0) testguid = newguid;

                parentId = components[1];

                //remove repeat indicator if exists from Guid
                if (parentId.indexOf(",") > 0)
                    parentId = parentGuid.substring(0, parentId.indexOf(","));

                ID = components[0].substring(1);

               
                if (textboxes[i].type == "hidden") {
                   //note that parent has repeat indicator
                    newname = "q" + ID + '-' + newguid + ":" + parentId;
                }

                
                //find the element in the new table
                var item;
                var allelements = newtable.getElementsByTagName('*');
                for(k=0;k<allelements.length;k++)
                {
                   if(allelements[k].name == textboxes[i].name)
                   {
                       item = allelements[k];

                       break;
                   }
                 }
                
                

                if (item != null) {

                                        
                    if(item.type=="hidden")   //question will have Q as the first letter
                    {                                             //find question in xml fragment
                       $question = $sectionNew.find('Question[ID="' + ID + '"]');
                       $question.attr("ID", ID + '-' + newguid);                       
                       item.name = newname;
                      
                    }
                    else {                   //answers do not have Q
                            item.name = newname.substring(1);
                            if(item.type=="radio" || item.type == "checkbox")
                                 item.checked = false;
                             else
                                 item.value = "";
                    }

                }

            }
        }

        //better to append new table after setting properties of individual controls
        parentsection.appendChild(newtable);

        //insert newsec after section
        $sectionCurrent.after($sectionNew);


        //hide the Add button if max count reached
        if (countRepeats(sectionGuid) == max) {
            // alert('max repeat = ' + max + ' reached');
            inputs = newtable.getElementsByTagName('*');
            for(m=0;m<inputs.length;m++)
            {
		if(inputs[m].id=="btnAdd")
                   inputs[m].style.visibility="hidden";
                if(inputs[m].id=="btnRemove")
                   inputs[m].style.visibility="visible";
            }

        }



    }
    catch (err) {
        alert(err.message + "\n" + trace + "\n" + newname + "n" + i);
    }

}


function generateGuid() {
    var result, i, j;
    result = '';
    for (j = 0; j < 32; j++) {
        if (j == 8 || j == 12 || j == 16 || j == 20)
            result = result + '-';
        i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
        result = result + i;
    }
    return result;
}


function countRepeats(sectionid) {

    var section = document.getElementById(sectionid);  //
    var tables = section.getElementsByTagName('TABLE');
    var count = 0;
    for(i=0; i<tables.length; i++)
    {
       if(tables[i].id == sectionid) count++;
    }
   
    return count;

}

function getLastRepeat(sectionid) {
    var section = document.getElementById(sectionid);
    var tables = section.parentElement.getElementsByTagName('TABLE');
    var ret = null;
    for(i=0;i<tables.length;i++)
    {
       if(tables[i].id==sectionid)
         ret = tables[i];
    }
    return ret;

}

function removeSection(obj) {
    td = obj.parentElement;
    tr = td.parentElement;
    tbody = tr.parentElement;
    table = tbody.parentElement;
    var section = table.parentElement;
    section.removeChild(table);

    //make Add button on the last repeat visible again
    last = getLastRepeat(section.id);
    if (last==null)
    {
        alert("Error: last repeat is null");
        return false;
    }
    inputs = last.getElementsByTagName('*');
    for(m=0;m<inputs.length;m++)
    {
	if(inputs[m].id=="btnAdd")
        {
             inputs[m].style.visibility="visible";
        }
    }
    
    
    id = section.id;
    //repeat = table.id;
    $xml.find('Section[ID="' + id + '"]').eq(table.id).remove(); 
}


/*
Helper functions
*/
function trim(input) {
input = input.replace(/^\s+|\s+$/g, '');
return input;
}

function findElementById(parentId, Id) {
   //finds an element among descedants of a given node
   var parent = document.getElementById(parentId);

   var children = parent.getElementsByTagName('*');


   for (i = 0; i < children.length; i++) {

      if (children[i].id == Id) {
         return children[i];
      }
   }

}

function findElementByName(parentName, Name) {
  //finds an element among descedants of a given node
  var parent = document.getElementById(parentName);
  var children = parent.getElementsByTagName('*');
  
  for (i = 0; i < children.length; i++) {
     if (children[i].name == Name) {
         return children[i];
     }
  }
}

function xmlToString(xmlData) {

    var xmlString;
    //no longer needed for newer IE
    //IE
    //if (window.ActiveXObject) {
    //    xmlString = xmlData.xml;
    //}
    // code for Mozilla, Firefox, Opera, etc.
    //else {
    xmlString = (new XMLSerializer()).serializeToString(xmlData);
    //}
    return xmlString;
}

//helper functions end

//submit form calls this function
/*
Builds flatXml, updates the original xml with answers.
Note that new section nodes for repeat sections have already been added (upon clicking btnAdd - addSection function) 
*/
var flatXml;
function openMessageData() {

    var sb = "";
    var q, answer = "";
    var elem = document.getElementById("checklist").elements;
    var response = "<response>";
    var html = response;

    for (var i = 0; i < elem.length; i++) {
        q = "";
        var name = elem[i].name;

        var value;

        //split up name into instanceGuid and parentGuid and question id
        //var components = name.split(':');
        //var instanceGuid = components[0].substring(1);
        //var parentGuid = components[1];
        //var id = components[2];
        var instanceGuid = '';
        var parentGuid = '';
        var id = name;
        if (name.indexOf("q") == 0) {
            value = elem[i].value;

            answer = GetAnswer(name.substring(1));

            if (answer != "") {

                response += "<question ID=\"" + id + "\" display-name=\"" + value.replace(/</g, "&lt;").replace(/>/g, "&gt;") 
                         + "\">";
                response += answer + "</question>";               

                q += "<div class=\"MessageDataQuestion\">&lt;question ID=\"" + id + "\" display-name=\"" + value + "";
                q += "&gt;<br><div class=\"MessageDataAnswer\">" + answer.replace(/</g,"&lt;").replace(/>/g,"&gt;") + "</div>&lt;/question&gt;</div>";


            }
            sb += q;
            answer = "";
        }
    }

    response = response.replace(/<br>/g, "");
    response = response + "</response>";

    flatXml = response;


    sb = "<div style='font-weight:bold; color:purple'>Flat Xml response</div>" 
         + "<div class=\"MessageDataChecklist\">&lt;response&gt;" + sb + "&lt;/response&gt;</div>"
         + "<br/><div style='font-weight:bold; color:purple'>Response xml sent to web service.</div>"


    document.getElementById('MessageDataResult').innerHTML = sb;
    document.getElementById('MessageData').style.display = 'block';
    document.getElementById('FormData').style.display = 'none';
    
    //update Xml with answers
    updateXml();
    

    //var test = xmlToString(xmlDoc);
    //document.getElementById('rawxml').innerText = test;

    //Ajax call to web service
    CallTestService(xmlToString(xmlDoc));
    
}

function closeMessageData() {
    document.getElementById('MessageData').style.display = 'none';
    document.getElementById('FormData').style.display = 'block';
}

function GetAnswer(qCkey) {
    var elem = document.getElementById("checklist").elements;
    var str = "";
    var name, value;

    for (var i = 0; i < elem.length; i++) {
        name = elem[i].name;
        value = elem[i].value;

        if (name.indexOf(qCkey) == 0) {

            if (elem[i].checked || (elem[i].type == "text" && value != "")) {

                {

                    var k = value.split(',');

                    if (elem[i].type == "text" && value != "") {
                        //str += "&lt;answer value=\"" + value + "\"/&gt;<br>";
                        str += "<answer value=\"" + value + "\"/><br>";
                    }
                    else if (elem[i].type != "text") {
                        //str += "&lt;answer ID=\"" + k[0] + "\" display-name=\"" + GetDisplayName(value) + "\"/&gt;<br>";
                        str += "<answer ID=\"" + k[0] + "\" display-name=\"" + GetDisplayName(value) + "\"/><br>";
                    }
                }
            }
        }
    }
    return str;
}

function GetDisplayName(value) {
    var strArray = value.split(',');
    var returnStr = "";
    if (strArray.length > 1) {
        for (var i = 1; i < strArray.length; i++) {
            if (i != strArray.length) {
                returnStr += strArray[i] + ",";
            }
            else {
                returnStr += strArray[i];
            }
        }
    }
    returnStr = returnStr.replace(/</g,"&lt;").replace(/>/g,"&gt;");
    return returnStr.substr(0, returnStr.length - 1);
}


//updates answers in full xml
function updateXml() {
    var $xml = $(xmlDoc);  //full xml
    FlatDoc = $.parseXML(flatXml);
    $xmlFlatDoc = $(FlatDoc);
    $xmlFlatDoc.find('question').each(function () {
        var $question = $(this);
        var questionid = $question.attr("ID");

        if(questionid.indexOf(":")>0)
            questionid = questionid.substring(0,questionid.indexOf(':'));

        //if(questionid.indexOf("-")>0)
        //    questionid = questionid.substring(0,questionid.indexOf('-'));

        questionid = questionid.substring(1);

        var repeat = 0;
        


        //there may be multiple answers per question
        $question.find('answer').each(function () {
            var $test = $(this);
            var id = $test.attr("ID");
            var val = $test.attr("value");

            
            var $targetQuestion = $(xmlDoc).find("Question[ID='" + questionid + "']");
            var targetQuestionId = $targetQuestion.attr("ID");


            if (id != null) {
                 
                var $targetAnswer = $targetQuestion.find("ListItem[ID='" + id + "']");
                $targetAnswer.attr("selected", "true");
                //alert("set selected to true");
                if ($targetAnswer.find("ListItemResponseField") != null) {
                    val = $question.find('answer').next().attr("value");
                    $response = $targetAnswer.find("Response").children(0);
                    $response.attr("val", val);
                }

            }
            else {  //free response
                
                $targetAnswer = $targetQuestion.find("ResponseField").find("Response");
                $targetAnswer.children(0).attr("val", val);
            }
        });

    });
    
   

}

function CallTestService(data) {
    var webServiceURL = "http://localhost:5000/Service1.asmx";
    webServiceURL = prompt("Enter endpoint:", webServiceURL);
    
    $.support.cors = true;
    var xmldata = encodeURIComponent(data);
    
    var soapRequest =
					'<?xml version="1.0" encoding="utf-8"?>' +
						' <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
								' xmlns:xsd="http://www.w3.org/2001/XMLSchema"' +
								' xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
							' <soap:Body>' +
    								//' <Add xmlns="urn:ihe:iti:rfd:2007">' +
									//' <i>4</i>' +
									//' <j>5</j>' +
								    //' </Add>' +
                                    //' </test>' +
                                    ' <SubmitFormRequest xmlns="urn:ihe:iti:rfd:2007">' +
                                    ' <body>' + xmldata + '</body> ' +
                                    ' </SubmitFormRequest>' +
							' </soap:Body>' +
						' </soap:Envelope>';

    
    soapAction = "urn:SubmitForm";
    //soapAction = "urn:ihe:iti:rfd:2007/Add";

    $.ajax({
        type: "POST",
        url: webServiceURL,
        contentType: "text/xml",
        dataType: "xml",
        processData: false,
        headers: {
            "SOAPAction": soapAction
        },
        data: soapRequest,
        success: OnSuccess,
        error: OnError
    });

    return false;
}


function OnSuccess(data, status) {

    var xmlstring = xmlToString(data);
    if (document.getElementById("outxml") != null) {
        alert(xmlstring);
        document.getElementById("outxml").textContent = xmlstring;
        $("#outxml").css("background-color", "yellow");
    }
    
    
}

function OnError(xhr, textStatus, err) {
    alert('Status:' + xhr.status + ', Text:' + textStatus + ', Error: ' + err);
}

