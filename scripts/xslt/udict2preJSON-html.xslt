<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:silp="silp.org.ph/ns" exclude-result-prefixes="f xs silp" version="2.0" xmlns:f="myfunctions">
      <!-- Main template for SILP Dictionary output pre JSON for app
It is called by a template that contatins the variables for the project.
This template then includes other templates.

 maybe a better name is dict2preJSON-html.xslt
 -->
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" exclude-result-prefixes="f silp" use-character-maps="silp"/>
      <xsl:strip-space elements="*"/>
      <xsl:preserve-space elements="span p div"/>
      <xsl:variable name="posturl" select="'.html'"/>
      <xsl:include href='project.xslt'/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href='inc-css-common-param.xslt'/>
      <xsl:include href='../../scripts/xslt/inc-dict-make-control-lists.xslt'/>
      <!-- above list for group div level elements -->
      <!-- <xsl:include href='../../scripts/xslt/inc-dict-xhtml-write-one-file.xslt'/>
      above template for writing html shell 
      <xsl:include href='../../scripts/xslt/test-nav.xslt'/> -->
      <!-- <xsl:include href='../../scripts/xslt/inc-dict-nav.xslt'/>
      above navigation templates -->
      <xsl:include href='../../scripts/xslt/inc-dict-sense-hom.xslt'/>
      <!-- sense and homonym templates -->
      <xsl:include href='../../scripts/xslt/inc-udict-link.xslt'/>
      <!-- hyperlink handling -->
      <xsl:include href='../../scripts/xslt/inc-dict-table.xslt'/>
      <xsl:include href='../../scripts/xslt/inc-char-map-silp.xslt'/>
      <!--
      <xsl:variable name="pathuri" select="f:file2uri($htmlpath)"/>-->
      <xsl:variable name="abreviationsinline" select="tokenize($abreviationsinlinelist,' ')"/>
      <!-- table element handling -->
      <xsl:variable name="verletters">
            <xsl:for-each-group select="/*/*/lx" group-by="lower-case(substring(translate(.,concat($accentedchar,'- '),$noaccentchar),1,1))">
                  <xsl:value-of select="lower-case(substring(translate(current-group()[1],concat($accentedchar,'- '),$noaccentchar),1,1))"/>
            </xsl:for-each-group>
      </xsl:variable>
      <xsl:template match="/*">
            <data verletters="{$verletters}">
                  <xsl:apply-templates/>
            </data>
      </xsl:template>
      <xsl:template match="lxGroup">
            <xsl:param name="lxno" as="xs:double" select="position()"/>
            <body lxno="{$lxno}" word="{lx}" sortWord="{translate(replace(lx,'^-',''),$accentedchar,$noaccentchar)}" letterIndex="{f:jsposition(substring(translate(replace(lx,'^-',''),$accentedchar,$noaccentchar),1,1),$verletters)}">
                  <div class="{name(.)}">
                        <xsl:apply-templates/>
                  </div>
                  <!-- Copyright is not needed for udict as inserted by dictionary.js  -->
                  <!--
                  <div class="copyright">
                        <xsl:text>© </xsl:text>
                        <xsl:value-of select="$copyright"/>
                  </div> -->
            </body>
      </xsl:template>
      <!-- <xsl:template match="msGroup">
            <div class="{name(.)}" id="sense{count(preceding-sibling::msGroup) + 1}">
                  < ! - - need to add sense IDs for jumping to sense number 
                  <xsl:apply-templates/>
            </div>
      </xsl:template>-->
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
      <xsl:template match="*[local-name() = $groupsdivs//element]">
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
      <xsl:template match="*[local-name() = $inlinespans//element]">
            <!-- list for span type elements like charbold|charitbold|charitalic  web-present-inline-spans.txt -->
            <span class="{name(.)}">
                  <xsl:apply-templates/>
            </span>
      </xsl:template>
      <xsl:template match="*[local-name() = $omitfields-html]" name="omit_elements"/>
      <!-- fields to be removed web-present-omit.txt -->
      <xsl:template match="*[local-name() = $sensehom//element]">
            <!-- fields to be tested for homonym numbers web-present-sense-hom.txt -->
            <xsl:param name="field" select="name()"/>
            <xsl:choose>
                  <xsl:when test="name() = $sensehomgrouped//element">
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
      <xsl:template match="*[local-name() = $csstranslate//element/text()]">
            <!-- handle translation of abbreviations into full word in css -->
            <xsl:choose>
                  <xsl:when test="local-name() = $abreviationsinline">
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
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="div">
                              <xsl:attribute name="class">
                                    <xsl:value-of select="name()"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="name()"/>
                                    <xsl:text>_</xsl:text>
                                    <xsl:value-of select="translate(.,$transfrom,$transto)"/>
                                    <!-- period removed from abbreviation -->
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*[local-name() = $serialnodes//element/text()]">
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
      <xsl:template match="text()">
            <xsl:value-of select="replace(.,'\r?\n',' ')"/>
      </xsl:template>
      <xsl:function name="f:jsposition">
            <xsl:param name="letter"/>
            <xsl:param name="string"/>
            <xsl:value-of select="string-length(substring-before($string,$letter))"/>
      </xsl:function>
</xsl:stylesheet>
