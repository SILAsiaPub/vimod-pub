<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		epub-mod-smil.xslt
    # Purpose:		epub-mod-smil.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns="http://www.w3.org/ns/SMIL">
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="*:text[matches(@src,'\d$')]">
            <xsl:copy>
                  <xsl:attribute name="src">
                        <xsl:value-of select="@src"/>
                        <xsl:text>a</xsl:text>
                  </xsl:attribute>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
