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

        <graph description="DITA Base Modules">
            <nodes root="DITA">
                <xsl:for-each select="$topModules">
                    <node name="{.}"/>
                </xsl:for-each>
            </nodes>
        </graph>
    </xsl:template>








    <xsl:template match="text()"/>





</xsl:stylesheet>
