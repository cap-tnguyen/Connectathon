<?xml version="1.0" encoding="UTF-8"?>
<!--xmlns:fo="http://www.w3.org/1999/XSL/Format"-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    >
    <xsl:output indent="yes"/>
    <xsl:template match="FormDesign">
        <Window>
            <xsl:attribute name="Title">
                <xsl:value-of select="Header/@title"/>
            </xsl:attribute>
            <xsl:attribute name="Height">350</xsl:attribute>
            <xsl:attribute name="Width">500</xsl:attribute>
            <xsl:apply-templates select="Body/ChildItems"/>    
        </Window>
        
    </xsl:template>
    <xsl:template match="ChildItems">
        <StackPanel>
            <xsl:apply-templates select = "Section"/>             
            
        </StackPanel>
    </xsl:template>
    <xsl:template match="Section">
        <StackPanel>            
            <xsl:apply-templates select="Question"/>
        </StackPanel>
    </xsl:template>
    <xsl:template match="Question">
        <TextBlock>
            <xsl:attribute name="Text">
                <xsl:value-of select="@title"/>
            </xsl:attribute>
            <xsl:attribute name="Height">20</xsl:attribute>
            <xsl:attribute name="Width">200</xsl:attribute>
            <xsl:attribute name="Margin">10</xsl:attribute>
        </TextBlock>
    </xsl:template>
</xsl:stylesheet>