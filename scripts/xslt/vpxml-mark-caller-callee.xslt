<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         .xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay.org>
    # Created:      2014- -
    # Copyright:    (c) 2013 SIL International
    # Licence:      <LGPL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:template match="scr">
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
                  <xsl:apply-templates select="node()">
                        <xsl:with-param name="fnbefore" select="count(preceding::tag[@value = $caller-feature][normalize-space(.) = $caller])"/>
                  </xsl:apply-templates>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="para">
            <xsl:param name="fnbefore"/>
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
                  <xsl:apply-templates select="node()">
                        <xsl:with-param name="fnbefore" select="$fnbefore"/>
                  </xsl:apply-templates>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="tag[@value = $caller-feature][normalize-space(.) = $caller]">
            <!--<xsl:template match="tag[matches(@value,$f_match)]"> -->
            <xsl:param name="fnbefore"/>
            <xsl:choose>
                  <xsl:when test="string-length(.) = 0"/>
                  <xsl:otherwise>
                        <xsl:element name="caller">
                              <xsl:attribute name="cseq">
                                    <!-- <xsl:number count="//tag[@value = $caller-feature][normalize-space(.) = $caller]" format="01."/>  -->
                                    <xsl:value-of select="count(preceding::tag[@value = $caller-feature][normalize-space(.) = $caller]) + 1 - number($fnbefore)"/>
                                    <!-- <xsl:text>-</xsl:text> -->
                                    <!-- <xsl:value-of select="count(preceding::tag[@value = $caller-feature][normalize-space(.) = $caller][ancestor::book/scr/para/tag]) + 1"/> -->
                              </xsl:attribute>
                              <xsl:attribute name="value">
                                    <xsl:value-of select="@value"/>
                              </xsl:attribute>
                              <xsl:attribute name="callertext">
                                    <xsl:value-of select="normalize-space(.)"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[@value = $callee-feature][ancestor::note]">
            <!-- matches callee features -->
            <callee value="{.}"/>
      </xsl:template>
      <xsl:template match="*[@value = $callee-ref-tag][ancestor::note][1]">
            <!-- matches back ref in footnote -->
            <fr>
                  <xsl:value-of select="."/>
            </fr>
      </xsl:template>
      <xsl:template match="para[@class = $fnote][parent::note]">
            <!-- this is when footnotes are in individual paragraphs -->
            <xsl:element name="fnote">
                  <xsl:attribute name="nseq">
                        <xsl:value-of select="count(preceding-sibling::*[@class = $fnote]) + 1"/>
                  </xsl:attribute>
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="calleeGroup">
            <!-- this is when multiple footnotes are in one paragraphs -->
            <xsl:element name="fnote">
                  <xsl:attribute name="nseq">
                        <xsl:value-of select="count(preceding-sibling::calleeGroup)   + 1"/>
                  </xsl:attribute>
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
