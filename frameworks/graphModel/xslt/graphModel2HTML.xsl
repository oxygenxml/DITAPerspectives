<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="html" indent="yes"/>

    <xsl:key name="nodesByName" match="node" use="@name"/>

    <xsl:variable name="var" as="map(xs:string, xs:integer)">
        <xsl:map>
            <xsl:for-each select="//node">
                <xsl:map-entry key="xs:string(@name)" select="position()"/>
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>

    <!-- Create an HTML page with a graph showing how topics link to each other.-->
    <xsl:template match="/">
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of select="/graph/@description"/>
                </title>
                <script type="text/javascript" src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"/>
                <style type="text/css">
                    #mynetwork {
                        width: 90%;
                        height: 700px;
                        border: 1px solid lightgray;
                    }</style>
            </head>
            <body>
                <div id="mynetwork"/>
                <script type="text/javascript">
                    <xsl:text>&#10;var nodes = new vis.DataSet([&#10;</xsl:text>
                    <xsl:if test="/graph/nodes/@root">
                        <xsl:text expand-text="yes">{{ id: 0, label: "{/graph/nodes/@root}" }},&#10;</xsl:text>
                    </xsl:if>
                    <xsl:for-each select="//node">
                        <xsl:text expand-text="yes">{{ id: {$var(@name)}, label: "{(@label, @name)[1]}" }},&#10;</xsl:text>
                    </xsl:for-each>
                    <xsl:text>]);&#10;</xsl:text>
                    <!--
                        Create links//-->
                    <xsl:text>&#10;var edges = new vis.DataSet([&#10;</xsl:text>
                    <xsl:apply-templates select="//node" mode="links"/>
                    <xsl:text>]);</xsl:text>
                    <xsl:text>
// create a network
var container = document.getElementById("mynetwork");
var data = {
nodes: nodes,
edges: edges,
};
var options = {
  nodes:{
      shape: 'box',
      widthConstraint: 200,
  }
};
var network = new vis.Network(container, data, options);
				</xsl:text>
                </script>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="text()" mode="links"/>
    <xsl:template match="*" mode="links"/>
    <xsl:template match="node[parent::node]" mode="links">
        <xsl:text expand-text="yes">{{ from: {$var(../@name)}, to: {$var(@name)}, arrows: "to" }},&#10;</xsl:text>
    </xsl:template>
    <xsl:template match="node[parent::nodes[@root]]" mode="links">
        <xsl:text expand-text="yes">{{ from: 0, to: {$var(@name)}, arrows: "to" }},&#10;</xsl:text>
    </xsl:template>


</xsl:stylesheet>
