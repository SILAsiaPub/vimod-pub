<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		Parse Rho markup.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    # Issues: 		heirachy in lists not handled
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns:xs="http://www.w3.org/2001/XMLSchema">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:param name="textfile" select="'D:\All-SIL-Publishing\dev\rho-sample.txt'"/>
      <xsl:variable name="all" select="f:file2text($textfile)"/>
      <xsl:template match="/">
            <xsl:variable name="string2" select="replace($all,'\r?\n\r?\n','%%%')"/>
            <xsl:variable name="div" select="tokenize($string2,'~~~')"/>
            <xsl:for-each select="$div">
                  <!-- <xsl:comment select="round(position() div 2) = position() div 2"/> -->
                  <xsl:call-template name="section">
                        <xsl:with-param name="part" select="."/>
                        <xsl:with-param name="seq" select="position()"/>
                  </xsl:call-template>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="section">
            <xsl:param name="part"/>
            <xsl:param name="seq"/>
            <xsl:variable name="topline" select="tokenize($part,'\r?\n')[1]"/>
            <xsl:variable name="attribute" select="replace($topline,'.*\{.+\}.*','$1')"/>
            <xsl:variable name="para" select="tokenize($part,'%%%')"/>
            <xsl:choose>
                  <xsl:when test="round($seq div 2) = $seq div 2">
                        <xsl:element name="div">
                              <xsl:sequence select="f:attribute($attribute)"/>
<xsl:comment select="$attribute"/>
                              <xsl:for-each select="$para">
                                    <!-- <xsl:comment select="."/> -->
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:call-template name="block">
                                          <xsl:with-param name="pstring" select="."/>
                                          <xsl:with-param name="seq" select="position()"/>
                                    </xsl:call-template>
                              </xsl:for-each>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:for-each select="$para">
                              <!-- <xsl:comment select="."/> -->
                              <xsl:text>&#10;</xsl:text>
                              <xsl:call-template name="block">
                                    <xsl:with-param name="pstring" select="."/>
                                    <xsl:with-param name="seq" select="position()"/>
                              </xsl:call-template>
                        </xsl:for-each>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="block">
            <xsl:param name="pstring"/>
            <xsl:param name="seq"/>
            <!-- remove attribute braces if first in-->
            <xsl:variable name="newpstring" select="if ($seq = 1) then replace($pstring,'^\{[^\}]+\}','') else $pstring"/>
            <xsl:variable name="attribute" select="replace($newpstring,'.*\{.+\}.*','$1')"/>
            <xsl:variable name="cleanpstring" select="replace($newpstring,'\{.+\}','')"/>
            <!-- <xsl:variable name="cleanpstring" select="replace($cleantopline,$topline,$cleantopline)"/> -->
            <!-- <xsl:variable name="newpstring" select="replace($pstring,'^\{[^\}]+\}','')"/> -->
            <!-- <xsl:variable name="pline" select="tokenize($newpstring,'\r?\n')"/> -->
            <!-- <xsl:comment select="'para'"/> -->
            <xsl:text>&#10;</xsl:text>
            <xsl:choose>
                  <xsl:when test="matches($cleanpstring,'^#+ ')">
                        <xsl:call-template name="header">
                              <xsl:with-param name="pstring" select="$cleanpstring"/>
                              <xsl:with-param name="attribute" select="$attribute"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($cleanpstring,'^[0-9\*]')">
                        <xsl:call-template name="list">
                              <xsl:with-param name="pstring" select="$cleanpstring"/>
                              <xsl:with-param name="attribute" select="$attribute"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($cleanpstring,'^~{3}')">
                        <xsl:call-template name="code">
                              <xsl:with-param name="pstring" select="$cleanpstring"/>
                              <xsl:with-param name="attribute" select="$attribute"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($cleanpstring,'^-{3}')">
                        <xsl:call-template name="hr">
                              <xsl:with-param name="pstring" select="$cleanpstring"/>
                              <xsl:with-param name="attribute" select="$attribute"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($cleanpstring,'^-{4,}')">
                        <xsl:call-template name="table">
                              <xsl:with-param name="pstring" select="$cleanpstring"/>
                              <xsl:with-param name="attribute" select="$attribute"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="p">
                              <xsl:sequence select="f:attribute($attribute)"/>
                              <xsl:value-of select="f:parse-string(f:removeattrib($cleanpstring))"/>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="header">
            <xsl:param name="pstring"/>
            <xsl:param name="attribute"/>
            <xsl:variable name="hash" select="substring-before($pstring,' ')"/>
            <xsl:variable name="data" select="substring-after($pstring,' ')"/>
            <xsl:variable name="hcount" select="string-length($hash)"/>
            <xsl:element name="h{$hcount}">
                  <xsl:sequence select="f:attribute($attribute)"/>
                  <xsl:value-of select="f:parse-string($data)"/>
            </xsl:element>
      </xsl:template>
      <xsl:template name="list">
            <xsl:param name="pstring"/>
            <xsl:param name="attribute"/>
            <xsl:variable name="line" select="tokenize($pstring,'\r?\n')"/>
            <xsl:choose>
                  <xsl:when test="matches($pstring,'^\*')">
                        <xsl:element name="ul">
                              <xsl:for-each select="$line">
                                    <xsl:variable name="trimmed" select="substring-after(.,'*')"/>
                                    <xsl:element name="li">
                                          <xsl:value-of select="f:parse-string($pstring)"/>
                                    </xsl:element>
                              </xsl:for-each>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="ol">
                              <xsl:for-each select="$line">
                                    <xsl:variable name="trimmed" select="replace(.,'^[0-9]+ ?','')"/>
                                    <xsl:element name="li">
                                          <xsl:value-of select="f:parse-string($pstring)"/>
                                    </xsl:element>
                              </xsl:for-each>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="code">
            <xsl:param name="pstring"/>
            <xsl:param name="attribute"/>
      </xsl:template>
      <xsl:template name="table">
            <xsl:param name="pstring"/>
            <xsl:param name="attribute"/>
      </xsl:template>
      <xsl:template name="hr">
            <xsl:param name="pstring"/>
            <xsl:param name="attribute"/>
            <xsl:element name="hr">

