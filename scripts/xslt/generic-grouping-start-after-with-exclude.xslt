<!--
    #############################################################
    # Name:   		generic-grouping-start-after-with-exclude.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-03-23
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
      <!-- Part of the SILP Dictionary Creator
Used to group by $groupnode found within $parentnode but excluding the listed nodes in $excludelist
Written by Ian McQuay 
Created 2012-06-14

-->
      <xsl:output method="xml" indent="yes"/>
      <xsl:param name="parent-node_list"/>
      <xsl:param name="start-node_list"/>
      <xsl:param name="exclude-node_list"/>
      <xsl:param name="group-node-name"/>
      <xsl:variable name="parent-node" select="tokenize($parent-node_list,' ')"/>
      <xsl:variable name="start-node" select="tokenize($start-node_list,' ')"/>
      <xsl:variable name="exclude-node" select="tokenize($exclude-node_list,' ')"/>
      <xsl:template match="*[local-name() = $parent-node]">
            <xsl:copy>
                  <xsl:for-each-group select="*" group-starting-with="*[local-name() = $start-node]">
                        <xsl:choose>
                              <xsl:when test="self::*[local-name() = $start-node]">
                                    <xsl:copy>
                                          <xsl:apply-templates/>
                                    </xsl:copy>
                                    <xsl:element name="{$group-node-name}">
                                          <xsl:apply-templates select="current-group()" mode="include"/>
                                    </xsl:element>
                                    <xsl:apply-templates select="current-group()" mode="exclude"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:for-each-group>
            </xsl:copy >
      </xsl:template>
      <xsl:template match="*" mode="include">
            <xsl:choose>
                  <xsl:when test="local-name() = $start-node"/>
                  <xsl:when test="local-name() = $exclude-node"/>
                  <xsl:otherwise>
                        <xsl:copy>
                              <xsl:apply-templates select="node()|@*"/>
                        </xsl:copy>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*" mode="exclude">
            <xsl:choose>
                  <xsl:when test="local-name() = $exclude-node">
                        <xsl:copy>
                              <xsl:apply-templates select="node()|@*"/>
                        </xsl:copy>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="@*|node()">
            <xsl:copy>
                  <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
