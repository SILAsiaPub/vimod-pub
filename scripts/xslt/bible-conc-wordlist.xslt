<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         .xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2015- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:variable name="notwordcharregex" select="f:keyvalue($xvarset,'notwordcharregex')"/>
      <xsl:template match="/*">
            <wordlist>
                  <xsl:apply-templates select="usx"/>
            </wordlist>
      </xsl:template>
      <xsl:template match="verse">
            <xsl:param name="book"/>
            <xsl:param name="bookno"/>
            <xsl:param name="chaptno"/>
            <xsl:variable name="verseno" select="@number"/>
            <xsl:variable name="noemdash" select="replace(following::text()[1],'\-\-\-',' ')"/>
            <!-- <xsl:variable name="word" select="tokenize(normalize-space(replace(following::text()[1],'&#46;,\?!;:“”‘’\(\)\[\]—&lt;–&gt;',' ')),' ')"/>  -->
            <xsl:variable name="word" select="tokenize(normalize-space(replace($noemdash,$notwordcharregex ,' ')),' ')"/>
            <xsl:for-each select="$word">
                  <xsl:element name="w">
                        <xsl:attribute name="word">
                              <xsl:value-of select="."/>
                        </xsl:attribute>
                        <xsl:attribute name="bk">
                              <xsl:value-of select="$book"/>
                        </xsl:attribute>
                        <xsl:attribute name="bkno">
                              <xsl:value-of select="$bookno"/>
                        </xsl:attribute>
                        <xsl:attribute name="c">
                              <xsl:value-of select="$chaptno"/>
                        </xsl:attribute>
                        <xsl:attribute name="v">
                              <xsl:value-of select="$verseno"/>
                        </xsl:attribute>
                        <xsl:attribute name="case">
                              <xsl:choose>
                                    <xsl:when test="lower-case(substring(.,1,1)) = substring(.,1,1)">
                                          <xsl:choose>
                                                <xsl:when test="number(f:checkcase(.,0)) gt 0">
                                                      <xsl:text>U</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                      <xsl:text>L</xsl:text>
                                                </xsl:otherwise>
                                          </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <xsl:text>U</xsl:text>
                                    </xsl:otherwise>
                              </xsl:choose>
                        </xsl:attribute>
                  </xsl:element>
            </xsl:for-each>
      </xsl:template>
      <xsl:template match="usx">
            <xsl:apply-templates select="chapterGroup">
                  <xsl:with-param name="book" select="@book"/>
                  <xsl:with-param name="bookno" select="@pos"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="chapterGroup">
            <xsl:param name="book"/>
            <xsl:param name="bookno"/>
            <xsl:apply-templates select="verse">
                  <xsl:with-param name="book" select="@book"/>
                  <xsl:with-param name="bookno" select="@bookno"/>
                  <xsl:with-param name="chaptno" select="@number"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:function name="f:checkcase">
            <xsl:param name="string1"/>
            <xsl:param name="value"/>
            <xsl:variable name="string" select="replace($string1,concat('[',$sq,$dq,']'),'')"/>
            <!-- <xsl:variable name="codepoint" select="string-to-codepoints(substring($string,1,1))"/> -->
            <xsl:variable name="codepoint">
                  <xsl:choose>
                        <xsl:when test="upper-case(substring($string,1,1)) = substring($string,1,1)">
                              <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:value-of select="0"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:variable name="newvalue">
                  <xsl:choose>
                        <xsl:when test="number($codepoint) gt number(0)">
                              <xsl:value-of select="1 + number($value)"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:value-of select="number($value)"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                  <xsl:when test="number($newvalue) gt 0">
                        <xsl:value-of select="$newvalue"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:choose>
                              <xsl:when test="string-length(substring($string,2)) gt 0">
                                    <xsl:value-of select="f:checkcase(substring($string,2),0)"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:value-of select="0"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:function>
</xsl:stylesheet>
