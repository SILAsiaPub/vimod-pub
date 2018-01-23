<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		vp2usx-fix-missing-bk-att.xslt
    # Purpose:		Fix missing book Group.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:			Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-12-11
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="bkgrp[@bk = '']">
            <xsl:variable name="prevbk">
                  <xsl:choose>
                        <xsl:when test="string-length(preceding-sibling::*[1]/@bk) = 3">
                              <xsl:value-of select="preceding-sibling::*[1]/@bk"/>
                        </xsl:when>
                        <xsl:when test="string-length(preceding-sibling::*[2]/@bk) = 3">
                              <xsl:value-of select="preceding-sibling::*[2]/@bk"/>
                        </xsl:when>
                        <xsl:when test="string-length(preceding-sibling::*[3]/@bk) = 3">
                              <xsl:value-of select="preceding-sibling::*[3]/@bk"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:text>unknown</xsl:text>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:copy>
                  <xsl:attribute name="bk">
                        <xsl:value-of select="$prevbk"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="@ch|@vr"></xsl:apply-templates>
                  <xsl:apply-templates select="node()"></xsl:apply-templates>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
