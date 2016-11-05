<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
      <!--
    #############################################################
    # Name:         dict-split-string.xslt
    # Purpose:	Split string for particular fields. Based on defined separator field. remove unwanted fields and separate se fields.
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016-08-31
    # Copyright:    (c) 2016 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
      <!-- 
            Used t to split node text into separate nodes based on a spliting string (default=, )
            Created by Ian McQuay 
            Created 2012-06-14
            Modified: 2014-08-20 changed from generated xml to tokenized list

            
            the following is sample data:
            <database>
            <lxGroup><ie>meaning1; meaning2; meaning3; meaning4</ie></lxGroup>
            </database>
      -->
      <xsl:output method="xml" indent="yes"/>
      <xsl:include href="project.xslt"/>
      <!-- <xsl:param name="separatorstring" select="';'"/> -->
      <!-- <xsl:param name="elementstosplit"/> -->
      <!-- <xsl:variable name="split" select="tokenize($elementstosplit,' ')"/> -->
      <xsl:include href='inc-file2uri.xslt'/>
      <!-- Template used to copy a generic node -->
      <xsl:template match="/*">
            <xsl:copy>
                  <xsl:apply-templates select="*"/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="lx|se">
            <xsl:element name="lx">
                  <xsl:apply-templates/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="lxGroup">
            <xsl:copy>
                  <xsl:apply-templates select="*"/>
            </xsl:copy>
            <xsl:apply-templates select="seGroup" mode="outside"/>
      </xsl:template>
      <xsl:template match="seGroup"/>
      <xsl:template match="seGroup" mode="outside">
            <lxGroup>
                  <xsl:apply-templates select="*"/>
            </lxGroup>
      </xsl:template>
      <xsl:template match="*[local-name() = $elementstosplit]">
            <!-- Template used to select data to split-->
            <xsl:variable name="subfield" select="tokenize(.,$separatorstring)"/>
            <xsl:variable name="name" select="name()"/>
            <xsl:for-each select="$subfield">
                  <xsl:element name="{$name}">
                        <xsl:value-of select="normalize-space(.)"/>
                  </xsl:element>
            </xsl:for-each>
      </xsl:template>
      <xsl:template match="*">
            <xsl:apply-templates select="*"/>
      </xsl:template>
</xsl:stylesheet>
