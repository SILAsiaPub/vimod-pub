<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     dict-ratchet-make-index.xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="html" version="5.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes" name="html5"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:template match="/*">
            <xsl:apply-templates select="*"/>
            <data/>
            <xsl:for-each select="$core_to_build">
                  <xsl:variable name="pos" select="position()"/>
                  <xsl:variable name="last" select="last()"/>
                  <xsl:call-template name="writecorepage">
                        <xsl:with-param name="pagetitle" select="$core_to_build_title[$pos]"/>
                        <xsl:with-param name="type" select="."/>
                        <xsl:with-param name="corepos" select="$pos"/>
                        <xsl:with-param name="last" select="$last"/>
                  </xsl:call-template>
            </xsl:for-each>
      </xsl:template>
      <xsl:template match="ver|eng|nat|reg|reg2|reg3">
            <xsl:variable name="winpath" select="concat($buildpath,'\index\',name(),'.html')"/>
            <xsl:variable name="href" select="f:file2uri($winpath)"/>
            <xsl:variable name="corepos" select="f:position($core_to_build,name())"/>
            <xsl:variable name="last" select="f:position($core_to_build,$core_to_build[last()])"/>
            <xsl:variable name="type" select="name()"/>
            <xsl:result-document href="{$href}" format="html5">
                  <html>
                        <xsl:call-template name="head">
                              <xsl:with-param name="string" select="name()"/>
                        </xsl:call-template>
                        <body>
                              <header class="bar">
                                    <nav class="bar-nav " style="text-align:center">
 
                                          <a data-transition="slide-out" class="icon {if (number($corepos) gt 1) then 'icon-left-nav pull-left' else ''}" id="left" href="../index/{$core_to_build[number($corepos) -1]}.html"></a>
                                          <a data-transition="slide-in" class="icon {if (number($corepos) lt number($last)) then 'icon-right-nav pull-right' else ''}" id="right" href="../index/{$core_to_build[number($corepos) +1]}.html"></a>
                                          <h1 class="title"><xsl:value-of select="$title"/></h1>
                                    </nav>
                              </header>
                              <div class="bar bar-standard bar-header-secondary">
                                    <div class="bar-nav my-overflow" style="white-space: nowrap;  overflow-x: auto;  -webkit-overflow-scrolling: touch;  -ms-overflow-style: -ms-autohiding-scrollbar;">
                                          <xsl:for-each select="$core_to_build">
                                                <xsl:variable name="thispos" select="position()"/>
                                                <xsl:choose>
                                                      <xsl:when test="$type = .">
                                                            <a class="tab-item active" href="#" data-transition="{if (number($thispos) gt number($corepos)) then 'slide-in' else 'slide-out'}">
                                                                  <xsl:value-of select="$core_to_build_title[number($thispos)]"/>
                                                            </a>
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                            <a class="tab-item" href="../index/{.}.html" data-transition="{if (number($thispos) gt number($corepos))  then 'slide-in' else 'slide-out'}">
                                                                  <xsl:value-of select="$core_to_build_title[($thispos)]"/>
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
                                    <xsl:element name="script">
var options = {
  valueNames: [ 'word' ]
};

