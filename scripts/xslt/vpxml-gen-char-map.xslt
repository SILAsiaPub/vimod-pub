<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		vpxml-gen-char-map.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" use-character-maps="cmap"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:param name="inputfile"/>
      <xsl:variable name="line" select="f:file2lines($inputfile)"/>
      <xsl:template match="/*">
            <xsl:element name="xsl:stylesheet">
                  <xsl:attribute name="version">
                        <xsl:text>2.0</xsl:text>
                  </xsl:attribute>
                  <xsl:namespace name="f" select="'myfunctions'"/>
                  <xsl:attribute name="exclude-result-prefixes">
                        <xsl:text>f</xsl:text>
                  </xsl:attribute>
                  <xsl:element name="xsl:character-map">
                        <xsl:attribute name="name">
                              <xsl:text>cmap</xsl:text>
                        </xsl:attribute>
                        <xsl:for-each select="$line">
                              <xsl:variable name="part" select="tokenize(.,'=')"/>
                              <xsl:comment select="$part[3]"/>
                              <xsl:if test=".">
                                    <xsl:element name="xsl:output-character">
                                          <xsl:attribute name="character">
                                                <xsl:value-of select="f:makeentity($part[1])"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="string">
                                                <xsl:value-of select="f:makeentity($part[2])"/>
                                          </xsl:attribute>
                                    </xsl:element>
                              </xsl:if>
                        </xsl:for-each>
                  </xsl:element>
            </xsl:element>
      </xsl:template>
      <xsl:function name="f:makeentity">
            <xsl:param name="char"/>
            <xsl:choose>
                  <xsl:when test="string-length($char) = 5 and substring($char,1,1) = 'u'">
                        <xsl:text>&amp;#x</xsl:text>
                        <xsl:value-of select="substring-after($char,'u')"/>
                        <xsl:text>;</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="$char"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:function>
      <xsl:character-map name="cmap">
            <xsl:output-character character="&amp;" string="&amp;"/>
      </xsl:character-map>
</xsl:stylesheet>
