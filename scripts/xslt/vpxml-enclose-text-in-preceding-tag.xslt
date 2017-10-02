<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		vpxml-enclose-text-in-preceding-tag.xslt
    # Purpose:		include following text in empty tag.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
<xsl:strip-space elements="*"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="para[not(child::*)][not(text())]">
            <xsl:if test="@class = $b or @class = $ib">
                  <!-- Need to preserve \b and \ib -->
                  <para class="{@class}"/>
            </xsl:if>
      </xsl:template>
      <xsl:template match="@value">
            <!-- remove the kerning values from the tag values -->
            <xsl:attribute name="value">
                  <xsl:value-of select="replace(.,'%\-?\d+','')"/>
            </xsl:attribute>
      </xsl:template>
<xsl:template match="text()[preceding-sibling::tag[1] and string-length(preceding-sibling::tag[1]) = 0]"/>
      <xsl:template match="tag[not(text())]">
            <xsl:choose>
                  <xsl:when test="following-sibling::text()[1] and string-length(normalize-space(following-sibling::text()[1])) gt 0">
                        <xsl:copy>
                              <xsl:apply-templates select="@*"/>
                              <xsl:value-of select="following-sibling::text()[1]"/>
                        </xsl:copy>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
