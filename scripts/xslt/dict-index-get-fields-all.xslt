<!--
    #############################################################
    # Name:         dict-index-get-fields-all.xslt
    # Purpose:	make the output for each index needed
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay.org>
    # Created:      2014- 04-08 (the day XP died)
    # Copyright:    (c) 2013 SIL International
    # Licence:      <LGPL>
    ################################################################
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:variable name="data" select="."/>
      <xsl:template match="/*">
            <xsl:element name="database">
                  <xsl:element name="ver">
                        <xsl:variable name="fields" select="$index_source_fields_ver"/>
                        <xsl:apply-templates select="lxGroup" mode="lx">
                              <xsl:with-param name="list" select="$fields"/>
                        </xsl:apply-templates>
                  </xsl:element>
                  <xsl:element name="eng">
                        <xsl:apply-templates select="lxGroup">
                              <xsl:with-param name="list" select="$index_source_fields_eng_list"/>
                        </xsl:apply-templates>
                  </xsl:element>
                  <xsl:if test="string-length($index_source_fields_nat) gt 0">
                        <xsl:element name="nat">
                              <xsl:variable name="fields" select="$index_source_fields_nat"/>
                              <xsl:apply-templates select="lxGroup">
                                    <xsl:with-param name="list" select="$fields"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:if>
                  <xsl:if test="string-length($index_source_fields_reg) gt 0">
                        <xsl:element name="reg">
                              <xsl:variable name="fields" select="$index_source_fields_reg"/>
                              <xsl:apply-templates select="lxGroup">
                                    <xsl:with-param name="list" select="$fields"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:if>
                  <xsl:if test="string-length($index_source_fields_reg2) gt 0">
                        <xsl:element name="reg2">
                              <xsl:variable name="fields" select="$index_source_fields_reg2"/>
                              <xsl:apply-templates select="lxGroup">
                                    <xsl:with-param name="list" select="$fields"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:if>
                  <xsl:if test="string-length($index_source_fields_reg3) gt 0">
                        <xsl:element name="reg3">
                              <xsl:variable name="fields" select="$index_source_fields_reg3"/>
                              <xsl:apply-templates select="lxGroup">
                                    <xsl:with-param name="list" select="$fields"/>
                              </xsl:apply-templates>
                        </xsl:element>
                  </xsl:if>
            </xsl:element>
      </xsl:template>
      <xsl:template match="lxGroup">
            <xsl:param name="list"/>
<xsl:variable name="list2" select="tokenize($list,' ')"/>
            <xsl:apply-templates select="*[name()=$list2]" mode="field">
                  <xsl:with-param name="counter" select="position()"/>
                  <xsl:with-param name="list" select="$list"/>
                  <xsl:with-param name="lx" select="lx"/>
            </xsl:apply-templates>
      </xsl:template>
      <xsl:template match="lxGroup" mode="lx">
            <record>
                  <xsl:element name="i">
                        <xsl:value-of select="lx"/>
                  </xsl:element>
                  <xsl:element name="d">
                        <xsl:apply-templates select="de[1]"/>
                  </xsl:element>
                  <counter>
                        <xsl:value-of select="position()"/>
                  </counter>
            </record>
      </xsl:template>
      <xsl:template match="*" mode="field">
            <xsl:param name="lx"/>
            <xsl:param name="counter"/>
            <xsl:call-template name="line">
                  <xsl:with-param name="ie" select="."/>
                  <xsl:with-param name="lx" select="$lx"/>
                  <xsl:with-param name="count" select="$counter"/>
            </xsl:call-template>
      </xsl:template>
      <xsl:template name="line">
            <xsl:param name="ie"/>
            <xsl:param name="lx"/>
            <xsl:param name="count"/>
            <xsl:if test="$ie ne ''">
                  <record>
                        <i>
                              <xsl:value-of select="normalize-space($ie)"/>
                        </i>
                        <d>
                              <xsl:value-of select="normalize-space($lx)"/>
                        </d>
                        <counter>
                              <xsl:value-of select="$count"/>
                        </counter>
                  </record>
            </xsl:if>
      </xsl:template>
<xsl:template match="eng|de">
<xsl:apply-templates />
</xsl:template>
</xsl:stylesheet>
