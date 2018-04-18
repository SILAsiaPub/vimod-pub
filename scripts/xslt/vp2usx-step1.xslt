<?xml version="1.0"?>
<!--
    #############################################################
    # Name:   		vp2xml-multifile-input.xslt
    # Purpose:		Import a multi Ventura text of whole text that has been converted to UTF-8 and output USX
    # Part of: 		Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author: 		Ian McQuay <ian_mcquay.org>
    # Created: 		2017-10-26
    # Copyright:		(c) 2017 SIL International
    # Licence:  		<MIT>
    #############################################################
can I put the foot notes into a variable and put them straight in, 
Should intro be done separately? with mode?
funcion for vpimport = done
-->
<xsl:stylesheet version="2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="f xs functx">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" name="xml"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="scr note"/>
      <!-- includes for needed params, functions, templates -->
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="inc-replace-array.xslt"/>
      <xsl:include href="vp2usx-mods.xslt"/>
      <xsl:include href="vpxml-cmap.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:variable name="bknamecase">
            <xsl:choose>
                  <xsl:when test="$booknamecase = 'LC'">
                        <xsl:text>LC</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:text>UC</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>
      <xsl:variable name="note">
            <xsl:for-each select="$book-numb-key">
                  <xsl:variable name="bk" select="f:keyvalue($adjust-book-code,.)"/>
                  <!-- <xsl:variable name="bkfn" select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,$bk,$fnpart,$fileext))"/> -->
                  <xsl:variable name="bkfn">
                        <!--  this handles upper and lower case based on $booknamecase -->
                        <xsl:choose>
                              <xsl:when test="$bookname = '41MAT'">
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:keyvalue($book-numb,.),f:case($bknamecase,.),$fnpart,$fileext))"/>
                              </xsl:when>
                              <xsl:when test="$bookname = 'MT'">
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:case($bknamecase,$bk),$fnpart,$fileext))"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <!-- three letter book name -->
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:case($bknamecase,.),$fnpart,$fileext))"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="unparsed-text-available($bkfn)">
                        <xsl:element name="notes">
                              <xsl:attribute name="bk">
                                    <xsl:value-of select="."/>
                              </xsl:attribute>
                              <xsl:call-template name="book">
                                    <xsl:with-param name="text" select="f:vpimport($bkfn)"/>
                                    <!-- change < char to { and > to } and remove carriage return characters -->
                                    <xsl:with-param name="type" select="'note'"/>
                              </xsl:call-template>
                        </xsl:element>
                  </xsl:if>
            </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="body">
            <xsl:for-each select="$book-numb-key">
                  <xsl:variable name="bk" select="f:keyvalue($adjust-book-code,.)"/>
                  <!-- <xsl:variable name="bkintro" select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,$bk,$intropart,$fileext))"/> -->
                  <!-- <xsl:variable name="bkbody" select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,$bk,$fileext))"/> -->
                  <xsl:variable name="bkintro">
                        <xsl:choose>
                              <xsl:when test="$bookname = '41MAT'">
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:keyvalue($book-numb,.),f:case($bknamecase,.),$intropart,$fileext))"/>
                              </xsl:when>
                              <xsl:when test="$bookname = 'MT'">
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:case($bknamecase,$bk),$intropart,$fileext))"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <!--  -->
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:case($bknamecase,.),$intropart,$fileext))"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="bkbody">
                        <xsl:choose>
                              <xsl:when test="$bookname = '41MAT'">
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:keyvalue($book-numb,.),f:case($bknamecase,.),$fileext))"/>
                              </xsl:when>
                              <xsl:when test="$bookname = 'MT'">
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:case($bknamecase,$bk),$fileext))"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <!--  -->
                                    <xsl:value-of select="f:file2uri(concat($projectpath,'\',$xmlimportpath,'\',$langpre,f:case($bknamecase,.),$fileext))"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:variable>
                  <xsl:if test="unparsed-text-available($bkbody)">
                        <xsl:element name="usx">
                              <xsl:attribute name="version">
                                    <xsl:value-of select="'2.5'"/>
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
                                          <xsl:with-param name="text" select="f:vpimport($bkintro)"/>
                                          <!-- <xsl:with-param name="type" select="'intro'"/> -->
                                    </xsl:call-template>
                              </xsl:if>
                              <xsl:call-template name="book">
                                    <xsl:with-param name="text" select="f:vpimport($bkbody)"/>
                                    <!-- change < char to { and > to } and remove carriage return characters -->
                                    <!-- <xsl:with-param name="type" select="'scr'"/> -->
                              </xsl:call-template>
                        </xsl:element>
                  </xsl:if>
            </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="bodyx">
            <xsl:apply-templates select="$body" mode="fix"/>
      </xsl:variable>
      <!-- <xsl:variable name="alltext2" select="translate(f:replace-array($alltext,$replace-array,1,'='),'&lt;&gt;&#13;','{}')"/> -->
      <xsl:template match="/">
            <xsl:result-document href="{f:file2uri(concat($projectpath,'\xml\body.xml'))}" format="xml">
                  <!-- This is not need except to validate the data in the variable -->
                  <body>
                        <xsl:sequence select="$bodyx"/>
                        <xsl:sequence select="$note"/>
                  </body>
            </xsl:result-document>
            <xsl:element name="data">
                  <xsl:apply-templates select="$bodyx/usx"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="note">
            <xsl:variable name="noteseq" select="count(preceding::note) + 1"/>
            <xsl:copy>
                  <xsl:apply-templates select="$note/notes/note[number($noteseq)]/@*"/>
                  <xsl:apply-templates select="$note/notes/note[number($noteseq)]/node()" mode="note"/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="remove" mode="note"/>
      <xsl:template match="text()" mode="note">
            <char style="ft" closed="false">
                  <xsl:value-of select="."/>
            </char>
      </xsl:template>
      <xsl:template match="char" mode="note">
            <xsl:copy>
                  <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
      </xsl:template>
      <xsl:template name="book">
            <xsl:param name="book"/>
            <xsl:param name="type"/>
            <xsl:param name="text"/>
            <xsl:variable name="para" select="tokenize($text,'\n?@')"/>
            <!--<xsl:value-of select="$text"/>
            <xsl:value-of select="'&#10;'"/> -->
            <xsl:for-each select="$para[position() gt 1]">
                  <xsl:variable name="line" select="replace(.,'\r?\n',' ')"/>
                  <xsl:call-template name="para">
                        <xsl:with-param name="line" select="$line"/>
                        <xsl:with-param name="type" select="$type"/>
                  </xsl:call-template>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="para">
            <xsl:param name="line"/>
            <xsl:param name="type"/>
            <!-- The following line had a space changed to a \s to handle a CR LF there instead of a space that is commonly found, working better 2014-12-02s  -->
            <xsl:variable name="para-seperator" select="' =\s{0,2}'"/>
            <xsl:variable name="part" select="tokenize($line,$para-seperator)"/>
            <xsl:variable name="paralabel" select="upper-case(translate($part[1],' ','_'))"/>
            <xsl:variable name="paratext" select="normalize-space($part[2])"/>
            <xsl:choose>
                  <!-- don't output empty paragraphs -->
                  <xsl:when test="string-length($part[2]) = 0"/>
                  <xsl:when test="$paralabel = $unwanted-para"/>
                  <xsl:when test="$paralabel = $intropara-key and $type = 'intro'">
                        <xsl:call-template name="elementwriter">
                              <xsl:with-param name="elem" select="'para'"/>
                              <xsl:with-param name="style" select="f:keyvalue($intropara,$paralabel)"/>
                              <xsl:with-param name="text" select="$paratext"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$paralabel = $c">
                        <xsl:call-template name="elementwriter">
                              <xsl:with-param name="elem" select="'chapter'"/>
                              <xsl:with-param name="style" select="'c'"/>
                              <xsl:with-param name="attrib1" select="'number'"/>
                              <xsl:with-param name="value1" select="f:removetags($paratext)"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$paralabel = $h">
                        <!-- get the header -->
                        <xsl:call-template name="elementwriter">
                              <xsl:with-param name="elem" select="'para'"/>
                              <xsl:with-param name="style" select="'h'"/>
                              <xsl:with-param name="text" select="$paratext"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="$paralabel = $fnote">
                        <!-- get the header -->
                        <xsl:call-template name="elementwriter">
                              <xsl:with-param name="elem" select="'note'"/>
                              <xsl:with-param name="style" select="'f'"/>
                              <xsl:with-param name="attrib1" select="'caller'"/>
                              <xsl:with-param name="value1" select="'+'"/>
                              <xsl:with-param name="text" select="$paratext"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="f:keyvalue($para-keyvalue,$paralabel) = $paralabel">
                        <xsl:call-template name="elementwriter">
                              <xsl:with-param name="elem" select="'para'"/>
                              <xsl:with-param name="style" select="'unknown'"/>
                              <xsl:with-param name="attrib1" select="'vpp'"/>
                              <xsl:with-param name="value1" select="$paralabel"/>
                              <xsl:with-param name="text" select="$paratext"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:call-template name="elementwriter">
                              <xsl:with-param name="elem" select="'para'"/>
                              <xsl:with-param name="style" select="f:keyvalue($para-keyvalue,$paralabel)"/>
                              <xsl:with-param name="text" select="$paratext"/>
                        </xsl:call-template>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="char">
            <!-- analyze-string template -->
            <xsl:param name="paracontent"/>
            <xsl:choose>
                  <xsl:when test="matches($paracontent,'\{')">
                        <!-- Handles regular markup elements containing { -->
                        <xsl:variable name="part" select="tokenize($paracontent,'\{')"/>
                        <xsl:for-each select="$part">
                              <xsl:variable name="tag" select="tokenize(.,'\}')"/>
                              <xsl:choose>
                                    <xsl:when test="matches(.,'\}')">
                                          <xsl:choose>
                                                <xsl:when test="matches($tag[1],'^$')"/>
                                                <xsl:when test="$tag[1] = $caller-feature and normalize-space($tag[2]) = $caller">
                                                      <!-- matches note caller -->
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'note'"/>
                                                            <xsl:with-param name="style" select="'f'"/>
                                                            <xsl:with-param name="value1" select="$tag[2]"/>
                                                            <xsl:with-param name="attrib1" select="'caller'"/>
                                                      </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $v and matches($tag[2],'^[\-\da-d ]+$')">
                                                      <!-- matches a verse -->
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'verse'"/>
                                                            <xsl:with-param name="style" select="'v'"/>
                                                            <xsl:with-param name="attrib1" select="'number'"/>
                                                            <xsl:with-param name="value1" select="f:removetags($tag[2])"/>
                                                      </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $nd">
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'char'"/>
                                                            <xsl:with-param name="style" select="'nd'"/>
                                                            <xsl:with-param name="attrib1" select="'closed'"/>
                                                            <xsl:with-param name="value1" select="'true'"/>
                                                            <xsl:with-param name="text" select="f:removetags($tag[2])"/>
                                                      </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $keep-text-removetag">
                                                      <xsl:value-of select="$tag[2]"/>
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $callee-feature and normalize-space($tag[2]) = $caller">
                                                      <!-- matches note callee
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'remove'"/>
                                                            <xsl:with-param name="style" select="''"/>
                                                            <xsl:with-param name="attrib1" select="'oldcallee'"/>
                                                            <xsl:with-param name="value1" select="$tag[2]"/>
                                                      </xsl:call-template> -->
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $callee-ref-tag">
                                                      <!-- matches note reference -->
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'char'"/>
                                                            <xsl:with-param name="style" select="'fr'"/>
                                                            <xsl:with-param name="text" select="$tag[2]"/>
                                                            <xsl:with-param name="attrib1" select="'closed'"/>
                                                            <xsl:with-param name="value1" select="'false'"/>
                                                      </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $fq">
                                                      <!-- matches fq tage features -->
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'char'"/>
                                                            <xsl:with-param name="style" select="'fq'"/>
                                                            <xsl:with-param name="attrib1" select="'closed'"/>
                                                            <xsl:with-param name="value1" select="'false'"/>
                                                            <xsl:with-param name="text" select="$tag[2]"/>
                                                      </xsl:call-template>
                                                </xsl:when>
                                                <xsl:when test="$tag[1] = $embedded-par">
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'para'"/>
                                                            <xsl:with-param name="style" select="f:keyvalue($para-keyvalue,$tag[1])"/>
                                                            <xsl:with-param name="text" select="$tag[2]"/>
                                                      </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                      <xsl:call-template name="elementwriter">
                                                            <xsl:with-param name="elem" select="'char'"/>
                                                            <xsl:with-param name="style" select="'unknown'"/>
                                                            <xsl:with-param name="attrib1" select="'tag'"/>
                                                            <xsl:with-param name="value1" select="$tag[1]"/>
                                                            <xsl:with-param name="text" select="$tag[2]"/>
                                                      </xsl:call-template>
                                                </xsl:otherwise>
                                          </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <!-- contains no } closing the tag -->
                                          <xsl:value-of select="."/>
                                    </xsl:otherwise>
                              </xsl:choose>
                        </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                        <!-- no part of the paragaph has a { in it  -->
                        <xsl:value-of select="$paracontent"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="elementwriter">
            <xsl:param name="elem"/>
            <xsl:param name="style"/>
            <xsl:param name="text"/>
            <xsl:param name="attrib1"/>
            <xsl:param name="attrib2"/>
            <xsl:param name="value1"/>
            <xsl:param name="value2"/>
            <xsl:element name="{$elem}">
                  <xsl:if test="$style">
                        <xsl:attribute name="style">
                              <xsl:value-of select="$style"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$attrib1">
                        <xsl:attribute name="{$attrib1}">
                              <xsl:value-of select="$value1"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$attrib2">
                        <xsl:attribute name="{$attrib2}">
                              <xsl:value-of select="$value2"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="string-length(normalize-space($text)) gt 0">
                        <xsl:call-template name="char">
                              <xsl:with-param name="paracontent" select="$text"/>
                        </xsl:call-template>
                  </xsl:if>
            </xsl:element>
      </xsl:template>
      <xsl:function name="f:vpimport">
            <xsl:param name="bk"/>
            <!-- change < char to { and > to } and remove carriage return characters -->
            <xsl:value-of select="translate(f:replace-array(unparsed-text($bk),$replace-array,1,'='),'&lt;&gt;&#13;','{}')"/>
      </xsl:function>
      <xsl:function name="f:case">
            <xsl:param name="case"/>
            <xsl:param name="text"/>
            <xsl:choose>
                  <xsl:when test="$case = 'LC'">
                        <xsl:value-of select="lower-case($text)"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="upper-case($text)"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:function>
</xsl:stylesheet>
