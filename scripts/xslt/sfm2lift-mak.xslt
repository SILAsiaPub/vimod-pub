<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         sfm2lift-mak.xslt
    # Purpose:	convert SFM directly to LIFT for use in DAB
    # Part of:      Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2017-02-22
    # Copyright:    (c) 2017 SIL International
    # Licence:      <MIT>
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
            <xsl:variable name="id" select="concat(lx,'_',hm)"/>
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
                        <xsl:value-of select="concat(lx,'_',hm)"/>
                  </xsl:attribute>
                  <xsl:if test="hm">
                        <xsl:attribute name="order">
                              <xsl:value-of select="hm"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:element name="lexical-unit">
                        <xsl:apply-templates select="lx|vr"/>
                  </xsl:element>
                  <xsl:if test="va">
                        <xsl:element name="variant">
                              <xsl:apply-templates select="va"/>
                        </xsl:element>
                  </xsl:if>
                  <xsl:apply-templates select="bw|lf|cf"/>
                  <xsl:apply-templates select="psGroup">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
            <xsl:apply-templates select="psGroup/seGroup">
                  <!-- Create the se as separate entries -->
                  <xsl:with-param name="pos" select="$pos"/>
                  <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="*[name() = $form-element]">
            <!-- These are all the elements that use the form@lang with text inside. Note lont is an irregular field should be vr -->
            <xsl:call-template name="form">
                  <xsl:with-param name="lang" select="f:keyvalue($element-lang,name())"/>
                  <xsl:with-param name="text" select="."/>
            </xsl:call-template>
      </xsl:template>
      <xsl:template match="psGroup">
            <xsl:param name="pos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="pspos" select="count(preceding-sibling::psGroup) + 1"/>
            <xsl:element name="sense">
                  <xsl:attribute name="id">
                        <xsl:value-of select="concat('lx',$pos,'ps',$pspos)"/>
                  </xsl:attribute>
                  <xsl:apply-templates>
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="pspos" select="$pspos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="$secaller"/>
                  </xsl:apply-templates>
            </xsl:element>
      </xsl:template>
      <xsl:template match="seGroup">
            <xsl:param name="pos"/>
            <xsl:param name="pspos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="sepos" select="count(preceding-sibling::seGroup) + 1"/>
            <xsl:choose>
                  <xsl:when test="$secaller = $true">
                        <xsl:element name="relation">
                              <xsl:attribute name="type">
                                    <xsl:text>subentry</xsl:text>
                              </xsl:attribute>
                              <xsl:attribute name="ref">
                                    <xsl:value-of select="concat(se,'_')"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="entry">
                              <xsl:attribute name="id">
                                    <xsl:value-of select="concat(se,'_')"/>
                              </xsl:attribute>
                              <xsl:attribute name="guid">
                                    <xsl:value-of select="concat('lx',$pos,'ps',$pspos,'se',$sepos)"/>
                              </xsl:attribute>
                              <xsl:element name="lexical-unit">
                                    <xsl:apply-templates select="se|vr"/>
                              </xsl:element>
                              <xsl:if test="va">
                                    <xsl:element name="variant">
                                          <xsl:apply-templates select="va"/>
                                    </xsl:element>
                              </xsl:if>
                              <xsl:apply-templates select="psGroup|lf|lv|le|bw|cf"/>
                        </xsl:element>
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
      <!--  Custom fields start ======================== -->
      <xsl:template match="lf">
            <relation type="{.}" ref="{concat(following-sibling::lv[1],'_')}"/>
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
      <!-- <xsl:template match="bw">
            <xsl:element name="note-key">
                  <xsl:value-of select="$note-element-key"/>
            </xsl:element>
            <xsl:element name="note">
                  <xsl:value-of select="$note-element"/>
            </xsl:element>
            <xsl:element name="note-value">
                  <xsl:value-of select="$note-value-substitute"/>
            </xsl:element>
      </xsl:template> -->
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
                              <range-element id="mak">
                                    <label>
                                          <form lang="en">
                                                <!-- <xsl:element name="text"> -->
                                                <text>MANGKASARA</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                    </label>
                                    <abbrev>
    </abbrev>
                              </range-element>
                              <range-element id="bug">
                                    <label>
                                          <form lang="en">
                                                <!-- <xsl:element name="text"> -->
                                                <text>Buginese</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                    </label>
                                    <abbrev>
    </abbrev>
                              </range-element>
                              <range-element id="id">
                                    <label>
                                          <form lang="en">
                                                <!-- <xsl:element name="text"> -->
                                                <text>Indonesian</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                    </label>
                                    <abbrev>
    </abbrev>
                              </range-element>
                              <range-element id="en">
                                    <label>
                                          <form lang="en">
                                                <!-- <xsl:element name="text"> -->
                                                <text>English</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="fr">
                                                <!-- <xsl:element name="text"> -->
                                                <text>anglais</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="es">
                                                <!-- <xsl:element name="text"> -->
                                                <text>Inglés</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="pt">
                                                <!-- <xsl:element name="text"> -->
                                                <text>Inglês</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="bg">
                                                <!-- <xsl:element name="text"> -->
                                                <text>английски</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="rw">
                                                <!-- <xsl:element name="text"> -->
                                                <text>Icyongereza</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="id">
                                                <!-- <xsl:element name="text"> -->
                                                <text>Bahasa Inggris</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="zh-CHT">
                                                <!-- <xsl:element name="text"> -->
                                                <text>英文</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="zh-CHS">
                                                <!-- <xsl:element name="text"> -->
                                                <text>英文</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                          <form lang="km">
                                                <!-- <xsl:element name="text"> -->
                                                <text>អង់គ្លេស</text>
                                                <!-- </xsl:element> -->
                                          </form>
                                    </label>
                                    <abbrev>
    </abbrev>
                              </range-element>
                        </range>
                  </ranges>
            </header>
      </xsl:template>
</xsl:stylesheet>
