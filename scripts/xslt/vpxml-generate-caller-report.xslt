<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         vpxml-generate-caller-report.xslt
    # Purpose:      Looks at the callers in vpxml file to compare to callee report
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay.org>
    # Created:      2015-03-04
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:template match="/*">
            <xsl:apply-templates select="book"/>
      </xsl:template>
      <xsl:template match="book">
            <xsl:value-of select="@book"/>
            <xsl:text> ==============&#13;&#10;</xsl:text>
            <xsl:apply-templates select="scr/para"/>
      </xsl:template>
      <xsl:template match="para">
            <xsl:apply-templates select="tag">
                  <xsl:with-param name="bk" select="@book"/>
                  <xsl:with-param name="prechapt" select="normalize-space(preceding-sibling::*[@class = $c][1]/tag[1])"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="tag[@value = $caller-feature][normalize-space(.) = $caller]">
            <xsl:param name="bk"/>
            <xsl:param name="prechapt"/>
            <xsl:variable name="chap">
                  <xsl:choose>
                        <xsl:when test="string-length($prechapt) = 0">
                              <xsl:text>1</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:value-of select="$prechapt"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:variable name="verse" select="normalize-space(preceding::tag[@value = $v][1])"/>
            <xsl:value-of select="."/>
            <xsl:text>&#9;</xsl:text>
            <xsl:value-of select="concat($chap,':',$verse)"/>
            <xsl:text>&#10;</xsl:text>
      </xsl:template>
      <xsl:template match="text()"/>
</xsl:stylesheet>
