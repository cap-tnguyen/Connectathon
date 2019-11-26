<?xml version="1.0" encoding="us-ascii"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:sr="http://www.cap.org/pert/2009/01/"
	xmlns:x="urn:ihe:qrph:sdc:2016">
	
  <xsl:output encoding="us-ascii" method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	
  <!--<xsl:variable name="form-action" select="document('sr-service.xml')/sr:sr-service"/>-->
	<xsl:variable name="show-toc" select="'false'"/>
	<!--<xsl:variable name="sct-code" select="document('sct-codes.xml')/sr:concept-descriptors"/>-->
	<!--<xsl:variable name="template-links" select="document('sr-toc.xml')/sr:template-toc"/>-->
	<xsl:variable name="debug" select="'false'"/>
	
	<xsl:template match="/">
		
		<xsl:variable name ="required" select="string(//Header/Property[@type='web_posting_date meta']/@val)"/>
        <html>
            <head>
			<!--<link rel="stylesheet" href="sdctemplate.css" type="text/css" />-->
            <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
			<!--<script type="text/javascript" src="sdc.js"></script>-->
            
			<style>
				Body 
				{
					font-family: Arial;
					font-size: 12px;
					width: 100%;
					margin-left: auto;
					margin-right: auto;
				}

				li
				{
					padding: 1px;
					color: blue;
					list-style-type: square;
				}

				p
				{
					margin-top:2px;
					margin-bottom:2px;
					padding:0px;
				}
				.BodyGroup
				{
					width: 900px;
					margin-left: auto;
					margin-right: auto;
					text-align: left;
				}

				.HeaderGroup
				{
					width: 99%;
					margin-top: 5px;
					margin-bottom: 5px;
					margin-left: auto;
					margin-right: auto;
					border: solid 1px #000080;
					padding: 5px;
					clear: both;
				}

				.HeaderGroupText
				{
					font-size: 12px;
					font-weight: bold;
					background-color: #FFFFFF;
					color: #000080;
					padding: 8px;
					vertical-align: bottom;
				}

				.HeaderInfoText
				{
					font-size: 12px;
					text-align: right;
					font-style: italic;    
				}

				.HeaderText
				{
					text-align: center;
					font-size: 18px;
					font-weight: bold;
					background-color: #FFFFFF;
					color: #000080;
					padding: 8px;
					vertical-align: bottom;
				}

				.TopHeader
				{
					text-align: center;
					font-size: 30px;
					font-weight: bold;
					background-color: #000080;
					color: #FFFFFF;
					padding: 2px;
				}

				.form-version
				{
					font-name:courier;
					font-size:9px;
					float:right;
				}

				.subSection
				{
					text-align: center;
					font-size: 20px;
					font-weight: bold;
					background-color: #000080;
					color: #FFFFFF;
					padding: 2px;
				}

				.thinBox
				{
					text-align: center;
					font-size: 14px;
					font-weight: bold;
					font-style:italic;
					background-color: #000080;
					color: #FFFFFF;
					padding: 2px;
				}


				.QuestionReset
				{
					float: right;
					padding-left: 2px;
					font-size: 10px;
					text-decoration: none;
					font-style: normal;
					color: Blue;
				}


				.QuestionInSection
				{
					float: left;
					width: 49%;
					padding: 2px;
				}

				.QuestionInQuestion
				{
					float: left;    
					padding: 2px;
				}

				.QuestionInListItem
				{
					padding: 2px;
					padding-left: 20px;
				}



				.QuestionTitle
				{
					padding: 2px;
					background-color: #add8e6;
					font-size: 13px;
					font-style: italic;
					font-weight: bold;
					clear: both;
				}

				.Answer
				{
					float: left;
					padding-top: 2px;
					width: 93%;
				}

				.DisplayProperty
				{
					float: left;
					padding-top: 2px;
					width: 22%;
				}

				.DisplayProperty1
				{
					float: left;
					padding-top: 2px;
					padding-left: 5px;
				}

				.AnswerTextBox
				{
					height: 11px;
					font-size: 10px;
					padding-left: 2px;
					margin-left: 4px;
				}

				.NoteText
				{
					padding: 2px;
					font-weight: bold;
					color: Blue;
					clear: both;
				}

				.TextBox
				{
					padding: 2px;
					width: 98%;
					height: 15px;
				}

				.SubmitButton
				{
					padding: 2px;
					text-align: center;
				}

				.MessageDataResult
				{
					padding-bottom: 20px;
					padding-top: 20px;
					clear: both;
					padding-left: 10px;
					padding-right: 10px;
				}

				.MessageDataQuestion
				{
					padding-left: 20px;
					color: blue;
					font-style: italic;
				}

				.MessageDataAnswer
				{
					padding-left: 20px;
					color: green;
					font-style: normal;
					font-weight: bold;
				}

				.MessageDataChecklist
				{
					font-weight: bold;
					color: red;
				}


				.header_text
				{
					border-bottom:1px solid black;padding-bottom:0px;text-align:left;
				}

				.title
				{
					text-align: center;
					font-size: 18px;
					font-weight: bold;
					font-style:italic;
					background-color: #FFFFFF;
					color: #000080;
					padding: 8px;
					vertical-align: bottom;

				}

				#S1
				{
					font-size: 18px;
					font-weight: bold;
					background-color: #FFFFFF;
					color: #000080;
					padding: 8px;
					vertical-align: bottom;
				}
				.right.noBreak{float: right}
				.right{float: right;clear:both}
				.float-right{float: right;}
				.Header_left
				{
					color:purple;
					text-align: left;
					font-size: 18px;
					font-weight: bold;
					
				}
				.left
				{
					text-align:left;clear:both;
				}
				.copyright
				{
					font-style:italic;
					float:left;
				}
				
				.section_wthin_list
				{
					margin-left:20px;
					
				}
			</style>
			
				<script type="text/javascript">
				
					<xsl:text disable-output-escaping="yes" >
						<![CDATA[
							var xmlDoc;
							var repeatIndex = 0;   //used to generate unique ids, names in repeated elements
							$(document).ready(function () {

								jQuery.support.cors = true;  //not sure if needed because cors setting is on the server
								
								
								
								var endpoints;
								var successIndex = 0;
								
								
								/*
									save original xml in jquery variable  
									server or xslt puts original xml in #rawxml, issue with xslt putting in xml is copy-of function decodes special characters, thus 
									making xml invalid
								*/
								var xmlstring = $("#rawxml").val();   

								//remove declaration part if exists
								//xmlstring = xmlstring.substring(xmlstring.indexOf("<FormDesign"));
								//$("#rawxml").val(xmlstring);
								
								//load into xml dom
								try{
									xmlDoc = $.parseXML(xmlstring);
									$xml = $(xmlDoc);

									//allow submit
									if($("#allowsubmit").val()=='no')
									{
										$("#send").css("display","none");
										$("#btnAdd").css("display","none");
									}
									
									

								}
								catch(err){
									alert(err.message);
								}

							});


							function sayHello(name) {
								alert("sayHello function in javascripts says - hello, " + name);
								return window.external.ShowMessage("If you can see this message sayHello successfully called ShowMessage function in this desktop client app.");


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
								
								try{
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
								
								if(countRepeats(parentTable,currentSectionId.split("..")[0])==max)
								{
									alert("max repeat = " + max + " reached ");
									return;
								}
								
								var newtable = table.cloneNode(true);    							
								
								//newtable.id = currentSectionId.split(":")[0] + ":" + blockGuid;   //each repeated section id has the same ID from xml + blockGuid							
								newtable.id = currentSectionId.split("..")[0] + ".." + repeatIndex
															
								//set new ids to each nested table 
								var newtableitems = newtable.getElementsByTagName('*');										
								for(i=0; i< newtableitems.length; i++)			
									if(newtableitems[i].tagName=="TABLE")
										//newtableitems[i].id = newtableitems[i].id.split(":")[0] + ":" + blockGuid;
										newtableitems[i].id = newtableitems[i].id.split("..")[0] + ".." + repeatIndex;
							
								var trace = 0;
								var newname;
								var i;
								
								var ID;

								//add the new repeat
								try {
									
									/*find section in xml corresponding to this block (ID=currentSectionId.substring(1)) and clone it, then assign new ID*/
									
									var $sectionCurrent = $xml.find('Section[ID="' + currentSectionId.substring(1) + '"]:first');  //first is redundant since there is only one section with this ID
									if($sectionCurrent.length==0)
									{
										alert("Section ID = " + currentSectionId.substring(1) + " not found");
										return;
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
													
													
												    if(newtableitems[k].type=="hidden")   //question will have Q as the first letter
													{  
														
													   //find question in xml fragment and change ID
													   
													   $question = $sectionNew.find('Question[ID="' + oldtableitems[i].name.substring(1) + '"]');
													   
													   if($question.length==0)
													   {
															alert("Qusetion ID = " + oldtableitems[i].name.substring(1) + " not found.");
															$sectionNew.find('Question').each(function(index){
																alert($(this).attr("ID"));
															})
															return;
													    }
														else{
															
															//$question.attr("ID", newtableitems[k].name.split(":")[0].substring(1) + ':' + blockGuid); 
															$question.attr("ID", newtableitems[k].name.split("..")[0].substring(1) + '..' + repeatIndex); 
															
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
													else {                   //answers do not have Q											
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
										alert("error adding section repeat");
										return;
									}
										
										
									//remove all nested repeats
									newtable = removeNestedTableRepeats(newtable);
								
									//update rawxml for view							
									$('#rawxml').val(xmlToString(xmlDoc));												
									
									repeat = countRepeats(parentTable, currentSectionId.split("..")[0])																	
									
									showHideButtons(newtable);	
									
									//make sure + is visible on the first repeat of nested section
									nestedtables = getChildTables(newtable);
									
									
									for(i=0;i<nestedtables.length;i++)
									{
										elements = nestedtables[i].getElementsByTagName('*');	
										for(j=0;j<elements.length;j++)
										{
											if(elements[j].id=="btnAdd")
												elements[j].style.visibility="visible";
										}
									}
										
									
								}
								catch (err) {
									alert(err.message + "\n" + trace + "\n" + newname + "n" + i);
								}

							}


							function generateShortUid() {
    								return ("0000" + (Math.random()*Math.pow(36,4) << 0).toString(36)).slice(-4)
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


							/*
							Counts the number of repeats of a block (table)
							Each repeated block (table) has id that has two parts
							1. id that is the same for each repeat.
							2. a guid that is different for each repeat 
							*/
							function countRepeats(parentT, sectionid) {
								
								
								var tables = parentT.getElementsByTagName('TABLE');
								var count = 0;
								for(i=0; i<tables.length; i++)
								{
								   checkid = tables[i].id.split("..")[0];
								   if(checkid == sectionid) count++;
								}
							   
								return count;

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
												
												
												if($j.length==0)
													alert("removeNestedTableRepeats - not found: " + v.substring(1));
												
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
								
								var parentTable =  getParentTable(table)
								
								//show/hide buttons
								
								//get all siblings of this table
								var siblings = getSiblingTables(parentTable);
								
								//get max repeat for this table - get parent which is DIV and the firstChild of DIV is maxcount
								var max = table.parentElement.firstChild.value;  
								
								//how many repeats are there for this table currently
								var repeat = countRepeats(parentTable, table.id.split("..")[0]);
								
								
								var inputs = "";
								if(siblings.length==0)
								{
									alert("error in getting siblings");
									return;
								}
								
						
								
								if(repeat<max)   //
								{
									
									for (k=0;k<siblings.length; k++)
									{										
										if(siblings[k].id.split("..")[0]==table.id.split("..")[0])
										{	
											inputs = siblings[k].getElementsByTagName('*');
									
											for(m=0;m<inputs.length;m++)
											{
												if(inputs[m].id=="btnAdd")
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
												if(inputs[m].id=="btnAdd")
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
														
							function removeSection(obj) {
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
									alert("Could not find section with ID = " + table.id.substring(1) + " to delete");
									return;
								}
								
								$todelete.remove();
								
								$todelete = $xml.find('Section[ID="' + table.id.substring(1) + '"]');
								if($todelete.length!=0)
								{
									alert("Could not delete Section ID = " + table.id.substring(1));									
								}
								
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

							function xmlToString(xmlData) {

								var xmlString;
								
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
							function openMessageData() {

								var sb = "";
								var answer = "";
								var elem = document.getElementById("checklist").elements;
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
								//alert(sb);

								document.getElementById('MessageDataResult').innerHTML = sb;
								document.getElementById('MessageData').style.display = 'block';
								document.getElementById('FormData').style.display = 'none';
								
								
								//update Xml with answers
								updateXml();
								
								

								//var test = xmlToString(xmlDoc);
								//document.getElementById('rawxml').innerText = test;

								//Ajax call to web service
								CallTestService1(xmlToString(xmlDoc));
								
							}

							function closeMessageData() {
								document.getElementById('MessageData').style.display = 'none';
								document.getElementById('response').style.display = 'none';
								document.getElementById('FormData').style.display = 'block';
							}

							function GetAnswer(qCkey) {
								
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

							//soap 1.2
							function CallTestService2(data) {

							
								var webServiceURL = "http://www.sharedapps.net/SDCReceiver/service1.asmx";
								webServiceURL = $("#submiturl").val();  // prompt("Enter endpoint:", webServiceURL);
								
								var ns = $("#submitnamespace").val();
								
								$.support.cors = true;
								var xmldata = encodeURIComponent(data);
								
								var soapRequest =
													'<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"' + 
													' xmlns:urn="' + ns + '/">'  + 
													'<soap:Header/>' +
														' <soap:Body>' +
																' <urn:SubmitFormRequest>' +
																 data +
																'</urn:SubmitFormRequest>' +
														' </soap:Body>' +
													' </soap:Envelope>';

								//alert(soapRequest);
								$("#submitsoap").val(soapRequest);

								soapAction = $("#submitaction").val();  // "SubmitFormRequest";
								//soapAction = ns + "/SubmitFormRequest";
								
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
							

							//soap 1.1
							function CallTestService1(data) {
								

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
									error: OnError
								});
								
								}
								

								

								return false;
								
							}

							/*
							function CallTestService(data) {
								var webServiceURL = "%receiver%";
								webServiceURL = prompt("Enter endpoint:", webServiceURL);
								var ns = $('#submitnamespace').val();

								$.support.cors = true;
								var xmldata = encodeURIComponent(data);
								
								var soapRequest =
												'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" + xmlns:tem="http://tempuri.org/">' + 
												 '  <soapenv:Header/>' +
												  ' <soapenv:Body>' + 
													 ' <tem:SubmitFormRequest>' + data + '</tem:SubmitFormRequest>' +
												  ' </soapenv:Body>' + 
												' </soapenv:Envelope>'

								
								soapAction = ns + "//SubmitFormRequest";    //"http://tempuri.org/SubmitFormRequest";
								
								
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
							*/

							function OnSuccess(data, url) {
								
								var xmlstring = xmlToString(data);
							    //add breaks
								
							    xmlstring = xmlstring.replace(/</g,'&lt;');
							    xmlstring = xmlstring.replace(/>/g,'&gt;');
							    xmlstring = xmlstring.replace(/\n/g,'<br/>');
							    

								if (document.getElementById("response") != null) {       
									
									$("#response").append("Received Response from " + url  + " - <PRE>" + xmlstring + '</PRE>');
									$("#response").css("background-color", "yellow");
									$("#response").css("display", "block");
									
									
								}
								
								
							}

							function OnError(xhr, textStatus, err) {
								var xmlstring = xhr.responseText;
								alert("Error:" + xmlstring);
							    //add breaks

							    
								if (document.getElementById("response") != null) {       
									$("#response").html("Receiver Response - " + xmlstring + '');
									$("#response").css("background-color", "white");
									$("#response").css("color", "red");
									$("#response").css("display", "block");
								}
								//alert('Status:' + xhr.status + ', Text:' + textStatus + ', Error: ' + err);
							}


						]]>
					</xsl:text>
					
				</script>
				
			
			 
            </head>
            <body align="left">
            	<!--
				<xsl:if test="$show-toc='true' and count($template-links/template-link) &gt; 0">
					<div style="width:250px;height:600px;float:left;margin:10px;padding-left:10px;padding-right:20px">
						<xsl:apply-templates select="$template-links"/>
						<br/>
						<p/>
					</div>
				</xsl:if>-->
            	<!--hidden textbox to store rawxml at run time-->
            	<!--<input type="hidden" id = "rawxml"/>-->
            	<!--<textarea rows="10" style="width:90%;margin:40px;background-color:lightyellow" id = 'rawxml'> 
		               <xsl:copy-of select="node()"/>
		               
         		</textarea>	-->
				<div class="BodyGroup">
					<!--
					<xsl:if test="$show-toc='true' and count($template-links/template-link) &gt; 0">
						<xsl:attribute name="style">
							<xsl:text>float:left</xsl:text>
						</xsl:attribute>
					</xsl:if>
					-->
					<div id="MessageData" style="display:none;">
						<table class="HeaderGroup" align="center">
							<tr>
								<td>
									<div class="TopHeader">
										Structured Report Data
									</div>
									<div id="MessageDataResult" class="MessageDataResult"/>
									
									
									<div class="SubmitButton">
										<input type="button" value="Back" onClick="javascript:closeMessageData()" />
									</div>
								</td>
							</tr>
						</table>
					</div>
					
					<div id="response" style="display:none;">
					</div>
					
					<div id="FormData">
						<form id="checklist" name="checklist" method="post" >
							<xsl:attribute name="action">
								<!--<xsl:value-of select="$form-action"/>-->
							</xsl:attribute>
							
							<!--formInstanceURI, formInstanceVersionURI, formPreviousInstanceVersionURI-->
							<div class="form-version">								
								<xsl:if test="//x:FormDesign/@formInstanceURI">
									<p>
										Form Instance: 
										<xsl:value-of select="//x:FormDesign/@formInstanceURI"/>
									</p>
								</xsl:if>
								<xsl:if test="//x:FormDesign/@formInstanceVersionURI">
									<p>
										Version: 
										<xsl:value-of select="//x:FormDesign/@formInstanceVersionURI"/>
									</p>
								</xsl:if>
								<xsl:if test="//x:FormDesign/@formPreviousInstanceVersionURI">
									<p>
										Previous Version: 
										<xsl:value-of select="//x:FormDesign/@formPreviousInstanceVersionURI"/>
									</p>
								</xsl:if>
							</div>

							<!--show header-->
							<xsl:variable name="title_style" select="//x:Header/@styleClass"/>
							<xsl:variable name='title_id' select="//x:Header/@ID"/>
							<div ID = '{$title_id}' class="Header_{$title_style}">								
								<xsl:value-of select="//x:Header/@title"/>
							</div>
							<div style="clear:both"/>
							<hr/>
							
							<div>
							<xsl:for-each select="//x:Header/x:Property">
								<xsl:variable name="textstyle" select="@styleClass"/>
								<p class='{$textstyle}'>
									<b><xsl:value-of select="@propName"/></b>
									<xsl:if test="@propName">
										:
									</xsl:if>
									<xsl:value-of select="@val"/>
								</p>
								<!--
									
									<xsl:choose>
										<xsl:when test="@type='AJCC_UICC_Version meta'">
											AJCC UICC Version:
										</xsl:when>
										<xsl:when test="@type='CS'">
											CS Version:
										</xsl:when>
										<xsl:when test="@type='web_posting_date meta'">
											Protocol web posting date:
										</xsl:when>
									</xsl:choose>
									
									<xsl:if test="@type!='approval-status meta'">
										<xsl:value-of select="@val"/>
									</xsl:if>
									-->
								<!--<div style="clear:both"/>-->
								
							</xsl:for-each>
								
							</div>
							
							<div style="clear:both"></div>
							<!--Demo-->		
							<a style="text-decoration:none;color:black;font-weight:bold;font-size:large" id="demshowhide" href="#" onclick="ShowHideDemo()">+ Demographics</a>
							<div id="divdemo" style="display:none">								
								<xsl:apply-templates select="//x:DemogFormDesign/x:Body/x:ChildItems/x:Section" >
									<xsl:with-param name="required" select="$required" />
									<xsl:with-param name="parentId" select="'*'"/>  
								</xsl:apply-templates>
								<xsl:apply-templates select="//x:DemogFormDesign/x:Body/x:ChildItems/x:Question" mode="level2" >
									<xsl:with-param name="required" select="$required" />
									<xsl:with-param name="parentId" select="'*'"/>   
								</xsl:apply-templates>
							</div>
							
							<!--show body-->
							<xsl:apply-templates select="//x:FormDesign/x:Body/x:ChildItems/x:Section" >
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/> <!--parentId = * for outermost --> 
							</xsl:apply-templates>
							<xsl:apply-templates select="//x:FormDesign/x:Body/x:ChildItems/x:Question" mode="level2" >
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/>  <!--parentId = * for outermost --> 
							</xsl:apply-templates>
							
							<!--<xsl:if test="contains($form-action, 'http') or contains($form-action, 'javascript')">-->
								<!--remove submit button for the desktop verion-->
								
								<div class="SubmitButton">
									<input type="submit" id="send" value="Submit" onclick="javascript:openMessageData();return false;"/>
								</div>
							<!--</xsl:if>-->
						</form>
					</div>
				</div>
            </body>
        </html>
    </xsl:template>
   
    <xsl:template match="//x:Header">
       
       
    </xsl:template>
	
	<xsl:template match="x:Section">
		<xsl:param name="parentSectionId"/>		
		<xsl:if test="not (@visible) or (@visible='true')">
			<xsl:variable name="required" select="true"/>
			<xsl:variable name="style" select="@styleClass"/>
			<xsl:variable name="defaultStyle" select="'TopHeader'"/>
			<xsl:variable name="sectionId" select="concat('s',@ID)"/>
			<div> 
			        <xsl:attribute name="id">
					<xsl:value-of select="$sectionId"/>
					
				</xsl:attribute>
				<input id = "maxcardinality" type="hidden">
					<xsl:attribute name="value">
						<xsl:value-of select="@maxCard"/>
					</xsl:attribute>
					
				</input>
				
				<!-- table is repeated if cardinality is greater than 1 and id value will be incremented-->
				<table class="HeaderGroup" align="center">
				   
				   <xsl:attribute name="id">
				   	<!--<xsl:value-of select="1"/>-->
				   	<xsl:value-of select="$sectionId"/>
				   </xsl:attribute>
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="$style!=''">
									<div class="{$style}">										
										<xsl:value-of select="@title"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="{$defaultStyle}">
										<xsl:value-of select="@title"/>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="$required='false'">

								</xsl:when>
								<xsl:otherwise>	
									<xsl:apply-templates select="x:ChildItems/x:Question" mode="level1" >
										<xsl:with-param name="required" select="'true'"/>
										<xsl:with-param name="parentSectionId" select="$sectionId"/>
									</xsl:apply-templates>

									<xsl:apply-templates select="x:ChildItems/x:Section" >
										<xsl:with-param name="required" select="'true'"/>
										<xsl:with-param name="parenSectiontId" select="$sectionId"/>
									</xsl:apply-templates>

								</xsl:otherwise>
							</xsl:choose>
							<div style="clear:both"/>
							<xsl:if test="@maxCard&gt;1">
								<input type="button" id="btnAdd" onclick="addSection(this)" value="+"/>
								<input type="button" id ="btnRemove" onclick="removeSection(this)" value="-">
									<xsl:attribute name = "style">
										<xsl:value-of select="'visibility:hidden;'"/>
									</xsl:attribute>
								</input>
							</xsl:if>
						</td>
					</tr>
				</table>
			</div>
		
		</xsl:if>
	</xsl:template>
	
	<!--section within a list item -->
	<xsl:template match="x:Section" mode="level2">
		<xsl:param name="parentSectionId"/>		
		<xsl:if test="not (@visible) or (@visible='true')">
			<xsl:variable name="required" select="true"/>
			<xsl:variable name="style" select="@styleClass"/>
			<xsl:variable name="defaultStyle" select="'TopHeader'"/>
			<xsl:variable name="sectionId" select="concat('s',@ID)"/>
			<div class="section_wthin_list"> 
				<xsl:attribute name="id">
					<xsl:value-of select="$sectionId"/>
					
				</xsl:attribute>
				<input id = "maxcardinality" type="hidden">
					<xsl:attribute name="value">
						<xsl:value-of select="@maxCard"/>
					</xsl:attribute>
					
				</input>
				
				<!-- table is repeated if cardinality is greater than 1 and id value will be incremented-->
				<table class="HeaderGroup" align="center">
					
					<xsl:attribute name="id">
						<!--<xsl:value-of select="1"/>-->
						<xsl:value-of select="$sectionId"/>
					</xsl:attribute>
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="$style!=''">
									<div class="{$style}">										
										<xsl:value-of select="@title"/>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="{$defaultStyle}">
										<xsl:value-of select="@title"/>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="$required='false'">
									
								</xsl:when>
								<xsl:otherwise>	
									<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2" >
										<xsl:with-param name="required" select="'true'"/>
										<xsl:with-param name="parentSectionId" select="$sectionId"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates select="x:ChildItems/x:Section" mode="level2" >
										<xsl:with-param name="required" select="'true'"/>
										<xsl:with-param name="parenSectiontId" select="$sectionId"/>
									</xsl:apply-templates>
									
								</xsl:otherwise>
							</xsl:choose>
							<div style="clear:both"/>
							<xsl:if test="@maxCard&gt;1">
								<input type="button" id="btnAdd" onclick="addSection(this)" value="+"/>
								<input type="button" id ="btnRemove" onclick="removeSection(this)" value="-">
									<xsl:attribute name = "style">
										<xsl:value-of select="'visibility:hidden;'"/>
									</xsl:attribute>
								</input>
							</xsl:if>
						</td>
					</tr>
				</table>
			</div>
			
		</xsl:if>
	</xsl:template>
	
	<!--question in section-->
	<xsl:template match="x:Question" mode="level1">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>		            
    		<input type="hidden" class="TextBox">
				<xsl:attribute name="name">
					<xsl:value-of select="$questionId"/>
				</xsl:attribute>				
				<xsl:attribute name="value">
					<xsl:value-of select="@title"/>
				</xsl:attribute>
    		</input>
    
		<div class="QuestionInSection">   <!--two columns-->
			<div class="QuestionTitle">
				<xsl:value-of select="@title"/> 
				<xsl:if test="x:ResponseField"> 
					<input type="text" class="TextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ResponseField/x:Response//@val"/>
							<!--<xsl:value-of select="substring($expandedId,2)"/>-->
						</xsl:attribute>
					</input>
				</xsl:if>
			</div>
			
			<div style="clear:both;"/>
			
			<xsl:if test="x:ListField">
			  <xsl:apply-templates select="x:ListField" mode="level1">
				  <xsl:with-param name="questionId" select="$questionId" />
				  <xsl:with-param name="parentSectionId" select="$parentSectionId" />
			  </xsl:apply-templates>
			</xsl:if>
			
			<!--11/13/2016: question within question-->
			<div style="clear:both;"/>
			<xsl:if test="x:ChildItems/x:Question">				
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
			</div>
		
	</xsl:template>

	
	<!--question in list item-->
<xsl:template match="x:Question" mode="level2">
	<xsl:param name="parentSectionId"/>
	<xsl:variable name="questionId" select="concat('q',@ID)"/>

    <input type="hidden" class="TextBox">
      <xsl:attribute name="name">
        <xsl:value-of select="$questionId"/>
      </xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="@title"/>
      </xsl:attribute>
    </input>
    
	<div class="QuestionInListItem"> 	  
		<xsl:choose>
			<!--not showing the hidden question-->
			<xsl:when test="string-length(@title)&gt;0">
				<div class="QuestionTitle">
					<xsl:value-of select="@title"/> 
					<xsl:if test="x:ResponseField">
						<input type="text" class="TextBox">
							<xsl:attribute name="name">
								<xsl:value-of select="substring($questionId,2)"/> <!--drop q-->
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="x:ResponseField/x:Response//@val"/>
							</xsl:attribute>
						</input>
					</xsl:if>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="x:ResponseField">
					<input type="text" class="TextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ResponseField/x:Response//@val"/>
						</xsl:attribute>
					</input>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		<div style="clear:both;"/>
		<xsl:if test="x:ListField">
    		<xsl:apply-templates select="x:ListField" mode="level1">
				<xsl:with-param name="questionId" select="$questionId" />
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
        	</xsl:apply-templates>
		</xsl:if>
		<!--11/13/2016: question within question-->
		<!--<xsl:if test="ChildItems/Question">
			
			<xsl:apply-templates select="ChildItems/Question" mode="level2">
				<xsl:with-param name="parentSectionId" select="$parentSectionId" />
			</xsl:apply-templates>
		</xsl:if>-->
		
	</div>

</xsl:template>

	<!--question in question-->
	<xsl:template match="x:Question" mode="level3">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID)"/>		            
		<input type="hidden" class="TextBox">
			<xsl:attribute name="name">
				<xsl:value-of select="$questionId"/>
			</xsl:attribute>				
			<xsl:attribute name="value">
				<xsl:value-of select="@title"/>
			</xsl:attribute>
		</input>
		
		<div class="QuestionInQuestion">   
			<div class="QuestionTitle">
				<xsl:value-of select="@title"/>  
				<xsl:if test="x:ResponseField"> 
					<input type="text" class="TextBox">
						<xsl:attribute name="name">
							<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="x:ResponseField/x:Response//@val"/>
							<!--<xsl:value-of select="substring($expandedId,2)"/>-->
						</xsl:attribute>
					</input>
				</xsl:if>
			</div>
			
			<div style="clear:both;"/>
			
			<xsl:if test="x:ListField">
				<xsl:apply-templates select="x:ListField" mode="level1">
					<xsl:with-param name="questionId" select="$questionId" />
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
			<!--11/13/2016: question within question-->
			<div style="clear:both;"/>
			<xsl:if test="x:ChildItems/x:Question">				
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level3">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:if>
			
		</div>
		
	</xsl:template>

<xsl:template match="x:ListField" mode="level1">
   <xsl:param name="questionId" />
   <xsl:param name="parentSectionId" />  
	<xsl:choose>
		<!--single select-->
		<xsl:when test="@maxSelections='1' or not (@maxSelections)" >
			<xsl:for-each select="x:List/x:ListItem">
				<div class="Answer">
					<input type="radio" style="float:left">
						<xsl:attribute name="name">
              				<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:if test="@selected='true'">
							<xsl:attribute name="checked">
							</xsl:attribute>
						</xsl:if>
						
						<xsl:attribute name="value">
							<xsl:value-of select="@ID"/>,<xsl:value-of select="@title"/>
						</xsl:attribute>
					</input> 
					<xsl:value-of select="@title"/>
					<!--answer fillin-->
					<xsl:if test="x:ListItemResponseField">
						<input type="text" class="AnswerTextBox">
							<xsl:attribute name="width">
								<xsl:value-of select="100"/>
							</xsl:attribute>
							<xsl:attribute name="name">
								<xsl:value-of select="substring($questionId,2)"/>
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="x:ListItemResponseField/x:Response//@val"/>
							</xsl:attribute>
						</input>
					</xsl:if>
				</div>

				<!--property-->
				<xsl:if test="x:Property">
					<div class="property">
						<xsl:value-of select="@name"/>
						<xsl:value-of select="@type"/>
						<xsl:value-of select="@val"/>
					</div>
				</xsl:if>
				
				<!--SRB: 12/18/2016 - handle section within listitem -->
				<xsl:apply-templates select="x:ChildItems/x:Section" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
				<!--question within list-->
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>	
			</xsl:for-each>
			
		</xsl:when>
	
		<!--multi select-->
		<xsl:otherwise>

			<xsl:for-each select="x:List/x:ListItem">
				<div class="Answer">
					<input type="checkbox" style="float:left;">
						<xsl:attribute name="name">
              				<xsl:value-of select="substring($questionId,2)"/>
						</xsl:attribute>
						<xsl:attribute name="value">
							<xsl:value-of select="@ID"/>,<xsl:value-of select="@title"/>
						</xsl:attribute>
						<xsl:if test="@selected='true'">
							<xsl:attribute name="checked">
							</xsl:attribute>
						</xsl:if>
					</input>
					<xsl:value-of select="@title"/>
					
					<xsl:if test="x:ListItemResponseField">
						<input type="text" class="AnswerTextBox">
						    <xsl:attribute name="name">
								<xsl:value-of select="substring($questionId,2)"/>
						    </xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="x:ListItemResponseField/x:Response//@val"/>
							</xsl:attribute>
						</input>
					</xsl:if>
				</div>
				<!--SRB: 12/18/2016 - handle section within listitem -->
				<xsl:apply-templates select="x:ChildItems/x:Section" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
				<!--question within list-->
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:for-each>

			
		</xsl:otherwise>
		
	</xsl:choose>

</xsl:template>

</xsl:stylesheet>