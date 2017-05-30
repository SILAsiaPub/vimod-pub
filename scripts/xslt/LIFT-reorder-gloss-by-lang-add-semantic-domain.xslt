<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		LIFT-reorder-gloss-by-lang-add-semantic-domain.xslt
    # Purpose:		Reorder gloss entries based on order of langs param.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-04-08
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:param name="semantic" select="'off'"/>
      <xsl:param name="classification" select="'classification'"/>
      <xsl:param name="langorder" select="'id en de'"/>
      <xsl:variable name="lang" select="tokenize($langorder,' ')"/>
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
      <xsl:template match="trait[@name = 'semantic-domain-ddp4']">
            <xsl:choose>
                  <xsl:when test="$semantic = 'on'">
                        <xsl:variable name="value" select="replace(@value,'^[\d\.]+ ','')"/>
                        <note type="{$classification}">
                              <form lang="sdm">
                                    <xsl:element name="text">
                                          <xsl:value-of select="$value"/>
                                    </xsl:element>
                              </form>
                        </note>
                        <reversal type="sdm">
                              <form lang="sdm">
                                    <xsl:element name="text">
                                          <xsl:value-of select="lower-case($value)"/>
                                    </xsl:element>
                              </form>
                        </reversal>
                        <xsl:copy>
                              <xsl:apply-templates select="@*"/>
                        </xsl:copy>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:copy>
                              <xsl:apply-templates select="@*"/>
                        </xsl:copy>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
