<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		insert-ge.xslt
    # Purpose:		Inserts a ge field if there is none before a seGroup.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="ps">
            <xsl:choose>
                  <xsl:when test="name(following-sibling::*[1]) = 'seGroup'">
                        <xsl:element name="ge">
                              <xsl:text> ⋯ </xsl:text>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
