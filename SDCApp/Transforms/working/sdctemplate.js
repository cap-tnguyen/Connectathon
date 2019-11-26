
var xmlDoc;
var repeatIndex = 0;   //used to generate unique ids, names in repeated elements
var _debug = true;

$(document).ready(function () {
	
	
	
								
	//hide all notRequired
	//toggle_notRequired();
	
	

	jQuery.support.cors = true;  //not sure if needed because cors setting is on the server
	
	
	var endpoints;
	var successIndex = 0;
	
	
	
	/*
		save original xml in jquery variable  
		server or xslt puts original xml in #rawxml, issue with xslt putting in xml is copy-of function decodes special characters, thus 
		making xml invalid
	*/
	
	var xmlstring = $("#rawxml").val();   
	

	//load into xml dom
	try{
		
		
		xmlDoc = $.parseXML(xmlstring);
		
		$xml = $(xmlDoc);

		//allow submit
		if($("#allowsubmit").val()=='no')
		{
			$("#send").css("display","none");
			
		}
		
		
	}
	catch(err){
		alert('Error loading xml: ' + err.message);
	}
	
	
	//disable all fill-in boxes
	/*
	var $fillins = $xml.find("ListItemResponseField")
	$fillins.each(function(){
		var answerid = $(this).parent().attr("ID");
		var $answerElement = getAnswerItemByID(answerid, $("html"))
		if(!$answerElement.prop('checked'))
			$answerElement.parent().find('.AnswerTextBox').prop('disabled',true);
		
	})
	*/
});

function validateDate(value)
{
	//2015-1-11 13:57:24
	var pattern = /^\d\d\d\d-(0?[1-9]|1[0-2])-(0?[1-9]|[12][0-9]|3[01]) (00|[0-9]|1[0-9]|2[0-3]):([0-9]|[0-5][0-9]):([0-9]|[0-5][0-9])$/g;
	
}

function doConfirm(msg, yesFn, noFn)
{
	var confirmBox = $("#confirmBox");
	confirmBox.find(".message").text(msg);
	confirmBox.find(".yes,.no").unbind().click(function()
	{
		confirmBox.hide();
	});
	confirmBox.find(".yes").click(yesFn);
	confirmBox.find(".no").click(noFn);
	confirmBox.show();
}

