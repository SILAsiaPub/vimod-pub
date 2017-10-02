<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		xml2Ptmodule.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:strip-space elements="*"/>
      <xsl:param name="copy-elem" select="tokenize('mt1|s|s2|pi','\|')"/>
      <xsl:template match="/*">
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="id">
            <xsl:text>\id XXA </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>&#10;</xsl:text>
      </xsl:template>
      <xsl:template match="*">
         <!-- delete -->
     </xsl:template>
      <xsl:template match="idGroup|bkGroup">
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="*[name() = $copy-elem]">
            <xsl:text>\</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>&#10;</xsl:text>
      </xsl:template>
      <xsl:template match="p[1]">
            <xsl:text>\ms </xsl:text>
            <xsl:value-of select="preceding-sibling::bk[1]"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="preceding-sibling::c[1]"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="v[1]/@verse"/>
            <xsl:text>-</xsl:text>
            <xsl:choose>
                  <xsl:when test="following-sibling::p">
                        <xsl:value-of select="following-sibling::p[position() = last()]/v[position() = last()]/@verse"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="v[position() = last()]/@verse"/>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#10;</xsl:text>
            <!-- start ref output -->
            <xsl:text>\ref </xsl:text>
            <xsl:value-of select="f:keyvalue($booknames,preceding-sibling::bk[1])"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="preceding-sibling::c[1]"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="v[1]/@verse"/>
            <xsl:text>-</xsl:text>
            <xsl:choose>
                  <xsl:when test="following-sibling::p">
                        <xsl:value-of select="following-sibling::p[position() = last()]/v[position() = last()]/@verse"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="v[position() = last()]/@verse"/>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#10;</xsl:text>
      </xsl:template>
</xsl:stylesheet>
