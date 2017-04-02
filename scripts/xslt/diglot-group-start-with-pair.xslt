<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
      <!--
    #############################################################
    # Name:         	diglot-group-start-with-pair.xslt
    # Purpose:		group paragraphs starting with pair attribute within a chapter
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay@sil.org>
    # Created:      	2017-03-29
    # Copyright:    	(c) 2017 SIL International
    # Licence:      	<MIT>
    ################################################################ -->
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:param name="group-attrib"/>
      <xsl:param name="parent-node_list"/>
      <xsl:variable name="parent" select="tokenize($parent-node_list,' ')"/>
      <xsl:param name="exclude_list"/>
      <xsl:variable name="exclude" select="tokenize($exclude_list,' ')"/>
      <xsl:include href='inc-copy-anything.xslt'/>
      <xsl:template match="*[local-name() = $parent]">
            <xsl:copy>
                  <xsl:for-each-group select="*" group-by="*[name(@*) = $group-attrib]">
                        <xsl:choose>
                              <xsl:when test="preceding-sibling::*[name(@*) = $group-attrib] or self::*[name(@*) = $group-attrib] ">
                                    <xsl:element name="div">
                                          <xsl:attribute name="class">
                                                <xsl:choose>
                                                      <xsl:when test="ancestor::usxcollection[1]">
                                                            <xsl:text>group1</xsl:text>
                                                      </xsl:when>
                                                      <xsl:when test="ancestor::usxcollection[2]">
                                                            <xsl:text>group2</xsl:text>
                                                      </xsl:when>
                                                </xsl:choose>
                                          </xsl:attribute>
                                          <xsl:apply-templates select="current-group()[local-name() != $exclude or local-name() != $parent]" mode="include"/>
                                    </xsl:element>
                                    <xsl:apply-templates select="current-group()[local-name() = $exclude or local-name() = $parent]" mode="exclude"/>
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
                  <xsl:when test="local-name() = $exclude or local-name() = $parent">
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
                  <xsl:when test="local-name() = $exclude or local-name() = $parent">
                        <xsl:copy>
                              <xsl:apply-templates/>
                        </xsl:copy>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
