<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		LIFT-reorder-gloss-by-lang.xslt
    # Purpose:		Reorder gloss entries based on order of langs param.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-04-08
    # Modified:		2017-05-30
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:param name="langs" select="'id en de'"/>
      <xsl:variable name="lang" select="tokenize($langs,' ')"/>
      <xsl:template match="sense">
            <xsl:variable name="cursense" select="."/>
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
                  <xsl:for-each select="$lang">
                        <xsl:variable name="langcode" select="."/>
                        <xsl:apply-templates select="$cursense/gloss[@lang=$langcode]"/>
                  </xsl:for-each>
                  <xsl:apply-templates select="*[name() ne 'gloss']"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