function isLocalMode()
{
	if (window.location.protocol=='file:')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function loadXml(){
	
	if (isLocalMode())
	{
		// 2018-08-02 change: 
	    // alert('local');
		
		$('#rawxml').remove();
		$('<textarea id="rawxml" rows="20" style="-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;width: 100%;"/>').appendTo('body');
		readTextFile(window.location.href);
		if(_debug)
		{
			$('#rawxml').show();
		}
		else{
		    
			$('#rawxml').hide();
		}								
	}
}

function readTextFile(file)
{
		
	var rawFile = new XMLHttpRequest();
	rawFile.open("GET", file, false);
	rawFile.onreadystatechange = function ()
	{
		if(rawFile.readyState === 4)
		{
			if(rawFile.status === 200 || rawFile.status == 0)
			{
				var allText = rawFile.responseText;
				$('#rawxml').val(allText);
			}
		}
	}
	rawFile.send(null);
}

function sayHello(name) {
	alert("sayHello function in javascripts says - hello, " + name);
	return window.external.ShowMessage("If you can see this message sayHello successfully called ShowMessage function in this desktop client app.");
}

function toggle_metadata() 
{
   var divsMD = document.getElementsByClassName('MetadataDisplay')
   var divsMDH = document.getElementsByClassName('MetadataDisplayHeader')           
	  
	  var display = 'none'
	  if (divsMD[0].style.display)
	  {                  
		 if (divsMD[0].style.display == 'inline' )
		 { display = 'none' }
			else
		 { display = 'inline' }
	  }
	  
	  for (var i = 0; i < divsMD.length; i++)
	  { divsMD[i].style.display = display; }
	  for (var i = 0; i < divsMDH.length; i++) 
	  { divsMDH[i].style.display = display; } 
	  
	  
	  //Toggle ids too
	  var divs = document.getElementsByClassName('idDisplay')   
	  for (var i = 0; i < divs.length; i++)
	  { 
		 divs[i].style.display = display; 
	  }
	  
	  //Toggle deprecated items                 
	  var dis = document.getElementsByClassName('TopHeader')
	  var searchText = "(Deprecated Items)"
	  
	  for (var i = 0; i < dis.length; i++) 
	  { 
	  if (dis[i].textContent.indexOf(searchText) >=0) 
		 {
			var divHeader = dis[i].parentElement.parentElement.parentElement //the tbody element
			if (display == 'inline') {display = ''}
			divHeader.style.display = display;
			break;                         
		 }                     
	  }                

   }
   
 function toggle_name() 
   {
   var nameDiv = document.getElementsByClassName('nameDiv');
 
	  var display = 'none'
	  if (nameDiv[0].style.display)
	  {                  
		 if (nameDiv[0].style.display == 'inline' )
		 { display = 'none' }
			else
		 { display = 'inline' }
	  }
	  
	  for (var i = 0; i < nameDiv.length; i++)
	  { nameDiv[i].style.display = display }         
   }
   
function toggle_mustImplement()
{
	//alert('here');
	// $('.mustImplement').parent().toggle();
	if($('.mustImplement').parent().is(":visible")){
		$('#mnuRequired').text('Toggle optional items');
		$('.mustImplement').parent().toggle();
	}
	else{
		$('#mnuRequired').text('Hide optional items');
		$('.mustImplement').parent().toggle();
	}
}

function toggle_id() {
		  var divs = document.getElementsByClassName('idDisplay');
			var display = 'none';
			
		  if (divs[0].style.display)
		  {                  
			  if (divs[0].style.display == 'inline' )
				{ display = 'none'; }
			  else
				{ display = 'inline'; }
		  }
		  
		  for (var i = 0; i < divs.length; i++)
		  { 
		  divs[i].style.display = display;
		  }
	   }
	   function resetAnswer(obj)
	   {
	   
	   	var button = $(obj);
		
		//find question div
		var questionToRemove = button.closest('.question');  //closest parent div with class='question'
		//alert(questionToRemove.attr('id'))		;												
		var currentQuestionId = questionToRemove.attr('id').substring(1);
		//alert(currentQuestionId);
		 var answers = document.getElementsByName(currentQuestionId);
	  
	   //alert(questionId.split("..")[0]);
	   for (var i = 0; i < answers.length; i++) {
			var selecttype = $(answers[i]).attr('type');
			
			if(selecttype=="checkbox" || selecttype=="radio" || selecttype=="text")
			{
				answers[i].checked = false;
				answers[i].value="";
				// fire onchange on this answer choice	
				//answers[i].onchange();
			}
					}
		//return false;
	   }
	
function ShowHideDemo() {
	$('#divdemo').toggle();
	if (($('#divdemo')).css("display")=='none')
		$('#demshowhide').text('+ Demographics');
	else
		$('#demshowhide').text('- Demographics');
}

//adds a new repeat of a section
function addSection(obj) {
	//obj is btnAdd
	/*
		UI: Clone the block
			Get new guid for block (section)
			Change names of each element (textbox, hiddenbox, checkbox, radio) in the block to original id + ":" + blockguid
		XML:    
			Clone the current section in xml
			Add new attribute called Guid = blockguid to the top level element
			Add new attribute called ParentGuid and set it equal to blockguid
			Change Id of each child to original id + ":" + blockguid
			
		Each question and answer choices in repeated block will have their ids changed to their original id + ": " + blockguid 
		
	*/
	
	//we need to clone table, so get table
	var td = obj.parentElement;
	var table = td.parentElement  //tr
				   .parentElement  //tbody
				   .parentElement //table
	
	/*if current section is the first occurrence, it's ID is from the xml
	if current section is a repeat it's ID = ID from the xml + Guid*/
	var currentSectionId = table.id; 
	
	var blockGuid = generateShortUid();  // generateGuid();  //to distinguish each repeat of parent element which is section for now
	repeatIndex++;
	
	var max = table.parentElement.firstChild.value;  //maxcardinality								
	
	try
	{
		var parentTable =  table.parentElement.
						   parentElement.
						   parentElement.
						   parentElement.
						   parentElement;
	}
	catch(err)
	{
		alert("Error when getting parent table: " + err);
		return;
	}
	
	if(countSectionRepeats(parentTable,currentSectionId.split("..")[0])==max)
	{
		alert("max repeat = " + max + " reached ");
		repeatIndex--;
		return;
	}
	
	var newtable = table.cloneNode(true);    							
	
	//newtable.id = currentSectionId.split(":")[0] + ":" + blockGuid;   //each repeated section id has the same ID from xml + blockGuid							
	newtable.id = currentSectionId.split("..")[0] + ".." + repeatIndex
								
	//set new ids to each nested table 
	var newtableitems = newtable.getElementsByTagName('*');										
	for(i=0; i< newtableitems.length; i++)		{	
		if(newtableitems[i].tagName=="TABLE"){
				newtableitems[i].id = newtableitems[i].id.split("..")[0] + ".." + repeatIndex;
	}
	if(newtableitems[i].className=="question"){
				newtableitems[i].id = newtableitems[i].id.split("..")[0] + ".." + repeatIndex;
	}
	if(newtableitems[i].tagName=="input"){
				newtableitems[i].name = newtableitems[i].name.split("..")[0] + ".." + repeatIndex;
	}
	}

	var trace = 0;
	var newname;
	var i;
	var ID;

	//add the new repeat
	try {
		
		/*find section in xml corresponding to this block (ID=currentSectionId.substring(1)) and clone it, then assign new ID*/
		//alert(currentSectionId.substring(1));
		var $sectionCurrent = $xml.find('Section[ID="' + currentSectionId.substring(1) + '"]:first');  //first is redundant since there is only one section with this ID
		if($sectionCurrent.length==0)
		{
			//alert("Section ID = " + currentSectionId.substring(1) + " not found");
			//return;
		}
		
		var $sectionNew = $sectionCurrent.clone(true);
		
		//$sectionNew.attr('ID',currentSectionId.split(":")[0].substring(1)+":" + blockGuid);
		$sectionNew.attr('ID',currentSectionId.split("..")[0].substring(1)+".." + repeatIndex);								
		
		//xml: set IDs of all children sections
		$sectionNew.find('Section').each(function(index){
			//var secid = $(this).attr("ID").split(":")[0] + ":" + blockGuid;	
			var secid = $(this).attr("ID").split("..")[0] + ".." + repeatIndex;	
			$(this).attr("ID",secid);			
		});
										
		var oldtableitems = td.getElementsByTagName("input");  //get hidden input, radio buttons, checkboxes and input text boxes
		
		//iterate through oldtableitems and assign new unique ids to them
		for (i = 0; i < oldtableitems.length; i++) {
			
			if (oldtableitems[i].type == "hidden" || oldtableitems[i].type == "text" || oldtableitems[i].type=="radio") {
				oldname = oldtableitems[i].name;  //name of the first instance is ID from xml, repeats have ID + ":" + Guid

				if(oldtableitems[i].id=="maxcardinality")
					  continue;

				if(oldtableitems[i].name=="")
				{
					alert("error: a " + oldtableitems[i].type + " box without name is found at " + i);
					continue;
				}
					   
				//newname = oldtableitems[i].name.split(":")[0] + ':' + blockGuid;
				newname = oldtableitems[i].name.split("..")[0] + '..' + repeatIndex;
															
				//find the element in the new table
				
				newtableitems = newtable.getElementsByTagName('*');										
				
				for(k=0;k<newtableitems.length;k++)
				{												
				   if(newtableitems[k].name == oldtableitems[i].name)
				   {
						newtableitems[k].name = newname;													
						if(newtableitems[k].class=="question")
						{
						
						}
						if(newtableitems[k].type=="hidden")   //question will have Q as the first letter
						{  
						   //find question in xml fragment and change ID
						   
						   $question = $sectionNew.find('Question[ID="' + oldtableitems[i].name.substring(1) + '"]');
						   
						   if($question.length==0)
						   {
								//alert("Qusetion ID = " + oldtableitems[i].name.substring(1) + " not found.");
								$sectionNew.find('Question').each(function(index){
									//alert($(this).attr("ID"));
								})
								//return;
							}
							else
							{
								//$question.attr("ID", newtableitems[k].name.split(":")[0].substring(1) + ':' + blockGuid); 
								//$question.attr("ID", newtableitems[k].name.split("..")[0].substring(1) + '..' + repeatIndex); 
								
							}
						   
						   /* 12/18/2016
						   New constraints
						   Property name, ResponseField name and Value name have to be unique 
						   */
						   
						   if (typeof $question.find("Property").attr("name") != 'undefined')
						   {
								//new property name
								//var propname = $question.find("Property").attr("name") + "_" + blockGuid; // repeat;
								var propname = $question.find("Property").attr("name").split('..')[0] + ".." + repeatIndex;
								$question.find("Property").attr("name",propname);
						   }
						   
						   if (typeof $question.find("ResponseField").attr("name") != 'undefined')
						   {
								//new response name
								//propname = $question.find("ResponseField").attr("name") + "_" + blockGuid;  // repeat;
								propname = $question.find("ResponseField").attr("name").split('..')[0] + ".." + repeatIndex;  // repeat;
								$question.find("ResponseField").attr("name",propname);
						   }
						   
						   if (typeof $question.find("Response").children(0).attr("name") != 'undefined')
						   {
								//new name on value field
								//propname = $question.find("Response").children(0).attr("name") + "_" + blockGuid;  // repeat;
								propname = $question.find("Response").children(0).attr("name").split('..')[0] + ".." + repeatIndex;  // repeat;
								$question.find("Response").children(0).attr("name", propname);
						   }
						}
						else 
						{                   //answers do not have Q											
								if(newtableitems[k].type=="radio" || newtableitems[k].type == "checkbox")
								{
									 newtableitems[k].checked = false;														  
								}
								 else
								{
									 newtableitems[k].value = "";
								}
						}												   
					}
				}	
			}
		}

		newtable.getElementsByClassName("btnRemove")[0].style.visibility="visible";
		//better to append new table after setting properties of individual controls
		table.parentElement.appendChild(newtable);
								
		//insert newsec after last section
		
		//$xml.find('Section[ID="' + table.id.substring(1) + '"]').after($sectionNew);
		
		var $orgsecid = table.id.substring(1).split('..')[0];
		
		var $lastindex = $xml.find('Section[ID*="' + $orgsecid + '"]').length - 1;									
		
		if($lastindex>=0)
		{
			$xml.find('Section[ID*="' + $orgsecid + '"]').last().after($sectionNew);
		}
		else
		{
			//alert("error adding section repeat");
			return;
		}
			
		//remove all nested repeats
		newtable = removeNestedTableRepeats(newtable);
	
		//update rawxml for view							
		$('#rawxml').val(xmlToString(xmlDoc));												
		
		repeat = countSectionRepeats(parentTable, currentSectionId.split("..")[0])																	
		
		showHideButtons(newtable);	
		
		//make sure + is visible on the first repeat of nested section
		nestedtables = getChildTables(newtable);
		
		for(i=0;i<nestedtables.length;i++)
		{
			elements = nestedtables[i].getElementsByTagName('*');	
			for(j=0;j<elements.length;j++)
			{
				if(elements[j].className=="btnAdd")
					elements[j].style.visibility="visible";
			}
		}
	}
	catch (err) 
	{
		alert(err.message + "\n" + trace + "\n" + newname + "n" + i);
	}
}

var repeatIndexQuestion=0;
//adds a new repeat of a question
function addQuestion(obj) {
	//obj is btnAdd inside command div
	/*
		UI: Clone .question div, update id of this div to original id + '..' + repeatIndex
		change names of children to name + '..' + repeatIndex 
		
		XML:    
			Clone the current question node in xml
			Change Id of the question and its children to original id + ":" + blockguid
		Each question and answer choices in repeated block will have their ids changed to their original id + ": " + blockguid 
	*/
	
	try
	{
		var button = $(obj);
		
		//find question div
		var questionToRepeat = button.closest('.question');  //closest parent div with class='question'
		
			//alert(questionToRepeat.html())
			
		var currentQuestionId = questionToRepeat.attr('id');
		
		var count=0;
		
		var test=document.getElementsByClassName("question").length;
		for (i=0;i<test;i++)
		{
		if(document.getElementsByClassName("question")[i].id.substring(1).split('..')[0]==currentQuestionId.substring(1).split('..')[0]){
		count++;}
		}
		
		currentQuestionId = currentQuestionId.substring(1).split('..')[0];
		
		var max = questionToRepeat.find("input[id='maxcardinality']").first().val();  //maxcardinality	
		
		//alert(max);
		
	     var repeats = countQuestionRepeats(currentQuestionId);
				repeatIndexQuestion++;
		
		if(count> max)
		{
			alert('max repeat value ' + max + ' reached.');
			repeatIndexQuestion--;
			return;
		}
				
		var clonedBlock = questionToRepeat.clone();
		//alert(currentQuestionId);
		clonedBlock.attr("id", 'q' + currentQuestionId + '..' + repeatIndexQuestion);
		
		//alert(clonedBlock.html());
		
		//find the top level question node in xml and clone it
		var elementToClone = $xml.find("Question[ID='" + currentQuestionId + "']");
		var clonedXml = elementToClone.clone();
		
		//change name attributes 
		clonedXml.find("Property").each(function(){
				var prop = $(this);
				if(typeof prop.attr("name") != "undefined")
					prop.attr("name",prop.attr("name").split('..')[0] + ".." + repeatIndexQuestion);
		});
		
		clonedXml.find("ResponseField").each(function(){
				var temp = $(this);
				if(typeof temp.attr("name") != "undefined")
				temp.attr("name",temp.attr("name").split('..')[0] + ".." + repeatIndexQuestion);
		});
		
		clonedXml.find("Response").each(function(){
				var temp = $(this).children(0);
				if(typeof temp.attr("name") != "undefined")
				temp.attr("name",temp.attr("name").split('..')[0] + ".." + repeatIndexQuestion);
		});
		
		clonedXml.find("ListItemResponseField").each(function(){
				var temp = $(this);
				if(typeof temp.attr("name") != "undefined")
				temp.attr("name",temp.attr("name").split('..')[0] + ".." + repeatIndexQuestion);
		});
		
		//update names of cloned elements
		var clonedItems = clonedBlock.find("input");  //get hidden input, radio buttons, checkboxes and input text boxes
		var clonedItems1 = clonedBlock.find(".question"); 
		clonedItems1.each(function(){
			var item = $(this);
			var id = item.attr('id');
			
			if(typeof id != 'undefined')
			{	   
				if(id.substring(0,1)=='q')
				{
					var questionId = id.substring(1).split('..')[0];
					item.attr('id','q' + questionId + '..' + repeatIndexQuestion);
					//alert(questionId + ':' + clonedXml.find("Question[ID='" + questionId + "']").length);
					if(clonedXml.attr("ID")==questionId)
					{
						//alert('here')
						clonedXml.attr("ID",questionId + '..' + repeatIndexQuestion);	
					}
					else
					{
						clonedXml.find("Question[ID='" + name.substring(1) + "']").attr('ID',questionId + '..' + repeatIndexQuestion);	
						//alert(questionId + '..' + repeatIndexQuestion);
					}
				}
				else
				{
					//answer choices do not have 'q'
					var questionId = name.split('..')[0];
					item.attr('name',questionId + '..' + repeatIndexQuestion);
					//alert(item.attr('type'));
					if(item.attr('type')=='text')
					{
						item.val('');
					}
					item.attr('checked',false);
				}
			}	
		});
		//iterate through clonedItems and assign new unique ids to them
		clonedItems.each(function(){
			var item = $(this);
			var name = item.attr('name');
			
			if(typeof name != 'undefined')
			{	   
				if(name.substring(0,1)=='q')
				{
					var questionId = name.substring(1).split('..')[0];
					item.attr('name','q' + questionId + '..' + repeatIndexQuestion);
					//alert(questionId + ':' + clonedXml.find("Question[ID='" + questionId + "']").length);
					if(clonedXml.attr("ID")==questionId)
					{
						//alert('here')
						clonedXml.attr("ID",questionId + '..' + repeatIndexQuestion);	
					}
					else
					{
						clonedXml.find("Question[ID='" + name.substring(1) + "']").attr('ID',questionId + '..' + repeatIndexQuestion);	
						//alert(questionId + '..' + repeatIndexQuestion);
					}
				}
				else
				{
					//answer choices do not have 'q'
					var questionId = name.split('..')[0];
					item.attr('name',questionId + '..' + repeatIndexQuestion);
					//alert(item.attr('type'));
					if(item.attr('type')=='text')
					{
						item.val('');
					}
					item.attr('checked',false);
				}
			}	
		});
		
		//append cloned node to xml
		clonedXml.appendTo(elementToClone.parent());
		
		//append cloned UI block in display
		clonedBlock.find('.btnRemove').css('visibility', 'visible');  //show does not work
		//clonedBlock.appendTo(questionToRepeat.after());   
		questionToRepeat.after(	clonedBlock);	
	}
	catch (err) 
	{
		alert(err.message );
	}
}

function removeQuestion(obj)
{
	try 
	{
		var button = $(obj);
		
		//find question div
		var questionToRemove = button.closest('.question');  //closest parent div with class='question'
																				
		var currentQuestionId = questionToRemove.attr('id').substring(1);
	repeatIndexQuestion--;
		//remove
		questionToRemove.remove();
		//alert('now removing ' + currentQuestionId);
		//alert(countQuestionRepeats(currentQuestionId));
		//if($xml.find("Question [ID='" + currentQuestionId + "']").length==0)
		//{
		//	alert("ID = " + currentQuestionId + " not found");
		//}
		//$xml.find("Question [ID='" + currentQuestionId + "']").remove();
	}
	catch(err)
	{
		alert(err.message);
	}
}

function getRepeats(id)
{
	var id = id.split('_')[0];
	var count = 0;
	$('input').each(function(){
		var name = $(this).attr('name');
		if(name==id)
		{
			count++;
		}
	});
	
	return count;
}

function generateShortUid() 
{
		return ("0000" + (Math.random()*Math.pow(36,4) << 0).toString(36)).slice(-4)
}

function generateGuid()
{
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

/*
Counts the number of repeats of a block (table)
Each repeated block (table) has id that has two parts
1. id that is the same for each repeat.
2. a guid that is different for each repeat 
*/
function countSectionRepeats(parentT, sectionid)
{
	var tables = parentT.getElementsByTagName('TABLE');
	var count = 0;
	for(i=0; i<tables.length; i++)
	{
	   checkid = tables[i].id.split("..")[0];
	   if(checkid == sectionid) count++;
	}
	return count;
}

/*
count question repeats 
*/
function countQuestionRepeats(questionid)
{
	//questionid = questionid.split('.')[0];
	
	//alert(questionid + ':' + $xml.find('Question[ID^="' + questionid + '"]').length);
	return $xml.find('Question[ID^="' + questionid + '"]').length;
}

function getMaxCount(sectionid)
{
	alert(document.getElementById(sectionid).length);

}

function getSiblingTables(parentT) {								
	
	return tables = parentT.getElementsByTagName('TABLE');								
}

function getChildTables(table)
{
	return table = table.getElementsByTagName('TABLE');
}

function getLastRepeat(sectionid) {
	var section = document.getElementById(sectionid);
	var tables = section.parentElement.getElementsByTagName('TABLE');
	var ret = null;
	for(i=0;i<tables.length;i++)
	{
	   if(tables[i].id.split("..")[0]==sectionid)
		 ret = tables[i];
	}
	return ret;
}

function getFirstRepeat(sectionid) {
	var section = document.getElementById(sectionid);
	var tables = section.parentElement.getElementsByTagName('TABLE');
	var ret = null;
	for(i=0;i<tables.length;i++)
	{
	   if(tables[i].id.split("..")[0]==sectionid)
	   {
		 ret = tables[i];
		 break;
		}
	}
	return ret;
}

function removeNestedTableRepeats(table)
{
	var all = table.getElementsByTagName("*");
	for(i=0; i<all.length-1; i++)
	{
		if(all[i].id.indexOf("s")==0 & all[i].tagName=="TABLE") //nested table
		{										
			var id = all[i].id;
			//alert("delete id = " + id);
			for(j=i+1; j<all.length-1; j++)
			{
				if(all[j].id.split("..")[0]==id.split("..")[0])
				{
					v = all[j].id;
					
					//remove table
					all[j].parentElement.removeChild(all[j]);
					
					//remove xmlnode
					
					$j = $xml.find('Section[ID="' + v.substring(1) + '"]');
					
					//if($j.length==0)
					//	alert("removeNestedTableRepeats - not found: " + v.substring(1));
					
					if($j.length > 1 )
					{
						try
						{
							$j.slice(1).remove();  //remove from index = 1 down
						}
						catch(err)
						{
							alert("Error in removeNestedTableRepeats: " + err);
						}
					}
					removeNestedTableRepeats(table);
				}
			}
		}
	}
	return table;
}

//gets the id parentSection of +, - buttons
function getParentSectionId(button)
{
	if(button.parentElement.parentElement.parentElement.parentElement.tagName=="TABLE")
		return button.parentElement.parentElement.parentElement.parentElement.id;
	else
		alert("Unexpected tagName");
}

function getParentTable(table)
{
	//get parentTable
	try{
	var parentTable =  table.parentElement.
						   parentElement.
						   parentElement.
						   parentElement.
						   parentElement;
	return parentTable;
	}
	catch(err)
	{
		alert("Error in getParentTable: " + err);
		return;
	}
}

function showHideButtons(table)
{
	//get parentTable
	var parentTable =  getParentTable(table);
	
	//show/hide buttons
	
	//get all siblings of this table
	var siblings = getSiblingTables(parentTable);
	
	//get max repeat for this table - get parent which is DIV and the firstChild of DIV is maxcount
	var max = table.parentElement.firstChild.value;  
	
	//how many repeats are there for this table currently
	var repeat = countSectionRepeats(parentTable, table.id.split("..")[0]);
	
	var inputs = "";
	if(siblings.length==0)
	{
		alert("error in getting siblings");
		return;
	}
	
	if(repeat<max)   
	{
		for (k=0;k<siblings.length; k++)
		{										
			if(siblings[k].id.split("..")[0]==table.id.split("..")[0])
			{	
				inputs = siblings[k].getElementsByTagName('*');
		
				for(m=0;m<inputs.length;m++)
				{
					if(inputs[m].className=="btnAdd")
					{														
						//which section does it belong?
						sectionid = getParentSectionId(inputs[m]);
						
						if(table.id.split("..")[0] != sectionid.split("..")[0])
						{
							//alert(table.id);
							//alert(sectionid);
							continue;
						}													
					
						if(k>0)
						{
							inputs[m].nextSibling.style.visibility = "visible";
							inputs[m].style.visibility = "visible";
						}
						else
						{
							
							inputs[m].nextSibling.style.visibility = "hidden";
							inputs[m].style.visibility = "visible";
						}											
					}
				}
			}
		}
	}
	else
	{
		for (k=0;k<siblings.length; k++)
		{
			if(siblings[k].id.split("..")[0]==table.id.split("..")[0])
			{
				inputs = siblings[k].getElementsByTagName('*');
				for(m=0;m<inputs.length;m++)
				{
					if(inputs[m].className=="btnAdd")
					{
						inputs[m].style.visibility = "hidden";
						
						if(k>0)
							inputs[m].nextSibling.style.visibility = "visible";
					}
				}
			}
		}				
	}								
}
							
function removeSection(obj)
{
	td = obj.parentElement;
	tr = td.parentElement;
	tbody = tr.parentElement;
	table = tbody.parentElement;
	var section = table.parentElement;
	var id = table.id;
	
	parentTable = getParentTable(table);
					   
	//do not let user remove the first instance
	if(table.id.indexOf("..")==-1)
	{
		alert("Cannot remove the first instance.");
		return;
	}
	section.removeChild(table);
							
	id = section.id;
									
	$todelete = $xml.find('Section[ID="' + table.id.substring(1) + '"]');
	if($todelete.length==0)
	{
		//alert("Could not find section with ID = " + table.id.substring(1) + " to delete");
		//return;
	}
	
	$todelete.remove();
	
	$todelete = $xml.find('Section[ID="' + table.id.substring(1) + '"]');
	if($todelete.length!=0)
	{
		//alert("Could not delete Section ID = " + table.id.substring(1));									
	}
	repeatIndex--;
	//update rawxml
	$('#rawxml').val(xmlToString(xmlDoc));
								
	//current table is deleted, so get the first table by going upto the parent, then the first Table
	table = document.getElementById(parentTable.id);
	
	if(table.tagName=="DIV")   //first table is inside DIV element
	{
		table = table.childNodes[1];  //parentTable
		table = table.getElementsByTagName("TABLE")[0]  //firstChild table																		
		
	}
	else  //subsequent repeats are nested inside parent TABLE directly
	{
		
		table = table.getElementsByTagName("TABLE")[0]  //first child table
	}
		
	showHideButtons(table);	
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

function validateSubmit()
{
	
	$('input').removeClass('error');
	//document.getElementById('navBar').style.display = 'none';
	

	
	
	var retval = false;
	var $allinputs = $("#FormData").find(":input:not([type=hidden], [type=button], [type=submit])")
	$allinputs.each(function() {
		var $test = $(this);
		
		if($test.is(':checkbox') || $test.is(':radio'))
		{
			if($test.prop('checked')==true)
			{
					//alert($test.attr('id'));
				retval = true;
			}
		}
		else
		{
			if($test.val()!='')
			{
				retval = true;
				//alert($test.attr('id'));
			}
		}
	});
	
	//alert(retval);
	if(!retval)
	{
		alert('Error: You have not selected/entered any response on the form.');
		return false; //so 
	}
	
	retval = true;
	
	var $fillins = $(xmlDoc).find("ListItemResponseField")
	
	$fillins.each(function(){
		var answerid = $(this).parent().attr("ID");
		var $answerElement = getAnswerItemByID(answerid, $("#FormData"));
		
		if(!$answerElement.prop('checked') & $answerElement.parent().find(".AnswerTextBox").val()!=''){
				//alert('error');
				$answerElement.parent().find('.AnswerTextBox').addClass('error');
				retval = false;
		}
	})
	//alert(retval);
	if(!retval)
	{
		alert('Error: You have entered text in fill-in box)(es) without selecting the corresponding choice(s)');
		return false;
	}
	
	var requiredResponses = $xml.find("ListItemResponseField[responseRequired='true']");
	retval = true;
	requiredResponses.each(function(){
		var test = $(this);
		var id = test.parent().attr('ID');
		
		var response = test.find('>Response');
		
		if(response.length>0)
		{
			var box = $(document).find(':input[value^="' + id + '"]'); //check/option 
			if(box.length>0)
			{
				var testval = box.siblings('input').val();									
			
				if(testval=='')
				{												
					if(box.is(':checked'))
					{
						box.siblings('input').addClass('error');
						retval = false;
					}													
				}
			}
		}
	});
	
	if(!retval)
	{
		alert('Error: You have not answered all required questions.');
		return false
	}
	return true;
}

function xmlToString(xmlData) 
{
	var xmlString;
	//alert(xmlData);
	xmlString = (new XMLSerializer()).serializeToString(xmlData);
	
	return xmlString;
}

//helper functions end

//submit form calls this function
/*
Builds flatXml, updates the original xml with answers.
Note that new section nodes for repeat sections have already been added (upon clicking btnAdd - addSection function) 
*/
var flatXml;
function openMessageData(submit)
{
	var sb = "";
	var answer = "";
	
	try {
	
	
	$('#menu').hide();
	console.log('hid menu');
	$('#step3').addClass('selected');
	$('#step2').removeClass('selected');
	
	
	
	if(document.getElementById("checklist")==null)
	{
       alert('checklist not found');	
	   //return;
	}
	if(document.getElementById("FormData")==null)
	{
       alert('checklist not found');	
	   return;
	}
	var elem = document.getElementById("checklist").elements;
	//var elem = document.getElementById("FormData").elements;
	var response = "<response>";
	var html = "";
	
	
	
	for (var i = 0; i < elem.length; i++) {
		html = "";
		var name = elem[i].name;

		var value;

		var instanceGuid = '';
		
		var id = name;
		var guid = "";
		if (name.indexOf("q") == 0) {
			
			value = elem[i].value;
			
			//make answer xml safe
			answer = GetAnswer(name.substring(1));

			if (answer != "") {
				
				response += "<question ID=\"" + id + "\" display-name=\"" + value.replace(/</g, "&lt;").replace(/>/g, "&gt;") 
						 + "\">";
				response += answer + "</question>";               

				
				newid = id.split('..')[0].substring(1);									
				
				if(id.split('..').length==2)
					guid=id.split('..')[1]
				
				//html += "<div class=\"MessageDataQuestion\">&lt;question ID=\"" + id + "\" guid=\"" + guid + "\" display-name=\"" + value + "";
				html += "<div class=\"MessageDataQuestion\">&lt;question ID=\"" + id.substring(1) +  "\" display-name=\"" + value + "";
				html += "&gt;<br><div class=\"MessageDataAnswer\">" + answer.replace(/</g,"&lt;").replace(/>/g,"&gt;") + "</div>&lt;/question&gt;</div>";
			}
			sb += html;
			answer = "";
		}
	}
	response = response.replace(/<br>/g, "");
	response = response + "</response>";															
	flatXml = response;

		sb = "<div style='font-weight:bold; color:purple'>Flat Xml response</div>" 
		 + "<div class=\"MessageDataChecklist\">&lt;response&gt;" + sb + "&lt;/response&gt;</div>"
		 + "<br/><div style='font-weight:bold; color:purple'>Response xml sent to web service.</div>"
	
	
	//update Xml with answers
	updateXml();
	
	
	
	if(!validateSubmit())
	{
	
		if (confirm('Do you want to submit this form with errors? Click Ok to submit or Cancel to fix errors.')==false)
		{
			return;
		}
	}								
	
	
	
	document.getElementById('MessageDataResult').innerHTML = sb;
	document.getElementById('MessageData').style.display = 'block';
	document.getElementById('FormData').style.display = 'none';
	
	
	
	//if running from disk 
	if(isLocalMode()) return;

	var test = xmlToString(xmlDoc);
	document.getElementById('rawxml').innerText = test;
	
	if($('#scriptsubmit').is(':checked'))
	{
		//Ajax call to web service
		CallSoapSubmit2(xmlToString(xmlDoc));
		return false;
	}
	else
	{
		//call formreceiver from server side code
		//alert('calling server submit');
		ServerSubmit();

	}
	}
	catch(err)
	{
		alert(err);
	}
}

/* start of functions to call .NET serverside methods*/
function ServerSubmit()
{
	//alert('trace1');
	var xml = document.getElementById("rawxml").value;
	var submiturls = document.getElementById("submiturl").value
	//alert(submiturls);
	//alert('trace2');
	var responsetext = PageMethods.submitform(xml, submiturls, OnServerSucceed, OnServerError);
	//alert('trace3');
	return false;
}

function OnServerSucceed(result)
{
	//alert('Server submit succeded.');
   //server response includes SoapResponse and SoapRequest strings delimited by #!#2#3
	var response = result.split('#!#2#3')[0];
	var request = result.split('#!#2#3')[1];

	//request = formatXml(request);
	$("#submitsoap").val(request);

	response = formatXml(response);
	xml_escaped = response.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/ /g, '&nbsp;').replace(/\n/g, '<br />');
	
	$("#response").html("<PRE>" + xml_escaped + '</PRE>');
	$("#response").css("background-color", "yellow");
	$("#response").css("display", "block");								
}

function OnServerError(error)
{
	var result = error.get_message();
	alert("Error on server submit: " + result);
	document.getElementById("response").innerText = result;
	document.getElementById("response").style.backgroundColor = "yellow";
	document.getElementById("response").style.color = "red";
}

/* end of functions to call .NET serverside methods */
function closeMessageData() 
{
	$('#step2').addClass('selected');
	$('#step3').removeClass('selected');
	
	document.getElementById('MessageData').style.display = 'none';
	document.getElementById('response').style.display = 'none';
	document.getElementById('FormData').style.display = 'block';
	document.getElementById('navBar').style.display = 'block';
}

function GetAnswer(qCkey) 
{
	
	var elem = document.getElementById("checklist").elements;
	var str = "";
	var name, value;

	for (var i = 0; i < elem.length; i++) {
		name = elem[i].name;
		value = elem[i].value;

		//if (name.indexOf(qCkey) == 0) {
		if (name==qCkey) {	
			if (elem[i].checked || (elem[i].type == "text" && value != "")) {
				{
					var k = value.split(',');

					if (elem[i].type == "text" && value != "") {
						value = value.replace(/&/g,"&amp;")
									 .replace(/</g,"&lt;")
									 .replace(/>/g,"&gt;")
									 .replace(/"/g,"&quot;")
									 .replace(/'/g,"&apos;");
												 
					//alert(answer);
						
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

function padLeft (str, max) {
  str = str.toString();
  return str.length < max ? padLeft("0" + str, max) : str;
}

//soap 1.2
function CallSoapSubmit2(data) 
{

	if($('#scriptsubmit').length == 0 | (!$('#scriptsubmit').is(':checked')))
	{
		alert("Script Submit is not supported.");
		//serverSubmit(data);
		return;
	}
	
	try
	{
		//get DemogFormDesign and FormDesign element only
	xmlDoc = $.parseXML(data);
	$xml = $(xmlDoc);
	
	var $formdesignelement = $xml.find('FormDesign');
			   
	if($xml.find('DemogFormDesign'))
	{	
		$demog = $xml.find('DemogFormDesign'); 
		$demogNew = $demog.clone(true);
	}

	var $designNew = $formdesignelement.clone(true);
	newDoc = $.parseXML("<SDCSubmissionPackage xmlns='urn:ihe:qrph:sdc:2016'></SDCSubmissionPackage>")
	test = $(newDoc).find("SDCSubmissionPackage");
	
	//add 2018 - pkgInstanceURI, pkgInstanceVersionURI, pkgPreviousInstanceVersionURI, pkgDateTimeStamp
	test.attr("pkgInstanceURI","1223456");
	test.attr("pkgInstanceVersionURI","1223456");
	test.attr("pkgPreviousInstanceVersionURI","1223456");
	
	var d = new Date();

	var month = padLeft(d.getMonth()+1,2);
	var day = padLeft(d.getDate(),2);
	var year = d.getFullYear();
	var hr = padLeft(d.getHours(),2);
	var min = padLeft(d.getMinutes(),2);
	var sec = padLeft(d.getSeconds(),2);
	var fulldate = year + '-' + month + '-' + day + 'T' + hr + ':' + min + ':' + sec;
	//alert(fulldate);
	var dt = new Date("30 July 2010 15:05 UTC");
	//document.write(dt.toISOString());
	//test.attr("pkgDateTimeStamp","2017-11-18T07:53:01");
	//2017-11-18T8:7:34
	test.attr("pkgDateTimeStamp",fulldate);
	test.append($designNew);
	if($demogNew)
	{
		test.prepend($demogNew);						
	}

	data = xmlToString(newDoc);

	//read destination url from xml if present
	var webServiceURL = "";

	$destinations = $xml.find('Destination');
	
	if($destinations.length>0)								
	{
		$.each($destinations, function()
		{	
			webServiceURL = webServiceURL + "|" + $(this).find('Endpoint').attr('val');
		});
	
		webServiceURL = webServiceURL.substring(1);															
	}
	else
	{
		alert('submiturl = ' + $("#submiturl").val());
		webServiceURL = $("#submiturl").val();
		if(webServiceURL=='')
		{
			alert("destination not found.");
			return;
			}
	}
									
	var ns = 'urn:ihe:iti:rfd:2007';

	$.support.cors = true;
	var xmldata = encodeURIComponent(data);
	
	var soapRequest =
						'<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"' + 
						' xmlns:urn="' + ns + '">'  + 
						'<soap:Header/>' +
							' <soap:Body>' +
									' <urn:SubmitFormRequest>' +
									 data +
									'</urn:SubmitFormRequest>' +
							' </soap:Body>' +
						' </soap:Envelope>';
								

	$("#submitsoap").val(soapRequest);
	endpoints = webServiceURL.split('|')  //multiple endpoints are separated by |
	numEndpoints = endpoints.length;
	
	//clear before submit
	$("#response").html('');
	
	var currEndpoint='';
	for(i=0;i<numEndpoints;i++)
	{
		currEndpoint = endpoints[i].trim();
		try
		{
			$.ajax({
			type: "POST",
			context:{test:currEndpoint},  //test is the value when call was made and is available in success and error
			url: currEndpoint,
			//contentType: "application/soap+xml;charset=utf-8;",
			contentType: "application/soap+xml;",
			dataType: "xml",
			processData: false,									
			data: soapRequest,
			success: function (response) {OnSuccess(response,this.test)},
			error: function (xhr, message, exception ) {OnError(xhr, message, exception, this.test)}
			});
		}
		catch(err)
		{
			alert("Error when posting submit request to " + currEndpoint + ": " + err);
		}
	}
	return false;
	}
	catch (err)
	{
		alert(err.message);
		return false;
	}
}

//soap 1.1
function CallSoapSubmit1(data) 
{	
	$("#response").val("************");
	
	//get DemogFormDesign and FormDesign element only
	xmlDoc = $.parseXML(data);
	$xml = $(xmlDoc);

	var $formdesignelement = $xml.find('FormDesign');
			   
	if($xml.find('DemogFormDesign'))
	{	
		$demog = $xml.find('DemogFormDesign'); 
		$demogNew = $demog.clone(true);
	}

	var $designNew = $formdesignelement.clone(true);
	newDoc = $.parseXML("<SDCSubmissionPackage xmlns='urn:ihe:qrph:sdc:2016'></SDCSubmissionPackage>")
	test = $(newDoc).find("SDCSubmissionPackage");
	test.append($designNew);
	if($demogNew)
	{
		test.prepend($demogNew);						
	}

	data = xmlToString(newDoc);

	//read destination url from xml if present
	var webServiceURL = "";

	//webServiceURLFromPackage = $xml.find('Destination').find('Endpoint').attr('val');
	$destinations = $xml.find('Destination');
	
	if($destinations.length>0)								
	{
		for(i=0;i<$destinations.length;i++)
		{
			webServiceURL = webServiceURL + "|" + $destinations.find('Endpoint').attr('val');									
			
		}
		webServiceURL = webServiceURL.substring(1);															
	}
	else
	{
		alert('1.1');
		alert("destination not found.");
		return;
	}
	
	if(webServiceURL!="" & $("#submiturl").val()=="")
		$("#submiturl").val(webServiceURL);
	
	webServiceURL = $("#submiturl").val();  
	
	var ns = $("#submitnamespace").val();
	
	$.support.cors = true;
	var xmldata = encodeURIComponent(data);
	
	var soapRequest =
						'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"' + 
						' xmlns:urn="' + ns + '">'  + 
						'<soap:Header/>' +
							' <soap:Body>' +
									' <urn:SubmitFormRequest>' +
									//' <SDCSubmissionPackage xmlns="urn:ihe:qrph:sdc:2016">' +
									 data +
									// ' </SDCSubmissionPackage>' +
									'</urn:SubmitFormRequest>' +
							' </soap:Body>' +
						' </soap:Envelope>';

	$("#submitsoap").val(soapRequest);

	//soapAction = "SubmitForm";  
	soapAction = $("#submitaction").val();
	
	endpoints = webServiceURL.split('|')  //multiple endpoints are separated by |
	numEndpoints = endpoints.length;
	
	var currEndpoint='';
	
	//clear before submit
	$("#response")='';
	
	//soapRequest='<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ihe:iti:rfd:2007"> <soap:Header/><soap:Body><urn:SubmitFormRequest>test</urn:SubmitFormRequest> </soap:Body></soap:Envelope>'
	//alert(soapRequest);
	for(i=0;i<numEndpoints;i++)
	{
		currEndpoint = endpoints[i].trim();
		
		$.ajax({
		type: "POST",
		context:{test:currEndpoint},  //test is the value when call was made and is available in success and error
		url: currEndpoint,
		contentType: "text/xml",
		dataType: "xml",
		processData: false,
		headers: {
			"SOAPAction": soapAction  
		},
		data: soapRequest,
		success: function (response) {OnSuccess(response,this.test)},
		error: function (response) {OnError(response, this.test)}
	});
	}
	return false;
}

function OnSuccess(data, url) 
{	
	var xmlstring = xmlToString(data);

	xmlstring = formatXml(xmlstring);
	xml_escaped = xmlstring.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/ /g, '&nbsp;').replace(/\n/g,'<br />');

	if (document.getElementById("response") != null)
	{       	
		$("#receiverresponse").append("<b>Submit Endpoint " + url + "</b>");
		$("#receiverresponse").append("<PRE>" + xml_escaped + '</PRE>');		
		$("#receiverresponse").css("display", "block");
	}	
}

function OnError(xhr, textStatus, errThrown, url) 
{
	//CORS error can only be see in Chrome 
	var xmlstring = xhr.responseText;
		
	if (document.getElementById("response") != null) {       
		$("#receiverresponse").append("Receiver Response from " + url + " - <PRE>" + xmlstring + '</PRE>');
		$("#receiverresponse").css("background-color", "white");
		$("#receiverresponse").css("color", "red");
		$("#receiverresponse").css("display", "block");
	}
}

//https://gist.github.com/sente/1083506
function formatXml(xml) {
	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node) {
		var indent = 0;
		if (node.match( /.+<\/\w[^>]*>$/ )) {
			indent = 0;
		} else if (node.match( /^<\/\w/ )) {
			if (pad != 0) {
				pad -= 1;
			}
		} else if (node.match( /^<\w([^>]*[^\/])?>.*$/ )) {
			indent = 1;
		} else {
			indent = 0;
		}

		var padding = '';
		for (var i = 0; i < pad; i++) {
			padding += '  ';
		}

		formatted += padding + node + '\r\n';
		pad += indent;
	});
	return formatted;
}

function getAnswerItemByID(ID, container)
{
	//finds an answer item within container element
	try{
		//alert(ID + ':' + $(container).find(':input[value^="' + ID + '"]').length);
		return $(container).find(':input[value^="' + ID + '"]');
		}
	catch(e)
	{
		alert(e + ", ID = " + ID);
	}
}


function getAnswerID(answerElement)
{
	var id = $(answerElement).attr('value');
	if (id === undefined || id === null) {
		 // do something 
		 alert("Error in getAnswerID: value attribute not found.");
		 alert($(answerElement).length);
	}
	if(id.indexOf(',')>0)
		id = id.substring(0, id.indexOf(','));
	return id;
}

/*
function getQuestionID(answerElement)
{
	var id = answerElement.attr('name');
	return id;
}
*/

function getSectionID(answerElement)
{
	var $section = $(answerElement).parentsUntil('table').parent();
	//alert($section.get(0).nodeName);
	var sectionid = '';
	if($section.length>0)
	{
		sectionid = $section.get(0).id.substring(1);
	}
	return sectionid;
}

function getAnswerSection(answerElement)
{
   //returns DOM element
	var $section = $(answerElement).parentsUntil('table').parent();
	
	//return the first in the list
	return $($section.get(0));
}

function isSDSAnswer(answerElement)
{
	//alert('isSDS');
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	var attr = $answer.attr('selectionDeselectsSiblings');

	// For some browsers, 'attr' is undefined; for others,
	// 'attr' is false.  Check for both.
	if (typeof attr !== typeof undefined && attr !== false) {
		return true;
	}
	else
	{
		return false;
	}
}

function isFillinAnswerChoice(answerElement)
{
//checks if the checkbox or radio button has fillin-abswer box
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	//alert($answer.child().attr(
	if ($answer.has('> ListItemResponseField').length>0)
		return true;
	else
		return false;	
}

function isFillinInput(answerElement)
{
	//checks if the input box is a fill-in answer input box
	alert($(answerElement).prev().type());
}

function isSDCAnswer(answerElement)
{
	//alert('isSDC');
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	var attr = $answer.attr('selectionDisablesChildren');

	// For some browsers, 'attr' is undefined; for others,
	// 'attr' is false.  Check for both.
	if (typeof attr !== typeof undefined && attr !== false) {
		return true;
	}
	else{
		return false;
	}		
}

function isNestedAnswer(answerElement)
{
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	if($answer.length==0)
		alert('Error in isNestedAnswer');
	var $parent = $answer.parentsUntil('Question').parent();
	if($parent.length==0)
		alert('Error in isNestedAnswer');
	
	if($parent.parent().get(0).nodeName=='ChildItems')
	{
		if($parent.parent().parent().get(0).nodeName=='ListItem')
			return true;
		else
			return false;
	}
	else
	{
		return false;
	}
}

function getAnswerSiblings(answerElement)
{
	//returns xml nodes
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	return $answer.siblings('ListItem');
}

function getNestedAnswers(answerElement)
{
	//return xml nodes
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	return $answer.children("ChildItems").children("Question").children("ListField").children("List").children("ListItem");
}


function getParentAnswerID(answerElement)
{
	//finds answer in xml and returns parentAnswerID
	var answerid = getAnswerID(answerElement);
	var sectionid = getSectionID(answerElement);
	var $answer = $xml.find('Section[ID="' + sectionid + '"]').find('ListItem[ID="' + answerid + '"]');
	if($answer.length==0)
	{
		alert('Error in getParentAnswerID: answerElement not found.answerid=' + answerid);
	}
	var $parent = $answer.parentsUntil('Question').parent();
	if($parent.length==0)
		alert('Error in getParentAnswerID: Question element not found.');
	if($parent.parent().get(0).nodeName=='ChildItems')
	{
		if($parent.parent().parent().get(0).nodeName=='ListItem')
		{
			return $parent.parent().parent().attr('ID');
		}
		else{
			//no parent answer
			return "";
		}
	}
	else
		alert('Error in getParentAnswerID');
}


function isAnswerSelected(answerElement)
{
	return $(answerElement).is(':checked');
}

function SelectAnswer(answerElement, section)
{
	$(answerElement).prop('checked',true);
	$(answerElement).parent().find('.AnswerTextBox').prop('disabled',false);
	
	//if there are any SDS answers they will need to be unchecked
	var $siblings = getAnswerSiblings(answerElement);
	$siblings.each(function() {
		var id = $(this).attr("ID");
		var testElement = getAnswerItemByID(id, section);
		if(isSDSAnswer($(answerElement)))  //if this answer element is SDS, unselect all siblings
		{
			UnSelectAnswer(testElement, section);
		}
		else if(isSDSAnswer(testElement))//if this sibling is SDS 
		{
		   UnSelectAnswer(testElement, section);
		}
		else if ($(answerElement).is(":radio"))  //if this is a single select make sure the siblings and their children are unselected
		{
			
			UnSelectAnswer(testElement, section);
		}
	}
	)
}

function UnSelectAnswer(answerElement, section)
{
	//unselects answerElement and its children recursively
	if(!$(answerElement).is(":checkbox, :radio")) return;
	
		$(answerElement).prop('checked',false);
		
	//unselect all child answers
	var $childanswers = getNestedAnswers(answerElement);
	
	$childanswers.each(function(){
		var childid = $(this).attr("ID");									
		var childelement = getAnswerItemByID(childid, section);
		UnSelectAnswer(childelement,section);
	})
}

function DisableAnswer(answerElement)
{
	$(answerElement).prop('disabled',true);
	//disble children
	$(answerElement).find('*').prop('disabled', true);
}

function EnableAnswer(answerElement)
{
	$(answerElement).prop('disabled',false);
}

function getSelectedListItems(listitems, section)
{
	var $selecteditems = [];
	listitems.each(function() {
		var $answeritem = getAnswerItemByID($(this).attr('ID'),section);
		if(($answeritem).is(':checked'))
			$selecteditems.push($answeritem);
	});
	return $selecteditems;
}

function UncheckChildAnswers(currentInput)
{
	var test;
	$(currentInput).find(':input:checked').prop('checked', false);
}

function UncheckSiblings(currentInput)
{

}
function getSelectedSiblings(currentInput)
{
	var count =0 ;
	var siblings = $(currentInput).parent().siblings();
	siblings.each(function() {
		if($(this).get(0).className=='Answer')
		{
			
			if ($(this).find(':input').is(':checked'))
				count++;
		}	
	});
	if($(currentInput).is(':checked'))
		count++;
	return count;
}

function SelectUnselectDescendents(parentQuestion, event)
{

}

function SelectUnselectChoiceOnBlur(choiceID, element)
{
	var $section = getAnswerSection(element);
	var $answeritem = getAnswerItemByID(choiceID, $section);
	return;
	
	if($(element).val()!='')
		SelectAnswer($answeritem, $section);
	else
		UnSelectAnswer($answeritem, $section);
}

function OnChoiceBlur(choiceID, element)
{
	var $section = getAnswerSection(element);
	//alert(choiceID);
	var $answeritem = getAnswerItemByID(choiceID, $section);
	var $input = $answeritem.parent().find('.AnswerTextBox');
	
	$input.removeClass('error');
	
	if(!$answeritem.is(':checked'))
	{
		if($input.val()!='')
		{
			//$answeritem.siblings('input').addClass('error');
			//$input.removeClass('error');
			//$input.addClass('error');
			//alert($input.val());
		}
		//$input.prop('disabled',true);
	}
}

//changing fill-in value calls this function
function SelectChoiceOnKeyPress(choiceID, element, event)
{
	//if control characters return
	var keycode = (event.keyCode ? event.keyCode : event.which);
	
	if(keycode==8) return;
	var $answeritem = $(element).parent().parent().find('input:radio, input:checkbox');
	$($answeritem).prop('checked',true);
	
	var $section = getAnswerSection($answeritem.get(0));
	var parentid = getParentAnswerID($answeritem.get(0));
	if(parentid==null || parentid=='')
		return;
		
	var parent = getAnswerItemByID(parentid, $section);
	
	SelectAnswer(parent, $section);	
}

function SelectUnselectParents(parentQuestion, element)
{
	/* parentQuestion: questionid of the answer clicked */
	if (!$(element).is(":checkbox, :radio"))  //only if the element is a radio or a checkbox
	{
		return;
	}
	var issingleselect = $(element).is(":radio");
	var answerid = getAnswerID(element);  //$(event.target).attr("name");
	//alert(answerid);
	var selecttype = $(element).attr('type');
	var $section = getAnswerSection(element);
	var $answeritem = getAnswerItemByID(answerid, $section);
	var selected = $answeritem.is(':checked');  //value is true or false
	var sectionId = getSectionID(element);
	
	var $siblings = getAnswerSiblings(element);
	var $childanswers = getNestedAnswers(element);
	
	var parentid = getParentAnswerID(element);
	
	var selectedsiblings = $(getSelectedListItems($siblings,$section)).length;
	
	/*
	SELECT/UNSELECT PARENT ANSWER
	if current item or one or more of its siblings are selected
	  select the parent answer
	*/
	if( selected || (selectedsiblings > 0))
	{
		//select parent answer
		
		if(parentid=="")
		{
			//alert('no parent answer');
		}
		else{
			var parent = getAnswerItemByID(parentid, $section);	
			
			//if parent is SDC, don't select it 
			if(!isSDCAnswer(parent))
			{	
				SelectAnswer(parent, $section);											
			}
		}									
	}
	else  //neither this answer nor any of its siblings are selected, unselect parent
	{
		//unselect parent answer
		UnSelectAnswer(getAnswerItemByID(parentid, $section),$section);
	}
	
	/*
	 UNSELECT all child answers if current answer is not selected
	*/
	
	if(selected==false){
		//unckeck all children
		
		$childanswers.each(function(){
			var childid = $(this).attr("ID");
			UnSelectAnswer(getAnswerItemByID(childid, $section),$section);
		})
	}
	
	//selection disables children
	if (isSDCAnswer(element) & selected)
	{
	   try{
			//go to the Answer level and disable all answer choices at first
			$(element).parent().parent().find('* [type=checkbox], [type=radio], [type=text]').prop('disabled', true);
			//uncheck all answers
			$(element).parent().parent().find('* [type=checkbox],[type=radio]').prop('checked', false);
			//enable just this answer
			EnableAnswer(element);  //EnableAnswer will enable checkbox/radio and fill-in box 
			//check just this answer
			SelectAnswer(element, $section);
	   }
	   catch(err)
	   {
			alert(err);
	   }
	}
	else 
	{
		//enable children								
		try{
			$(element).parent().parent().find('* [type=checkbox], [type=radio]').prop('disabled', false);	
	   }
	   
	   catch(err)
	   {
			alert(err);
	   }
	}
	
	//selection deselects siblings
	if(isSDSAnswer(element) & selected)
	{
		//unselect all siblings
		$siblings.each(function() {
	
			var id = $(this).attr("ID");
			UnSelectAnswer(getAnswerItemByID(id, $section), $section);  //unselect will disable fill-in also
		})
	}
	else if(!isSDSAnswer(element) & selected)
	{
		//all SDSAnswers must be unselected
		$siblings.each(function()
		{
			var id = $(this).attr("ID");
			var testElement = getAnswerItemByID(id, $section);
			
			if(isSDSAnswer(testElement))
			   UnSelectAnswer(testElement, $section);    //unselect will disable fill-in also
		})
	}
	
	//enable/disable fillin boxes
	if(selected & isFillinAnswerChoice(element))
	{
		//enable fillin box
		//var $input = $(element).parent().find('.AnswerTextBox');
		//$input.prop('disabled',false);
		
	}
	else if (!selected & isFillinAnswerChoice(element))
	{
		//disable fillin box
		//var $input = $(element).parent().find('.AnswerTextBox');
		//$input.prop('disabled',true);
	}
	
	if(selected & $(element).is(":radio"))
	{ 
		$siblings.each(function(){
			var sibling = $(this);
		
		UnSelectAnswer(sibling, $section);		
		});
	}
}


