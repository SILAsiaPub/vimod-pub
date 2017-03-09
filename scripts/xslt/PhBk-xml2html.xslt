<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		PhBk-xml2html.xslt
    # Purpose:		Make an mutiple HTMLs from phrase book XML
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-03-08
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="html" version="5.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes" name="html5"/>
      <xsl:output method="text" encoding="utf-8"/>
<xsl:strip-space elements="*"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:template match="/*">
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="*[local-name() = $page-group]">
            <xsl:variable name="pos" select="count(preceding-sibling::*)"/>
            <xsl:variable name="href" select="f:file2uri(concat('file:///',$projectpath,'/output/group-',$pos,'.html'))"/>
            <xsl:value-of select="sGroup/s[1]"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:result-document href="{$href}" format="html5">
                  <html>
                        <head>
                              <meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8"/>
                              <link rel="stylesheet" href="{$cssfile}" type="text/css"/>
                              <title>
                                    <xsl:value-of select="sGroup/s[1]"/>
                              </title>
                        </head>
                        <body>
                              <xsl:apply-templates/>
                        </body>
                  </html>
            </xsl:result-document>
      </xsl:template>
      <xsl:template match="*">
            <!-- <xsl:variable name="this-name" select="local-name()"/> -->
            <xsl:variable name="element-name">
                  <xsl:choose>
                        <xsl:when test="local-name() = $span">
                              <xsl:text>span</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:text>div</xsl:text>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:element name="{$element-name}">
                  <xsl:attribute name="class">
                        <xsl:value-of select="name()"/>
                  </xsl:attribute>
                  <xsl:choose>
                        <xsl:when test="name() = $example-node[1]">
                              <xsl:variable name="number" select="replace(.,'^(\d+)\. .+','$1')"/>
                              <xsl:variable name="string" select="replace(.,'^\d+\. ','')"/>
                              <span class="numb">
                                    <xsl:value-of select="$number"/>
                              </span>
                              <xsl:value-of select="$string"/>
                        </xsl:when>
                        <xsl:when test="name() = $example-node[position() gt 1]">
                              <xsl:value-of select="replace(.,'^\d+\. ','')"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:apply-templates/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:element>
            <!--  <xsl:if test="name() = 'sGroup'">
                  <div class="lang">
                        <div class="l2">
                              <xsl:value-of select="$lang1"/>
                        </div>
                        <div class="l2">
                              <xsl:value-of select="$lang2"/>
                        </div>
                        <div class="l3">
                              <xsl:value-of select="$lang3"/>
                        </div>
                        <div class="l4">
                              <xsl:value-of select="$lang4"/>
                        </div>
                  </div>
            </xsl:if> -->
      </xsl:template>
      <xsl:template match="@*">
            <xsl:copy>
                  <xsl:value-of select="."/>
            </xsl:copy>
      </xsl:template>
      </xsl:stylesheet>
