<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		jbatsh2cmd.xslt
    # Purpose:		convert a jbatsh xml file to a batch cmd file.
    # Part of:		Vimod Pub - https://github.com/indiamcq/jbatsh
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2018- -
    # Copyright:   	(c) 2018 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:strip-space elements="*"/>
      <xsl:variable name="calc" select="tokenize('equal notequal gt lt lte gte',' ')"/>
      <xsl:template match="/*">
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="func">
            <xsl:text>&#13;&#10;:</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text></xsl:text>
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="*[name() = 'true']">
            <!-- if statement -->
            <xsl:text>&#13;&#10;if </xsl:text>
            <xsl:choose>
                  <xsl:when test="@class ='var'">
                        <xsl:text>defined </xsl:text>
                        <xsl:value-of select="@id"/>
                  </xsl:when>
                  <xsl:when test="@class ='novar'">
                        <xsl:text>not defined </xsl:text>
                        <xsl:value-of select="@id"/>
                  </xsl:when>
                  <xsl:when test="@class = '^file'">
                        <xsl:text>exist </xsl:text>
                        <xsl:value-of select="@id"/>
                  </xsl:when>
                  <xsl:when test="@class = 'nofile'">
                        <xsl:text>not exist </xsl:text>
                        <xsl:value-of select="@id"/>
                  </xsl:when>
                  <xsl:when test="@class = $calc">
                        <xsl:text>"</xsl:text>
                        <xsl:choose>
                              <xsl:when test="name(*[1]) = 'val'">
                                    <xsl:text>%</xsl:text>
                                    <xsl:value-of select="@id"/>
                                    <xsl:text>%</xsl:text>
                              </xsl:when>
                              <xsl:when test="name(*[1]) = 'text'">
                                    <xsl:value-of select="*[1]"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:text>rem oh no value not found&#13;&#10;</xsl:text>
                                    <!-- oh no value not found -->
                              </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                              <xsl:when test="@class = 'equal'">
                                    <xsl:text>" == "</xsl:text>
                              </xsl:when>
                              <xsl:when test="@class = 'notequal'">
                                    <xsl:text>" neq "</xsl:text>
                              </xsl:when>
                              <xsl:when test="@class = 'gt'">
                                    <xsl:text>" gtr "</xsl:text>
                              </xsl:when>
                              <xsl:when test="@class = 'lt'">
                                    <xsl:text>" lss "</xsl:text>
                              </xsl:when>
                              <xsl:when test="@class = 'gte'">
                                    <xsl:text>" geq "</xsl:text>
                              </xsl:when>
                              <xsl:when test="@class = 'lte'">
                                    <xsl:text>" leq "</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:text>OH NO unhandled&#13;&#10;</xsl:text>
                              </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>" == "</xsl:text>
                        <xsl:choose>
                              <xsl:when test="name(*[2]) = 'val'">
                                    <xsl:text>%</xsl:text>
                                    <xsl:value-of select="@id"/>
                                    <xsl:text>%</xsl:text>
                              </xsl:when>
                              <xsl:when test="name(*[2]) = 'text'">
                                    <xsl:value-of select="*[1]"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:text>rem oh no value not found&#13;&#10;</xsl:text>
                                    <!-- oh no value not found -->
                              </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>"</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:text>OH NO unhandled&#13;&#10;</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="*"/>
            <xsl:text>&#13;&#10;)</xsl:text>
      </xsl:template>
      <xsl:template match="*[name() = 'false']">
            <xsl:text> else (</xsl:text>
            <xsl:text>&#13;&#10;)</xsl:text>
      </xsl:template>
      <xsl:template match="var">
            <xsl:text>&#13;&#10;set </xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>=</xsl:text>
            <xsl:choose>
                  <xsl:when test="child::*">
                        <xsl:apply-templates select="*"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="text()"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="val">
            <xsl:text>%</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>%</xsl:text>
      </xsl:template>
      <xsl:template match="doc">
            <xsl:text>&#13;&#10;:: </xsl:text>
            <xsl:apply-templates select="node()"/>
      </xsl:template>
      <xsl:template match="com">
            <xsl:text>&#13;&#10;rem </xsl:text>
            <xsl:apply-templates select="node()"/>
      </xsl:template>
      <xsl:template match="echo">
            <xsl:text>&#13;&#10;echo</xsl:text>
            <xsl:choose>
                  <xsl:when test="@class = 'on' or @class = 'off'">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="@class"/>
                  </xsl:when>
                  <xsl:when test="@class = 'nl'">
                        <xsl:text>.</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="node()"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="log">
            <xsl:text>&#13;&#10;echo </xsl:text>
            <xsl:apply-templates select="node()"/>
            <xsl:text>>> %logfile%</xsl:text>
      </xsl:template>
      <xsl:template match="text">
            <xsl:value-of select="text()"/>
      </xsl:template>
</xsl:stylesheet>
