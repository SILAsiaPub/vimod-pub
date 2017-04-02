<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		diglot-add-matching-attrib.xslt
    # Purpose:		Add an attribut for paragraphs that have a matching para.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="chapterGroup[ancestor::usxcollection[1]]">
            <xsl:variable name="curbook" select="@book"/>
            <xsl:variable name="curchapt" select="@number"/>
            <xsl:variable name="outerparaverse" select="/data/usxcollection[2]/usx[@book = $curbook]/chapterGroup[@number = $curchapt]/para/verse[1]/@number"/>
            <xsl:comment select="$outerparaverse"/>
            <xsl:copy>
                  <xsl:apply-templates select="@*|node()">
                        <xsl:with-param name="paramatch" select="$outerparaverse"/>
                  </xsl:apply-templates>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="para[ancestor::usxcollection[1]]">
            <xsl:param name="paramatch"/>
            <xsl:copy>
                  <xsl:if test="verse[1]/@number = $paramatch">
                        <xsl:attribute name="pair">
                              <xsl:text>true</xsl:text>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
