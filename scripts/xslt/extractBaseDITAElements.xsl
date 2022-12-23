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
        <xsl:variable name="totalElementsNumber" select="count(//element)"/>
        <xsl:variable name="baseElements" select="//element[count(tokenize(@class))=2]"/>
        <xsl:variable name="baseElementsNumber" select="count($baseElements)"/>
        <xsl:variable name="otherElementsNumber" select="$totalElementsNumber - $baseElementsNumber"/>
        <xsl:variable name="duplicateElements" select="//element[@name = preceding::element/@name]"/>
        <xsl:variable name="duplicateElementsNumber" select="count($duplicateElements)"/>

        <graph description="DITA Stats">
            <nodes>
                <node name="elements" label = "DITA elements | {$totalElementsNumber}">
                    <node name="baseElements" label="base elements | {$baseElementsNumber}">
                        <xsl:for-each select="$baseElements">
                            <node name="{@name}"/>
                        </xsl:for-each>
                    </node>
                    <node name="otherElements" label="specialized elements | {$otherElementsNumber}"/>
                    <node name="duplicateElements" label="duplicate elements | {$duplicateElementsNumber}">
                        <xsl:for-each select="$duplicateElements">
                            <node name="{@name}">
                                <xsl:variable name="name" select="@name"/>
                                <xsl:for-each select="//element[@name = $name]">
                                    <node name="class = '{@class}'"/>
                                </xsl:for-each>
                            </node>
                        </xsl:for-each>
                    </node>
                </node>
            </nodes>
        </graph>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
