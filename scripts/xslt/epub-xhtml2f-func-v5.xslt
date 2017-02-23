<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:        	epub-xhtml2f-func .xslt
    # Purpose:		create a xslt function that contains footnotes and cross references from the xhtml file. Created before running epub-xhtml2usfm.xslt
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay.org>
    # Created:      	2014/03/11
    # Copyright:   	(c) 2013 SIL International
    # Licence:      	<LGPL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:gen="dummy-namespace-for-the-generated-xslt" xmlns:f="myfunctions" exclude-result-prefixes="xsl">
      <xsl:strip-space elements="*"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:namespace-alias stylesheet-prefix="gen" result-prefix="xsl"/>
      <xsl:include href="project.xslt"/>
      <!-- <xsl:param name="f-caller" select="'+'"/> -->
      <!-- <xsl:param name="x-caller" select="'-'"/> -->
      <xsl:template match="/*">
            <gen:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                  <gen:function name="f:refmatch">
                        <gen:param name="string"/>
                        <gen:variable name="ref" select="substring($string,1,1)"/>
                        <gen:choose>
                              <gen:when test="$string = 'xxxxx'"></gen:when>
                              <xsl:apply-templates select="//aside"/>
                               <!-- <xsl:apply-templates select="//*[@class = $xrefclass]"/> -->
                              <xsl:text>&#10;</xsl:text>
                              <gen:otherwise>
                                    <gen:value-of select="concat('\',$ref,' ???\',$ref,'*')"/>
                              </gen:otherwise>
                        </gen:choose>
                  </gen:function>
            </gen:stylesheet>
      </xsl:template>
      <xsl:template match="text()">

</xsl:template>
      <xsl:template match="aside">
            <xsl:variable name="id" select="@id"/>
<xsl:variable name="f-caller" select="span[1]"/>
<xsl:variable name="ref" select="p/a"/>
            <xsl:element name="xsl:when">
                  <xsl:attribute name="test">
                        <xsl:text>$string = '</xsl:text>
                        <xsl:value-of select="$id"/>
                        <xsl:text>'</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="concat('\f ',$f-caller,' \fr ',$ref)"/>
                  <xsl:apply-templates />
                  <xsl:text>\f*</xsl:text>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[@class = $xrefclass]">
            <xsl:comment select="'para'"/>
            <xsl:variable name="chap" select="preceding-sibling::*[@class = 'chapternumber'][1]"/>
            <xsl:variable name="vref1" select="replace(*[1],'ay ([\d\-]+):','$1')"/>
            <xsl:comment select="'bold'"/>
            <xsl:element name="xsl:when">
                  </xsl:element>
            
            <!--
            <xsl:apply-templates>
                  <xsl:with-param name="chap" select="$chap"/>
            </xsl:apply-templates> -->
      </xsl:template>
      <xsl:template match="b">
            <xsl:param name="chap"/>
            <xsl:variable name="vref" select="replace(.,'ay (\d+):','$1')"/>
            <xsl:comment select="'bold'"/>
            <xsl:element name="xsl:when">
                  <xsl:attribute name="test">
                        <xsl:text>$string = '</xsl:text>
                        <xsl:value-of select="concat($chap,':',$vref)"/>
                        <xsl:text>'</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="concat('\x ',$x-caller,' \xo ')"/>
                  <xsl:value-of select="concat($chap,':',$vref)"/>
                  <xsl:text> \xt </xsl:text>
                  <xsl:value-of select="following-sibling::node()[1]"/>
                  <xsl:text>\x*</xsl:text>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
