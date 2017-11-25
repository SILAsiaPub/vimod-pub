<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		compilation2sorted.xslt
    # Purpose:		Take a compilation XML and sort it by book and chapter and verse.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-10-02
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:template match="/*">
            <xsl:copy>
                  <xsl:for-each-group select="bkGroup" group-by="f:keyvalue($bookname,bk)">
                        <xsl:sort select="bk"/>
                         <!-- <xsl:sort select="c[1]"/> -->
                         <!-- <xsl:sort select="p[1]/v[1]/@verse"/> -->
                        <xsl:element name="book">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="bk[1]"/>
                              </xsl:attribute>
                              <xsl:call-template name="chapter">
                                    <xsl:with-param name="chap" select="current-group()"/>
                              </xsl:call-template>
                              <!-- <xsl:apply-templates select="current-group()"/> -->
                        </xsl:element>
                  </xsl:for-each-group>
            </xsl:copy>
      </xsl:template>
      <xsl:template name="chapter">
            <xsl:param name="chap"/>
            <xsl:for-each-group select="$chap" group-by="c">
                  <xsl:sort select="number(c[1])"/>
                  <xsl:sort select="number(p[1]/v[1]/@verse)"/>
                  <xsl:element name="chap">
                        <xsl:value-of select="c[1]"/>
                  </xsl:element>
                  <xsl:apply-templates select="current-group()"/>
            </xsl:for-each-group>
      </xsl:template>
      <xsl:template match="bkGroup">
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="c">
            <xsl:choose>
                  <xsl:when test="preceding::c[1] = . and preceding::bk[1] = preceding::bk[2]"/>
                  <xsl:otherwise>
                        <xsl:copy>
                              <xsl:apply-templates select="node()"/>
                        </xsl:copy>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="bk"/>
</xsl:stylesheet>
