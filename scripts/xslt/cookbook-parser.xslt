<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes" name="xml"/>
      <xsl:param name="precede"/>
      <xsl:variable name="outpath2" select="f:file2uri('D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk\data\eng\cookbook\Text\parsed')"/>
      <xsl:template match="//div[@class = 'recipe']">
            <xsl:variable name="pos" select="count(preceding::div[@class = 'recipe']) + 1 + 107"/>
            <xsl:result-document href="{concat($outpath2,'/',$pos,'.html')}" format="xml">
                  <xsl:copy-of select="."/>
            </xsl:result-document>
      </xsl:template>
</xsl:stylesheet>
