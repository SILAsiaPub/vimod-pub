<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		inc-dict-sfm2lift.xslt
    # Purpose:		for inclusion in custom xslts.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-03-29
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <!-- Start common templates ============================= -->
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
                  <xsl:apply-templates select="*">
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
            <xsl:variable name="refid" select="concat($id,'.',$sepos)"/>
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
                              <xsl:apply-templates select="*">
                                    <xsl:with-param name="inse" select="'true'"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[local-name() = $subsense-group-node]">
            <xsl:param name="pos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="pspos" select="count(preceding-sibling::*[local-name() = $subsense-group-node]) + 1"/>
            <xsl:element name="sub-sense">
                  <xsl:attribute name="id">
                        <xsl:value-of select="concat('lx',$pos,'ps',$pspos)"/>
                  </xsl:attribute>
                  <xsl:attribute name="order">
                        <xsl:value-of select="$pspos"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="*">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="pspos" select="$pspos"/>
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="secaller" select="$secaller"/>
                        <xsl:with-param name="insn" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $form-node]">
            <!-- These are all the elements that use the form@lang with text inside. Note lont is an irregular field should be vr -->
            <xsl:comment select="local-name()"/>
            <xsl:choose>
                  <xsl:when test="local-name() = $form-host-node-key">
                        <xsl:element name="{f:keyvalue($form-host-node,local-name())}">
                              <xsl:if test="local-name() ne f:keyvalue($form-host-attrib-name,local-name())">
                                    <xsl:attribute name="{f:keyvalue($form-host-attrib-name,local-name())}">
                                          <xsl:value-of select="f:keyvalue($form-host-attrib-value,local-name())"/>
                                    </xsl:attribute>
                              </xsl:if>
                              <form lang="{f:keyvalue($node-lang,name())}">
                                    <xsl:element name="text">
                                          <xsl:choose>
                                                <xsl:when test="local-name() = 'lx'">
                                                      <xsl:value-of select="translate(.,'.','')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                      <xsl:apply-templates/>
                                                </xsl:otherwise>
                                          </xsl:choose>
                                    </xsl:element>
                              </form>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <form lang="{f:keyvalue($node-lang,name())}">
                              <xsl:element name="text">
                                    <xsl:apply-templates/>
                              </xsl:element>
                        </form>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="local-name() = $addcitation and matches(.,'\d$')">
                  <xsl:variable name="word" select="replace(.,'\d$','')"/>
                  <xsl:variable name="hom" select="replace(.,'^.+(\d)$','$1')"/>
                  <xsl:element name="citation">
                        <form lang="{f:keyvalue($node-lang,name())}">
                              <xsl:element name="text">
                                    <xsl:value-of select="$word"/>
                                    <span class="entry-homonym-index">
                                          <xsl:value-of select="$hom"/>
                                    </span>
                              </xsl:element>
                        </form>
                  </xsl:element>
            </xsl:if>
            <xsl:if test="local-name() = $autoreversal">
                  <reversal type="{f:keyvalue($node-lang,local-name())}">
                        <form lang="{f:keyvalue($node-lang,local-name())}">
                              <xsl:element name="text">
                                    <xsl:value-of select="."/>
                              </xsl:element>
                        </form>
                  </reversal>
            </xsl:if>
      </xsl:template>
      <xsl:template match="*[name() = $non-form-node-key]">
            <xsl:comment select="local-name()"/>
            <xsl:element name="{f:keyvalue($non-form-node,name())}">
                  <xsl:attribute name="lang">
                        <xsl:value-of select="f:keyvalue($node-lang,name())"/>
                  </xsl:attribute>
                  <xsl:element name="text">
                        <xsl:apply-templates/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = $trait-element]">
            <xsl:comment select="local-name()"/>
            <xsl:element name="trait">
                  <xsl:attribute name="name">
                        <xsl:value-of select="f:keyvalue($trait-name-attrib-value,local-name())"/>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                        <xsl:value-of select="."/>
                  </xsl:attribute>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $simple-group-key]">
            <xsl:comment select="local-name()"/>
            <xsl:element name="{f:keyvalue($simple-group,local-name())}">
                  <xsl:if test="local-name() = $simple-group-attrib-name-key">
                        <xsl:attribute name="{f:keyvalue($simple-group-attrib-name,local-name())}">
                              <xsl:value-of select="f:keyvalue($simple-group-attrib-value,local-name())"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="ps">
            <grammatical-info value="{f:keyvalue($ps-value-substituite,.)}"/>
      </xsl:template>
      <!-- <xsl:template match="*[local-name() = $example-group-node]">
            <xsl:element name="example">
                  <xsl:apply-templates select="*[local-name() = $example-vern-node]"/>
                  <xsl:element name="translation">
                        <xsl:apply-templates select="*[local-name() = $example-trans-node]"/>
                  </xsl:element>
            </xsl:element>
      </xsl:template> -->
      <xsl:template match="*[name() = $relation-node-key]">
            <xsl:comment select="local-name()"/>
            <relation type="{f:keyvalue($relation-node,name())}" ref="{.}"/>
      </xsl:template>
      <xsl:template match="span">
            <xsl:copy>
                  <xsl:attribute name="class">
                        <xsl:value-of select="@class"/>
                  </xsl:attribute>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
      <!-- Unhandled fields ============================== -->
      <xsl:template match="*">
            <xsl:element name="xxxxxxxxxxxxxxxxxxxxxxx">
                  <xsl:element name="{name()}">
                        <xsl:apply-templates/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
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
