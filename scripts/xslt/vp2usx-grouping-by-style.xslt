<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
      <!--
    #############################################################
    # Name: 			vp2usx-grouping-by-style.xslt
    # Purpose:		Takes a USX with a compilation from various books and groups the parts ready to be output to different USX in the next step.
    # Part of:			Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:   		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-11-16
    # Copyright:   	(c) 2017 SIL International
    # Licence:   		<MIT>
    ################################################################ -->
      <xsl:output method="xml" indent="yes"/>
      <xsl:param name="parent-node_list" select="'usx'"/>
       <!-- <xsl:param name="attribname"/> -->
      <xsl:param name="attribmatchvalue" select="'ms1'"/>
      <xsl:variable name="parent-node" select="tokenize($parent-node_list,' ')"/>
      <xsl:param name="attribinclude_list" select="'s1 s2'"/>
      <xsl:variable name="attribinclude" select="tokenize($attribinclude_list,' ')"/>
      <xsl:include href='inc-copy-anything.xslt'/>
      <xsl:template match="*[local-name() = $parent-node]">
            <xsl:for-each-group select="*" group-starting-with="*[@style = $attribmatchvalue]">
                  <xsl:choose>
                        <xsl:when test="preceding-sibling::*[@style = $attribmatchvalue] or self::*[@style = $attribmatchvalue]">
                              <xsl:element name="bkgrp">
                                    <!-- the next template writes the attributs bk, cha vr for later sorting. -->
                                    <xsl:apply-templates select="current-group()" mode="attrib"/>
                                    <!-- The next two templates bring in the preceding siblings that we want included-->
                                    <xsl:apply-templates select="preceding-sibling::para[2][@style = $attribinclude]" mode="include"/>
                                    <xsl:apply-templates select="preceding-sibling::para[1][@style = $attribinclude]" mode="include"/>
                                    <xsl:apply-templates select="current-group()[@style != $attribinclude or local-name()  != $parent-node]" mode="include"/>
                              </xsl:element>
                              <!-- <xsl:apply-templates select="current-group()[@style = $atribinclude or local-name() = $parent-node]" mode="exclude"/> -->
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:apply-templates select="current-group()"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:for-each-group>
      </xsl:template>
      <xsl:template match="*" mode="include">
            <xsl:choose>
                  <xsl:when test="local-name() = $parent-node">
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:copy>
                              <xsl:apply-templates select="@*|node()"/>
                        </xsl:copy>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*" mode="exclude">
            <xsl:choose>
                  <xsl:when test="@style = $attribinclude or local-name() = $parent-node">
                        <xsl:copy>
                              <xsl:apply-templates select="@*|node()"/>
                        </xsl:copy>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="para[@style = $attribinclude]"/>
      <xsl:template match="*[@style = 'ref']" mode="attrib">
            <xsl:variable name="ref" select="tokenize(.,'[ :]')"/>
            <xsl:attribute name="bk">
                  <xsl:value-of select="$ref[1]"/>
            </xsl:attribute>
            <xsl:attribute name="ch">
                  <xsl:value-of select="$ref[2]"/>
            </xsl:attribute>
            <xsl:attribute name="vr">
                  <xsl:value-of select="$ref[3]"/>
            </xsl:attribute>
      </xsl:template>
      <xsl:template match="text()" mode="attrib"/>
</xsl:stylesheet>
