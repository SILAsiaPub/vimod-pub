<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		usx-collection2usfm.xslt
    # Purpose:		Take aset of USX files and output USFM in a sibling folder.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:			Ian McQuay <ian_mcquay@sil.org>
    # Created:		2018-01-15
    # Copyright:   	(c) 2018 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:include href="usx2usfm.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:variable name="usxpath" select="concat($projectpath,'\usx')"/>
      <xsl:variable name="usfmpath" select="concat($projectpath,'\usfm')"/>
      <xsl:variable name="usxpathuri" select="f:file2uri($usxpath)"/>
      <xsl:variable name="collection" select="collection(concat($usxpathuri,'?select=','.usx'))"/>
      <xsl:output method="text" encoding="utf-8" indent="yes" name="usfm"/>
      <xsl:template match="/">
            <xsl:for-each select="$collection/usx">
                  <xsl:variable name="usfm" select="concat($projectpath,'\usfm\',book/@code,'.sfm')"/>
                  <xsl:value-of select="$usfm"/>
                  <xsl:text>&#13;&#10;</xsl:text>
                  <xsl:result-document href="{$usfm}" format="usfm">
                        <xsl:apply-templates select="*"/>
                  </xsl:result-document>
            </xsl:for-each>
      </xsl:template>
</xsl:stylesheet>
