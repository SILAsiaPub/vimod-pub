<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	sfm2lift-mak.xslt
    # Purpose:		convert SFM directly to LIFT for use in DAB
    # Part of:      	Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay@sil.org>
    # Created:      	2017-02-22
    # Copyright:    	(c) 2017 SIL International
    # Licence:      	<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:template match="/*">
            <xsl:element name="lift">
                  <xsl:attribute name="producer">
                        <xsl:text>Vimod-Pub SFM2LIFT</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="version">
                        <xsl:text>0.1</xsl:text>
                  </xsl:attribute>
                  <xsl:call-template name="header"/>
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="lxGroup">
            <xsl:variable name="pos" select="count(preceding-sibling::lxGroup) + 1"/>
            <xsl:variable name="id" select="lx"/>
            <xsl:variable name="lx" select="replace(lx,'\d$','')"/>
            <xsl:variable name="homonym">
                  <xsl:choose>
                        <xsl:when test="matches(lx,'\d$')">
                              <xsl:value-of select="replace(lx,'.+(\d)$','$1')"/>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:variable>
            <xsl:element name="entry">
                  <xsl:attribute name="dateCreated">
                        <xsl:value-of select="current-dateTime()"/>
                  </xsl:attribute>
                  <xsl:attribute name="dateModified">
                        <xsl:value-of select="current-dateTime()"/>
                  </xsl:attribute>
                  <xsl:attribute name="guid">
                        <xsl:value-of select="concat('lx',$pos)"/>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                        <!-- <xsl:value-of select="concat(lx,'_',hm,'_','lx',$pos)"/> -->
                        <xsl:value-of select="$id"/>
                  </xsl:attribute>
                  <xsl:if test="matches(lx/text(),'\d$')">
                        <xsl:attribute name="order">
                              <xsl:value-of select="$homonym"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:element name="lexical-unit">
                        <xsl:apply-templates select="lx" mode="lexical-unit"/>
                  </xsl:element>
                  <!-- <xsl:if test="lc">
                        <xsl:element name="citation">
                              <xsl:apply-templates select="lc" mode="citation"/>
                        </xsl:element>
                  </xsl:if> -->
                  <xsl:apply-templates select="*">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
            <xsl:apply-templates select="*[local-name() = $se-group-node]">
                  <!-- Create the se as separate entries -->
                  <xsl:with-param name="pos" select="$pos"/>
                  <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="lx"/>
      <xsl:template match="lx" mode="lexical-unit">
            <xsl:variable name="lx" select="replace(.,'\d$','')"/>
            <!-- <xsl:variable name="homonym" select="replace(.,'.+(\d?)$','$1')"/> -->
            <xsl:variable name="homonym">
                  <xsl:choose>
                        <xsl:when test="matches(.,'\d$')">
                              <xsl:value-of select="replace(.,'.+(\d)$','$1')"/>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:variable>
            <form lang="{f:keyvalue($element-lang,name())}">
                  <xsl:element name="text">
                        <xsl:value-of select="$lx"/>
                  </xsl:element>
            </form>
            <xsl:if test="matches(.,'\d$')">
                  <form lang="numb">
                        <xsl:element name="text">
                               <!-- <span class="homonym"> -->
                                    <xsl:value-of select="$homonym"/>
                               <!-- </span> -->
                        </xsl:element>
                  </form>
            </xsl:if>
      </xsl:template>
      <xsl:template match="lc" mode="citation">
            <xsl:variable name="lx" select="replace(.,'\d$','')"/>
            <xsl:variable name="homonym" select="replace(.,'.+(\d?)$','$1')"/>
            <form lang="{f:keyvalue($element-lang,name())}">
                  <xsl:element name="text">
                        <xsl:value-of select="$lx"/>
                        <sub>
                              <xsl:value-of select="$homonym"/>
                        </sub>
                  </xsl:element>
            </form>
      </xsl:template>
      <xsl:template match="*[local-name() = $pos-group-node]">
            <xsl:param name="pos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="pspos" select="count(preceding-sibling::*[local-name() = $pos-group-node]) + 1"/>
            <xsl:element name="sense">
                  <xsl:attribute name="id">
                        <xsl:value-of select="concat('lx',$pos,'ps',$pspos)"/>
                  </xsl:attribute>
                  <xsl:attribute name="order">
                        <xsl:value-of select="$pspos"/>
                  </xsl:attribute>
                  <!--  <xsl:apply-templates select="ps"/>
                  <xsl:apply-templates select="*[local-name() = $gloss-element]"/>
                  <xsl:apply-templates select="*[local-name() =$second-level-node]"> -->
                  <xsl:apply-templates select="*[local-name() =$second-level-node]">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="pspos" select="$pspos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="$secaller"/>
                        <xsl:with-param name="insn" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $se-group-node]">
            <xsl:param name="pos"/>
            <xsl:param name="pspos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="sepos" select="count(preceding-sibling::*[local-name() = $se-group-node]) + 1"/>
            <xsl:variable name="refid" select="concat(se,$pos,'.',$sepos)"/>
            <xsl:choose>
                  <xsl:when test="$secaller = $true">
                        <xsl:element name="relation">
                              <xsl:attribute name="type">
                                    <xsl:text>subentry</xsl:text>
                              </xsl:attribute>
                              <xsl:attribute name="ref">
                                    <xsl:value-of select="$refid"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="entry">
                              <xsl:attribute name="id">
                                    <xsl:value-of select="$refid"/>
                              </xsl:attribute>
                              <xsl:attribute name="guid">
                                    <xsl:value-of select="concat($id,$pos,'se',$sepos)"/>
                              </xsl:attribute>
                              <xsl:element name="lexical-unit">
                                    <xsl:apply-templates select="*[local-name() = $lexical-node]"/>
                              </xsl:element>
                              <xsl:apply-templates>
                                    <xsl:with-param name="inse" select="'true'"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[name() = $form-element]">
            <!-- These are all the elements that use the form@lang with text inside. Note lont is an irregular field should be vr -->
            <xsl:choose>
                  <xsl:when test="local-name() = $variant-node">
                        <xsl:element name="variant">
                              <form lang="{f:keyvalue($element-lang,name())}">
                                    <xsl:element name="text">
                                          <xsl:apply-templates/>
                                    </xsl:element>
                              </form>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <form lang="{f:keyvalue($element-lang,name())}">
                              <xsl:element name="text">
                                    <xsl:apply-templates/>
                              </xsl:element>
                        </form>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[name() = $gloss-element]">
            <gloss lang="{f:keyvalue($element-lang,name())}">
                  <xsl:element name="text">
                        <xsl:value-of select="."/>
                  </xsl:element>
            </gloss>
      </xsl:template>
      <xsl:template match="*[name() = $definition-group-element]">
            <xsl:element name="definition">
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="ps">
            <grammatical-info value="{f:keyvalue($pos-value-substitute,.)}"/>
      </xsl:template>
      <xsl:template match="*[local-name() = $example-group-node]">
            <xsl:element name="example">
                  <xsl:apply-templates select="*[local-name() = $example-vern-node]"/>
                  <xsl:element name="translation">
                        <xsl:apply-templates select="*[local-name() ne $example-vern-node]"/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = $note-element-key]">
            <note type="{f:keyvalue($note-element,name())}">
                  <xsl:choose>
                        <xsl:when test=". = ''">
                              <xsl:value-of select="f:keyvalue($note-element-empty-meaning,name())"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:apply-templates/>
                        </xsl:otherwise>
                  </xsl:choose>
            </note>
      </xsl:template>
      <xsl:template match="*[name() = $relation-element-key]">
            <relation type="{f:keyvalue($relation-element,name())}" ref="{.}"/>
      </xsl:template>
      <xsl:template match="*[local-name() = $groups2sudo-pos]">
            <xsl:param name="inse"/>
            <xsl:param name="pos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:param name="insn"/>
            <xsl:choose>
                  <xsl:when test="$inse = 'true'">
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="$insn = 'true'">
                        <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="sense">
                              <xsl:attribute name="id">
                                    <xsl:value-of select="concat($id,$pos,'ps0')"/>
                              </xsl:attribute>
                              <xsl:apply-templates/>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <!-- <xsl:template match="*[local-name() = $pos-node]"/> -->
      <!--  Custom fields start ======================== -->
      <xsl:template match="glGroup">
            <definition>
                  <xsl:apply-templates/>
            </definition>
            <xsl:apply-templates mode="reversal"/>
      </xsl:template>
      <xsl:template match="gl">
            <form lang="{f:keyvalue($element-lang,name())}">
                  <text>
                        <xsl:value-of select="translate(.,'*','')"/>
                  </text>
            </form>
      </xsl:template>
      <xsl:template match="gl" mode="reversal">
            <xsl:variable name="word" select="tokenize(.,' ')"/>
            <xsl:comment select="$word"/>
            <xsl:for-each select="$word">
                  <xsl:if test="matches(.,'^.')">
                        <reversal type="eng">
                              <form lang="en">
                                    <xsl:element name="text">
                                          <xsl:value-of select="translate(.,'*','')"/>
                                    </xsl:element>
                              </form>
                        </reversal>
                  </xsl:if>
            </xsl:for-each>
      </xsl:template>
      <xsl:template match="span">
            <xsl:copy>
                  <xsl:attribute name="class">
                        <xsl:value-of select="@class"/>
                  </xsl:attribute>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="coGroup">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="lf">
            <relation type="{f:keyvalue($relation-element,.)}" ref="{following-sibling::*[1]}"/>
      </xsl:template>
      <xsl:template match="lv"/>
      <!-- Custom field end =========================== -->
      <!-- Checking fields ============================== -->
      <xsl:template match="*">
            <xsl:element name="xxxxxxxxxxxxxxxxxxxxxxx">
                  <xsl:element name="{name()}">
                        <xsl:apply-templates/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <!-- Checking fields  end============================== -->
      <!--  Start named templates ============================ -->
      <xsl:template name="form">
            <xsl:param name="lang"/>
            <xsl:param name="text"/>
            <form lang="{$lang}">
                  <xsl:element name="text">
                        <xsl:value-of select="$text"/>
                  </xsl:element>
            </form>
      </xsl:template>
      <xsl:template name="header">
            <header>
                  <ranges>
                        <range id="dialect">
                              <xsl:for-each select="$non-eng-lang-key">
                                    <xsl:call-template name="range-element">
                                          <xsl:with-param name="lang" select="."/>
                                    </xsl:call-template>
                              </xsl:for-each>
                              <range-element id="en">
                                    <label>
                                          <xsl:for-each select="$eng-lang-name-key">
                                                <xsl:call-template name="form">
                                                      <xsl:with-param name="lang" select="."/>
                                                      <xsl:with-param name="text" select="f:keyvalue($eng-lang-name,.)"/>
                                                </xsl:call-template>
                                          </xsl:for-each>
                                    </label>
                                    <abbrev></abbrev>
                              </range-element>
                        </range>
                  </ranges>
            </header>
      </xsl:template>
      <xsl:template name="range-element">
            <xsl:param name="lang"/>
            <xsl:if test="string-length($lang) gt 0">
                  <range-element id="{$lang}">
                        <label>
                              <form lang="en">
                                    <text>
                                          <xsl:value-of select="f:keyvalue($non-eng-lang,$lang)"/>
                                    </text>
                              </form>
                        </label>
                        <abbrev></abbrev>
                  </range-element>
            </xsl:if>
      </xsl:template>
</xsl:stylesheet>
