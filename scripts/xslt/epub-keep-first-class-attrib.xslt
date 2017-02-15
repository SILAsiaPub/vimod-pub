<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         epub-keep-first-class-attrib.xslt
    # Purpose:	Keep the first attrib that corresponds to the sfm markers. Remove anything sith _id in it.
    # Part of:      Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2017-02-14
    # Copyright:    (c) 2017 SIL International
    # Licence:      <MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="@class">
            <xsl:variable name="c1" select="tokenize(.,' ')[1]"/>
            <xsl:if test="not(matches($c1,'_id'))">
                  <xsl:attribute name="class">
                        <xsl:value-of select="$c1"/>
                  </xsl:attribute>
            </xsl:if>
      </xsl:template>
</xsl:stylesheet>
