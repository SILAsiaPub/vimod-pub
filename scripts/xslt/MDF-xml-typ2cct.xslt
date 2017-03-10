

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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output method="text" encoding="utf-8"/>
<xsl:strip-space elements="*"/>
      <xsl:template match="/*">
            <xsl:text>begin	>	store(char) 'abcdefghijklmnopqrstuvwxyz01234567890' store(nul)</xsl:text>
            <xsl:apply-templates mode="label"/>
            <xsl:apply-templates mode="counter"/>
            <xsl:text>&#10;&#9;&#9;store(nul)</xsl:text>
            <xsl:apply-templates mode="switch"/>
            <xsl:text>&#10;&#10;group(main)</xsl:text>
            <xsl:apply-templates mode="match"/>
<xsl:text>&#10;'\' any(char) any(char) any(char) any(char) &#9;&gt;&#9;append(residue) dup ' ' store(nul)</xsl:text>
<xsl:text>&#10;'\' any(char) any(char) any(char) &#9;&gt;&#9;append(residue) dup ' ' store(nul)</xsl:text>
<xsl:text>&#10;'\' any(char) any(char) &#9;&gt;&#9;append(residue) dup ' ' store(nul)</xsl:text>
<xsl:text>&#10;'\' any(char)  &#9;&gt;&#9;append(residue) dup ' ' store(nul)</xsl:text>
            <xsl:text>&#10;endfile	>	endstore dup back Use(end)

group(end)
endfile	>	dup</xsl:text>
            <xsl:apply-templates mode="write"/>
            <xsl:text>&#10;&#9;&#9; nl nl</xsl:text>
            <xsl:apply-templates mode="writeline"/>
<xsl:text>&#10;&#10;&#9;&#9;'Residue: ' out(residue)</xsl:text>
      </xsl:template>
      <xsl:template match="mkrGroup" mode="label">
            <xsl:text>&#10;&#9;&#9;store(lbl-</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) '</xsl:text>
            <xsl:value-of select="nam"/>
            <xsl:text>'</xsl:text>
      </xsl:template>
      <xsl:template match="mkrGroup" mode="counter">
            <xsl:text>&#10;&#9;&#9;store(</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) "0"</xsl:text>
      </xsl:template>
      <xsl:template match="mkrGroup" mode="switch">
            <xsl:text>&#10;&#9;&#9;clear(x</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>)</xsl:text>
      </xsl:template>
      <xsl:template match="mkrGroup" mode="match">
            <xsl:text>&#10;'\</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text> '&#9;>&#9;dup incr(</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) set(x</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>)</xsl:text>
            <xsl:text>&#10;'\</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>'&#9;>&#9;dup incr(</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) set(x</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>)</xsl:text>
      </xsl:template>
      <xsl:template match="mkrGroup" mode="write">
            <xsl:text>&#10;&#9;&#9;if(x</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) '</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>' tab out(</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) tab out(lbl-</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) nl endif</xsl:text>
      </xsl:template>
      <xsl:template match="mkrGroup" mode="writeline">
            <xsl:text>&#10;&#9;&#9;if(x</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text>) "</xsl:text>
            <xsl:value-of select="mkr"/>
            <xsl:text> " endif</xsl:text>
      </xsl:template>
</xsl:stylesheet>
