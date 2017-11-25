<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		epub-join-xhtml-fix.xslt
    # Purpose:		Join chapter files into single xhtml.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:f="myfunctions" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="f">
      <xsl:output method="xhtml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:variable name="xhtmlpathuri" select="f:file2uri($sourcetextpath)"/>
      <xsl:variable name="collection" select="collection(concat($xhtmlpathuri,'?select=',$collectionfile))"/>
      <xsl:template match="/">
            <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="en" lang="en">
                  <head>
                        <link rel="stylesheet" type="text/css" href="../stylesheet.css"/>
                  </head>
                  <body class="story" dir="ltr">
                        <xsl:apply-templates select="$collection/*:html/*:body"/>
                  </body>
            </html>
      </xsl:template>
      <xsl:template match="*:body">
            <xsl:element name="div">
                  <xsl:attribute name="class">
                        <xsl:text>page</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                        <xsl:text>page</xsl:text>
                        <xsl:value-of select="position()"/>
                  </xsl:attribute>
                  <xsl:if test="*:img">
                        <xsl:apply-templates select="*:img"/>
                  </xsl:if>
                  <xsl:copy-of select="*[local-name() = 'div']"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*:img">
            <xsl:element name="img">
                  <xsl:attribute name="src">
                        <xsl:value-of select="translate(@src,' ,','_')"/>
                  </xsl:attribute>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
