<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:strip-space elements="*"/>
      <xsl:template match="/">
            <!-- matches root -->
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="body|html">
            <!-- matches body or html -->
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="p">
            <!-- matches any paragrap not defined elsewhere by class -->
            <xsl:if test="substring(.,1,1) = upper-case(substring(.,1,1) )">
                  <xsl:text>&#10;\p </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="span[@class = 's2']">
            <!-- matches regular verse reference -->
              <xsl:choose>
                  <xsl:when test="matches(.,'^\(\d+\)')">
                        <!-- match footnot caller -->
                        <xsl:text>\f + \fr </xsl:text>
                        <xsl:apply-templates select="following::p[@class = 's4'][1]" mode="footnote"/>
                        <xsl:text>\f*</xsl:text>
                  </xsl:when>
                  <xsl:when test="matches(.,'^\d+$')">
                        <!-- matches regular verse reference -->
                        <xsl:text>&#10;\v </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <!-- matchers unhandled -->
                        <xsl:text>&#10;\unhandled </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="p[@class = 's2']">
            <!-- matches paragraphs that have verse numbers in them -->
            <xsl:text>&#10;\p</xsl:text>
            <xsl:apply-templates select="text()|span[@class = 'p']" mode="verse"/>
      </xsl:template>
      <xsl:template match="text()" mode="verse">
            <xsl:choose>
                  <xsl:when test="matches(.,'^\(\d+\)')">
                        <!-- match footnot caller -->
                        <xsl:text>\f + \fr </xsl:text>
                        <xsl:apply-templates select="following::p[@class = 's4'][1]" mode="footnote"/>
                        <xsl:text>\f*</xsl:text>
                  </xsl:when>
                  <xsl:when test="matches(.,'^\d+$')">
                        <!-- matches regular verse reference -->
                        <xsl:text>&#10;\v </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <!-- matchers unhandled -->
                        <xsl:text>&#10;\unhandled </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="span[@class = 'p']" mode="verse">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="p[@class = 's1']">
<!-- This matches page headers and are not needed -->
</xsl:template>
      <xsl:template match="h3|h4">
            <xsl:text>&#10;\r </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="span/img"/>
      <xsl:template match="p[@class = 's4']" mode="footnote">
            <xsl:apply-templates mode="footnote"/>
      </xsl:template>
      <xsl:template match="p[@class = 's3']">
            <xsl:apply-templates mode="footnote"/>
      </xsl:template>
      <xsl:template match="text()" mode="footnote">
            <xsl:text>fix referece </xsl:text>
            <xsl:value-of select="."/>
      </xsl:template>
      <xsl:template match="span[@class = 'h2']" mode="footnote">
            <!-- seems to be a footnote quote -->
            <xsl:text>\fq </xsl:text>
            <xsl:value-of select="."/>
      </xsl:template>
      <xsl:template match="span[@class = 's5']" mode="footnote">
            <!-- seems to be regular footnote text -->
            <xsl:text>\ft </xsl:text>
            <xsl:value-of select="."/>
      </xsl:template>
      <xsl:template match="p[@class = 's4']">
<!-- remove this as footnote inserted into text as per USFM standards -->
</xsl:template>
      <xsl:template match="p[@class = 's6']">
            <!-- matchers second line if cross references -->
            <xsl:apply-templates/>
      </xsl:template>
</xsl:stylesheet>
