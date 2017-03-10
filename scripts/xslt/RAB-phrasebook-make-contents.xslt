<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     RAB-phrasebook-make-contents.xslt
    # Purpose:	Take a Song file in SFM and generate a menu contents xml
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016-10-31
    # Copyright:    (c) 2016 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="project.xslt"/>
      <xsl:variable name="tree" select="."/>
      <xsl:template match="/*">
            <contents>
                  <feature name="show-titles" value="true"/>
                  <feature name="show-subtitles" value="false"/>
                  <feature name="show-references" value="false"/>
                  <contents-items>
                        <!-- initial menu content -->
                        <xsl:for-each select="$home-menu">
                              <xsl:call-template name="submenu-item">
                                    <!-- this is working -->
                                    <xsl:with-param name="title" select="."/>
                                    <xsl:with-param name="target" select="position()"/>
                              </xsl:call-template>
                        </xsl:for-each>
                        <!-- subpage content -->
                        <xsl:for-each select="$field">
                              <!-- <xsl:comment select="'for each field'"/> -->
                              <!-- creates the items info for the menus -->
                              <xsl:apply-templates select="$tree//*[local-name() = $page-group]" mode="items">
                                    <!-- this is working -->
                                    <xsl:with-param name="field-seq" select="position()"/>
                                    <xsl:with-param name="cur-node" select="."/>
                              </xsl:apply-templates>
                        </xsl:for-each>
                        <!-- <xsl:call-template name="bulkitems"/> -->
                  </contents-items>
                  <contents-screens>
                        <!-- home page  -->
                        <contents-screen id="1">
                              <title lang="default">
                                    <xsl:value-of select="$home-menu[1]"/>
                              </title>
                              <items>
                                    <xsl:for-each select="$home-menu[position() gt 1]">
                                          <!-- this is working -->
                                          <item id="{position() + 1}"/>
                                    </xsl:for-each>
                              </items>
                        </contents-screen>
                        <!-- Other pages with menu place holders -->
                        <xsl:for-each select="$home-menu[position() gt 1]">
                              <contents-screen id="{position()}">
                                    <title lang="default">
                                          <xsl:value-of select="."/>
                                    </title>
                                    <items>
                                          <!-- <xsl:comment select="'inside for each homemenu'"/> -->
                                          <!-- Creates the pointers in the menu pages -->
                                          <xsl:apply-templates select="$tree//*[local-name() = $page-group]" mode="order">
                                                <xsl:with-param name="field-seq" select="position()"/>
                                                <xsl:with-param name="cur-node" select="$field[position()]"/>
                                          </xsl:apply-templates>
                                    </items>
                              </contents-screen>
                        </xsl:for-each>
                  </contents-screens>
            </contents>
      </xsl:template>
      <xsl:template match="*[name() = $page-group]" mode="items">
            <xsl:param name="field-seq"/>
            <xsl:param name="cur-node"/>
            <xsl:variable name="page-pos" select="count(preceding-sibling::*[name() = $page-group]) +1"/>
            <!-- <xsl:comment select="'page group lines'"/> -->
            <xsl:apply-templates select="*[name() = $subpage-group]" mode="items">
                  <xsl:with-param name="field-seq" select="$field-seq"/>
                  <xsl:with-param name="cur-node" select="$cur-node"/>
                  <xsl:with-param name="page-pos" select="$page-pos"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="*[name() = $page-group]" mode="order">
            <xsl:param name="field-seq"/>
            <xsl:param name="cur-node"/>
            <xsl:variable name="page-pos" select="count(preceding-sibling::*[name() = $page-group]) +1"/>
            <!-- <xsl:comment select="'page group order'"/> -->
            <xsl:apply-templates select="*[name() = $subpage-group]" mode="order">
                  <xsl:with-param name="field-seq" select="$field-seq"/>
                  <xsl:with-param name="cur-node" select="$cur-node"/>
                  <xsl:with-param name="page-pos" select="$page-pos"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="*[name() = $subpage-group]" mode="items">
            <xsl:param name="field-seq"/>
            <xsl:param name="cur-node"/>
            <xsl:param name="page-pos"/>
            <!-- <xsl:comment select="'subpage group items'"/> -->
            <xsl:apply-templates select="*[name() = $cur-node]" mode="items">
                    <!-- <xsl:sort select="replace(.,'^\d+\. ','')"/>  -->
                  <xsl:with-param name="field-seq" select="$field-seq"/>
                  <xsl:with-param name="cur-node" select="$cur-node"/>
                  <xsl:with-param name="page-pos" select="$page-pos"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="*[name() = $subpage-group]" mode="order">
            <xsl:param name="field-seq"/>
            <xsl:param name="cur-node"/>
            <xsl:param name="page-pos"/>
            <!-- <xsl:comment select="'subpage group order'"/> -->
            <!-- <xsl:variable name="pos" select="count(preceding::*[local-name() = $page-group]) + 1 + number($multiplier) * number($field-seq)"/> -->
            <!-- <xsl:variable name="thisele" select="$field[number($field-seq)]"/> -->
            <xsl:apply-templates select="*[name() = $cur-node]" mode="order">
                  <xsl:sort select="replace(child::*[name() = $cur-node]/text(),'^\d+\. ','')"/>
                  <xsl:with-param name="field-seq" select="$field-seq"/>
                  <xsl:with-param name="cur-node" select="$cur-node"/>
                  <xsl:with-param name="page-pos" select="$page-pos"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="*[local-name() = $field]" mode="items">
            <xsl:param name="field-seq"/>
            <xsl:param name="cur-node"/>
            <xsl:param name="page-pos"/>
            <!-- <xsl:variable name="id" select="$target"/> -->
            <xsl:variable name="page-ref">
                  <xsl:number value="$page-pos" format="001"/>
            </xsl:variable>
            <contents-item id="{number($field-seq) * number($jump) + count(preceding::*[local-name() = $cur-node] ) +1}">
                  <title lang="default">
                        <xsl:value-of select="replace(.,'^\d+\. ','')"/>
                  </title>
                  <link type="reference" target="{$page-ref}"/>
            </contents-item>
      </xsl:template>
      <xsl:template match="*[local-name() = $field]" mode="order">
            <xsl:param name="field-seq"/>
            <xsl:param name="cur-node"/>
            <xsl:param name="page-pos"/>
            <xsl:variable name="pos" select="number($field-seq) * number($jump) + count(preceding::*[local-name() = $cur-node]) +1"/>
            <item id="{$pos}"/>
      </xsl:template>
      <xsl:template name="submenu-item">
            <xsl:param name="title"/>
            <xsl:param name="target"/>
            <xsl:variable name="id" select="$target"/>
            <contents-item id="{$id}">
                  <title lang="default">
                        <xsl:value-of select="$title"/>
                  </title>
                  <link type="screen" target="{$target}"/>
            </contents-item>
      </xsl:template>
</xsl:stylesheet>
