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
		<xsl:for-each select="/categories/group">
			<xsl:variable name="group" select="@name"/>
			<xsl:result-document href="./dot/{$group}.dot">
				<xsl:text>strict digraph {</xsl:text>
				<xsl:apply-templates mode="defineNodes"/>
				<xsl:apply-templates mode="defineEdges"/>
				<xsl:text>}</xsl:text>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*" mode="defineNodes">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	<xsl:template match="text()" mode="defineNodes"/>
	<xsl:template match="element" mode="defineNodes">
		<xsl:text expand-text="true">
			"{@name}"[fontname="Arial" shape="Mrecord" label ="{{ {@name} | {@module} }}" style="filled"  fillcolor="#1f77b4"]</xsl:text>
	</xsl:template>
	
	<xsl:template match="*" mode="defineEdges">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	<xsl:template match="text()" mode="defineEdges"/>
	<xsl:template match="element[@parent]" mode="defineEdges">
		<xsl:text expand-text="true">
	"{@name}" -> "{@parent}"[fillcolor="#a6cee3" color="#1f78b4"]</xsl:text>
	</xsl:template>
</xsl:stylesheet>