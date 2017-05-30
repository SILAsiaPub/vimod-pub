<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		glo-insert-verses.xslt
    # Purpose:		In glossary USX add in verse numbers to aid searching.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-04-20
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:param name="existingstyle"/>
      <xsl:param name="newstyle"/>
      <xsl:template match="para[@style=$existingstyle]">
            <xsl:copy>
                  <xsl:attribute name="style">
                        <xsl:value-of select="$newstyle"/>
                  </xsl:attribute>
                  <xsl:element name="verse">
                        <xsl:attribute name="style">
                              <xsl:text>v</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="number">
                              <xsl:value-of select="count(preceding::para[@style=$existingstyle]) + 1"/>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
