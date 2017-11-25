<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		epub-mod-xhtml-toc.xslt
    # Purpose:		modify the xhtml toc file.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns="http://www.w3.org/1999/xhtml">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="*:a[matches(.,'Chapter')]">
            <xsl:copy>
                  <xsl:attribute name="href">
                        <xsl:value-of select="replace(@href,'\d\d\d\.','001.')"/>
                        <xsl:text>#page</xsl:text>
                        <xsl:value-of select="tokenize(.,' ')[2]"/>
                  </xsl:attribute>
                  <xsl:value-of select="replace(.,'Chapter','Page')"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
