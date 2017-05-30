<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     usfm2usx-v1.xslt
    # Purpose:	import USFM and create USX file
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016-10-21
    # Copyright:    (c) 2016 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<!-- needs a fuller list of paragraphs
		needs testing on some other data sources especially with fuller footnotes i.e with fr ft fq etc
		Also needs testing with other inline markup
		only tested on web exodus
		there are some space difference in elements but not significant 
		some verses after notes move to the next line -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
       <!-- <xsl:param name="para_list" select="'sp imt is ip ipi im imi ipq imq ipr iq ib ili iot io iex imte ie q qr qc qa qm b tr th thr tc tcr restore'"/> -->
      <xsl:param name="para-re" select="'(id|ide|sts|rem|h|toc1|toc2|toc3|p|m|pmo|pm|pmc|pmr|pi|mi|nb|cls|li|pc|pr|ph|b|cl|cp|cd|mt|mte|ms|mr|s|sr|r|d|sp|imt|is|ip|ipi|im|imi|ipq|imq|ipr|iq|ib|ili|iot|io|iex|imte|ie|q|qr|qc|qa|qm|b|tr|th|thr|tc|tcr|restore)\d?'"/>
      <xsl:param name="file" />
      <xsl:variable name="notestyle" select="tokenize('f x',' ')"/>
       <!-- <xsl:variable name="para" select="tokenize($para_list,' ')"/> -->
      <xsl:variable name="line" select="f:file2lines($file)"/>
      <xsl:variable name="sfmparse" select="'^\\([a-z0-9]+) ?(.*)'"/>
      <xsl:variable name="idparse" select="'^\\([a-z0-9]+) (...)(.*)'"/>
      <!-- <xsl:variable name="text" select="tokenize($usfm,'\n\\' matches(.,''))"/> -->
      <xsl:template match="/">
            <xsl:element name="usx">
                  <xsl:attribute name="version">
                        <xsl:text>2.5</xsl:text>
                  </xsl:attribute>
                  <xsl:for-each select="$line">
                        <!-- pass each line to the initial parser -->
                        <xsl:variable name="sfm" select="replace(.,$sfmparse,'$1')"/>
                        <xsl:variable name="content" select="replace(.,$sfmparse,'$2')"/>
                        <xsl:variable name="bookid" select="replace(.,$idparse,'$2')"/>
                        <xsl:variable name="idrest" select="replace(.,$idparse,'$3')"/>
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:choose>
                              <xsl:when test="$sfm = 'id'">
                                    <!-- handle the id marker -->
                                    <xsl:element name="book">
                                          <xsl:attribute name="code">
                                                <xsl:value-of select="$bookid"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="style">
                                                <xsl:value-of select="$sfm"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="normalize-space($idrest)"/>
                                    </xsl:element>
                              </xsl:when>
                              <xsl:when test="$sfm = 'c'">
                                    <!-- handle chapters -->
                                    <xsl:element name="chapter">
                                          <xsl:attribute name="number">
                                                <xsl:value-of select="normalize-space($content)"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="style">
                                                <xsl:value-of select="$sfm"/>
                                          </xsl:attribute>
                                    </xsl:element>
                              </xsl:when>
                              <xsl:when test="matches($sfm,$para-re)">
                                    <!-- Paragraph styles are listed in $para-re parameter that can be overritten but the list is complete for usfm 2.4-->
                                    <xsl:element name="para">
                                          <xsl:attribute name="style">
                                                <xsl:value-of select="$sfm"/>
                                          </xsl:attribute>
                                        <xsl:call-template name="inlinecheck">
                                                <xsl:with-param name="text" select="$content"/>
                                          </xsl:call-template>
                                          <xsl:call-template name="get-para-line">
                                                <xsl:with-param name="pos" select="number($pos) + 1"/>
                                          </xsl:call-template>
                                    </xsl:element>
                              </xsl:when>
                              <xsl:otherwise/>
                              <!-- only defined markers are handled -->
                        </xsl:choose>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="get-para-line">
            <xsl:param name="pos"/>
            <xsl:variable name="nextline" select="$line[number($pos)]"/>
            <xsl:variable name="sfm" select="replace($nextline,$sfmparse,'$1')"/>
            <xsl:variable name="content" select="replace($nextline,$sfmparse,'$2')"/>
            <xsl:variable name="verseno" select="replace($nextline,'^\\(v) ([\da-e\-]+) (.*)','$2')"/>
            <xsl:variable name="versedata" select="replace($nextline,'^\\(v) ([\da-e\-]+) (.*)','$3')"/>
            <xsl:choose>
                  <xsl:when test="$sfm = 'c'"/>
                  <xsl:when test="matches($sfm,$para-re)"/>
                  <xsl:when test="$sfm = 'v'">
                        <xsl:text> </xsl:text>
                        <xsl:element name="verse">
                              <xsl:attribute name="number">
                                    <xsl:value-of select="$verseno"/>
                              </xsl:attribute>
                              <xsl:attribute name="style">
                                    <xsl:value-of select="$sfm"/>
                              </xsl:attribute>
                        </xsl:element>
                        <xsl:call-template name="inlinecheck">
                              <xsl:with-param name="text" select="$versedata"/>
                        </xsl:call-template>
                        <xsl:call-template name="get-para-line">
                              <xsl:with-param name="pos" select="number($pos) + 1"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$line[number($pos)] = $line[last()]"/>
                  <xsl:otherwise>
                        <xsl:call-template name="get-para-line">
                              <xsl:with-param name="pos" select="number($pos) + 1"/>
                        </xsl:call-template>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="inlinecheck">
            <xsl:param name="text"/>
            <xsl:variable name="pretext" select="substring-before($text,'\')"/>
            <xsl:variable name="postbackslash" select="substring-after($text,'\')"/>
            <!-- <xsl:variable name="xpretext" select="substring-before($text,'\x ')"/> -->
            <!-- <xsl:variable name="noteraw" select="substring-before(substring-after($text,'\'),'*')"/> -->
            <xsl:variable name="style" select="substring-before($postbackslash,' ')"/>
            <xsl:variable name="note" select="substring-before(substring-after($text,concat('\', $style, ' ')),concat('\', $style, '*'))"/>
            <xsl:variable name="posttext" select="substring-after($text,concat('\', $style, '*'))"/>
            <xsl:choose>
                  <xsl:when test="matches($text,'\\')">
                        <!-- checks if there is backslash markers to handle -->
                        <xsl:value-of select="$pretext"/>
                        <xsl:choose>
                              <xsl:when test="$style = $notestyle">
                                    <!-- checks if the markup is notes -->
                                    <xsl:call-template name="noteparser">
                                          <xsl:with-param name="text" select="$note"/>
                                          <xsl:with-param name="type" select="$style"/>
                                    </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                    <!-- Handles scr text inline markup -->
                                    <xsl:call-template name="inlineparser">
                                          <xsl:with-param name="text" select="$note"/>
                                          <xsl:with-param name="type" select="$style"/>
                                    </xsl:call-template>
                              </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="inlinecheck">
                              <xsl:with-param name="text" select="$posttext"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="$text"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="noteparser">
            <xsl:param name="text"/>
            <xsl:param name="type"/>
            <!-- <xsl:variable name="caller" select="replace($text,'^(.)( .+)','$1')"/> -->
            <xsl:variable name="caller" select="substring-before($text,' ')"/>
            <xsl:variable name="bodya" select="substring-after($text,' ')"/>
            <!-- <xsl:variable name="ref" select="replace($text,'^(. )([0-9\-a-e:]+)( .+)','$2')"/> -->
            <xsl:variable name="ref" select="substring-before($bodya,' ')"/>
            <xsl:variable name="fnbody">
                  <xsl:choose>
                        <xsl:when test="matches($ref,'\d+:[0-9\-a-e]+')">
                              <xsl:value-of select="substring-after($bodya,' ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:value-of select="$bodya"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <!-- <xsl:variable name="bodypostref" select="replace($text,'^(. )([0-9\-a-e]+ )(.+)','$3')"/> -->
            <!-- <xsl:variable name="bodynoref" select="replace($text,'^(. )(.+)','$2')"/> -->
            <xsl:element name="note">
                  <!-- write the note -->
                  <xsl:attribute name="caller">
                        <xsl:value-of select="$caller"/>
                  </xsl:attribute>
                  <xsl:attribute name="style">
                        <xsl:value-of select="$type"/>
                  </xsl:attribute>
                  <xsl:choose>
                        <xsl:when test="matches($fnbody,'\\f. ')">
                              <!-- checks if other markup is in the note -->
                              <xsl:call-template name="notebodyparse">
                                    <xsl:with-param name="text" select="$fnbody"/>
                              </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                              <!-- other markup not found so just write out the note -->
                              <xsl:value-of select="$fnbody"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:element>
      </xsl:template>
      <xsl:template name="notebodyparse">
            <xsl:param name="text"/>
            <xsl:variable name="part" select=" tokenize(replace($text,'^\\',''),'\\')"/>
            <xsl:for-each select="$part">
                  <xsl:variable name="marker" select="substring-before(.,' ')"/>
                  <xsl:variable name="body" select="substring-after(.,' ')"/>
                  <xsl:variable name="curpos" select="position()"/>
                  <xsl:if test="$marker ne ''">
                        <!-- if style is closed it creates an empty $part -->
                        <xsl:element name="char">
                              <xsl:attribute name="style">
                                    <xsl:value-of select="$marker"/>
                              </xsl:attribute>
                              <xsl:if test="not(matches($part[number($curpos) + 1],'\*'))">
                                    <xsl:attribute name="closed">
                                          <xsl:text>flase</xsl:text>
                                    </xsl:attribute>
                              </xsl:if>
                              <xsl:value-of select="$body"/>
                              <!-- <xsl:text> </xsl:text> -->
                        </xsl:element>
                  </xsl:if>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="inlineparser">
            <xsl:param name="text"/>
            <xsl:param name="type"/>
            <xsl:element name="char">
                  <xsl:attribute name="style">
                        <xsl:value-of select="$type"/>
                  </xsl:attribute>
                  <xsl:value-of select="$text"/>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
