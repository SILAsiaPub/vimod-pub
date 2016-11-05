<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:f="myfunctions">
      <xsl:output method="html" version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:param name="spans_list" select="'d ex gl ms occ od oi oid tr exGroup glGroup psGroup'"/>
      <!--  raGroup reGroup rfGroup rgGroup rsGroup vaGroup -->
      <xsl:param name="divs_list" select="'lcGroup ldGroup lxGroup occGroup oidGroup'"/>
      <xsl:param name="commas_list" select="' ra re rf rg rm rs va'"/>
      <xsl:param name="labels_list" select="'da ds dt dts lc ld raGroup reGroup rfGroup rgGroup rmGroup rsGroup vaGroup'"/>
      <xsl:param name="labels-data_list">
da	(Ar.) 	
ds	(Sp.) 	
dt	(Tag.) 	
dts	(Tsg.) 	
ec	(	)
eg	[	]
es	[sem. 	]
lc		 (comp.)
ld		 (derv.)
li		 (idiom)
lk		 (k.t.)
ls		 (saying)
mb	(var. of 	)
mr	(see 	)
or	rdp. 	
raGroup	ant. 	
reGroup	c.f.  
rfGroup	(from 	)
rgGroup	genr. 	
rmGroup	spec. 	
roGroup	ov syn. 	
rsGroup	syn. 	
rt 	(See 	for table.) 
vaGroup	(var. 	)</xsl:param>
      <xsl:variable name="spans" select="tokenize($spans_list,' ')"/>
      <xsl:variable name="divs" select="tokenize($divs_list,' ')"/>
      <xsl:variable name="commas" select="tokenize($commas_list,' ')"/>
      <xsl:variable name="labels" select="tokenize($labels_list,' ')"/>
      <xsl:variable name="labels-data" select="tokenize($labels-data_list,'\r?\n')"/>
      <xsl:template match="/*">
            <html>
                  <head>
                        <meta name="generator" content="ToolBox PLB dictionary transformation"/>
                        <title>
                              <xsl:value-of select="$voltitle"/>
                        </title>
                        <link rel="stylesheet" href="dict.css" type="text/css"/>
                  </head>
                  <body>
                        <xsl:element name="div">
                              <xsl:attribute name="class">
                                    <xsl:text>dictBody</xsl:text>
                              </xsl:attribute>
                              <xsl:apply-templates/>
                        </xsl:element>
                  </body>
            </html>
      </xsl:template>
      <xsl:template match="*[local-name() = $divs]">
            <!--s <xsl:if test="name() ne 'lxGroup'">
                  <xsl:text>&#10;</xsl:text>
            </xsl:if> -->
            <div class="{name(.)}">
                  <xsl:apply-templates/>
            </div>
      </xsl:template>
      <xsl:template match="*[local-name() = $spans]">
            <!--<xsl:if test="name() ne 'lxGroup'">
                  <xsl:text>&#10;</xsl:text>
            </xsl:if> -->
            <span class="{name(.)}">
                  <xsl:apply-templates/>
                  <xsl:if test="not(matches(name(),'Group'))">
                        <xsl:text> </xsl:text>
                  </xsl:if>
            </span>
      </xsl:template>
      <xsl:template match="msGroup">
            <xsl:text>&#10;</xsl:text>
            <xsl:choose>
                  <xsl:when test="count(preceding-sibling::msGroup) = 0">
                        <span class="{name(.)}">
                              <xsl:choose>
                                    <xsl:when test="matches(ms,'\d')"/>
                                    <xsl:otherwise>
                                          <xsl:value-of select="count(preceding-sibling::msGroup) + 1"/>
                                    </xsl:otherwise>
                              </xsl:choose>
                              <xsl:text> </xsl:text>
                              <xsl:apply-templates/>
                        </span>
                  </xsl:when>
                  <xsl:otherwise>
                        <div class="{name(.)}">
                              <xsl:choose>
                                    <xsl:when test="matches(ms,'\d')"/>
                                    <xsl:otherwise>
                                          <xsl:value-of select="count(preceding-sibling::msGroup) + 1"/>
                                    </xsl:otherwise>
                              </xsl:choose>
                              <xsl:text> </xsl:text>
                              <xsl:apply-templates/>
                        </div>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*"> <!-- Remove non-specified fields --></xsl:template>
      <xsl:template match="*[local-name() = $labels]">
            <xsl:if test="text() or element()">
                  <span class="{name(.)}">
                        <span class="label">
                              <xsl:value-of select="f:lookupdefault($labels-data,name(),'&#9;',1,2,'')"/>
                        </span>
                        <xsl:apply-templates/>
                        <!-- <xsl:if test="string-length(f:lookupdefault($labels,name(),'&#9;',1,3,'')) gt 0"> -->
                        <span class="label postlabel">
                              <xsl:value-of select="f:lookupdefault($labels-data,name(),'&#9;',1,3,'')"/>
                        </span>
                        <!-- </xsl:if> -->
                        <xsl:text> </xsl:text>
                  </span>
            </xsl:if>
      </xsl:template>
      <xsl:template match="*[local-name() = $commas]">
            <span class="{name(.)}">
                  <xsl:apply-templates/>
                  <xsl:if test="position() ne last()">
                        <xsl:text>, </xsl:text>
                  </xsl:if>
            </span>
      </xsl:template>
      <xsl:template match="lx">
            <xsl:choose>
                  <xsl:when test="matches(.,' \d')">
                        <span class="{name(.)}">
                              <xsl:value-of select="replace(.,'(.+) \d','$1')"/>
                        </span>
                        <xsl:element name="sub">
                              <xsl:value-of select="replace(.,'.+ (\d)','$1')"/>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <span class="{name(.)}">
                              <xsl:apply-templates/>
                        </span>
                  </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
      </xsl:template>
      <xsl:template match="ps">
            <span class="{name(.)}">
                  <xsl:apply-templates/>
            </span>
            <xsl:text>&#160;</xsl:text>
      </xsl:template>
      <xsl:template name="css">

          </xsl:template>
      <xsl:template match="em|strong">
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="text()">
            <xsl:value-of select="translate(.,'&#141;&#157;&#129;','&#356;&#357; ')"/>
      </xsl:template>
      <xsl:template match="ms">

</xsl:template>
</xsl:stylesheet>
