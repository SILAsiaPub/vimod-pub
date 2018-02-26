<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		vp2sfm.xslt
    # Purpose:		Convert VP tagged text to SFM. Convert entities to UTF-8
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:			Ian McQuay <ian_mcquay@sil.org>
    # Created:		2018-02-24
    # Copyright:   	(c) 2018 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-replace-array.xslt"/>
      <xsl:output method="text" encoding="utf-8" name="text"/>
      <xsl:template match="/*">
            <xsl:for-each select="$file">
                  <xsl:variable name="input" select="f:file2uri(concat($projectpath,'/',.))"/>
                  <xsl:variable name="output" select="replace($input,$inext,$outext)"/>
                  <xsl:variable name="line" select="f:file2tokens($input,'&#13;&#10;@')"/>
                  <xsl:if test="unparsed-text-available($input)">
                        <xsl:result-document href="{$output}" format="text">
                              <xsl:text>\id </xsl:text>
                              <xsl:value-of select="."/>
                              <xsl:text>&#13;&#10;</xsl:text>
                              <xsl:for-each select="$line">
                                    <xsl:variable name="part" select="tokenize(.,' = ')"/>
                                    <xsl:value-of select="f:keyvalue($tag,$part[1])"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="f:replace-array($part[2],$char,0,'\=')"/>
                                    <xsl:text>&#13;&#10;</xsl:text>
                              </xsl:for-each>
                        </xsl:result-document>
                  </xsl:if>
            </xsl:for-each>
      </xsl:template>
</xsl:stylesheet>
