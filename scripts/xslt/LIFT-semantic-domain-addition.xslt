<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		LIFT-semantic-domain-addition.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="trait[@name = 'semantic-domain-ddp4']">
            <xsl:variable name="value" select="replace(@value,'^[\d\.]+ ','')"/>
            <note type="classification">
                  <form lang="sdm">
                        <xsl:element name="text">
                              <xsl:value-of select="$value"/>
                        </xsl:element>
                  </form>
            </note>
            <reversal type="sdm">
                  <form lang="sdm">
                        <xsl:element name="text">
                              <xsl:value-of select="$value"/>
                        </xsl:element>
                  </form>
            </reversal>
            <xsl:copy>
                  <xsl:apply-templates select="@*"/>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
