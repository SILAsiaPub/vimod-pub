<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:variable name="line" select="f:file2lines($inputfile)"/>
      <xsl:template match="/*">
            <contents>
                  <title lang="{$titlelanguage}">
                        <xsl:value-of select="$title"/>
                  </title>
                  <feature name="show-titles" value="{$show-titles}"/>
                  <feature name="show-subtitles" value="{$show-subtitles}"/>
                  <feature name="show-references" value="{$show-references}"/>
                  <feature name="launch-action" value="{$launch-action}"/>
                  <contents-items>
                        <xsl:for-each select="$home-menu-title">
                              <xsl:variable name="pos" select="position()"/>
                              <xsl:call-template name="item">
                                    <xsl:with-param name="title" select="."/>
                                    <xsl:with-param name="subtitle" select="$home-menu-subtitle[number(position())]"/>
                                    <xsl:with-param name="link-type" select="'screen'"/>
                                    <xsl:with-param name="link-target" select="position() + 1"/>
                              </xsl:call-template>
                        </xsl:for-each>
                        <xsl:for-each select="$line">
                              <xsl:variable name="pos" select="position() + 100"/>
                              <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                              <xsl:call-template name="lineparse">
                                    <xsl:with-param name="title" select="concat($cell[6],' - ',$cell[5])"/>
                                    <xsl:with-param name="subtitle" select="$cell[4]"/>
                                    <xsl:with-param name="collection_list" select="$cell[7]"/>
                                    <xsl:with-param name="link-type" select="'reference'"/>
                                    <xsl:with-param name="link-target" select="f:reference($cell[1])"/>
                                    <xsl:with-param name="layout-mode" select="if (string-length($cell[7]) gt 4) then 'two' else 'single'"/>
                              </xsl:call-template>
                        </xsl:for-each>
                  </contents-items>
                  <contents-screens>
                        <xsl:for-each select="$screen-name">
                              <xsl:call-template name="listscreen">
                                    <xsl:with-param name="title" select="."/>
                                    <xsl:with-param name="seq" select="position()"/>
                              </xsl:call-template>
                        </xsl:for-each>
                  </contents-screens>
            </contents>
      </xsl:template>
      <xsl:template name="item">
            <xsl:param name="title"/>
            <xsl:param name="subtitle"/>
            <xsl:param name="link-type"/>
            <xsl:param name="link-target"/>
            <xsl:param name="collection_list"/>
            <xsl:variable name="collection" select="tokenize($collection_list,' ')"/>
            <xsl:variable name="target" select="number($itemnumb) + 1"/>
            <contents-item id="{$itemnumb}">
                  <title lang="{$titlelanguage}">
                        <xsl:value-of select="$title"/>
                  </title>
                  <subtitle lang="{$subtitlelanguage}">
                        <xsl:value-of select="$subtitle"/>
                  </subtitle>
                  <link type="{$link-type}" target="{$target}"/>
                  <xsl:if test="$link-type = 'reference'">
                        <layout mode="{$layout-mode}">
                              <xsl:for-each select="$collection">
                                    <layout-collection id="{.}"/>
                              </xsl:for-each>
                        </layout>
                  </xsl:if>
            </contents-item>
      </xsl:template>
      <xsl:template name="listscreen">
            <xsl:param name="title"/>
            <xsl:param name="seq"/>
            <xsl:variable name="thisele" select="$field[number($seq)]"/>
            <contents-screen id="{number($seq) + 1}">
                  <title lang="default">
                        <xsl:value-of select="$title"/>
                  </title>
                  <items>
                        <xsl:choose>
                              <xsl:when test="number($seq) = 1">

</xsl:when>
                              <xsl:otherwise>
                                    <xsl:for-each select="$line">
                                          <xsl:variable name="line-numb" select="position()"/>
                                          <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                                          <xsl:if test="matches($cell[1],$screen-group-by[number($seq) + 1])">
                                                <item id="{$line-numb}"/>
                                          </xsl:if>
                                    </xsl:for-each>
                              </xsl:otherwise>
                        </xsl:choose>
                        <xsl:apply-templates select="*[local-name() = $page-group]" mode="order">
                              <xsl:sort select="replace(replace(*[name() = $thisele][1],'Tunu. ',''),'\((.+)\)','$1')" data-type="{if($thisele = 'c') then 'number' else 'text'}"/>
                              <xsl:with-param name="seq" select="$seq"/>
                        </xsl:apply-templates >
                  </items>
            </contents-screen>
      </xsl:template>
</xsl:stylesheet>
