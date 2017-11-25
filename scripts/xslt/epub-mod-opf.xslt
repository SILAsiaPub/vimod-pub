<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		epub-mod-opf.xslt
    # Purpose:		Modify existing opf file.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-11-07
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns="http://www.idpf.org/2007/opf">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:template match="*:item[matches(@id,'^t') and not(matches(@id,'^(t001|title|toc)'))]"/>
      <xsl:template match="*:itemref[matches(@idref,'^t') and not(matches(@idref,'^t001'))]"/>
      <xsl:template match="*:item[matches(@id,'^i')]">
            <xsl:copy>
                  <xsl:attribute name="id">
                        <xsl:text>i</xsl:text>
                        <xsl:value-of select="format-number(count(preceding-sibling::*:item[matches(@id,'^i')]) + 1,'000')"/>
                  </xsl:attribute>
                  <xsl:attribute name="href">
                        <xsl:value-of select="translate(@href,' ,','_')"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="@media-type"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
