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
            <xsl:variable name="id" select="concat(lx,hm)"/>
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
                  <xsl:if test="hm">
                        <xsl:attribute name="order">
                              <xsl:value-of select="hm"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:element name="lexical-unit">
                        <xsl:apply-templates select="lx|vr"/>
                  </xsl:element>
                  <xsl:apply-templates select="*[local-name() = $top-level-node]">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
            <xsl:apply-templates select="seGroup">
                  <!-- Create the se as separate entries -->
                  <xsl:with-param name="pos" select="$pos"/>
                  <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="*[local-name() = $pos-group]">
            <xsl:param name="pos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="pspos" select="count(preceding-sibling::psGroup) + 1"/>
            <xsl:element name="sense">
                  <xsl:attribute name="id">
                        <xsl:value-of select="concat('lx',$pos,'ps',$pspos)"/>
                  </xsl:attribute>
                  <xsl:attribute name="order">
                        <xsl:value-of select="$pspos"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="ps"/>
                  <xsl:apply-templates select="*[local-name() = $gloss-element]"/>
                  <xsl:apply-templates select="*[local-name() =$second-level-node]">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="pspos" select="$pspos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="$secaller"/>
                        <xsl:with-param name="insn" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
      </xsl:template>
      <xsl:template match="seGroup">
            <xsl:param name="pos"/>
            <xsl:param name="pspos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="sepos" select="count(preceding-sibling::seGroup) + 1"/>
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
                                    <xsl:value-of select="concat('lx',$pos,'se',$sepos)"/>
                              </xsl:attribute>
                              <xsl:element name="lexical-unit">
                                    <xsl:apply-templates select="se|vr"/>
                              </xsl:element>
                              <xsl:apply-templates select="*[local-name() = $second-level-node]">
                                    <xsl:with-param name="inse" select="'true'"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[name() = $form-element]">
            <!-- These are all the elements that use the form@lang with text inside. Note lont is an irregular field should be vr -->
            <xsl:choose>
                  <xsl:when test="local-name() = 'va'">
                        <xsl:element name="variant">
                              <xsl:call-template name="form">
                                    <xsl:with-param name="lang" select="f:keyvalue($element-lang,name())"/>
                                    <xsl:with-param name="text" select="."/>
                              </xsl:call-template>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:call-template name="form">
                              <xsl:with-param name="lang" select="f:keyvalue($element-lang,name())"/>
                              <xsl:with-param name="text" select="."/>
                        </xsl:call-template>
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
      <xsl:template match="xvGroup">
            <xsl:element name="example">
                  <xsl:apply-templates select="xv"/>
                  <xsl:element name="translation">
                        <xsl:apply-templates select="xn|xe|xr"/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = $note-element-key]">
            <note type="{f:keyvalue($note-element,name())}">
                  <form lang="en">
                        <xsl:element name="text">
                              <xsl:value-of select="f:keyvalue($note-value-substitute,.)"/>
                        </xsl:element>
                  </form>
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
                                    <xsl:value-of select="concat('lx',$pos,'ps0')"/>
                              </xsl:attribute>
                              <xsl:apply-templates/>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="sn"/>
      <!--  Custom fields start ======================== -->
      <xsl:template match="lf">
            <relation type="{f:keyvalue($relation-element,.)}" ref="{following-sibling::lv[1]}"/>
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
                                          <form lang="en">
                                                <text>English</text>
                                          </form>
                                          <form lang="fr">
                                                <text>anglais</text>
                                          </form>
                                          <form lang="es">
                                                <text>Inglés</text>
                                          </form>
                                          <form lang="pt">
                                                <text>Inglês</text>
                                          </form>
                                          <form lang="bg">
                                                <text>английски</text>
                                          </form>
                                          <form lang="rw">
                                                <text>Icyongereza</text>
                                          </form>
                                          <form lang="id">
                                                <text>Bahasa Inggris</text>
                                          </form>
                                          <form lang="zh-CHT">
                                                <text>英文</text>
                                          </form>
                                          <form lang="zh-CHS">
                                                <text>英文</text>
                                          </form>
                                          <form lang="km">
                                                <text>អង់គ្លេស</text>
                                          </form>
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
