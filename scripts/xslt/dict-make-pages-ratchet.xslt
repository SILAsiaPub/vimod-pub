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
      <xsl:output method="xhtml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" xmlns:silp="silp.org.ph/ns" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="f silp #default" name="xhtml" use-character-maps="silp"/>
      <xsl:strip-space elements="*"/>
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
      <xsl:variable name="pagepathuri" select="f:file2uri($pagespath)"/>
      <xsl:variable name="uniquemodifersorted">
            <xsl:perform-sort select="distinct-values(//modifier)">
                  <xsl:sort/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquemodifier" select="tokenize($uniquemodifersorted,'\s+')"/>
      <xsl:variable name="uniquenounsort">
            <xsl:perform-sort select="distinct-values(//noun)">
                  <xsl:sort/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquenoun" select="tokenize($uniquenounsort,'\s+')"/>
      <xsl:variable name="uniquedefinitionwordsorted">
            <xsl:perform-sort select="distinct-values(//def)">
                  <xsl:sort/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniquedefinitionword" select="tokenize($uniquedefinitionwordsorted,' ')"/>
      <xsl:variable name="uniqueliteralwordsorted">
            <xsl:perform-sort select="distinct-values(//lit)">
                  <xsl:sort/>
            </xsl:perform-sort>
      </xsl:variable>
      <xsl:variable name="uniqueliteralword" select="tokenize($uniqueliteralwordsorted,' ')"/>
      <xsl:variable name="idioms" select="/*"/>
      <xsl:template match="/*">
            <output>
                  <xsl:for-each select="$core-name">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:variable name="last" select="last()"/>
                        <xsl:variable name="curlist">
                              <xsl:choose>
                                    <xsl:when test=". = 'noun'">
                                          <xsl:value-of select="$uniquenoun"/>
                                    </xsl:when>
                                    <xsl:when test=". = 'modifier'">
                                          <xsl:value-of select="$uniquemodifier"/>
                                    </xsl:when>
                                    <xsl:when test=". = 'definition'">
                                          <xsl:value-of select="$uniquedefinitionword"/>
                                    </xsl:when>
                                    <xsl:when test=". = 'literal'">
                                          <xsl:value-of select="$uniqueliteralword"/>
                                    </xsl:when>
                              </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="writecorepage">
                              <xsl:with-param name="pagetitle" select="$core-title[$pos]"/>
                              <xsl:with-param name="list" select="$curlist"/>
                              <xsl:with-param name="type" select="."/>
                              <xsl:with-param name="corepos" select="$pos"/>
                              <xsl:with-param name="last" select="$last"/>
                        </xsl:call-template>
                  </xsl:for-each>
                  <!-- <xsl:call-template name="panel"/> -->
                  <xsl:for-each select="$uniquedefinitionword">
                        <xsl:comment select="."/>
                        <xsl:text>&#10;</xsl:text>
                  </xsl:for-each>
            </output>
            <xsl:apply-templates select="lxGroup"/>
      </xsl:template>
      <xsl:template match="lxGroup">
            <xsl:param name="list"/>
            <xsl:param name="label"/>
            <xsl:param name="header"/>
            <xsl:for-each select="$list">
                  <xsl:variable name="pos" select="position()"/>
                  <xsl:variable name="string" select="."/>
                  <xsl:variable name="href" select="concat($pagepathuri,'/',$label,'-',f:nosq(.),'.html')"/>
                  <xsl:variable name="last" select="last()"/>
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
 
                                          <a data-transition="slide-out" class="icon icon-left pull-left" id="left" href="../index/{$label}.html#{$list[$pos - 2]}"></a>
                                           <!-- <a data-transition="slide-in" class="icon {if ($corepos lt $last) then 'icon-right-nav pull-right' else ''}" id="right" href="../index/{$core-name[$corepos +1]}.html"></a> -->
                                          <h1 class="title">Kagayanen Idioms - <xsl:value-of select="$header"/></h1>
                                    </nav>
                                    </header>
                                    <div class="bar bar-standard bar-header-secondary">
                                          <div class="bar-nav my-overflow" style="white-space: nowrap;  overflow-x: auto;  -webkit-overflow-scrolling: touch;  -ms-overflow-style: -ms-autohiding-scrollbar;">
                                                <a data-transition="slide-out" class="icon {if ($pos gt 1) then 'icon-left-nav pull-left' else ''}" id="left" href="../pages/{$label}-{f:nosq($list[$pos - 1])}.html"></a>
                                                <a data-transition="slide-in" class="icon {if ($pos lt $last) then 'icon-right-nav pull-right' else ''}" id="right" href="../pages/{$label}-{f:nosq($list[$pos + 1])}.html"></a>
                                                <h1 class="title">
                                                      <xsl:value-of select="."/>
                                                </h1>
                                          </div>
                                    </div>
                                    <div class="content" id="content">
                                          <xsl:apply-templates select="*"/>
                                    </div>
                              </body>
                        </html>
                  </xsl:result-document>
            </xsl:for-each>
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
      <xsl:template name="writecorepage">
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
                                                            <!--  <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/search.html" data-transition="slide-in">Search</a>
                                                             </li> -->
                                                            <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/noun.html" data-transition="slide-in">Kagayanen Nouns Index</a>
                                                            </li>
                                                            <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/modifier.html" data-transition="slide-in">Kagayanen Modifiers Index</a>
                                                            </li>
                                                            <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/definition.html" data-transition="slide-in">English Definitions Index</a>
                                                            </li>
                                                            <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/literal.html" data-transition="slide-in">English Literal Meaning Index</a>
                                                            </li>
                                                            <li class="table-view-cell">
                                                                  <a class="push-right" href="../index/about.html" data-transition="slide-in">About</a>
                                                            </li>
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
                                                      <p>Jacqueline A. Huggins and Ruby C. Bundal
<br/>Collected between 1991-1993<br/>
Location: Cagayancillo, Palawan, Philippines</p>
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
                  </html>
            </xsl:result-document>
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
      <xsl:function name="f:sq">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,$sq,concat('\\',$sq))"/>
      </xsl:function>
      <xsl:function name="f:nosq">
            <xsl:param name="string"/>
            <xsl:value-of select="replace($string,$sq,'')"/>
      </xsl:function>
</xsl:stylesheet>
