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
      <xsl:include href="project.xslt"/>
      <xsl:template match="/*">
            <html lang='cs'>
                  <head>
                        <title>Envelope</title>
                        <meta charset='utf-8'>
                        <meta name='description' content=''>
                        <meta name='keywords' content=''>
                        <meta name='author' content='Ian McQuay'>
                  </head>
                  <body>
                        <xsl:apply-templates select="*"/>
                  </body>
            </html>
      </xsl:template>
      <xsl:template match="*[local-name() = $record]">
            <xsl:element name="div">
                  <xsl:attribute name="id">
                        <xsl:text>address</xsl:text>
                  </xsl:attribute>
                  <xsl:apply-templates select="*"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $addressline]">
            <xsl:element name="div">
                  <xsl:attribute name="class">
                        <xsl:text>addressline </xsl:text>
                        <xsl:value-of select="local-name()"/>
                  </xsl:attribute>
                  <xsl:value-of select="."/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = 'LastName']">
            <xsl:element name="div">
                  <xsl:attribute name="class">
                        <xsl:text>name </xsl:text>
                        <xsl:value-of select="local-name()"/>
                  </xsl:attribute>
                  <xsl:value-of select="following-sibling::FirstName[1]"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="."/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = 'City']">
            <xsl:element name="div">
                  <xsl:attribute name="class">
                        <xsl:text>name </xsl:text>
                        <xsl:value-of select="local-name()"/>
                  </xsl:attribute>
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="following-sibling::State[1]"/><xsl:text> </xsl:text>
                  <xsl:value-of select="following-sibling::PostalCode[1]"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="FirstName|State|PostalCode"/>
</xsl:stylesheet>
