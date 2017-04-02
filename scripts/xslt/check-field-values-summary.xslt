<!--
    #############################################################
    # Name:   		check-field-values-summary.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs f" version="2.0" xmlns:f="myfunctions">
      <xsl:output name="text" indent="yes" omit-xml-declaration="yes"/>
<xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" />
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:strip-space elements="*"/>
      <xsl:param name="node_list"/>
      <xsl:param name="outpath"/>
      <xsl:variable name="uripath" select="f:file2uri($outpath)"/>
      <xsl:variable name="default-collation" select="'http://saxon.sf.net/collation?lang=en-US;strength=primary'"/>
      <xsl:variable name="node" select="tokenize($node_list,' ')"/>
      <xsl:template match="/*">
            <xsl:for-each-group select="*[local-name() = $node]" group-by="local-name()">
                  <xsl:sort select="."/>
                  <xsl:value-of select="name()"/>
                  <xsl:text>&#13;&#10;</xsl:text>
                  <xsl:call-template name="writexmlreports">
                        <xsl:with-param name="filename">
                              <xsl:value-of select="$uripath"/>
                              <xsl:text>/</xsl:text>
                              <xsl:value-of select="name()"/>
                              <xsl:text>.xml</xsl:text>
                        </xsl:with-param>
                        <xsl:with-param name="fields" select="current-group()"/>
                        <xsl:with-param name="fieldname" select="local-name()"/>
                  </xsl:call-template>
                  <xsl:call-template name="writetabreports">
                        <xsl:with-param name="filename">
                              <xsl:value-of select="$uripath"/><xsl:text>/</xsl:text>
                              <xsl:value-of select="name()"/>
                              <xsl:text>.txt</xsl:text>
                        </xsl:with-param>
                        <xsl:with-param name="fields" select="current-group()"/>
                        <xsl:with-param name="fieldname" select="local-name()"/>
                  </xsl:call-template>
            </xsl:for-each-group>
      </xsl:template>
      <xsl:template name="writexmlreports">
            <xsl:param name="filename"/>
            <xsl:param name="fields"/>
            <xsl:param name="fieldname"/>
             <xsl:result-document href="{$filename}" method="xml"> 
            <data>
                  <xsl:for-each-group select="$fields" group-by=".">
                        <xsl:sort select="preceding-sibling::lx[1]" collation="{$default-collation}"/>
                        <xsl:element name="{$fieldname}">
                              <xsl:attribute name="count">
                                    <xsl:value-of select="count(current-group())"/>
                              </xsl:attribute>
                              <xsl:attribute name="value">
                                    <xsl:value-of select="."/>
                              </xsl:attribute>
                              <xsl:attribute name="display_word"/>
                              <xsl:attribute name="lx">
                                    <xsl:value-of select="preceding-sibling::lx[1]"/>
                              </xsl:attribute>
                              <xsl:attribute name="lxid">
                                    <xsl:value-of select="count(preceding-sibling::lx)"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:for-each-group>
            </data>
             </xsl:result-document> 
      </xsl:template>
      <xsl:template name="writetabreports">
            <xsl:param name="filename"/>
            <xsl:param name="fields"/>
            <xsl:param name="fieldname"/>
            <xsl:result-document href="{$filename}" method="text">
                  <xsl:value-of select="$fieldname"/>
                  <xsl:text> Report&#13;&#10;=========================================&#13;&#10;</xsl:text>
                  <xsl:for-each-group select="$fields" group-by=".">
                        <xsl:sort select="."/>
                        <xsl:text>	</xsl:text>
                        <xsl:value-of select="count(current-group())"/>
                        <xsl:text>	</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>&#13;&#10;</xsl:text>
                  </xsl:for-each-group>
            </xsl:result-document>
      </xsl:template>
</xsl:stylesheet>
