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
    
    <xsl:template match="/">
        <xsl:variable name="root" select="/"/>

        <xsl:variable name="topModules" 
            select="distinct-values(
            //element/@class[count(tokenize(.))=2]/substring-before(tokenize(.)[2], '/')
            )"/>
        <graph description="DITA Modules hierarchy">            
            <nodes>
                <xsl:for-each select="$topModules">
                    <xsl:variable name="module" select="."/>
                    <node name="{.}">
                    <xsl:for-each select="$root">
                        <xsl:call-template name="childModules">
                            <xsl:with-param name="parentModule" select="$module"/>
                            <xsl:with-param name="level" select="2"/>
                        </xsl:call-template>
                    </xsl:for-each>                            
                    </node>                    
                </xsl:for-each>
            </nodes>
        </graph>
    </xsl:template>
    
    
    <xsl:template name="childModules">
        <xsl:param name="parentModule"/>
        <xsl:param name="level"/>
        <xsl:variable name="root" select="/"/>
        
        <xsl:variable name="children" 
            select="distinct-values(
                //element/@class[
                    count(tokenize(.))>$level and 
                    substring-before(tokenize(.)[$level], '/')=$parentModule
                ]/substring-before(tokenize(.)[$level+1], '/')
            )"/>
        <xsl:for-each select="$children">
            <xsl:variable name="module" select="."/>
            <node name="{.}">
                <xsl:variable name="thisModule" select="."/>
                <xsl:for-each select="$root">
                    <xsl:call-template name="childModules">
                        <xsl:with-param name="parentModule" select="$thisModule"/>
                        <xsl:with-param name="level" select="$level+1"/>
                    </xsl:call-template>
                </xsl:for-each>
            </node>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="text()"/>
</xsl:stylesheet>


    

