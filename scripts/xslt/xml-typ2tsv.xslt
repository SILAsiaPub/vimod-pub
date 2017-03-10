<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		Make a table from xml.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="text" encoding="utf-8"/>
<xsl:strip-space elements="*"/>
      <xsl:template match="/*">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="mkrGroup">
            <xsl:value-of select="mkr"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="mkrOverThis"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="lng"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="nam"/>
            <xsl:text>&#10;</xsl:text>
      </xsl:template>
</xsl:stylesheet>
