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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:param name="textfile"/>
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

~​~​~ {.note}
This is a note.

This paragraph is inside a note.
~​~​~

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
---------------------
'"/>
      <xsl:template match="/">
            <xsl:variable name="div" select="tokenize($string,'~~~')"/>
            <!-- Parse div elements -->
            <xsl:for-each select="$div">
                  <xsl:variable name="divpos" select="position()"/>
                  <xsl:variable name="para" select="tokenize(.,'\n\r?\n')"/>
                  <!-- Parse para elements -->
                  <xsl:choose>
                        <xsl:when test="round($divpos div 2) = $divpos div 2">
                              <xsl:element name="div">
                                    <xsl:if test="matches($para[1],'\{.+\}')">
                                          <xsl:call-template name="class">
                                                <xsl:with-param name="pstring" select="$para[1]"/>
                                          </xsl:call-template>
                                    </xsl:if>
                                    <xsl:for-each select="$para">
                                          <xsl:call-template name="para">
                                                <xsl:with-param name="pstring" select="."/>
                                          </xsl:call-template>
                                    </xsl:for-each>
                              </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:for-each select="$para">
                                    <xsl:call-template name="para">
                                          <xsl:with-param name="pstring" select="."/>
                                    </xsl:call-template>
                              </xsl:for-each>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="para">
            <xsl:param name="pstring"/>
            <xsl:choose>
                  <xsl:when test="matches($pstring,'^#+ ')">
                        <xsl:call-template name="header">
                              <xsl:with-param name="pstring" select="."/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($pstring,'^[0-9\*]')">
                        <xsl:call-template name="list">
                              <xsl:with-param name="pstring" select="."/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($pstring,'^~{3}')">
                        <xsl:call-template name="code">
                              <xsl:with-param name="pstring" select="."/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($pstring,'^-{3}')">
                        <xsl:call-template name="hr">
                              <xsl:with-param name="pstring" select="."/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($pstring,'^-{4,}')">
                        <xsl:call-template name="table">
                              <xsl:with-param name="pstring" select="."/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="p">
                              <xsl:call-template name="class">
                                    <xsl:with-param name="pstring" select="."/>
                              </xsl:call-template>
                              <xsl:call-template name="inline">
                                    <xsl:with-param name="pstring" select="."/>
                              </xsl:call-template>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="header">
            <xsl:param name="pstring"/>
            <xsl:variable name="hashes" select="tokenize($pstring,' ')[1]"/>
            <xsl:variable name="hcount" select="string-length($hashes)"/>
            <xsl:element name="h{$hcount}">
                  <xsl:call-template name="inline">
                        <xsl:with-param name="pstring" select="substring-after(.,concat($hashes,' '))"/>
                  </xsl:call-template>
            </xsl:element>
      </xsl:template>
      <xsl:template name="list">
            <xsl:param name="pstring"/>
            <xsl:variable name="line" select="tokenize($pstring,'\r?\n')"/>
            <xsl:choose>
                  <xsl:when test="matches($pstring,'^\*')">
                        <xsl:element name="ul">
                              <xsl:for-each select="$line">
                                    <xsl:variable name="trimmed" select="substring-after(.,'*')"/>
                                    <xsl:element name="li">
                                          <xsl:call-template name="inline">
                                                <xsl:with-param name="pstring" select="$trimmed"/>
                                          </xsl:call-template>
                                    </xsl:element>
                              </xsl:for-each>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="ol">
                              <xsl:for-each select="$line">
                                    <xsl:variable name="trimmed" select="replace(.,'^[0-9]+ ?','')"/>
                                    <xsl:element name="li">
                                          <xsl:call-template name="inline">
                                                <xsl:with-param name="pstring" select="$trimmed"/>
                                          </xsl:call-template>
                                    </xsl:element>
                              </xsl:for-each>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="inline">
            <xsl:param name="pstring"/>
      </xsl:template>
      <xsl:template name="code">
            <xsl:param name="pstring"/>
      </xsl:template>
      <xsl:template name="table">
            <xsl:param name="pstring"/>
      </xsl:template>
      <xsl:template name="hr">
            <xsl:param name="pstring"/>
      </xsl:template>
      <xsl:template name="class">
            <xsl:param name="pstring"/>
            <xsl:variable name="idclasses" select="tokenize($pstring,'\{|\}')"/>
            <xsl:variable name="idclass" select="tokenize($idclasses[2],'#|\.|;')"/>
            <xsl:for-each select="$idclass">
                  <xsl:variable name="idpos" select="position()"/>
                  <xsl:variable name="prevpos" select="number($idpos) -1"/>
                 
                  <xsl:variable name="marker">
                        <xsl:choose>
                              <xsl:when test="$prevpos = 0">
                                    <xsl:value-of select="substring-before($idclasses[2],.)"/>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:value-of select="substring-after(substring-before($idclasses[2],.),$idclass[$prevpos])"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:variable>
                  <xsl:attribute name="{if ($marker = '#') then 'id' else if ($marker = ';') then 'style' else 'class'}">
                        <xsl:value-of select="."/>
                  </xsl:attribute>
            </xsl:for-each>
      </xsl:template>
</xsl:stylesheet>
