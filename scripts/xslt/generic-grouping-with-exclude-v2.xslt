<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		generic-grouping-with-exclude-v2.xslt
    # Purpose:		Groups within a list, finds a list, excludes a list
    # Updates:		generic-grouping-with-exclude.xslt That could only start within a list
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-03-02
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:param name="parent-node_list"/>
      <xsl:param name="group-node_list"/>
      <xsl:param name="exclude-node_list"/>
      <xsl:variable name="parent-node" select="tokenize($parent-node_list,' +')"/>
      <xsl:variable name="group-node" select="tokenize($group-node_list,' +')"/>
      <xsl:variable name="exclude-node" select="tokenize($exclude-node_list,' +')"/>
      <xsl:template match="*[local-name() = $parent-node]">
            <xsl:copy>
                  <xsl:for-each-group select="*" group-starting-with="*[local-name() = $group-node]">
                        <xsl:choose>
                              <xsl:when test="preceding-sibling::*[local-name() = $group-node] or self::*[local-name() = $group-node] ">
                                    <xsl:element name="{local-name()}Group">
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
                  <xsl:when test="local-name() = $exclude-node">
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:copy>
                              <xsl:apply-templates/>
                        </xsl:copy>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*" mode="exclude">
            <xsl:choose>
                  <xsl:when test="local-name() = $exclude-node">
                        <xsl:copy>
                              <xsl:apply-templates/>
                        </xsl:copy>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
