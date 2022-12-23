<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Copyright 2001-2022 Syncro Soft SRL. All rights reserved.
    This is licensed under MPL 2.0. 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:oxy="http://www.oxygenxml.com/oxy" exclude-result-prefixes="xs rng a oxy" version="3.0">

    <xsl:output method="xml" indent="true"/>

    <xsl:variable name="root" select="/"/>

    <xsl:template match="/">
        <xsl:variable name="structuralElements" select="//element[@elementType='structural']"/>
        <xsl:variable name="structuralModules" select="distinct-values($structuralElements/@module[not(.=('topic', 'map'))])"/>
        <graph description="DITA Specializations">
            <nodes>
                <node name="specializations" label="Specializations | {count($structuralModules)}">
                    <xsl:for-each select="$structuralModules">
                        <node name="{.}"/>
                        <xsl:call-template name="generateStructuralInfo">
                            <xsl:with-param name="module" select="."/>
                        </xsl:call-template>
                        
                    </xsl:for-each>
                </node>
            </nodes>
        </graph>
        
        <xsl:result-document href="maps/specializations.ditamap" doctype-public="-//OASIS//DTD DITA 2.x Map//EN" doctype-system="map.dtd">
            <map>
                <title>DITA Specializations</title>
                <xsl:for-each select="$structuralModules">
                    <topicref href="../topics/{.}.dita"/>
                </xsl:for-each>
            </map>            
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="generateStructuralInfo">
        <xsl:param name="module"/>
        
        <xsl:variable name="structuralElements" select="$root//element[@module=$module]"/>
        <xsl:variable name="parents" select="distinct-values($structuralElements/@parent)"/>
        
        
        <xsl:result-document href="topics/{$module}.dita" doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd">
            <xsl:variable name="schemas" select="distinct-values($root//(element[@module=$module])/@definedIn)"/>
            <topic id="topic_{generate-id($root)}">
                <title><xsl:value-of select="$module"/></title>
                <body>
                    <p>Defined in <xsl:value-of select="$schemas" separator="', '"/></p>
                    <p><image href="../specializations/{$module}-nodes.svg" scale="40" id="image_{generate-id($root)}"/></p>
                </body>
            </topic>
        </xsl:result-document>
        
        <xsl:result-document href="specializations/{$module}-nodes.xml">
            <graph description="DITA Specialization {$module}">
                <nodes root="{$module}Module"> 
                    <xsl:for-each-group select="$structuralElements" group-by="@parent">
                        <node name="{current-grouping-key()}">
                            <xsl:for-each select="current-group()">
                                <node name="{@name}"/>
                            </xsl:for-each>
                        </node>
                    </xsl:for-each-group>
                </nodes>
            </graph>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>
