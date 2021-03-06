<?xml version="1.0" encoding="UTF-8"?>
<!--
    #############################################################
    # Name:         	dict2web-dict-html-css-201501.xslt
    # Purpose:		Main template for SILP Dictionary creator. now a Vimod-Pub project
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Used in:		SILP Dictionary creator, dict2web
    # Modification: 	This is a modification of the dict2web-dict-html-css.xslt. It now uses project.xslt
    # Author:       	Ian McQuay <ian_mcquay.org>
    # Created:      	2015-01-24
    # Copyright:    	(c) 2015 SIL International
    # Licence:      	<LGPL>
    ################################################################ -->
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:silp="silp.org.ph/ns" exclude-result-prefixes="f xs silp" version="2.0" xmlns:f="myfunctions">
      <xsl:output method="xhtml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" xmlns:silp="silp.org.ph/ns" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="f silp #default" name="xhtml" use-character-maps="silp"/>
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:variable name="posturl" select="'.html'"/>
      <xsl:include href='project.xslt'/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href='../../scripts/xslt/inc-dict-xhtml-write-page-201501.xslt'/>
      <!-- above template for writing html shell  -->
      <xsl:include href='../../scripts/xslt/inc-dict-nav-201501.xslt'/>
      <!-- above navigation templates -->
      <xsl:include href='../../scripts/xslt/inc-dict-sense-hom.xslt'/>
      <!-- sense and homonym templates -->
      <xsl:include href='../../scripts/xslt/inc-dict-link.xslt'/>
      <!-- hyperlink handling -->
      <xsl:include href='../../scripts/xslt/inc-dict-table.xslt'/>
      <!-- table element handling -->
      <xsl:include href='../../scripts/xslt/inc-char-map-silp.xslt'/>
      <xsl:variable name="last" as="xs:double" select="count(//lxGroup)"/>
      <xsl:variable name="pathuri" select="f:file2uri($htmlpath)"/>
      <xsl:template match="/*">
            <xsl:for-each select="//lxGroup">
                  <xsl:call-template name="writehtmlpage">
                        <xsl:with-param name="filename" select="concat($pathuri,$prefile,format-number(position(),'00000'),$posturl)"/>
                        <xsl:with-param name="lxno" as="xs:double" select="position()"/>
                  </xsl:call-template>
            </xsl:for-each>
      </xsl:template>
      <xsl:template match="*">
            <!-- Generic data handling template                                                  -->
            <div class="{name(.)}">
                  <span class="d">
                        <xsl:choose>
                              <xsl:when test="name() = 'lx'">
                                    <xsl:call-template name="hom">
                                          <xsl:with-param name="string" select="."/>
                                    </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:apply-templates/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </span>
            </div>
      </xsl:template>
      <xsl:template match="*[local-name() = $groupdivs]">
            <!-- list for group div level elements from web-present-groups.txt -->
            <xsl:element name="div">
                  <xsl:attribute name="class">
                        <xsl:value-of select="name()"/>
                  </xsl:attribute>
                  <xsl:if test="name() = 'msGroup'">
                        <xsl:attribute name="id">
                              <xsl:choose>
                                    <xsl:when test="ms = ''">
                                          <xsl:text>calc_sense</xsl:text>
                                          <xsl:value-of select="count(preceding-sibling::msGroup) + 1"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <xsl:text>sense</xsl:text>
                                          <xsl:value-of select="ms"/>
                                    </xsl:otherwise>
                              </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="mspos">
                              <xsl:value-of select="count(preceding-sibling::msGroup) + 1"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $inlinespans]">
            <!-- list for span type elements like charbold|charitbold|charitalic  web-present-inline-spans.txt -->
            <span class="{name(.)}">
                  <xsl:apply-templates/>
            </span>
      </xsl:template>
      <xsl:template match="*[local-name() = $omit]" name="omit_elements"/>
      <!-- fields to be removed web-present-omit.txt -->
      <xsl:template match="*[local-name() = $sensehom]">
            <!-- fields to be tested for homonym numbers web-present-sense-hom.txt -->
            <xsl:param name="field" select="name()"/>
            <xsl:choose>
                  <xsl:when test="name() = $sensehomgrouped">
                        <span>
                              <xsl:attribute name="class">
                                    <xsl:value-of select="name()"/>
                                    <xsl:text> d</xsl:text>
                                    <xsl:call-template name="serialposition">
                                          <xsl:with-param name="followingsiblings" select="count(following-sibling::*[name() = $field])"/>
                                    </xsl:call-template>
                              </xsl:attribute>
                              <xsl:choose>
                                    <xsl:when test="child::link">
                                          <xsl:apply-templates/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                          <xsl:call-template name="hom">
                                                <xsl:with-param name="string" select="."/>
                                          </xsl:call-template>
                                    </xsl:otherwise>
                              </xsl:choose>
                        </span>
                  </xsl:when>
                  <xsl:otherwise>
                        <div class="{name()}">
                              <span>
                                    <xsl:attribute name="class">
                                          <xsl:text>d</xsl:text>
                                          <xsl:call-template name="serialposition">
                                                <xsl:with-param name="followingsiblings" select="count(following-sibling::*[name() = $field])"/>
                                          </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:choose>
                                          <xsl:when test="child::link">
                                                <xsl:apply-templates/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:call-template name="hom">
                                                      <xsl:with-param name="string" select="."/>
                                                </xsl:call-template>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </span>
                        </div>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[local-name() = $csstranslate]">
            <!-- handle translation of abbreviations into full word in css -->
            <xsl:element name="span">
                  <xsl:attribute name="class">
                        <xsl:value-of select="name()"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="translate(.,$transfrom,$transto)"/>
                        <!-- period removed from abbreviation -->
                  </xsl:attribute>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $serialnodesnothom]">
            <!-- like sens hom but can't use that as it has numbers. But needs the last class added -->
            <xsl:param name="field" select="name()"/>
            <xsl:element name="span">
                  <xsl:attribute name="class">
                        <xsl:value-of select="name()"/>
                        <xsl:text> d</xsl:text>
                        <xsl:call-template name="serialposition">
                              <xsl:with-param name="followingsiblings" select="count(following-sibling::*[name() = $field])"/>
                        </xsl:call-template>
                  </xsl:attribute>
                  <xsl:choose>
                        <xsl:when test="child::link">
                              <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:apply-templates/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:element>
      </xsl:template>
      <xsl:template match="ms">
            <!-- used to add sense number when they are absent -->
            <span class="{name(.)}">
                  <xsl:choose>
                        <xsl:when test=". = ''">
                              <xsl:value-of select="preceding-sibling::msGroup/@mspos"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:apply-templates/>
                        </xsl:otherwise>
                  </xsl:choose>
            </span>
      </xsl:template>
      <xsl:template match="co">
            <!-- This is needed to differentiate the \co field in different contexts for some dicts
			The \co is used as a second \gl field and sometimes as a comment field.  -->
            <xsl:element name="div">
                  <xsl:attribute name="class">
                        <xsl:value-of select="name()"/>
                        <xsl:text> co-</xsl:text>
                        <xsl:value-of select="name(preceding-sibling::*[1])"/>
                        <xsl:text></xsl:text>
                  </xsl:attribute>
                  <span class="d">
                        <xsl:apply-templates/>
                  </span>
            </xsl:element>
      </xsl:template>
      <xsl:template name="serialposition">
            <xsl:param name="followingsiblings"/>
            <xsl:choose>
                  <xsl:when test="$followingsiblings = 0"/>
                  <xsl:otherwise>
                        <xsl:text> comma</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