</xsl:element>
      </xsl:template>
      <xsl:function name="f:attribute" as="node()*">
            <xsl:param name="attrib-string"/>
            <!-- remove serial attrib markup -->
            <xsl:variable name="att1" select="replace($attrib-string,'\} *\{','')"/>
            <!-- put space before each attrib -->
            <xsl:variable name="att2" select="replace($att1,'(#|\.|;)',' $1')"/>
            <xsl:variable name="attrib" select="tokenize($att1,'\s+')"/>
            <xsl:for-each select="$attrib">
                  <xsl:if test="matches(.,'^#')">
                        <xsl:variable name="word" select="substring(.,2)"/>
                        <xsl:attribute name="id">
                              <xsl:value-of select="$word"/>
                        </xsl:attribute>
                  </xsl:if>
            </xsl:for-each>
            <xsl:if test="matches($att2,'\.')">
                  <xsl:attribute name="class">
                        <xsl:for-each select="$attrib">
                              <xsl:if test="matches(.,'^\.')">
                                    <xsl:variable name="word" select="substring-after(.,'.')"/>
                                    <xsl:value-of select="$word"/>
                                    <xsl:if test="not(last() = position())">
                                          <xsl:text> </xsl:text>
                                    </xsl:if>
                              </xsl:if>
                        </xsl:for-each>
                  </xsl:attribute>
            </xsl:if>
            <xsl:if test="matches($att2,';')">
                  <xsl:attribute name="style">
                        <xsl:for-each select="$attrib">
                              <xsl:if test="matches(.,'^;')">
                                    <xsl:variable name="word" select="substring(.,2)"/>
                                    <xsl:value-of select="$word"/>
                                    <xsl:text>;</xsl:text>
                              </xsl:if>
                        </xsl:for-each>
                  </xsl:attribute>
            </xsl:if>
      </xsl:function>
      <xsl:function name="f:parse-string" as="node()*">
            <xsl:param name="pS" as="xs:string"/>
            <xsl:analyze-string select="$pS" flags="x" regex='(__(.*?)__)  |   (\*(.*?)\*)  |   ("(.*?)"\[(.*?)\]) | (\*\*(.*?)\*\*)'>
                  <xsl:matching-substring>
                        <xsl:choose>
                              <xsl:when test="regex-group(1)">
                                    <strong>
                                          <xsl:sequence select="f:parse-string(regex-group(2))"/>
                                    </strong>
                              </xsl:when>
                              <xsl:when test="regex-group(8)">
                                    <strong>
                                          <xsl:sequence select="f:parse-string(regex-group(9))"/>
                                    </strong>
                              </xsl:when>
                              <xsl:when test="regex-group(3)">
                                    <span>
                                          <xsl:sequence select="f:parse-string(regex-group(4))"/>
                                    </span>
                              </xsl:when>
                              <xsl:when test="regex-group(5)">
                                    <a href="{regex-group(7)}">
                                          <xsl:sequence select="regex-group(6)"/>
                                    </a>
                              </xsl:when>
                        </xsl:choose>
                  </xsl:matching-substring>
                  <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                  </xsl:non-matching-substring>
            </xsl:analyze-string>
      </xsl:function>
      <xsl:function name="f:removeattrib">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,'^\{[^\}]+\}','')"/>
      </xsl:function>
      <xsl:variable name="string" select="'
## Section title

First paragraph.

Second
paragraph.

Third paragraph.

{#id.class1.class2}
Paragraph with id and some classes.

Paragraph with id {#id.class1.class2}
and some classes.

`​`​`
&lt;a href=''&gt;Load more&lt;/a&gt;
`​`​`

~~~ {.note}
This is a note.

This paragraph is inside a note.
~~~

* List item 1
* List item 2
* List item 3

1. List item 1
2. List item 2
3. List item 3

* List item 1

* List item 2

  Still list item 2, just another paragraph

* List item 3

* List item 1

  * Sub-list inside list item 1

    * Sub-sub-list
    * Sub-sub-list
    * Sub-sub-list

  * Sub-list inside list item 1, second sub-item

* List item 2

* List item 1   {.ul}{.li}{.p}

  Para          {.p}

* List item 2   {.li}{.p}

  Para          {.p}

* List item 1   {}{}{.p}

  Para          {.p}

* List item 2   {}{.p}

  Para          {.p}

--- {.clear}

--- One | Two | Three

---------------------
 One  | Two  | Three
 Four | Five | Six
---------------------

-----------------------
| Col1 | Col2 | Col3  |
|:-----|:----:|------:|
| One  | Two  | Three |
| Four | Five | Six   |
-----------------------

--------------------&gt;
 Col1 | Col2 | Col3
---------------------
 One  | Two  | Three
 Four | Five | Six
---------------------

---------------------      {.rows.cols.striped}
 Col1 | Col2 | Col3
---------------------
 One  | Two  | Three
 Four | Five | Six
---------------------'"/>
</xsl:stylesheet>
