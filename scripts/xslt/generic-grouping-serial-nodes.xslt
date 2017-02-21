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
      <xsl:output method="xml" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:strip-space elements="*"/>
      <xsl:param name="serialnodes"/>
      <xsl:variable name="serialnode" select="tokenize($serialnodes,'\s+')"/>
      <xsl:template match="*[name() = $serialnode[1]]">
            <!-- Match node that is equal to the first $serialnode in the array -->
            <xsl:element name="{$serialnode[1]}Group">
                  <xsl:copy>
                        <xsl:apply-templates/>
                  </xsl:copy>
                  <xsl:apply-templates select="following-sibling::node()[1][local-name()=$serialnode]" mode="next"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = $serialnode[position() gt 1]]">
            <!-- Does not allow copying when the element occurs normally -->
      </xsl:template>
      <xsl:template match="*" mode="next">
            <!-- Recursive template used to match the next sibling if it is in the list after the first -->
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
            <xsl:apply-templates select="following-sibling::*[1][local-name()=$serialnode]" mode="next"/>
      </xsl:template>
</xsl:stylesheet>
