<!-- Join adjacent nodes of the same name, name selected by $serialnode parameter, separator modifiable by $separator parameter. 
	default separator "; "
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="xml" indent="yes"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:strip-space elements="*"/>
      <xsl:param name="serialnodes"/>
      <xsl:variable name="serialnode" select="tokenize($serialnodes,'\s+')"/>
      <!-- from: http://stackoverflow.com/questions/1806123/merging-adjacent-nodes-of-same-type-xslt-1-0
This works on merging adjacent cells if space is stripped from parent
 -->
      <!-- Match node that is equal to $serialnode param -->
      <xsl:template match="*[name() = $serialnode[1]]">
            <!-- modified match to accept parameters -->
            <!-- Is this the first element in a sequence? -->
            <xsl:element name="{$serialnode[1]}Group">
                  <xsl:copy>
                        <xsl:apply-templates/>
                  </xsl:copy>
                  <xsl:apply-templates select="following-sibling::node()[1][local-name()=$serialnode]" mode="next"/>
            </xsl:element>
      </xsl:template>
      <xsl:template match="*[name() = $serialnode[position() gt 1]]"/>
      <!-- Recursive template used to match the next sibling if it has the same name -->
      <xsl:template match="*" mode="next">
            <xsl:copy>
                  <xsl:apply-templates/>
            </xsl:copy>
            <xsl:apply-templates select="following-sibling::*[1][local-name()=$serialnode]" mode="next"/>
      </xsl:template>
</xsl:stylesheet>
