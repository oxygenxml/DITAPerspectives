<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Copyright 2001-2022 Syncro Soft SRL. All rights reserved.
    This is licensed under MPL 2.0. 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:oxy="http://www.oxygenxml.com/oxy"
    exclude-result-prefixes="xs rng a oxy"
    version="3.0">

    <xsl:output method="text"/>
    <xsl:template match="/">
    	<xsl:variable name="root" select="/"/>
    	<xsl:variable name="modules" select="distinct-values(//element/@module)"/>
    	<xsl:variable name="parentModules" select="distinct-values(//element[@module = $modules]/@parentModule)"/>
    	<xsl:variable name="allModules" select="distinct-values(($parentModules, $modules))"/>
    	<xsl:text>// </xsl:text>
    	<xsl:value-of select="$allModules"/>
    	<xsl:text>&#10;</xsl:text>
    	<xsl:text>strict digraph {</xsl:text>
			<!-- Nodes   		-->
    	<xsl:for-each select="$allModules">
    		<xsl:text expand-text="true">
	"{.}" [fontname="Arial" shape="Mrecord" label ="{{ {.} }}" style="filled"  fillcolor="#AfA7F4"]</xsl:text>  		
    	</xsl:for-each>
    	<!-- Edges -->
    	<xsl:for-each select="$modules">
    		<xsl:variable name="currentModule" select="."/>
    		<xsl:variable name="parentModule" select="distinct-values($root//element[@module=$currentModule]/@parentModule)"/>
    		<xsl:text expand-text="true">
	"{.}" -> {{ "</xsl:text>
    		<xsl:value-of select="$parentModule" separator='" "'/>
    		<xsl:text expand-text="true">" }} [fillcolor="#a6cee3" color="#1f78b4"]</xsl:text>  		
    	</xsl:for-each>
    	<xsl:text>}</xsl:text>
    </xsl:template>
	
</xsl:stylesheet>