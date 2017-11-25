<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		epub-mod-ncx.xslt
    # Purpose:		remove unwanted chapter refs.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns="http://www.daisy.org/z3986/2005/ncx/">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="*:navPoint[not(matches(@playOrder,'^1$'))]"/>
</xsl:stylesheet>
