<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:param name="sortorder_file" select="'D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk\resources\kayan-sortorder.txt'"/>
      <xsl:variable name="line" select="f:file2lines($sortorder_file)"/>
      <xsl:template match="/">
            <xsl:for-each select="$line">
                  <xsl:variable name="part" select="tokenize(.,' ')"/>
                  <xsl:text> &lt; </xsl:text>
                  <xsl:value-of select="$part[1]"/>
                  <xsl:if test="$part[2]">
                        <xsl:text> &lt;&lt;&lt; </xsl:text>
                        <xsl:value-of select="$part[2]"/>
                  </xsl:if>
                  <xsl:if test="$part[3]">
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="$part[3]"/>
                  </xsl:if>
            </xsl:for-each>
      </xsl:template>
</xsl:stylesheet>
