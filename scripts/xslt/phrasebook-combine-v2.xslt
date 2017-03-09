<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="project.xslt"/>
      <xsl:variable name="doc2" select="doc(f:file2uri(concat($projectpath,'\xml\',$order-lang[2],'.xml')))"/>
      <xsl:variable name="doc3" select="doc(f:file2uri(concat($projectpath,'\xml\',$order-lang[3],'.xml')))"/>
      <xsl:variable name="doc4" select="doc(f:file2uri(concat($projectpath,'\xml\',$order-lang[4],'.xml')))"/>
      <xsl:template match="/*">
            <data>
                  <xsl:for-each select="*">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:element name="{name()}Group">
                              <xsl:copy-of select="."/>
                              <xsl:copy-of select="$doc2/database/*[position() = $pos]"/>
                              <xsl:copy-of select="$doc3/database/*[position() = $pos]"/>
                              <xsl:copy-of select="$doc4/database/*[position() = $pos]"/>
                        </xsl:element>
                  </xsl:for-each>
            </data>
      </xsl:template>
</xsl:stylesheet>
