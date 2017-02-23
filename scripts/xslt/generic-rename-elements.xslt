<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         generic-rename-elements.xslt
    # Purpose:	Rename nodes from supplied keyvalue list
    # Part of:      Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2017- -
    # Copyright:    (c) 2017 SIL International
    # Licence:      <MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:template match="*[local-name() = $element-rename-key]">
            <xsl:element name="{f:keyvalue($element-rename,local-name())}">
                  <xsl:apply-templates select="node()|@*"/>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
