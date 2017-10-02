<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		get-verse-numb.xslt
    # Purpose:		extract verse number from verse.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="v">
            <xsl:copy>
                  <xsl:attribute name="verse">
                        <xsl:value-of select="substring-before(.,' ')"/>
                  </xsl:attribute>
                  <xsl:value-of select="substring-after(.,' ')"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
