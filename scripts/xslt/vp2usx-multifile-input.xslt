<?xml version="1.0"?>
<!--
    #############################################################
    # Name:   		vp2xml-multifile-input.xslt
    # Purpose:		Import a multi Ventura text of whole text that has been converted to UTF-8
    # Part of: 		Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author: 		Ian McQuay <ian_mcquay.org>
    # Created: 		2014-08-29
    # Copyright:		(c) 2013 SIL International
    # Licence:  		<LGPL>
    ################################################################
-->
<xsl:stylesheet version="2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="scr note"/>
      <!-- includes for needed params, functions, templates -->
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-replace-array.xslt"/>
      <xsl:include href="vpxml-cmap.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <!-- <xsl:variable name="alltext2" select="translate(f:replace-array($alltext,$replace-array,1,'='),'&lt;&gt;&#13;','{}')"/> -->
      <xsl:template name="/*">
            <xsl:element name="data">
                  <xsl:for-each select="$book-numb-key">
                        <!-- <xsl:comment select="$book-code"/> -->
                        <xsl:variable name="bk" select="f:keyvalue($adjust-book-code,.)"/>
                        <xsl:variable name="bkintro" select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,$bk,$intropart,$fileext))"/>
                        <xsl:variable name="bkbody" select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,$bk,$fileext))"/>
                        <xsl:variable name="bkfn" select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,$bk,$fnpart,$fileext))"/>
                        <xsl:element name="usx">
                              <xsl:attribute name="version">
                                    <xsl:value-of select="'2.5"/>
                              </xsl:attribute>
                              <xsl:element name="book">
                                    <xsl:attribute name="code">
                                          <xsl:value-of select="."/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ptbknumb">
                                          <xsl:value-of select="f:keyvalue($book-numb,.)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="style">
                                          <xsl:value-of select="'id'"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$langname"/>
                              </xsl:element>
                              <xsl:if test="unparsed-text-available($bkintro)">
                                    <xsl:call-template name="book">
                                          <xsl:with-param name="text" select="translate(f:replace-array(unparsed-text($bkintro),$replace-array,1,'='),'&lt;&gt;&#13;','{}')"/>
                                          <!-- change < char to { and > to } and remove carriage return characters -->
                                          <xsl:with-param name="type" select="'intro'"/>
                                    </xsl:call-template>
                              </xsl:if>
                              <xsl:if test="unparsed-text-available($bkbody)">
                                    <xsl:call-template name="book">
                                          <xsl:with-param name="text" select="translate(f:replace-array(unparsed-text($bkbody),$replace-array,1,'='),'&lt;&gt;&#13;','{}')"/>
                                          <!-- change < char to { and > to } and remove carriage return characters -->
                                          <xsl:with-param name="type" select="'scr'"/>
                                    </xsl:call-template>
                              </xsl:if>
                              <xsl:if test="unparsed-text-available($bkfn)">
                                    <xsl:call-template name="book">
                                          <xsl:with-param name="text" select="translate(f:replace-array(unparsed-text($bkfn),$replace-array,1,'='),'&lt;&gt;&#13;','{}')"/>
                                          <!-- change < char to { and > to } and remove carriage return characters -->
                                          <xsl:with-param name="type" select="'notes'"/>
                                    </xsl:call-template>
                              </xsl:if>
                          </xsl:element>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="book">
            <xsl:param name="book"/>
            <xsl:param name="type"/>
            <xsl:param name="text"/>
            <xsl:variable name="para" select="tokenize($text,'\n?@')"/>
            <!--<xsl:value-of select="$text"/>
            <xsl:value-of select="'&#10;'"/> -->
            <xsl:element name="{$type}">
                  <xsl:for-each select="$para[position() gt 1]">
                        <xsl:variable name="line" select="replace(.,'\n',' ')"/>
                        <!-- The following line had a space changed to a \s to handle a CR LF there instead of a space that is commonly found, working better 2014-12-02s  -->
                        <xsl:variable name="para-seperator" select="' =\s{0,2}'"/>
                        <xsl:variable name="part" select="tokenize($line,$para-seperator)"/>
                        <xsl:variable name="chaptype" select="substring-before($line,$para-seperator)"/>
                        <xsl:variable name="initialstring" select="substring-after($line,$para-seperator)"/>
                        <xsl:variable name="prestring" select="substring-before($initialstring,'&lt;')"/>
                        <xsl:variable name="poststring" select="substring-after($initialstring,'&lt;')"/>
                        <xsl:choose>
                              <xsl:when test="'' = $part[2]"/>
                              <xsl:otherwise>
                                    <xsl:element name="para">
                                          <xsl:attribute name="style">
                                                <xsl:value-of select="upper-case(translate($part[1],' ','_'))"/>
                                          </xsl:attribute>
                                          <xsl:for-each select="$part[position() gt 1]">
                                                <xsl:variable name="pos" select="position()"/>
                                                <xsl:if test="$pos gt 1">
                                                      <xsl:text> = </xsl:text>
                                                </xsl:if>
                                                <xsl:call-template name="parsepara">
                                                      <xsl:with-param name="paracontent" select="f:replaceencodedchars(.)"/>
                                                </xsl:call-template>
                                          </xsl:for-each>
                                    </xsl:element>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="parsepara">
            <!-- analyze-string template -->
            <xsl:param name="paracontent"/>
            <xsl:choose>
                  <xsl:when test="matches($paracontent,'\{')">
                        <!-- Handles regular markup  elements -->
                        <xsl:variable name="part" select="tokenize($paracontent,'\{')"/>
                        <xsl:for-each select="$part">
                              <xsl:call-template name="parsetags">
                                    <xsl:with-param name="tagnstring" select="."/>
                              </xsl:call-template>
                        </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="replace($paracontent,'&#xA;','')"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="parsetags">
            <!-- analyze-string template -->
            <xsl:param name="tagnstring"/>
            <xsl:variable name="tag" select="tokenize($tagnstring,'\}')"/>
            <xsl:choose>
                  <xsl:when test="matches(.,'\}')">
                        <xsl:choose>
                              <xsl:when test="$tag[1] = $tagfindreplace-key">
                                    <xsl:value-of select="f:keyvalue($tagfindreplace,$tag[1])"/>
                                    <xsl:value-of select="replace($tag[2],'&#xA;','')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:element name="text">
                                          <xsl:attribute name="tag">
                                                <xsl:value-of select="replace($tag[1],'&#34;','')"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="replace($tag[2],'&#xA;','')"/>
                                    </xsl:element>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="replace(.,'&#xA;','')"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
