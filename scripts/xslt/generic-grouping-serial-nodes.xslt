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
      <xsl:template match="*[local-name() = $serialnode]">
            <xsl:variable name="sibling" select="tokenize(replace($serialnodes,local-name(),''),' ')"/>
            <xsl:choose>
                  <xsl:when test="preceding-sibling::*[1][local-name() = $serialnode]">
                        <xsl:choose>
                              <xsl:when test="local-name() = local-name(parent::*/*[local-name() = $serialnode][1])">
                                    <xsl:element name="{local-name()}Group">
                                          <xsl:copy>
                                                <xsl:apply-templates/>
                                          </xsl:copy>
                                          <xsl:apply-templates select="following-sibling::node()[1][local-name()=$sibling]" mode="next">
                                                <xsl:with-param name="first" select="name()"/>
                                          </xsl:apply-templates >
                                    </xsl:element>
                              </xsl:when>
                              <xsl:otherwise/>
                        </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                        <!-- Match node that is equal to the first $serialnode in the array -->
                        <xsl:element name="{local-name()}Group">
                              <xsl:copy>
                                    <xsl:apply-templates/>
                              </xsl:copy>
                              <xsl:apply-templates select="following-sibling::node()[1][local-name()=$sibling]" mode="next">
                                    <xsl:with-param name="first" select="name()"/>
                              </xsl:apply-templates >
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template match="*" mode="next">
            <!-- Recursive template used to match the next sibling if it is in the list after the first -->
            <xsl:param name="first"/>
            <xsl:variable name="sibling" select="tokenize(replace($serialnodes,$first,''),' ')"/>
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
            <xsl:apply-templates select="following-sibling::*[1][local-name()=$sibling]" mode=" next">
                  <xsl:with-param name="first" select="$first"/>
            </xsl:apply-templates >
      </xsl:template>
</xsl:stylesheet>
