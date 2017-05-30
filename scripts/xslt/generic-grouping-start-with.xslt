<!--
    #############################################################
    # Name:         generic-grouping-serial-nodes.xslt
    # Purpose:	Groups nodes that occur together. The first node must be first. The other nodes may or may not occur.
    # Part of:      Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2017-02-21
    # Copyright:    (c) 2017 SIL International
    # Licence:      <MIT>
    ################################################################ -->
<!-- Usage: grouping xv xn xe together -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <!-- <xsl:include href="inc-copy-anything.xslt"/> -->
      <xsl:strip-space elements="*"/>
      <xsl:param name="serial-node_list"/>
      <xsl:variable name="serial-node" select="tokenize($serial-node_list,'\s+')"/>
      <xsl:template match="/*">
            <xsl:apply-templates select="*"/>
      </xsl:template>
      <xsl:template match="*[local-name() = $serial-node]">
            <xsl:variable name="first" select="local-name()"/>
            <xsl:element name="{local-name()}Group">
                  <xsl:copy>
                        <xsl:apply-templates/>
                  </xsl:copy>
                  <xsl:apply-templates select="following-sibling::node()[1][local-name() ne $first]" mode=" next">
                        <xsl:with-param name="first" select="name()"/>
                  </xsl:apply-templates >
            </xsl:element>
      </xsl:template>
      <xsl:template match="*" mode=" next">
            <!-- Recursive template used to match the next sibling if it is in the list after the first -->
            <xsl:param name="first"/>
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
            <xsl:apply-templates select="following-sibling::*[1][local-name() ne $first]" mode=" next">
                  <xsl:with-param name="first" select="$first"/>
            </xsl:apply-templates >
      </xsl:template>
</xsl:stylesheet>
