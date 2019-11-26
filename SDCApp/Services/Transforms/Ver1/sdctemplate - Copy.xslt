<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:sr="http://www.cap.org/pert/2009/01/"
	xmlns:x="http://healthIT.gov/sdc">
	
  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	
  <xsl:variable name="form-action" select="document('sr-service.xml')/sr:sr-service"/>
	<xsl:variable name="show-toc" select="'false'"/>
	<xsl:variable name="sct-code" select="document('sct-codes.xml')/sr:concept-descriptors"/>
	<xsl:variable name="template-links" select="document('sr-toc.xml')/sr:template-toc"/>
	<xsl:variable name="debug" select="'false'"/>
	
	<xsl:template match="/">
		
		<xsl:variable name ="required" select="string(//Header/OtherText[@type='web_posting_date meta']/@val)"/>
        <html>
            <head>
            <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
			<script type="text/javascript" src="sdc.js"></script>
            
			 <link rel="stylesheet" href="sdctemplate.css" type="text/css" />
            </head>
            <body align="left">
				<xsl:if test="$show-toc='true' and count($template-links/template-link) &gt; 0">
					<div style="width:250px;height:600px;float:left;margin:10px;padding-left:10px;padding-right:20px">
						<xsl:apply-templates select="$template-links"/>
						<br/>
						<p/>
					</div>
				</xsl:if>
            	<!--hidden textbox to store rawxml at run time-->
            	<!--<input type="hidden" id = "rawxml"/>-->
            	<!--<textarea style="width:90%;margin:40px;background-color:lightyellow" id = 'rawxml'> 
		               <xsl:copy-of select="node()"/>
         		</textarea>	-->
				<div class="BodyGroup">
					<xsl:if test="$show-toc='true' and count($template-links/template-link) &gt; 0">
						<xsl:attribute name="style">
							<xsl:text>float:left</xsl:text>
						</xsl:attribute>
					</xsl:if>
					
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
					
					<div id="FormData">
						<form id="checklist" name="checklist" method="post" >
							<xsl:attribute name="action">
								<xsl:value-of select="$form-action"/>
							</xsl:attribute>
							
							<!--show header-->
							<xsl:variable name="title_style" select="//x:Header/@styleClass"/>
							<xsl:variable name='title_id' select="//x:Header/@ID"/>
							<div ID = '{$title_id}' class="{$title_style}">
								<xsl:value-of select="//x:Header/@title"/>
							</div>
							
							
							<xsl:for-each select="//x:Header/x:OtherText">
								<xsl:variable name="textstyle" select="@styleClass"/>
								
								<div class='{$textstyle}'>
									<!--meta data specific labels-->
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
									<!--do not show approval status as it is repeated-->
									<xsl:if test="@type!='approval-status meta'">
										<xsl:value-of select="@val"/>
									</xsl:if>
									
								</div>
								<div style="clear:both"/>
							</xsl:for-each>
							
							
							<!--show body-->
							<xsl:apply-templates select="//x:Body/x:ChildItems/x:Section" >
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/> <!--parentId = * for outermost --> 
							</xsl:apply-templates>
							<xsl:apply-templates select="//x:Body/x:ChildItems/x:Question" mode="level2" >
								<xsl:with-param name="required" select="$required" />
								<xsl:with-param name="parentId" select="'*'"/>  <!--parentId = * for outermost --> 
							</xsl:apply-templates>
							
							<xsl:if test="contains($form-action, 'http') or contains($form-action, 'javascript')">
								<!--remove submit button for the desktop verion-->
								
								<div class="SubmitButton">
									<input type="submit" value="Submit"/>
								</div>
							</xsl:if>
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
					<xsl:value-of select="concat($sectionId,':',parentSectionId,':','1')"/>
					
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
				   	<xsl:value-of select="concat($sectionId,':',parentSectionId,':','1')"/>
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
	
	<!--question in section-->
	<xsl:template match="x:Question" mode="level1">
		<xsl:param name="parentSectionId"/>
		<xsl:variable name="questionId" select="concat('q',@ID,':',$parentSectionId)"/>		            
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
			</div>
		
	</xsl:template>

	
	<!--question in list item-->
<xsl:template match="x:Question" mode="level2">
	<xsl:param name="parentSectionId"/>
	<xsl:variable name="questionId" select="concat('q',@ID,':',$parentSectionId)"/>

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
	</div>

</xsl:template>


<xsl:template match="x:ListField" mode="level1">
   <xsl:param name="questionId" />
   <xsl:param name="parentSectionId" />  
	<xsl:choose>
		<!--multiselect-->
		<xsl:when test="@multiSelect='true'">
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
				<!--question within list-->
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:when>
	
		<!--single select-->
		<xsl:otherwise>
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
				<!--question within list-->
				<xsl:apply-templates select="x:ChildItems/x:Question" mode="level2">
					<xsl:with-param name="parentSectionId" select="$parentSectionId" />
				</xsl:apply-templates>	
			</xsl:for-each>
		</xsl:otherwise>
		
	</xsl:choose>

</xsl:template>

</xsl:stylesheet>