<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	dict-make-pages-ratchet.xslt
    # Purpose:		generate pages for app from XML preprocessed source
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay@sil.org>
    # Created:      	2015-06-21
    # Copyright:    	(c) 2016 SIL International
    # Licence:      	<LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns:xs="http://www.w3.org/2001/XMLSchema">
      <xsl:output method="html" version="5.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes" name="html5"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:variable name="posturl" select="'.html'"/>
      <xsl:include href='project.xslt'/>
      <xsl:include href="inc-file2uri.xslt"/>
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
      <xsl:variable name="pagepathuri" select="f:file2uri($pagespath)"/>
      <xsl:variable name="lxdef">
            <xsl:apply-templates select="//lxGroup" mode="index"/>
      </xsl:variable>
      <xsl:variable name="uniquevernsorted">
            <!-- Get unique list of vern words -->
            <xsl:perform-sort select="distinct-values(//*[local-name() = $index_source_fields_ver])">
                  <xsl:sort select="lower-case(replace(.,'^\-',''))"/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquevernword" select="tokenize($uniquevernsorted,'\s+')"/>
      <xsl:variable name="letterlistvern1">
            <xsl:for-each select="$uniquevernword">
                  <xsl:value-of select="lower-case(substring(.,1,1))"/>
            </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="letterlistvern" select="tokenize($letterlistvern1,'\s+')"/>
      <xsl:variable name="uniqueengsort">
            <!-- Get unique list of eng words -->
            <xsl:perform-sort select="distinct-values(//*[local-name() = $index_source_fields_eng])">
                  <xsl:sort case-order="upper-first"/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniqueengword" select="tokenize($uniqueengsort,'\s+')"/>
      <xsl:variable name="uniquenatsorted">
            <!-- Get unique list of nat  words -->
            <xsl:perform-sort select="distinct-values(//*[local-name() = $index_source_fields_nat])">
                  <xsl:sort case-order="upper-first"/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquenatword" select="tokenize($uniquenatsorted,' ')"/>
      <xsl:variable name="uniqueregsorted">
            <!-- Get unique list of reg words -->
            <xsl:perform-sort select="distinct-values(//*[local-name() = $index_source_fields_reg])">
                  <xsl:sort case-order="upper-first"/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniqueregword" select="tokenize($uniqueregsorted,' ')"/>
      <xsl:variable name="uniquereg2sorted">
            <!-- Get unique list of reg2 words -->
            <xsl:perform-sort select="distinct-values(//*[local-name() = $index_source_fields_reg2])">
                  <xsl:sort case-order="upper-first"/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquereg2word" select="tokenize($uniquereg2sorted,' ')"/>
      <xsl:variable name="uniquereg3sorted">
            <!-- Get unique list of reg3 words -->
            <xsl:perform-sort select="distinct-values(//*[local-name() = $index_source_fields_reg3])">
                  <xsl:sort case-order="upper-first"/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquereg3word" select="tokenize($uniquereg3sorted,' ')"/>
      <xsl:variable name="idioms" select="/*"/>
      <xsl:template match="/*">
            <output>
                  <xsl:comment select="$letterlistvern"/>
                  <!-- output a record of what is done -->

            </output>
            <xsl:apply-templates select="lxGroup"/>
      </xsl:template>
      <xsl:template match="lxGroup">
            <xsl:param name="label" select="'lx-'"/>
            <xsl:param name="header"/>
            <xsl:param name="list"/>
            <xsl:variable name="pos" select="position()"/>
            <xsl:variable name="curpos" select="format-number(position(),'00000')"/>
            <xsl:variable name="string" select="lx"/>
            <xsl:variable name="href" select="concat($pagepathuri,'/',$label,$curpos,'.html')"/>
            <xsl:variable name="last" select="last()"/>
            <xsl:variable name="prev">
                  <xsl:choose>
                        <xsl:when test="position() = 1"/>
                        <xsl:otherwise>
                              <xsl:value-of select="format-number(position() - 1,'00000')"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:variable name="next">
                  <xsl:choose>
                        <xsl:when test="position() = last()"/>
                        <xsl:otherwise>
                              <xsl:value-of select="format-number(position() + 1,'00000')"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <!--<xsl:comment select="$href"/>
                  <xsl:text>&#10;</xsl:text> -->
            <xsl:result-document href="{$href}" format="html5">
                  <!--<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>-->
                  <html>
                        <xsl:call-template name="head">
                              <xsl:with-param name="string" select="$string"/>
                        </xsl:call-template>
                        <body>
                              <header class="bar">
                                    <nav class="bar-nav " style="text-align:center">
 
                                          <a data-transition="slide-out" class="icon icon-left pull-left" id="left" href="../index/{$label}.html"></a>
                                           <!-- <a data-transition="slide-in" class="icon {if ($corepos lt $last) then 'icon-right-nav pull-right' else ''}" id="right" href="../index/{$core-name[$corepos +1]}.html"></a> -->
                                          <h1 class="title"><xsl:value-of select="$title"/></h1>
                                    </nav>
                              </header>
                              <div class="bar bar-standard bar-header-secondary">
                                    <div class="bar-nav my-overflow" style="white-space: nowrap;  overflow-x: auto;  -webkit-overflow-scrolling: touch;  -ms-overflow-style: -ms-autohiding-scrollbar;">
                                          <a data-transition="slide-out" class="icon {if ($pos gt 1) then 'icon-left-nav pull-left' else ''}" id="left" href="../pages/{$label}{$prev}.html"></a>
                                          <a data-transition="slide-in" class="icon {if ($pos lt $last) then 'icon-right-nav pull-right' else ''}" id="right" href="../pages/{$label}{$next}.html"></a>
                                          <h1 class="title">
                                                <xsl:value-of select="lx"/>
                                          </h1>
                                    </div>
                              </div>
                              <div class="content" id="content">
                                    <div class="card">
                                          <xsl:apply-templates select="node()"/>
                                    </div>
                              </div>
                        </body>
                  </html>
            </xsl:result-document>
      </xsl:template>
      <xsl:template match="lxGroup" mode="index">
            <xsl:element name="lxG">
                  <xsl:element name="pos">
                        <xsl:value-of select="position()"/>
                  </xsl:element>
                  <xsl:element name="lx">
                        <xsl:value-of select="lx"/>
                  </xsl:element>
                  <xsl:apply-templates select="descendant::re" mode="index"/>
                  <xsl:apply-templates select="descendant::gg" mode="index"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="re" mode="index">
            <xsl:element name="re">
                  <xsl:value-of select="re"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="gg" mode="index">
            <xsl:element name="gg">
                  <xsl:value-of select="gg"/>
            </xsl:element>
      </xsl:template>
      <xsl:template name="head">
            <xsl:param name="string"/>
            <head>
                  <title>
                        <xsl:value-of select="$string"/>
                  </title>
                  <meta name="viewport" content="width=device-width, initial-scale=1"/>
                  <!-- Path to Ratchet Library CSS -->
                  <link rel="stylesheet" href="../css/ratchet.min.css"/>
                  <!-- Path to your custom app styles-->
                  <link rel="stylesheet" href="../css/my-app.css"/>
            </head>
      </xsl:template>
      <xsl:template name="writeindexpage">
            <xsl:param name="pagetitle"/>
            <xsl:param name="list"/>
            <xsl:param name="type"/>
            <xsl:param name="corepos"/>
            <xsl:param name="last"/>
            <xsl:variable name="page" select="f:file2uri(concat($projectpath,'\cordova\www\index\',$type,'.html'))"/>
            <xsl:result-document href="{$page}" format="html5">
                  <html>
                        <xsl:call-template name="head">
                              <xsl:with-param name="string" select="$pagetitle"/>
                        </xsl:call-template>
                        <body>
                              <header class="bar">
                                    <nav class="bar-nav " style="text-align:center">
 
                                          <a data-transition="slide-out" class="icon {if ($corepos gt 1) then 'icon-left-nav pull-left' else ''}" id="left" href="../index/{$core-name[number($corepos) -1]}.html"></a>
                                          <a data-transition="slide-in" class="icon {if ($corepos lt $last) then 'icon-right-nav pull-right' else ''}" id="right" href="../index/{$core-name[$corepos +1]}.html"></a>
                                          <h1 class="title">Kagayanen Idioms</h1>
                                    </nav>
                              </header>
                              <div class="bar bar-standard bar-header-secondary">
                                    <div class="bar-nav my-overflow" style="white-space: nowrap;  overflow-x: auto;  -webkit-overflow-scrolling: touch;  -ms-overflow-style: -ms-autohiding-scrollbar;">
                                          <xsl:for-each select="$core-name">
                                                <xsl:variable name="thispos" select="position()"/>
                                                <xsl:choose>
                                                      <xsl:when test="$type = .">
                                                            <a class="tab-item active" href="#" data-transition="{if (number($thispos) gt number($corepos)) then 'slide-in' else 'slide-out'}">
                                                                  <xsl:value-of select="$core-title[$thispos]"/>
                                                            </a>
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                            <a class="tab-item" href="../index/{.}.html" data-transition="{if (number($thispos) gt number($corepos))  then 'slide-in' else 'slide-out'}">
                                                                  <xsl:value-of select="$core-title[$thispos]"/>
                                                            </a>
                                                      </xsl:otherwise>
                                                </xsl:choose>
                                          </xsl:for-each>
                                    </div>
                              </div>
                              <!-- <h1>
                                    <xsl:value-of select="$pagetitle"/>
                               </h1> -->
                              <div class="content" id="content">
                                    <xsl:choose>
                                          <xsl:when test="matches($type,'index')">
                                                <div class="card" style="margin:55px 8px 55px 8px">
                                                      <div class="table-view">
                                                            <xsl:for-each select="$indexes_to_build[position() gt 1]">
                                                                  <li class="table-view-cell">
                                                                        <a class="push-right" href="../index/{$type[position()]}.html" data-transition="slide-in"><xsl:value-of select="$indexes_to_build_title[position()]"/> Index</a>
                                                                  </li>
                                                            </xsl:for-each>
                                                      </div>
                                                </div>
                                                <script type="text/javascript" src="../js/cordova.js"></script>
                                                <script type="text/javascript" src="../js/ratchet.min.js"></script>
                                                <script type="text/javascript" src="../js/index.js"></script>
                                                <!-- <script type="text/javascript">initialize();</script> -->
                                          </xsl:when>
                                          <xsl:when test="matches($type,'about')">
                                                <div class="card">
                                                      <h1>About</h1>
                                                      <h2>Created by</h2>
                                                      <p>
                                                            <xsl:value-of select="$authors"/>
                                                            <br/>
                                                            <xsl:value-of select="$collectionperiod"/>
                                                            <br/>
                                                            <xsl:value-of select="$collectionlocation"/>
                                                      </p>
                                                      <h2>Copyright</h2>
                                                      <p>© 2016 SIL International</p>
                                                      <h2>License</h2>
                                                      <a href="https://creativecommons.org/licenses/by-sa/4.0/legalcode">https://creativecommons.org/licenses/by-sa/4.0/legalcode</a>
                                                      <p>Attribution-ShareAlike <br/>
