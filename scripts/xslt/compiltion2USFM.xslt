<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		compiltion2USFM.xslt
    # Purpose:		output compilation as USFM.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-10-02
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="text" encoding="utf-8" name="text" use-character-maps="cmap"/>
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="project-cmap.xslt"/>
      <xsl:strip-space elements="*"/>
      <xsl:preserve-space elements="tag"/>
      <!-- <xsl:param name="iso"/>
      <xsl:param name="sfmoutpath"/> -->
      <xsl:template match="/*">
            <xsl:apply-templates select="book"/>
      </xsl:template>
      <xsl:template match="book">
            <xsl:variable name="outfile" select="concat($sfmoutpath,'\',$iso,f:keyvalue($booknumb,f:keyvalue($bookname,@name)),'-',f:keyvalue($bookname,@name),'.sfm')"/>
            <xsl:variable name="outfileuri" select="f:file2uri($outfile)"/>
            <xsl:value-of select="concat($outfile,'&#10;')"/>
            <xsl:result-document href="{$outfileuri}" format="text">
                  <xsl:value-of select="concat('\id ',upper-case(f:keyvalue($bookname,@name)),' ')"/>
                  <xsl:text>&#10;</xsl:text>
                  <xsl:text>\mt1 </xsl:text>
                  <xsl:value-of select="@name"/>
                  <xsl:apply-templates/>
            </xsl:result-document>
      </xsl:template>
      <xsl:template match="v">
            <xsl:text>&#10;\v </xsl:text>
            <xsl:value-of select="@verse"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="p|s|s1|s2|pi|r|q1|m">
            <xsl:text>&#10;\</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="*">
            <xsl:text>===Unhandled ===</xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="c"/>
      <xsl:template match="chap">
            <xsl:text>&#10;\c </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
</xsl:stylesheet>
