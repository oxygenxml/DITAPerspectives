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
        <xsl:variable name="topicElements" select="//element[starts-with(tokenize(@class)[2], 'topic/')]"/>
        
        
        <xsl:variable name="totalElementsNumber" select="count($topicElements)"/>
        <xsl:variable name="baseTopicElements" select="$topicElements[count(tokenize(@class))=2]"/>
        <xsl:variable name="baseTopicElementsNumber" select="count($baseTopicElements)"/>
        <xsl:variable name="otherTopicElementsNumber" select="$totalElementsNumber - $baseTopicElementsNumber"/>
        
        
        <xsl:variable name="mapElements" select="//element[starts-with(tokenize(@class)[2], 'map/')]"/>
        
        
        <xsl:variable name="totalMapElementsNumber" select="count($mapElements)"/>
        <xsl:variable name="baseMapElements" select="$mapElements[count(tokenize(@class))=2]"/>
        <xsl:variable name="baseMapElementsNumber" select="count($baseMapElements)"/>
        <xsl:variable name="otherMapElementsNumber" select="$totalMapElementsNumber - $baseMapElementsNumber"/>
        
        <graph description="DITA Topic and Map Stats">
            <nodes root="DITA elements">
                <node name="map elements" label = "DITA map elements | {$totalMapElementsNumber}">
                    <node name="baseMapElements" label="base map elements | {$baseMapElementsNumber}">
                        <xsl:for-each select="$baseMapElements">
                            <node name="{@name}"/>
                        </xsl:for-each>
                    </node>
                    <node name="specializedMapElements" label="specialized map elements | {$otherMapElementsNumber}"/>
                </node>
                <node name="topic elements" label = "DITA topic elements | {$totalElementsNumber}">
                    <node name="baseTopicElements" label="base topic elements | {$baseTopicElementsNumber}">
                        <xsl:for-each select="$baseTopicElements">
                            <node name="{@name}"/>
                        </xsl:for-each>
                    </node>
                    <node name="specializedTopic" label="specialized topic elements | {$otherTopicElementsNumber}"/>
                </node>
            </nodes>
        </graph>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