CC BY-SA</p>
                                                      <p>This license lets others remix, tweak, and build upon your work even for commercial purposes, as long as they credit you and license their new creations under the identical terms. This license is often compared to “copyleft” free and open source software licenses. All new works based on yours will carry the same license, so any derivatives will also allow commercial use. This is the license used by Wikipedia, and is recommended for materials that would benefit from incorporating content from Wikipedia and similarly licensed projects.</p>
                                                      <h2>App Creation</h2>
                                                      <p>
                                                            <xsl:value-of select="$publisher"/>
                                                            <br/>
                                                            <xsl:text>Built with:</xsl:text>
                                                            <ul>
                                                                  <li>Apache Cordova: https://cordova.apache.org/</li>
                                                                  <li>Ratchet app framework: http://goratchet.com/</li>
                                                                  <li>Vimod-Pub: https://github.com/SILAsiaPub/vimod-pub</li>
                                                            </ul>
                                                      </p>
                                                </div>
                                          </xsl:when>
                                          <xsl:when test="matches($type,'search')">
                                                <xsl:text>Search page</xsl:text>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <div class="card">
                                                      <ul class="table-view">
                                                            <xsl:call-template name="writelist">
                                                                  <xsl:with-param name="list" select="$list"/>
                                                                  <xsl:with-param name="type" select="$type"/>
                                                            </xsl:call-template>
                                                      </ul>
                                                </div>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </div>
                              <!-- <footer class="bar bar-footer">

                              </footer> -->
                        </body>
                  </html>
            </xsl:result-document>
            <xsl:for-each select="$list">
                  <xsl:comment select="."/>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="writelist">
            <xsl:param name="list"/>
            <xsl:param name="type"/>
            <!-- <xsl:variable name="tokenlist" select="tokenize($list,'\s+')"/> -->
            <xsl:for-each select="$list">
                  <xsl:variable name="page" select="concat('../pages/',$type,'-',.,'.html')"/>
                  <xsl:element name="li">
                        <xsl:attribute name="class">
                              <xsl:text>table-view-cell</xsl:text>
                        </xsl:attribute>
                        <xsl:element name="a">
                              <xsl:attribute name="href">
                                    <xsl:value-of select="f:nosq($page)"/>
                              </xsl:attribute>
                              <xsl:attribute name="id">
                                    <xsl:value-of select="f:nosq(.)"/>
                              </xsl:attribute>
                              <xsl:value-of select="."/>
                        </xsl:element>
                  </xsl:element>
            </xsl:for-each>
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
      <xsl:template match="*">
            <!-- list for span type elements like charbold|charitbold|charitalic  web-present-inline-spans.txt -->
            <div class="{name(.)}">
                  <xsl:apply-templates/>
            </div>
      </xsl:template>
      <xsl:template match="*[local-name() = $omit]"/>
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
                                    <xsl:when test="link">
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
                                          <xsl:when test="link">
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
                        <xsl:when test="link">
                              <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:apply-templates/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[local-name() = $audio]">
            <xsl:variable name="file" select="tokenize(.,'\\')[last()]"/>
            <audio controls="">
                  <source src="../audio/{$file}" type="audio/mpeg"/>
                  <xsl:text>Your browser does not support the audio element.</xsl:text>
            </audio>
      </xsl:template>
      <xsl:template match="*[local-name() = $picture]">
            <xsl:variable name="file" select="tokenize(.,'\\')[last()]"/>
            <img src="..\pics\{$file}" alt="{preceding::lx[1]}" style=""/>
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
      <xsl:function name="f:sq">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,$sq,concat('\\',$sq))"/>
      </xsl:function>
      <xsl:function name="f:nosq">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,$sq,'')"/>
      </xsl:function>
</xsl:stylesheet>
