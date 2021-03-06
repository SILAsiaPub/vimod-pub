<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	bible-conc-starting-caps.xslt
    # Purpose:      	sort and group bible word list
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay@sil.org>
    # Created:      	2016-05-24
    # Copyright:    	(c) 2016 SIL International
    # Licence:      	<LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns:saxon="http://saxon.sf.net/">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:variable name="customcollation" select="f:keyvalue($xvarset,$collationname)"/>
      <!-- <xsl:include href="dict-custom-collation.xslt"/> -->
      <!-- <xsl:param name="max-word-occurance-count" select="1600"/> -->
      <!-- <xsl:param name="min-word-length" select="3"/> -->
      <xsl:variable name="ignorecharregex" select="f:lookupdefault($xvarset,'ignorecharregex','=',1,2,'')"/>
      <!-- <xsl:variable name="ignore" select="concat('[',$ignorechar,']')"/> -->
      <xsl:template match="/*">
            <groupedWords>
                  <xsl:for-each-group select="w" group-by="lower-case(@word)">
                        <!-- group on lower case so capitalized words are in same group as nocap words -->
                        <xsl:sort select="lower-case(@word)" collation="http://saxon.sf.net/collation?rules={encode-for-uri($customcollation)}"/>
                        <!-- <xsl:sort select="@word" case-order="upper-first"/> -->
                        <xsl:variable name="group-count" select="count(current-group())"/>
                        <xsl:if test="$group-count le number($max-word-occurance-count)">
                              <!-- <xsl:variable name="curwd" select="concat(' ',current-group()[1],' ')"/> -->
                              <!-- <xsl:comment select="current-group()[1]/@word"/> -->
                              <xsl:if test="string-length(current-group()[1]/@word) ge number($min-word-length) or current-group()[1]/@word = $includeshortwords">
                                    <xsl:call-template name="word">
                                          <xsl:with-param name="group-count" select="$group-count"/>
                                    </xsl:call-template>
                              </xsl:if>
                              <!--  <xsl:choose>
                                    <xsl:when test="string-length(current-group()[1]/@word) ge number($min-word-length)">
                                          <xsl:call-template name="word">
                                                <xsl:with-param name="group-count" select="$group-count"/>
                                          </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="current-group()[1]/@word = $includeshortwords">
                                          <xsl:call-template name="word">
                                                <xsl:with-param name="group-count" select="$group-count"/>
                                          </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise/>
                              </xsl:choose> -->
                              <!-- <xsl:if test="(string-length(current-group()[1]/@word) ge number($min-word-length)) or matches($includeshortwords_list,$curwd)"> -->
                              <!-- </xsl:if> -->
                        </xsl:if>
                  </xsl:for-each-group>
            </groupedWords>
      </xsl:template>
      <xsl:template name="word">
            <xsl:param name="group-count"/>
            <xsl:choose>
                  <xsl:when test="current-group()/@case = 'L'">
                                    <!-- output lower case word -->
                                     <!-- <xsl:value-of select="lower-case(current-group()[1]/@word)"/> -->
                              </xsl:when>
                  <xsl:when test="current-group()[1]/@word = lower-case(current-group()[1]/@word)">
                                    <!-- check if non capitalized word is present in current-group, if so output as lower case group -->
                                    <!--  relies on sort order doing upper case first -->
                                     <!-- <xsl:value-of select="lower-case(current-group()[last()]/@word)"/> -->
                              </xsl:when>
                  <xsl:when test="current-group()/@word = $lower-case-words">
                                    <!-- check if non capitalized word is present in current-group, if so output as lower case group -->
                                    <!--  relies on sort order doing upper case first -->
                                     <!-- <xsl:value-of select="lower-case(current-group()[last()]/@word)"/> -->
                              </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="w">
                              <xsl:attribute name="word">
                                    <!-- output capitialised word -->
                                    <xsl:value-of select="current-group()[1]/@word"/>
                              </xsl:attribute>
                              <xsl:attribute name="count">
                                    <xsl:value-of select="$group-count"/>
                              </xsl:attribute>
                              <xsl:for-each-group select="current-group()" group-by="@bk">
                                    <xsl:element name="bk">
                                          <xsl:attribute name="book">
                                                <xsl:value-of select="current-group()[1]/@bk"/>
                                          </xsl:attribute>
                                          <xsl:for-each-group select="current-group()" group-by="@c">
                                                <xsl:element name="chapter">
                                                      <xsl:attribute name="number">
                                                            <xsl:value-of select="current-group()[1]/@c"/>
                                                      </xsl:attribute>
                                                      <xsl:for-each select="current-group()">
                                                            <xsl:element name="verse">
                                                                  <xsl:attribute name="number">
                                                                        <xsl:value-of select="@v"/>
                                                                  </xsl:attribute>
                                                            </xsl:element>
                                                      </xsl:for-each>
                                                </xsl:element>
                                          </xsl:for-each-group>
                                    </xsl:element>
                              </xsl:for-each-group>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
