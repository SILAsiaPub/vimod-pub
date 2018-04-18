<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		cmd2functions.xslt
    # Purpose:		parse a cmd file into individual functions.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-04-02
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="text" encoding="utf-8" name="text"/>
      <xsl:output method="text" encoding="utf-8"/>
      <!-- <xsl:include href="project.xslt"/> -->
      <xsl:param name="outputpath" select="'D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk\func'"/>
      <xsl:param name="cmdfilepath" select="'D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk\pub.cmd'"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:variable name="cmdfile" select="f:file2text($cmdfilepath)"/>
      <xsl:variable name="inserted-token" select=" replace($cmdfile,'\r\n(:[^:])','XXXX$1')"/>
      <xsl:variable name="func" select="tokenize($inserted-token,'XXXX')"/>
      <xsl:variable name="parsefilepath" select="tokenize($cmdfilepath,'\\')"/>
      <xsl:variable name="parsefilename" select="tokenize($parsefilepath[last()],'\.')"/>
      <xsl:template match="/">
            <xsl:value-of select="$func[1]"/>
            <xsl:for-each select="$func">
                  <xsl:variable name="line" select="tokenize(.,'\r?\n')"/>
                  <xsl:variable name="outname">
                        <xsl:choose>
                              <xsl:when test="position() = 1">
                                    <xsl:text>aa_</xsl:text>
                                    <xsl:value-of select="$parsefilename[1]"/>
                                    <xsl:text>-header</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:value-of select="replace($line[1],':([^\s]+)','$1')"/>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:variable>
                  <xsl:result-document href="{f:file2uri(concat($outputpath,'/',$outname,'.cmd'))}" format="text">
                        <xsl:value-of select="."/>
                        <xsl:text>&#13;&#10;</xsl:text>
                  </xsl:result-document>
            </xsl:for-each>
      </xsl:template>
</xsl:stylesheet>
