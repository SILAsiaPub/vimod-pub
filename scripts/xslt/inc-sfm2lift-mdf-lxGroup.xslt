<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		.xslt
    # Purpose:		.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017- -
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:template match="lxGroup">
            <xsl:variable name="pos" select="count(preceding-sibling::lxGroup) + 1"/>
            <xsl:variable name="guid" select="concat('lx',$pos)"/>
            <xsl:variable name="id" select="concat(translate(lx,'.*',''),hm)"/>
            <xsl:variable name="hm">
                  <xsl:choose>
                        <xsl:when test="hm">
                              <xsl:value-of select="hm"/>
                        </xsl:when>
                        <xsl:when test="preceding-sibling::lxGroup/lx[1] = lx">
                              <xsl:value-of select="count(preceding-sibling::lxGroup/lx = lx) +1"/>
                        </xsl:when>
                        <xsl:when test="following-sibling::lxGroup/lx[1] = lx">
                              <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:variable>
            <xsl:element name="entry">
                  <xsl:attribute name="dateCreated">
                        <xsl:value-of select="current-dateTime()"/>
                  </xsl:attribute>
                  <xsl:attribute name="dateModified">
                        <xsl:value-of select="current-dateTime()"/>
                  </xsl:attribute>
                  <xsl:attribute name="guid">
                        <xsl:value-of select="$guid"/>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                        <!-- <xsl:value-of select="concat(lx,'_',hm,'_','lx',$pos)"/> -->
                        <xsl:value-of select="$id"/>
                  </xsl:attribute>
                  <xsl:if test="$hm">
                        <xsl:attribute name="order">
                              <xsl:value-of select="$hm"/>
                        </xsl:attribute>
                  </xsl:if>
                  <xsl:apply-templates select="*">
                        <xsl:with-param name="pos" select="$pos"/>
                        <xsl:with-param name="id" select="$guid"/>
                        <xsl:with-param name="secaller" select="'true'"/>
                  </xsl:apply-templates>
            </xsl:element>
            <xsl:apply-templates select="*/*[local-name() = $se-group-node]">
                  <!-- Create the se as separate entries -->
                  <xsl:with-param name="pos" select="$pos"/>
                  <xsl:with-param name="id" select="$guid"/>
            </xsl:apply-templates>
      </xsl:template>
</xsl:stylesheet>
