<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mint="http://www.multi-access.de"
    version="1.0">
    <xsl:output method="text"  omit-xml-declaration="yes"/> 
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="mint:mapping">
        
        <xsl:text>
digraph Mapping {
#graph [ nodesep=0.8]
graph [rankdir=LR, nodesep=0.1,fontname=arial]
node [ fontname=Arial,  fontsize=14];
        </xsl:text>
       <xsl:apply-templates/>
        <xsl:apply-templates mode="connections"/>
        <xsl:text>
overlap=false
label="</xsl:text><xsl:value-of select="@name"/><xsl:text>"
fontsize=20;
labelloc=t
}
</xsl:text>
    </xsl:template>
    <xsl:template match="mint:operator">
<xsl:value-of select="@id"/><xsl:text> [
label = "S"
shape = "circle"
fixedsize=true
width=0.6
fontsize=24
style=bold
];</xsl:text>
     <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="mint:observation">
<xsl:value-of select="@id"/> [
label = "{<xsl:value-of select="@process"/> | <xsl:if test="@type['negation']">NOT </xsl:if><xsl:if test="@result"><xsl:value-of select="@result"/> = </xsl:if><xsl:if test="@name"><xsl:value-of select="@name"/>:</xsl:if><xsl:value-of select="@interactor"/>.<xsl:value-of select="@states"/>}"
        shape = "Mrecord"
        ];        
    </xsl:template>
    <xsl:template match="mint:event">
        <xsl:value-of select="@id"/><xsl:text> [
label = "</xsl:text><xsl:value-of select="@target"/>.<xsl:value-of select="@type"/>"
        shape = "box"
        ]; 
    </xsl:template>
    <xsl:template match="mint:backend">
        <xsl:value-of select="@id"/><xsl:text> [
label = "</xsl:text><xsl:value-of select="@class"/>.<xsl:value-of select="@call"/><xsl:if test="@parameter">(<xsl:value-of select="@parameter"/>)</xsl:if>"
        shape = "box"
        ]; 
    </xsl:template>
    <!-- mode connections -->
    <xsl:template match="mint:operator" mode="connections">
<xsl:variable name="opid" select="@id"/>
        <xsl:for-each select="mint:observations/mint:observation"> 
            <xsl:value-of select="@id"/><xsl:text>-></xsl:text><xsl:value-of select="$opid"/> [sametail="m003"];
</xsl:for-each>
        <xsl:for-each select="mint:actions/*"> 
<xsl:value-of select="$opid"/><xsl:text>-></xsl:text><xsl:value-of select="@id"/> [sametail="m001"];
</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>