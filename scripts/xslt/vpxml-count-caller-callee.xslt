<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         .xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay.org>
    # Created:      2014- -
    # Copyright:    (c) 2014 SIL International
    # Licence:      <LGPL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:template match="//book">
            <xsl:variable name="cseq" select="scr//@cseq"/>
            <xsl:variable name="nseq" select="note//@nseq"/>
            <xsl:value-of select="@book"/>
            <xsl:value-of select="'&#9;caller count&#9;'"/>
            <xsl:value-of select="count(scr//@cseq)"/>
            <xsl:value-of select="'&#9;callee count&#9;'"/>
            <xsl:value-of select="count(note//@nseq)"/>
            <xsl:value-of select="'&#9;last caller&#9;'"/>
            <xsl:value-of select="$cseq[last()]"/>
            <xsl:value-of select="'&#9;last callee&#9;'"/>
            <xsl:value-of select="$nseq[last()]"/>
            <xsl:text>&#9;</xsl:text>
            <xsl:if test="count(scr//@cseq) ne count(note//@nseq)">
                  <xsl:text>&#9;unequal</xsl:text>
            </xsl:if>
            <xsl:value-of select="'&#13;&#10;'"/>
      </xsl:template>
</xsl:stylesheet>
