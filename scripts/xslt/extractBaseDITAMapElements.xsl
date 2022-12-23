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
        <xsl:variable name="mapElements" select="//element[starts-with(tokenize(@class)[2], 'map/')]"/>
        
        
        <xsl:variable name="totalMapElementsNumber" select="count($mapElements)"/>
        <xsl:variable name="baseMapElements" select="$mapElements[count(tokenize(@class))=2]"/>
        <xsl:variable name="baseMapElementsNumber" select="count($baseMapElements)"/>
        <xsl:variable name="otherMapElementsNumber" select="$totalMapElementsNumber - $baseMapElementsNumber"/>
        
        <graph description="DITA Map Stats">
            <nodes>
                <node name="elements" label = "DITA map elements | {$totalMapElementsNumber}">
                    <node name="baseMapElements" label="base elements | {$baseMapElementsNumber}">
                        <xsl:for-each select="$baseMapElements">
                            <node name="{@name}"/>
                        </xsl:for-each>
                    </node>
                    <node name="otherElements" label="specialized elements | {$otherMapElementsNumber}"/>
                </node>
            </nodes>
        </graph>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
