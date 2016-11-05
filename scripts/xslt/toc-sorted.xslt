<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         toc-sorted.xslt
    # Purpose:		create a toc from a partial html
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2015- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>
      <xsl:strip-space elements="*"/>
      <xsl:param name="header_list"/>
      <xsl:variable name="header" select="tokenize($header_list,' ')"/>
      <xsl:template match="/*">
            <ul>
                  <xsl:for-each select="//*[local-name() = $header]">
                        <xsl:sort/>
                        <li class="{local-name()}">
                              <a id="{text()[1]}-back" href="#{text()[1]}">
                                    <xsl:value-of select="text()[1]"/>
                              </a>
                        </li>
                  </xsl:for-each>
            </ul>
      </xsl:template>
</xsl:stylesheet>
