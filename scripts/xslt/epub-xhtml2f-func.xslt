<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:        	epub-xhtml2f-func .xslt
    # Purpose:		create a xslt function that contains footnotes and cross references from the xhtml file. Created before running epub-xhtml2usfm.xslt
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay.org>
    # Created:      	2014/03/11
    # Modified: 	      2017-02-14 Ian McQuay, handling is more generic and allows \xt in \f now requires project.xslt
    # Copyright:   	(c) 2014 SIL International
    # Licence:      	<LGPL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gen="dummy-namespace-for-the-generated-xslt" xmlns:f="myfunctions" exclude-result-prefixes="xsl">
      <xsl:strip-space elements="*"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:namespace-alias stylesheet-prefix="gen" result-prefix="xsl"/>
      <xsl:include href="project.xslt"/>
      <xsl:param name="caller" select="'+'"/>
      <xsl:param name="f-caller" select="'+'"/>
      <xsl:param name="x-caller" select="'+'"/>
      <xsl:template match="/">
            <gen:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                  <gen:function name="f:refmatch">
                        <gen:param name="string"/>
                        <gen:variable name="ref" select="substring($string,1,1)"/>
                        <gen:choose>
                              <gen:when test="$string = 'xxxxx'"></gen:when>
                              <xsl:apply-templates select="descendant::*[@class = 'NoteFrame']"/>
                              <xsl:text>&#10;</xsl:text>
                              <gen:otherwise>
                                    <gen:value-of select="concat('\',$ref,' ???\',$ref,'*')"/>
                              </gen:otherwise>
                        </gen:choose>
                  </gen:function>
            </gen:stylesheet>
      </xsl:template>
      <xsl:template match="*[@class = 'NoteFrame']">
            <xsl:apply-templates select="*[@class = $noteclass]"/>
      </xsl:template>
      <xsl:template match="*[@class = $noteclass]">
            <!-- The following is needed for when a xref is put in a f paragraph in error -->
            <xsl:apply-templates select="spanGroup" mode="note"/>
      </xsl:template>
      <xsl:template match="spanGroup" mode="note">
            <xsl:variable name="id" select="tokenize(*[1],'_')[2]"/>
            <xsl:variable name="notestyle" select="substring($id,1,1)"/>
            <xsl:element name="xsl:when">
                  <xsl:attribute name="test">
                        <xsl:text>$string = '</xsl:text>
                        <xsl:value-of select="$id"/>
                        <xsl:text>'</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="concat('\',$notestyle,' ',$caller,' ')"/>
                  <xsl:apply-templates mode="note"/>
                  <xsl:text>\</xsl:text>
                  <xsl:value-of select="$notestyle"/>
                  <xsl:text>*</xsl:text>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*" mode="note">
            <xsl:variable name="classname" select="tokenize(@class,' ')"/>
            <xsl:choose>
                  <xsl:when test="$classname = $notespanmarker">
                        <xsl:value-of select="concat(' \',$classname,' ')"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="$classname = 'it'">
                        <xsl:value-of select="concat(' \',$classname,' ')"/>
                        <xsl:apply-templates/>
                        <xsl:value-of select="concat('\',$classname,'*')"/>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="text()">
            <xsl:value-of select="translate(.,'&#160;&#9;',' ')"/>
      </xsl:template>
      <xsl:template match="text()" mode="note">
            <xsl:value-of select="translate(.,'&#160;&#9;',' ')"/>
      </xsl:template>
</xsl:stylesheet>
