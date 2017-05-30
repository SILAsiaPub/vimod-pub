<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	sfm2lift-nac.xslt
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
            <xsl:variable name="guid" select="concat('lx',$pos)"/>
            <xsl:variable name="id" select="concat(translate(lx,'.*',''),hm)"/>
            <xsl:variable name="hm">
                  <xsl:choose>
                        <xsl:when test="hm">
                              <xsl:value-of select="hm"/>
                        </xsl:when>
                        <xsl:when test="preceding-sibling::lxGroup/lx[1] = lx">
                              <xsl:value-of select="count(preceding-sibling::lxGroup/lx = lx) +1"/>
                        </xsl:when>
                        <xsl:when test="following-sibling::lxGroup/lx[1] = lx">
                              <xsl:value-of select="1"/>
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
                        <xsl:value-of select="$guid"/>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                        <!-- <xsl:value-of select="concat(lx,'_',hm,'_','lx',$pos)"/> -->
                        <xsl:value-of select="$id"/>
                  </xsl:attribute>
                  <xsl:if test="$hm">
                        <xsl:attribute name="order">
                              <xsl:value-of select="$hm"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="*">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="id" select="$guid"/>
                        <xsl:with-param name="secaller" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
            <xsl:apply-templates select="*/*[local-name() = $subentry-group-node]">
                  <!-- Create the se as separate entries -->
                  <xsl:with-param name="pos" select="$pos"/>
                  <xsl:with-param name="id" select="$guid"/>
            </xsl:apply-templates>
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
      <xsl:template match="*[local-name() = $subentry-group-node]">
            <xsl:param name="pos"/>
            <xsl:param name="pspos"/>
            <xsl:param name="id"/>
            <xsl:param name="secaller"/>
            <xsl:variable name="sepos" select="count(preceding-sibling::*[local-name() = $subentry-group-node]) + 1"/>
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
      <xsl:template match="*[name() = $form-element]">
            <!-- These are all the elements that use the form@lang with text inside. Note lont is an irregular field should be vr -->
            <xsl:choose>
                  <xsl:when test="local-name() = $form-host-node-key">
                        <xsl:element name="{f:keyvalue($form-host-node,local-name())}">
                              <xsl:if test="local-name() ne f:keyvalue($form-host-attrib-name,local-name())">
                                    <xsl:attribute name="{f:keyvalue($form-host-attrib-name,local-name())}">
                                          <xsl:value-of select="f:keyvalue($form-host-attrib-value,local-name())"/>
                                    </xsl:attribute>
                              </xsl:if>
                              <form lang="{f:keyvalue($element-lang,name())}">
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
                        <form lang="{f:keyvalue($element-lang,name())}">
                              <xsl:element name="text">
                                    <xsl:apply-templates/>
                              </xsl:element>
                        </form>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="local-name() = 'lx'">
                  <xsl:element name="citation">
                        <!--<xsl:if test="local-name() ne f:keyvalue($form-host-attrib-name,local-name())">
                                    <xsl:attribute name="{f:keyvalue($form-host-attrib-name,local-name())}">
                                          <xsl:value-of select="f:keyvalue($form-host-attrib-value,local-name())"/>
                                    </xsl:attribute>
                              </xsl:if> -->
                        <form lang="{f:keyvalue($element-lang,name())}">
                              <xsl:element name="text">
                                    <xsl:apply-templates/>
                              </xsl:element>
                        </form>
                  </xsl:element>
            </xsl:if>
      </xsl:template>
      <xsl:template match="*[name() = $non-form-element-key]">
            <xsl:element name="{f:keyvalue($non-form-element,name())}">
                  <xsl:attribute name="lang">
                        <xsl:value-of select="f:keyvalue($element-lang,name())"/>
                  </xsl:attribute>
                  <xsl:element name="text">
                        <xsl:apply-templates/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = $trait-element]">
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
      <xsl:template match="*[local-name() = $example-group-node]">
            <xsl:element name="example">
                  <xsl:apply-templates select="*[local-name() = $example-vern-node]"/>
                  <xsl:element name="translation">
                        <xsl:apply-templates select="*[local-name() = $example-trans-node]"/>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <!--<xsl:template match="*[name() = $note-element-key]">
            <note type="{f:keyvalue($note-element,name())}">
                  <form lang="{f:keyvalue($element-lang,name())}">
                        <xsl:element name="text">
                              <xsl:value-of select="f:keyvalue($note-value-substitute,.)"/>
                        </xsl:element>
                  </form>
            </note>
      </xsl:template> -->
      <xsl:template match="*[name() = $relation-element-key]">
            <relation type="{f:keyvalue($relation-element,name())}" ref="{.}"/>
      </xsl:template>
      <xsl:template match="span">
            <xsl:copy-of select="."/>
      </xsl:template>
      <!-- <xsl:template match="*[local-name() = $groups2sudo-pos]">
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
      <xsl:template match="*[local-name() = $pos-node]"/> -->
      <!--<xsl:template match="lx" mode="lexical-unit">
            <xsl:variable name="lx" select="replace(.,'\d$','')"/>
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
                        <xsl:value-of select="."/>
                        <xsl:if test="following-sibling::hm">
                              <span class="homonym">
                                    <xsl:value-of select="following-sibling::hm"/>
                              </span>
                        </xsl:if>
                  </xsl:element>
            </form>
      </xsl:template>  -->
      <!--  Custom fields start ======================== -->
      <xsl:template match="*[name() = 'sd']">
            <!-- These are all the elements that use the form@lang with text inside. Note lont is an irregular field should be vr -->
            <xsl:choose>
                  <xsl:when test="local-name() = $form-host-node-key">
                        <xsl:element name="{f:keyvalue($form-host-node,local-name())}">
                              <xsl:if test="local-name() ne f:keyvalue($form-host-attrib-name,local-name())">
                                    <xsl:attribute name="{f:keyvalue($form-host-attrib-name,local-name())}">
                                          <xsl:value-of select="f:keyvalue($form-host-attrib-value,local-name())"/>
                                    </xsl:attribute>
                              </xsl:if>
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
            <xsl:element name="reversal">
                  <xsl:attribute name="type">
                        <xsl:text>sdm</xsl:text>
                  </xsl:attribute>
                  <xsl:element name="form">
                        <xsl:attribute name="lang">
                              <xsl:text>sdm</xsl:text>
                        </xsl:attribute>
                        <text>
                              <xsl:value-of select="."/>
                        </text>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = 'bw']">
            <xsl:variable name="source" select="tokenize(.,'; ')"/>
            <xsl:element name="note">
                  <xsl:attribute name="type">
                        <xsl:text>from</xsl:text>
                  </xsl:attribute>
                  <form lang="{f:keyvalue($element-lang,local-name())}">
                        <xsl:element name="text">
                              <xsl:for-each select="$source">
                                    <xsl:variable name="fromlang" select="tokenize(.,' ')[1]"/>
                                    <xsl:variable name="post" select="substring-after(.,' ')"/>
                                    <xsl:if test="position() gt 1">
                                          <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="f:keyvalue($node-value-substitute,$fromlang)"/>
                                    <xsl:text> </xsl:text>
                                    <span class="italic">
                                          <xsl:value-of select="$post"/>
                                    </span>
                              </xsl:for-each>
                        </xsl:element>
                  </form>
            </xsl:element>
      </xsl:template>
      <xsl:template match="pdl">
            <note type="{f:keyvalue($pdl-value-substituite,.)}">
                  <form lang="{f:keyvalue($element-lang,name())}">
                        <xsl:element name="text">
                              <!--<xsl:value-of select=""/>
                              <xsl:text> - </xsl:text> -->
                              <span class="bold">
                                    <xsl:value-of select="following-sibling::*[1]"/>
                              </span>
                        </xsl:element>
                  </form>
            </note>
      </xsl:template>
      <xsl:template match="pdv|sn"/>
      <!--  <xsl:template match="lf">
            <relation type="{f:keyvalue($relation-element,.)}" ref="{following-sibling::*[1]}"/>
      </xsl:template>
      <xsl:template match="lv"/> -->
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
