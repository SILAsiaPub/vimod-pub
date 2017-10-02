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
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:param name="datafile" select="'D:\All-SIL-Publishing\github-SILAsiaPub\audio-to-3gp\trunk\winff-presets.txt'"/>
      <xsl:variable name="line" select="f:file2lines($datafile)"/>
      <xsl:template match="/">
            <xsl:element name="presets">
                  <xsl:for-each select="$line">
                        <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                        <xsl:variable name="elename" select="concat(translate($cell[5],' ',''),$cell[1],$cell[3],$cell[2])"/>
                        <xsl:variable name="audiocodec" select="if ($cell[6] = 'AMR-wb') then 'libvo_amrwbenc' else if ($cell[6] = 'MP3')  then 'libmp3lame' else 'libopencore-amrnb'"/>
                        <xsl:variable name="videosettings" select="if ($cell[1] = '3gp') then '-r 5 -b:v 12k -vf scale=128:96 -vcodec h263' else '' "/>
                        <xsl:element name="{$elename}">
                              <label>
                                    <xsl:if test="$cell[1] ne 'mp3'">
                                          <xsl:value-of select="$cell[1]"/>
                                          <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="$cell[6]"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="$cell[2]"/>
                                    <xsl:text>Hz </xsl:text>
                                    <xsl:if test="$cell[4] = 'unofficial'">
                                          <xsl:text> unofficial sample rate </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="$cell[3]"/>
                                    <xsl:text> mono Video H.263 128x96 </xsl:text>
                              </label>
                              <params><xsl:value-of select="$videosettings"/> -ac 1 -ar <xsl:value-of select="$cell[2]"/> -b:a <xsl:value-of select="$cell[3]"/> -strict <xsl:value-of select="$cell[4]"/> -acodec <xsl:value-of select="$audiocodec"/></params>
                              <!-- <params>-r 15 -b:v 64k -ac 1 -vf scale=128:96 -ar 16000 -b:a 32k -acodec libvo_aacenc -vcodec h263</params> -->
                              <extension>
                                    <xsl:value-of select="$cell[1]"/>
                              </extension>
                              <category>
                                    <xsl:value-of select="$cell[5]"/>
                              </category>
                        </xsl:element>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
