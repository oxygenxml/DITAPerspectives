<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs f"
	xmlns:f="http://www.oxygenxml.com/xsl/functions" version="3.0">

	<xsl:output method="text"/>
	
	<xsl:variable name="defaultRootStyle" 
		select="'fontname=&quot;Arial&quot; shape=&quot;Mrecord&quot; style=&quot;filled&quot;  fillcolor=&quot;#DDDDDD&quot;'"/>
		
	<xsl:variable name="defaultStyles" select="(
		'fontname=&quot;Arial&quot; shape=&quot;Mrecord&quot; style=&quot;filled&quot;  fillcolor=&quot;#AFA7F4&quot;',
		'fontname=&quot;Arial&quot; shape=&quot;Mrecord&quot; style=&quot;filled&quot;  fillcolor=&quot;#1AFABC&quot;',
		'fontname=&quot;Arial&quot; shape=&quot;Mrecord&quot; style=&quot;filled&quot;  fillcolor=&quot;#BFCFFF&quot;',
		'fontname=&quot;Arial&quot; shape=&quot;Mrecord&quot; style=&quot;filled&quot;  fillcolor=&quot;#DDFFAA&quot;',
		'fontname=&quot;Arial&quot; shape=&quot;Mrecord&quot; style=&quot;filled&quot;  fillcolor=&quot;#AAFFAA&quot;'
		)"/>
	
	
	<xsl:template match="graph">
		<xsl:if test="@description">
			<xsl:text expand-text="true">// {@description}</xsl:text>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>
		<xsl:text>strict digraph {</xsl:text>
		<xsl:apply-templates select="nodes" mode="nodes"/>
		<xsl:apply-templates select="nodes" mode="edges"/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<!-- generate nodes -->
	
	<xsl:template match="nodes" mode="nodes">
		<xsl:if test="@root">
			<xsl:text expand-text="true">
				
  // Root node
  
	"{@root}" [label ="{@root}" {f:getStyle(.)}]</xsl:text>
		</xsl:if>
		<xsl:text expand-text="true">
			
  // Other nodes</xsl:text>
		<xsl:apply-templates mode="#current"/>
	</xsl:template>

	<xsl:template match="node" mode="nodes">
		<xsl:text expand-text="true">
	"{@name}" [label ="{f:getLabel(.)}" {f:getStyle(.)}]</xsl:text>
		<xsl:apply-templates mode="#current"/>
	</xsl:template>

	<!-- generate edges -->
	
	<xsl:template match="nodes" mode="edges">
		<xsl:text expand-text="true">
  // Edges</xsl:text>
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<xsl:template match="node/node" mode="edges">
		<xsl:text expand-text="true">
	"{../@name}" -> "{@name}" [fillcolor="#a6cee3" color="#1f78b4"]</xsl:text>
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
	<xsl:template match="nodes[@root]/node" mode="edges">
		<xsl:text expand-text="true">
	"{../@root}" -> "{@name}" [fillcolor="#a6cee3" color="#1f78b4"]</xsl:text>
		<xsl:apply-templates mode="#current"/>
	</xsl:template>

	<!-- functions -->

	<xsl:function name="f:getLabel" as="xs:string">
		<xsl:param name="context" as="node()"/>
		<xsl:value-of select="
				if ($context/@label) then
					$context/@label
				else
					$context/@name"/>
	</xsl:function>
	
	
	<xsl:function name="f:getStyle" as="xs:string">
		<xsl:param name="context" as="node()"/>
		<xsl:choose>
			<xsl:when test="$context/@style">
				<xsl:value-of select="$context/ancestor::graph//style[@id=$context/@style]"/>
			</xsl:when>
			<xsl:when test="$context/self::nodes">
				<xsl:value-of select="$defaultRootStyle"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level" select="count($context/ancestor::node)"/>
				<xsl:value-of select="$defaultStyles[$level+1]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
