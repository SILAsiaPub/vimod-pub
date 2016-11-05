<?xml version="1.0" encoding="utf-8"?> <!--
    #############################################################
    # Name:     .xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:template match="/">
    <xsl:call-template name="generatelist" />
</xsl:template>

<xsl:template name="generatelist">

        <xsl:element name="list">
            <xsl:element name="dir">
                <xsl:for-each
                    select="collection('file:///C:/tmp?select=project.tasks')">
                    <xsl:element name="file">
                        <xsl:attribute name="name">
                            <xsl:value-of select="tokenize(document-uri(.), '/')[last()]" />
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>

</xsl:template>
</xsl:stylesheet>