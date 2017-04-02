<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	sfm2lift-plb-v2.xslt
    # Purpose:		convert SFM directly to LIFT for use in DAB
    # Part of:      	Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay@sil.org>
    # Created:      	2017-03-29
    # Copyright:    	(c) 2017 SIL International
    # Licence:      	<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:include href="inc-dict-sfm2lift.xslt"/>
      <xsl:include href="inc-sfm2lift-plb-lxGroup.xslt"/>
<xsl:variable name="badstartword" select="tokenize('A a To to The the be',' ')"/>
      <!--  Custom fields start =================== ===== -->
      <xsl:template match="glGroup">
            <definition>
                  <xsl:apply-templates/>
            </definition>
            <xsl:apply-templates mode="reversal"/>
      </xsl:template>
      <xsl:template match="gl">
            <form lang="{f:keyvalue($node-lang,name())}">
                  <text>
                        <xsl:value-of select="translate(.,'*','')"/>
                  </text>
            </form>
      </xsl:template>
      <xsl:template match="gl" mode="reversal">
            <xsl:variable name="word" select="tokenize(.,'[ ]')"/>
            <xsl:comment select="$word"/>
            <xsl:choose>
                  <xsl:when test="matches(.,'\*')">
                        <reversal type="eng">
                              <form lang="en">
                                    <xsl:element name="text">
                                          <xsl:for-each select="$word">
                                                <xsl:if test="matches(.,'^\*')">
                                                      <xsl:value-of select="translate(.,'*','')"/>
                                                      <xsl:text> </xsl:text>
                                                </xsl:if>
                                          </xsl:for-each>
                                    </xsl:element>
                              </form>
                        </reversal>
                  </xsl:when>
                  <xsl:otherwise>
                        <reversal type="eng">
                              <form lang="en">
                                    <xsl:element name="text">
                                          <xsl:for-each select="$word">
                                                <xsl:choose>
                                                      <xsl:when test=". = $badstartword and position() = 1"/>
                                                      <xsl:when test=". = $badstartword and position() = 2 and $word[position() -1] = $badstartword"/>
                                                      <xsl:otherwise>
                                                            <xsl:value-of select="."/>
                                                            <xsl:text> </xsl:text>
                                                      </xsl:otherwise>
                                                </xsl:choose>
                                          </xsl:for-each>
                                    </xsl:element>
                              </form>
                        </reversal>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="coGroup">
            <xsl:apply-templates/>
      </xsl:template>
      <!--
      <xsl:template match="lf">
            <relation type="{f:keyvalue($relation-node,.)}" ref="{following-sibling::*[1]}"/>
      </xsl:template>
      <xsl:template match="lv"/> -->
      <xsl:template match="tb">
            <xsl:element name="note">
                  <xsl:attribute name="type">
                        <xsl:text>table</xsl:text>
                  </xsl:attribute>
                  <form lang="en">
                        <xsl:element name="text">
                              <xsl:element name="table">
                                    <xsl:apply-templates select="node()"/>
                              </xsl:element>
                        </xsl:element>
                  </form>
            </xsl:element>
      </xsl:template>
      <xsl:template match="tabletitle">
            <xsl:element name="caption">
                  <xsl:apply-templates select="node()"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="trow">
            <xsl:element name="tr">
                  <xsl:apply-templates select="node()"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="c1|c2|c3|c4|c5|c6|c7|c8">
            <xsl:element name="td">
                  <xsl:attribute name="class">
                        <xsl:value-of select="local-name()"/>
                  </xsl:attribute>
                  <xsl:apply-templates select="node()"/>
            </xsl:element>
      </xsl:template>
      <!-- Custom field end =========================== -->
</xsl:stylesheet>
