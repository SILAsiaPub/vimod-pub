<!--
    #############################################################
    # Name:         generic-reorder-2nodes.xslt
    # Purpose:	Reorder the two supplied nodes
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
            <xsl:copy-of select="following-sibling::node()[1][local-name()=$serialnode[2]]"/>
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
      </xsl:template>
      <xsl:template match="*[name() = $serialnode[2]]">
            <xsl:choose>
                  <xsl:when test="preceding-sibling::*[1][local-name() = $serialnode[1]]"/>
                  <xsl:otherwise>
                        <xsl:copy>
                              <xsl:apply-templates/>
                        </xsl:copy>
                  </xsl:otherwise>
            </xsl:choose>
            <!-- Does not allow copying when the element occurs normally -->
      </xsl:template>
</xsl:stylesheet>
