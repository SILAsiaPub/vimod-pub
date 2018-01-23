<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		vp2usx-split-compilaton.xslt
    # Purpose:		This will split a grouped compilaton.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:			Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-12-01
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" name="xml"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:variable name="remove" select="tokenize('s1 s2 ref ms1',' ')"/>
      <xsl:template match="/*">
            <blank></blank>
            <xsl:for-each-group select="bkgrp" group-by="@bk">
                  <xsl:result-document href="{f:file2uri(concat($projectpath,'\usx\',@bk,'.usx'))}" format="xml">
                        <usx version="2.5">
                              <xsl:element name="book">
                                    <xsl:attribute name="code">
                                          <xsl:value-of select="@bk"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="style">
                                          <xsl:text>id</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>Tagbanwa - This version was machine reconstructed from Ventura</xsl:text>
                              </xsl:element>
                              <xsl:element name="para">
                                    <xsl:attribute name="style">
                                          <xsl:text>rem</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>This was  created from round tripping Ventura Publish Tagged text to USX. In this case it was a compilation. So had extra processing to sort</xsl:text>
                              </xsl:element>
                              <xsl:element name="para">
                                    <xsl:attribute name="style">
                                          <xsl:text>mt1</xsl:text>
                                    </xsl:attribute>
                                    <xsl:apply-templates select="current-group()[1]" mode="bkname"/>
                              </xsl:element>
                              <xsl:call-template name="chapter">
                                    <xsl:with-param name="chap" select="current-group()"/>
                              </xsl:call-template>
                        </usx>
                  </xsl:result-document>
            </xsl:for-each-group>
      </xsl:template>
      <xsl:template name="chapter">
            <xsl:param name="chap"/>
            <xsl:for-each-group select="$chap" group-by="@ch">
                  <xsl:sort select="@ch" data-type="number"/>
                  <xsl:sort select="@vr" data-type="number"/>
                  <xsl:element name="chapter">
                        <xsl:attribute name="number">
                              <xsl:value-of select="@ch[1]"/>
                        </xsl:attribute>
                        <xsl:attribute name="style">
                              <xsl:text>c</xsl:text>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:apply-templates select="current-group()"/>
            </xsl:for-each-group>
      </xsl:template>
      <xsl:template match="chapter"/>
      <xsl:template match="para[@style = $remove]"/>
      <xsl:template match="*[@style = 'ms1']" mode="bkname">
            <xsl:value-of select="replace(.,'\d+:[\d\-a-e]+','')"/>
      </xsl:template>
      <xsl:template match="text()" mode="bkname"/>
</xsl:stylesheet>
