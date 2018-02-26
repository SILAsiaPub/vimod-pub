<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2018- -
    # Copyright:   	(c) 2018 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:param name="output"/>
      <xsl:variable name="equate" select="tokenize('equal notequal gt lt lte gte',' ')"/>
      <xsl:template match="/">
            <xsl:apply-templates select="func"/>
      </xsl:template>
      <xsl:template match="func">
            <xsl:choose>
                  <xsl:when test="$output = 'cmd'">
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="@id"/>
                        <xsl:text>&#13;&#10;</xsl:text>
                        <xsl:apply-templates select="*"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:text>Bash not implimented</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="ifc">
            <!-- if statement -->
            <xsl:choose>
                  <xsl:when test="cmd">
                        <xsl:text>if </xsl:text>
                        <xsl:choose>
                              <xsl:when test="@class ='var'">
                                    <xsl:text>defined </xsl:text>
                                    <xsl:value-of select="@id"/>
                              </xsl:when>
                              <xsl:when test="@class ='novar'">
                                    <xsl:text>not defined </xsl:text>
                                    <xsl:value-of select="@id"/>
                              </xsl:when>
                              <xsl:when test="@class = '^file'">
                                    <xsl:text>exist </xsl:text>
                                    <xsl:value-of select="@id"/>
                              </xsl:when>
                              <xsl:when test="@class = 'nofile'">
                                    <xsl:text>not exist </xsl:text>
                                    <xsl:value-of select="@id"/>
                              </xsl:when>
                              <xsl:when test="@class = $equate">
                                    <xsl:text>"</xsl:text>
                                    <xsl:choose>
                                          <xsl:when test="name(*[1]) = 'val'">
                                                <xsl:text>%</xsl:text>
                                                <xsl:value-of select="@id"/>
                                                <xsl:text>%</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="name(*[1]) = 'text'">
                                                <xsl:value-of select="*[1]"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:text>rem oh no value not found&#13;&#10;</xsl:text>
                                                <!-- oh no value not found -->
                                          </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                          <xsl:when test="@class = 'equal'">
                                                <xsl:text>" == "</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="@class = 'notequal'">
                                                <xsl:text>" neq "</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="@class = 'gt'">
                                                <xsl:text>" gtr "</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="@class = 'lt'">
                                                <xsl:text>" lss "</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="@class = 'gte'">
                                                <xsl:text>" geq "</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="@class = 'lte'">
                                                <xsl:text>" leq "</xsl:text>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:text>OH NO unhandled</xsl:text>
                                          </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>" == "</xsl:text>
                                    <xsl:choose>
                                          <xsl:when test="name(*[2]) = 'val'">
                                                <xsl:text>%</xsl:text>
                                                <xsl:value-of select="@id"/>
                                                <xsl:text>%</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="name(*[2]) = 'text'">
                                                <xsl:value-of select="*[1]"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:text>rem oh no value not found&#13;&#10;</xsl:text>
                                                <!-- oh no value not found -->
                                          </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>"</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:text>OH NO unhandled</xsl:text>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:text>OH NO unhandled</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
