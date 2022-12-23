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
	xmlns:arch="http://dita.oasis-open.org/architecture/2005/"
	exclude-result-prefixes="xs rng a oxy arch"
	version="2.0">
	
	<xsl:output indent="yes"/>
	<xsl:param name="relaxNGSchemasFolder" select="'../../data/DITA1.3/'"/>
	<xsl:variable name="basePath" select="resolve-uri($relaxNGSchemasFolder, base-uri(doc('')))"/>
	
	<xsl:template match="/">
		<xsl:call-template name="main"/>
	</xsl:template>
	
	<xsl:template name="main">
		<xsl:variable name="arg">
			<xsl:value-of select="$relaxNGSchemasFolder"/>
			<xsl:text>?select=*.rng;recurse=yes;on-error=ignore</xsl:text>
		</xsl:variable>
		<categories>
			<!-- Handle the difference between 1.3 and 2.0 schema structure, 1.3 has an additional rng subfolder -->
			<xsl:for-each-group 
				group-by="let $g:=tokenize(base-uri(.), '/')[last()-1] 
					return if ($g='rng') then tokenize(base-uri(.), '/')[last()-2] else $g" 
				select="collection($arg)">
				<xsl:variable name="group" select="current-grouping-key()"/>
				<xsl:if test="not($group = ('ditaval', 'xhtml', 'svg', 'svg11', 'mathml', 'mathml3'))">
					<group name="{$group}">
						<xsl:for-each select="current-group()">
							<schema file="{$relaxNGSchemasFolder}{substring-after(base-uri(.), $basePath)}">
								<xsl:copy-of select="//arch:moduleDesc"/>
								<xsl:for-each select=".//rng:element[@name]">
									<element 
										name="{@name}"
										definedIn="{$relaxNGSchemasFolder}{substring-after(base-uri(.), $basePath)}"
										definedInSchema="{substring-before(tokenize(base-uri(/), '/')[last()], '.rng')}"
										group="{$group}"
										>
										<xsl:call-template name="processClassAttribute"/>
										<xsl:call-template name="copyDocumentation"/>
									</element>
								</xsl:for-each>
							</schema>
						</xsl:for-each>                    
					</group> 
				</xsl:if>
			</xsl:for-each-group>
		</categories>
	</xsl:template>
	
	
	<xsl:template match="node() | @*" mode="doc">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- 
		Generate attributes containing parsed information from the class attribute	
		of an element, extracting the module, the parent module and the parent element 
		type as well as making the entire class value also available.
		
	-->	
	<xsl:template name="processClassAttribute">
		<xsl:variable name="class" select="oxy:getClassAtt(/, @name)"/>
		<xsl:if test="$class != ''">
			<xsl:variable name="elementType" select="if (starts-with($class, '+')) then 'domain' else 'structural'"/>
			<xsl:variable name="classTokens" select="tokenize($class, ' ')"/>
			<xsl:variable name="thisClass" select="$classTokens[count($classTokens)]"/>
			
			<xsl:attribute name="module" select="substring-before($thisClass, '/')"/>
			<xsl:attribute name="thisElementClass" select="$thisClass"/>
			<xsl:attribute name="elementType" select="$elementType"/>
			
			<!-- We have a derived element -->
			<xsl:if test="count($classTokens) > 2">
				<xsl:variable name="parentClass" select="$classTokens[count($classTokens)-1]"/>
				<xsl:attribute name="parent" select="substring-after($parentClass, '/')"/>
				<xsl:attribute name="parentModule" select="substring-before($parentClass, '/')"/>
				<xsl:attribute name="parentElementClass" select="$parentClass"/>
			</xsl:if>
			<xsl:attribute name="class" select="$class"/>
			<xsl:attribute name="elementLevel" select="count($classTokens) - 1"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:function name="oxy:getClassAtt">
		<xsl:param name="context"/>
		<xsl:param name="element"/>
		<xsl:variable name="attlist" select="concat($element, '.attlist')"/>
		<xsl:value-of  
			select="normalize-space($context//rng:define[@name=$attlist]/rng:optional/rng:attribute[@name='class']/@a:defaultValue)"/>
	</xsl:function>
	
	
	<xsl:template name="copyDocumentation">
		<xsl:choose>
			<xsl:when test="*[1][self::a:documentation]">
				<documentation>
					<xsl:value-of select="a:documentation"/>
				</documentation>
			</xsl:when>
			<xsl:when test="preceding-sibling::*[1][self::a:documentation]">
				<documentation>
					<xsl:value-of select="preceding-sibling::a:documentation[1]"/>
				</documentation>
			</xsl:when>
			<xsl:when test="not(preceding-sibling::*) and parent::*[1][self::*:define and preceding-sibling::*[1][self::a:documentation]]">
				<documentation>
					<xsl:value-of select="parent::rng:define[1]/preceding-sibling::a:documentation[1]"/>
				</documentation>
			</xsl:when>
			<xsl:when test="
				parent::*/preceding-sibling::node()[not(self::text())][1]
				[self::comment()]
				[starts-with(normalize-space(.), 'doc:')]">
				<documentation>
					<xsl:value-of select="substring-after(../preceding-sibling::comment()[1], 'doc:')"/>
				</documentation>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>