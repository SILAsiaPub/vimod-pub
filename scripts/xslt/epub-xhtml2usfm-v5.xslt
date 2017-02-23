<?xml version="1.0"?>
<!--
    #############################################################
    # Name:         epub-xhtml2usfm-v4.xslt
    # Purpose:      Generate USFM M Johnson created ePub. 
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay.org>
    # Created:      	2013/08/22
    # Copyright:	(c) 2013 SIL International
    # Licence:      	<LGPL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml" xpath-default-namespace= "http://www.w3.org/1999/xhtml" xmlns:f="myfunctions">
      <xsl:output method="text"/>
      <xsl:strip-space elements="*"/>
      <xsl:include href="epub-ref-func.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:variable name="book" select="tokenize(/html/body/ul[2]/li[1]/a/@href,'\.')[1]"/>
      <xsl:template match="/*">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="head"/>
      <xsl:template match="body">
            <xsl:text>\id </xsl:text>
            <xsl:value-of select="$book"/>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="*[local-name() = $node2ignore][@class = $nodeclass2ignore]"/>
      <xsl:template match="*[local-name() = $node2include1][@class = $nodeclass2include1]">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="*[local-name() = $node2include2][@class = $nodeclass2include2]">
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="div">
            <xsl:text>&#13;&#10;\</xsl:text>
            <xsl:value-of select="@class"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="div[@class = 'chapterlabel']">
            <xsl:text>&#13;&#10;\c </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="span">
            <!-- ================================ =============== spans -->
            <xsl:variable name="classname" select="tokenize(@class,' ')"/>
            <xsl:choose>
                  <!-- The following When contains Items to be removed
            cnum is handled separately. It is listed here so it is does not appear twice
            -->
                  <xsl:when test="$classname = $spanclasstoremove"/>
                  <!-- footnote caller and xref caller and other unwanted class types -->
                  <xsl:when test="not(@class) or $classname = $spanclasstocopy">
                        <!-- when there is no class, or a class that you just want to copy just copy text -->
                        <xsl:apply-templates/>
                  </xsl:when>
                  <!-- <xsl:when test="$classname = $spanclassnametoinline">
                        Default handling where inline style is followed by formatting -->
                  <!-- <xsl:text>\</xsl:text>
                        <xsl:value-of select="substring-before(@class,' ')"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text>\</xsl:text>
                        <xsl:value-of select="substring-before(@class,' ')"/>
                        <xsl:text>* </xsl:text>
                  </xsl:when> -->
                  <xsl:when test="$classname = 'verse'">
                        <xsl:text>&#13;&#10;\v </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text> </xsl:text>
                  </xsl:when>
                  <xsl:when test="$classname = 'noteId'">
                        <!-- footnote or xref caller ref id -->
                        <xsl:text>&#13;&#10;\</xsl:text>
                        <xsl:value-of select="substring(.,7,1)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="substring-after(.,'_')"/>
                  </xsl:when>
                  <xsl:when test="$classname = $spanclassnameref">
                        <!-- footnote and xref caller - starts one of these-->
                        <xsl:text> \</xsl:text>
                        <xsl:value-of select="substring(@class,1,2)"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text></xsl:text>
                  </xsl:when>
                  <xsl:when test="$classname = 'noteText'">
                        <!-- footnote and xref text - ends ref-->
                        <xsl:value-of select="f:refmatch(.)"/>
                        <xsl:text></xsl:text>
                  </xsl:when>
                  <xsl:when test="$classname = $span2para">
                        <!-- reference is in para but needs to be new line-->
                        <xsl:if test="count(preceding-sibling::span) = 0">
                              <xsl:text>&#13;&#10;\</xsl:text>
                              <xsl:value-of select="@class"/>
                              <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:apply-templates/>
                        <xsl:if test="matches(.,'[;,]$')">
                              <xsl:text> </xsl:text>
                        </xsl:if>
                  </xsl:when>
                  <!-- handling verses that are marked as first verses with formatting classses -->
                  <xsl:when test="$classname = $spanclassnameverse">
                        <!-- verse one handling where no first verse number -->
                        <xsl:text>&#13;&#10;\v </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text> </xsl:text>
                  </xsl:when>
                  <xsl:when test="$classname = 'fig'">
                        <!-- remove fig number inserted by PubAssist -->
                        <xsl:text>\</xsl:text>
                        <xsl:value-of select="@class"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="substring-after(.,'|')"/>
                        <xsl:text>\</xsl:text>
                        <xsl:value-of select="@class"/>
                        <xsl:text>*</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <!-- default handling of unspecified spans -->
                        <xsl:text>\</xsl:text>
                        <xsl:value-of select="@class"/>
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text>\</xsl:text>
                        <xsl:value-of select="@class"/>
                        <xsl:text>*</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="sectionatchapstart">
            <xsl:param name="data"/>
            <xsl:text>&#13;&#10;\s </xsl:text>
            <xsl:apply-templates select="$data"/>
      </xsl:template>
      <xsl:template match="table">
            <xsl:apply-templates select="thead"/>
            <xsl:apply-templates select="tbody|tr"/>
      </xsl:template>
      <xsl:template match="thead">
            <xsl:apply-templates select="tr" mode="head"/>
      </xsl:template>
      <xsl:template match="tbody">
            <xsl:apply-templates select="tr"/>
      </xsl:template>
      <xsl:template match="tr">
            <xsl:text>&#13;&#10;\tr </xsl:text>
            <xsl:apply-templates select="td"/>
      </xsl:template>
      <xsl:template match="tr" mode="head">
            <xsl:text>&#13;&#10;\tr </xsl:text>
            <xsl:apply-templates mode="head"/>
      </xsl:template>
      <xsl:template match="td">
            <xsl:text>\tc</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="node()" mode="table"/>
            <xsl:text> </xsl:text>
      </xsl:template>
      <xsl:template match="td|th" mode="head">
            <xsl:text>\th</xsl:text>
            <xsl:value-of select="position()"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="node()" mode="table"/>
            <xsl:text> </xsl:text>
      </xsl:template>
      <xsl:template match="p" mode="table">
            <xsl:value-of select="."/>
      </xsl:template>
      <xsl:template match="verse">
            <xsl:text>\v </xsl:text>
            <xsl:apply-templates/>
      </xsl:template>
      <xsl:template match="text()">
            <xsl:value-of select="translate(.,'&#160;&#9;',' ')"/>
      </xsl:template>
</xsl:stylesheet>
