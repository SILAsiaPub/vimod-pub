<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     dict-ratchet-index.xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:template match="/*">
            <xsl:for-each select="$index_to_build">
                  <xsl:variable name="pos" select="position()"/>
                  <xsl:variable name="last" select="last()"/>
                  <xsl:variable name="curlist">
                        <xsl:choose>
                              <xsl:when test=". = 'ver'">
                                    <xsl:sequence select="$uniquevernword"/>
                              </xsl:when>
                              <xsl:when test=". = 'eng'">
                                    <xsl:sequence select="$uniqueengword"/>
                              </xsl:when>
                              <xsl:when test=". = 'nat'">
                                    <xsl:sequence select="$uniquenatword"/>
                              </xsl:when>
                              <xsl:when test=". = 'reg'">
                                    <xsl:sequence select="$uniqueregword"/>
                              </xsl:when>
                              <xsl:when test=". = 'reg2'">
                                    <xsl:sequence select="$uniquereg2word"/>
                              </xsl:when>
                              <xsl:when test=". = 'reg3'">
                                    <xsl:sequence select="$uniquereg3word"/>
                              </xsl:when>
                        </xsl:choose>
                  </xsl:variable>
                  <xsl:call-template name="writeindexpage">
                        <xsl:with-param name="pagetitle" select="$indexes_to_build_title[$pos]"/>
                        <xsl:with-param name="list" select="$curlist"/>
                        <xsl:with-param name="type" select="."/>
                        <xsl:with-param name="corepos" select="$pos"/>
                        <xsl:with-param name="last" select="$last"/>
                  </xsl:call-template>
            </xsl:for-each>
            <!-- <xsl:call-template name="panel"/> -->
            <xsl:for-each select="$uniquevernword">
                  <xsl:comment select="."/>
                  <xsl:text>&#10;</xsl:text>
            </xsl:for-each>
      </xsl:template>
</xsl:stylesheet>
