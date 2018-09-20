<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		project-remove-empty-except.xslt
    # Purpose:		supply list of possible empty nodes to remove, but don't remove if they contain data or elements
    # Part of:		Xrunner - https://github.com/SILAsiaPub/xrunner
    # Author:  	Ian McQuay <ian_mcquay@sil.org>
    # Created: 	2018-07-03
    # Copyright:	(c) 2015 SIL International
    # Licence:  	<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" />
<xsl:strip-space elements="*"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:template match="*[local-name() = $removeempty]">
                  <xsl:if test="normalize-space(.) ne ''">
                        <!-- When there is something in the text field, output it -->
                        <xsl:copy>
                              <xsl:apply-templates/>
                        </xsl:copy>
                  </xsl:if>
      </xsl:template>
</xsl:stylesheet>
