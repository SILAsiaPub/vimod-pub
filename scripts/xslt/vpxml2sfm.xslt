<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         vpxml2sfm.xslt
    # Purpose:	convert xml generated from Ventura Publisher file to usfm
    # status		added handling for bold and Italic but messed up quotes
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay.org>
    # Created:      2014- -
    # Copyright:    (c) 2013 SIL International
    # Licence:      <LGPL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions">
      <xsl:output method="text" encoding="utf-8" name="text" use-character-maps="cmap"/>
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:include href="inc-file2uri.xslt"/>
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
            <xsl:variable name="outfile" select="concat($sfmoutpath,'\',$iso,@ptbknumb,'-',@book,'.sfm')"/>
            <xsl:variable name="outfileuri" select="f:file2uri($outfile)"/>
            <xsl:value-of select="concat($outfile,'&#10;')"/>
            <xsl:result-document href="{$outfileuri}" format="text">
                  <xsl:value-of select="concat('\id ',upper-case(@book),' ')"/>
                  <xsl:value-of select="scr/para[@class = $id]"/>
                  <xsl:value-of select="'&#10;'"/>
                  <xsl:value-of select="'\h '"/>
                  <xsl:value-of select="scr/para[@class = $h][1]"/>
                  <!-- <xsl:apply-templates select="scr/para[@class = $mt1 or @class = $mt2]" mode="titletop"/> -->
                  <xsl:apply-templates/>
            </xsl:result-document>
      </xsl:template>
      <xsl:template match="scr">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="para" mode="titletop">
            <xsl:choose>
                  <xsl:when test="@class = $mt1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mt1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $mt2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mt2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $mt3">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mt3 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="para">
            <xsl:choose>
                  <xsl:when test="@class = $unwanted"/>
                  <xsl:when test="@class = $id"/>
                  <xsl:when test="@class = $h"/>
                  <xsl:when test="@class = $mt1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mt1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $imte2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\imte2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $imte2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\imte2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $mt2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mt2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $mt3">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mt3 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $toc1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\toc1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $is">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\is '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $ip">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\ip '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $p">
                        <xsl:if test="$no_v1 = $true">
                              <xsl:if test="preceding-sibling::para[1]/@* = $ip or preceding-sibling::para[1]/@* = $iot ">
                                    <!-- handles no chapter like for Jud, 3Jn-->
                                    <xsl:value-of select="'&#10;\c 1 '"/>
                              </xsl:if>
                        </xsl:if>
                        <xsl:value-of select="'&#10;\p '"/>
                        <xsl:if test="$no_v1 = $true">
                              <xsl:if test="preceding-sibling::para[1]/@* = $ip or preceding-sibling::para[1]/@* = $iot ">
                                    <xsl:value-of select="'&#10;\v 1 '"/>
                              </xsl:if>
                              <xsl:if test="preceding-sibling::para[1]/@* = $c">
                                    <xsl:value-of select="'&#10;\v 1 '"/>
                              </xsl:if>
                              <xsl:if test="preceding-sibling::para[2]/@* = $c and preceding-sibling::para[1]/@* = $s1">
                                    <xsl:value-of select="'&#10;\v 1 '"/>
                              </xsl:if>
                              <xsl:if test="preceding-sibling::para[3]/@* = $c and preceding-sibling::para[2]/@* = $s1 and preceding-sibling::para[1]/@* = $r ">
                                    <xsl:value-of select="'&#10;\v 1 '"/>
                              </xsl:if>
                        </xsl:if>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $p_noverse1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\p &#10;\v 1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $c">
                        <xsl:choose>
                              <xsl:when test="matches(text()[1],'Salmo')">
                                    <xsl:variable name="part" select="tokenize(text(),' ')"/>
                                    <xsl:value-of select="'&#10;'"/>
                                    <xsl:value-of select="'\c '"/>
                                    <xsl:value-of select="$part[2]"/>
                                    <xsl:value-of select="'&#10;'"/>
                                    <xsl:value-of select="'\ms '"/>
                                    <xsl:apply-templates/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:value-of select="'&#10;'"/>
                                    <xsl:value-of select="'\c '"/>
                                    <xsl:apply-templates/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:when>
                  <xsl:when test="@class = $q1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:choose>
                              <xsl:when test="following-sibling::*[1][@class = $inline_para]">
                                    <xsl:variable name="nextq" select="lower-case(tokenize(following-sibling::*[1]/@class,'_')[1])"/>
                                    <xsl:choose>
                                          <xsl:when test="$nextq = 'q2'">
                                                <xsl:value-of select="'\q2 '"/>
                                          </xsl:when>
                                          <xsl:when test="$nextq = 'q3'">
                                                <xsl:value-of select="'\q3 '"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:value-of select="'\q1 '"/>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:value-of select="'\q1 '"/>
                              </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $b_q1">
                        <xsl:value-of select="'&#10;\b&#10;'"/>
                        <xsl:value-of select="'\q1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $b">
                        <xsl:value-of select="'&#10;\b '"/>
                  </xsl:when>
                  <xsl:when test="@class = $k">
                        <xsl:value-of select="'&#10;\p \k '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $k-close">
                        <xsl:value-of select="'\k* '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $iot">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\iot '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $io1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\io1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $io2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\io2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $io3">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\io3 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $ie">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\ie '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $q2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\q2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $q3">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\q3 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $s1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\s1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $s2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\s2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $r">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\r '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $x">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\x '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $m">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\m '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $mi">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\mi '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $pi">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\pi '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $ms1">
                        <xsl:variable name="chapno" select="tokenize(.,' ')"/>
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\c '"/>
                        <xsl:value-of select="$chapno[2]"/>
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\ms1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $li1">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\li1 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $li2">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\li2 '"/>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $sig">
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\m \sig '"/>
                        <xsl:apply-templates/>
                        <xsl:value-of select="'\sig*'"/>
                  </xsl:when>
                  <xsl:when test="@class = $inline_para">
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@class = $table">
                        <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="'\tr '"/>
                        <xsl:for-each select="$cell">
                              <xsl:text>\tc</xsl:text>
                              <xsl:value-of select="position()"/>
                              <xsl:text> </xsl:text>
                              <xsl:value-of select="."/>
                              <xsl:text> </xsl:text>
                        </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="'&#10;'"/>
                        <xsl:value-of select="concat('\rem unhandled-',@class,' ')"/>
                        <xsl:apply-templates/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="tag">
            <xsl:choose>
                  <xsl:when test="@value = $unwanted-tag"/>
                  <xsl:when test="@value = $v and matches(text(),'[0-9\-,]+')">
                        <xsl:value-of select="'&#10;\v '"/>
                        <xsl:value-of select="text()"/>
                        <!-- <xsl:apply-templates/> -->
                        <xsl:value-of select="$spaceafterverse"/>
                  </xsl:when>
                  <!-- <xsl:when test="@value = $ldquote">
                        <xsl:text>&#x201C;</xsl:text>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@value = $rdquote">
                        <xsl:text>&#x201D;</xsl:text>
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="@value = $a_macron">
                        <xsl:text>&#x0101;</xsl:text>
                        <xsl:apply-templates/>
                  </xsl:when> -->
                  <xsl:when test=". = ',' and preceding-sibling::tag[1][@value = $v]"/>
                  <xsl:when test="matches(text(),'&#158;+')"/>
                  <xsl:when test="matches(@value,'B')">
                        <xsl:choose>
                              <xsl:when test="$boldon = $true">
                                    <xsl:text>\bd </xsl:text>
                                    <xsl:apply-templates/>
                                    <xsl:text>\bd*</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:apply-templates/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:when>
                  <xsl:when test="matches(@value,'I')">
                        <xsl:choose>
                              <xsl:when test="$italicon = $true">
                                    <xsl:choose>
                                          <xsl:when test="matches(@value,'I\*')">
                                                <xsl:apply-templates/>
                                          </xsl:when>
                                          <xsl:when test="matches(@value,'Indent=')">
                                                <xsl:apply-templates/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:text>\em </xsl:text>
                                                <xsl:apply-templates/>
                                                <xsl:text>\em*</xsl:text>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:apply-templates/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:apply-templates/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="tag" mode="fnote">
            <xsl:choose>
                  <xsl:when test="@value = $callee-ref-tag and matches(text(),'\*[0-9\-,:]+')">
                        <xsl:value-of select="'\fr '"/>
                        <xsl:value-of select="substring(.,2)"/>
                  </xsl:when>
                  <xsl:when test="@value = $fq">
                        <xsl:value-of select="'\fq '"/>
                        <xsl:apply-templates/>
                        <xsl:if test="following-sibling::tag">
                              <xsl:value-of select="'\ft '"/>
                        </xsl:if>
                  </xsl:when>
                  <!--  <xsl:when test="@value = $callee-ref-tag and not(matches(text(),'\*[0-9\-,:]+'))">
                        <xsl:value-of select="' \ft '"/>
                        <xsl:apply-templates/>
                  </xsl:when>-->
                  <xsl:when test="@value = $callee-ref-tag">
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:apply-templates/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="fr" mode="fnote">
            <xsl:value-of select="'\fr '"/>
            <xsl:value-of select="replace(.,'\s+',' ')"/>
            <xsl:value-of select="' \ft '"/>
      </xsl:template>
      <xsl:template match="fnote">
            <xsl:text>\f + </xsl:text>
            <xsl:apply-templates mode="fnote"/>
            <xsl:text>\f*</xsl:text>
      </xsl:template>
      <xsl:template match="text()">
            <xsl:value-of select="replace(.,'\s+',' ')"/>
      </xsl:template>
      <!-- translate(.,'&#147;&#148;&#145;&#146;','“”‘’') -->
</xsl:stylesheet>