var userList = new List('content', options);
</xsl:element>
                                    <div class="card">
                                          <input class="search" placeholder="Search"/>
                                    </div>
                                    <div class="card">
                                          <ul class="table-view">
                                                <xsl:apply-templates select="record"/>
                                          </ul>
                                    </div>
                              </div>
                              <footer class="bar bar-footer">

                              </footer>
                              <script type="text/javascript" src="../js/cordova.js"></script>
                              <script type="text/javascript" src="../js/ratchet.min.js"></script>
                              <script type="text/javascript" src="../js/index.js"></script>
                              <script type="text/javascript" src="../js/list.js"></script>
                              <script type="text/javascript" src="../js/list.fuzzysearch.min.js"></script>
                        </body>
                  </html>
            </xsl:result-document>
      </xsl:template>
      <xsl:template name="writecorepage">
            <xsl:param name="pagetitle"/>
            <xsl:param name="list"/>
            <xsl:param name="type"/>
            <xsl:param name="corepos"/>
            <xsl:param name="last"/>
            <xsl:variable name="page" select="f:file2uri(concat($projectpath,'\cordova\www\index\',$type,'.html'))"/>
            <xsl:choose>
                  <xsl:when test="$type = $index_to_build"/>
                  <xsl:otherwise>
                        <xsl:result-document href="{$page}" format="html5">
                              <html>
                                    <xsl:call-template name="head">
                                          <xsl:with-param name="string" select="$pagetitle"/>
                                    </xsl:call-template>
                                    <body>
                                          <header class="bar">
                                                <nav class="bar-nav " style="text-align:center">
 
                                          <a data-transition="slide-out" class="icon {if ($corepos gt 1) then 'icon-left-nav pull-left' else ''}" id="left" href="../index/{$core_to_build[number($corepos) -1]}.html"></a>
                                          <a data-transition="slide-in" class="icon {if ($corepos lt $last) then 'icon-right-nav pull-right' else ''}" id="right" href="../index/{$core_to_build[$corepos +1]}.html"></a>
                                          <h1 class="title">Kagayanen Idioms</h1>
                                    </nav>
                                          </header>
                                          <div class="bar bar-standard bar-header-secondary">
                                                <div class="bar-nav my-overflow" style="white-space: nowrap;  overflow-x: auto;  -webkit-overflow-scrolling: touch;  -ms-overflow-style: -ms-autohiding-scrollbar;">
                                                      <xsl:for-each select="$core_to_build">
                                                            <xsl:variable name="thispos" select="position()"/>
                                                            <xsl:choose>
                                                                  <xsl:when test="$type = .">
                                                                        <a class="tab-item active" href="#" data-transition="{if (number($thispos) gt number($corepos)) then 'slide-in' else 'slide-out'}">
                                                                              <xsl:value-of select="$core_to_build_title[number($thispos)]"/>
                                                                        </a>
                                                                  </xsl:when>
                                                                  <xsl:otherwise>
                                                                        <a class="tab-item" href="../index/{.}.html" data-transition="{if (number($thispos) gt number($corepos))  then 'slide-in' else 'slide-out'}">
                                                                              <xsl:value-of select="$core_to_build_title[number($thispos)]"/>
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
                                                                        <!--  <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/search.html" data-transition="slide-in">Search</a>
                                                             </li> -->
                                                                        <xsl:element name="ul">
                                                                              <xsl:attribute name="class">
                                                                                    <xsl:text>table-view</xsl:text>
                                                                              </xsl:attribute>
                                                                              <xsl:for-each select="$core_to_build[position() gt 1]">
                                                                                    <xsl:variable name="curpos" select="position() "/>
                                                                                    <li class="table-view-cell">
                                                                                          <a class="push-right" href="../index/{.}.html" data-transition="slide-in">
                                                                                                <xsl:value-of select="$core_to_build_title[number($curpos) +1]"/>
                                                                                          </a>
                                                                                    </li>
                                                                              </xsl:for-each>
                                                                        </xsl:element>
                                                                  </div>
                                                            </div>
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
                                                                  <p>SIL International - Asia Publishing<br/>
Built with:
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
                                    <script type="text/javascript" src="../js/cordova.js"></script>
                                    <script type="text/javascript" src="../js/ratchet.min.js"></script>
                                    <script type="text/javascript" src="../js/index.js"></script>
                                    <script type="text/javascript" src="../js/list.js"></script>
                                    <script type="text/javascript" src="../js/list.fuzzysearch.min.js"></script>
                              </html>
                        </xsl:result-document>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="$list">
                  <xsl:comment select="."/>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="writelist">
            <xsl:param name="list"/>
            <xsl:param name="type"/>
            <xsl:variable name="tokenlist" select="tokenize($list,'\s+')"/>
            <xsl:for-each select="$tokenlist">
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
      <xsl:template match="record">
            <xsl:element name="li">
                  <xsl:attribute name="class">
                        <xsl:text>table-view-cell</xsl:text>
                  </xsl:attribute>
                  <xsl:element name="a">
                        <xsl:attribute name="href">
                              <xsl:text>../pages/lx-</xsl:text>
                              <xsl:value-of select="format-number(counter,'00000')"/>
                              <xsl:text>.html</xsl:text>
                        </xsl:attribute>
                        <xsl:if test="lower-case(substring(preceding-sibling::*[1]/i,1,1)) ne lower-case(substring(i,1,1))">
                              <xsl:attribute name="id">
                                    <xsl:text>lx-</xsl:text>
                                    <xsl:value-of select="format-number(counter,'00000')"/>
                              </xsl:attribute>
                        </xsl:if>
                        <xsl:element name="span">
                              <xsl:attribute name="class">
                                    <xsl:text>word</xsl:text>
                              </xsl:attribute>
                              <xsl:value-of select="i"/>
                        </xsl:element>
                        <xsl:element name="span">
                              <xsl:attribute name="class">
                                    <xsl:text>meaning</xsl:text>
                              </xsl:attribute>
                              <xsl:value-of select="d"/>
                        </xsl:element>
                  </xsl:element>
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
      <xsl:function name="f:sq">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,$sq,concat('\\',$sq))"/>
      </xsl:function>
      <xsl:function name="f:nosq">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,$sq,'')"/>
      </xsl:function>
</xsl:stylesheet>
