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
        <graph description="Diagram connecting group folders to shell modules defined in that group">            
            <nodes root="DITA">
                <xsl:apply-templates/>
            </nodes>
        </graph>
    </xsl:template>

    <xsl:template match="group">
        <node name="group_{@name}" label="{@name}">
            <xsl:apply-templates/>            
        </node>
    </xsl:template>

    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()"/>

    <xsl:template match="*:moduleType[. = 'mapshell' or . = 'topicshell']">
        <xsl:variable name="rootElement" select="substring-before(doc(ancestor::schema/@file)//*:start/*:ref/@name, '.')"/>
        <xsl:variable name="moduleName" select="following-sibling::*[1]"/>
        <node name="{$moduleName}" label="{$moduleName}{if (not($moduleName=$rootElement) and $rootElement!='') then concat('|', $rootElement) else ''}"/>
    </xsl:template>

</xsl:stylesheet>
