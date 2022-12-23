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
        <xsl:variable name="domainElements" select="//element[@elementType='domain']"/>
        <xsl:variable name="domains" select="distinct-values($domainElements/@module)"/>
        <graph description="DITA Domains">
            <nodes>
                <node name="domains" label="Domanins | {count($domains)}">
                    <xsl:for-each select="$domains">
                        <node name="{.}"/>
                        <xsl:call-template name="generateDomainInfo">
                            <xsl:with-param name="domain" select="."/>
                        </xsl:call-template>
                        
                    </xsl:for-each>
                </node>
            </nodes>
        </graph>
        
        <xsl:result-document href="maps/domains.ditamap" doctype-public="-//OASIS//DTD DITA 2.x Map//EN" doctype-system="map.dtd">
            <map>
                <title>DITA Domains</title>
                <xsl:for-each select="$domains">
                    <topicref href="../topics/{.}.dita"/>
                </xsl:for-each>
            </map>            
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="generateDomainInfo">
        <xsl:param name="domain"/>
        
        <xsl:variable name="domainElements" select="$root//element[@module=$domain]"/>
        <xsl:variable name="parents" select="distinct-values($domainElements/@parent)"/>
        
        <xsl:result-document href="topics/{$domain}.dita" doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd">
            <xsl:variable name="schema" select="doc($root//(element[@module=$domain])[1]/@definedIn)"/>
            <topic id="topic_{generate-id($root)}">
                <title><xsl:value-of select="$schema//*:moduleTitle"/></title>
                <body>
                    <p><image href="../domains/{$domain}-nodes.svg" scale="40" id="image_{generate-id($root)}"/></p>
                </body>
            </topic>
        </xsl:result-document>
        
        
        <xsl:result-document href="domains/{$domain}-nodes.xml">
            <graph description="DITA Domain {$domain}">
                <nodes root="{$domain}"> 
                    <xsl:for-each-group select="$domainElements" group-by="@parent">
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
