<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://saxon.sf.net/" version="2.0"  xmlns:f="myfunctions" exclude-result-prefixes="f">
      <!--
    #############################################################
    # Name:         dict-sort-combined-index.xslt
    # Purpose:	Sort multiple lists in one file
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2016-09-01
    # Copyright:    (c) 2016 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
      <!-- Part of the SILP Dictionary Creator
Used to sort a xml dictionary source form SIL Philippines SFM code. But could work with MDF sfm also.
See Inculde below for essential other files.
 -->
      <xsl:output method="xml" indent="yes" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
      <!-- <xsl:include href='dict-custom-collation.xslt'/> -->
      <xsl:include href="inc-lower-remove-accents.xslt"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:include href="project.xslt"/>
      <!-- project.xslt contains all the paramaters for this xslt
collationname 
secondarysort
 -->
      <xsl:variable name="default-collation" select="'http://saxon.sf.net/collation?lang=en-US;strength=primary'"/>
      <xsl:character-map name="xul">
            <xsl:output-character character="&#38;" string='&#38;'/>
      </xsl:character-map>
      <xsl:template match="/*">
            <data>
                  <xsl:apply-templates select="*"/>
            </data>
      </xsl:template>
      <xsl:template match="ver|eng|nat|reg|reg2|reg3">
            <xsl:variable name="collation-name" select="f:keyvalue($collation-names,name())"/>
            <xsl:variable name="custom-collation" select="f:keyvalue($custom-collations,name())"/>
            <xsl:copy>
                  <xsl:choose>
                        <xsl:when test="$collation-name != ''">
                              <xsl:comment select="concat('remove accent visual feedback &#10;',$ac,'&#10; Changed to &#10;',f:lower-remove-accents($ac),'&#10;')"/>
                              <xsl:comment select="concat('custom sort = [',$custom-collation,']')"/>
                              <xsl:for-each select="record">
                                    <xsl:sort collation="http://saxon.sf.net/collation?rules={encode-for-uri($custom-collation)}" select="f:lower-remove-accents-word(f:word-no-number(i))"/>
                                    <xsl:sort collation="{$default-collation}" select="f:hom-number(i)"/>
                                    <xsl:sort collation="{$default-collation}" select="d"/>
                                    <xsl:copy>
                                          <xsl:apply-templates/>
                                    </xsl:copy>
                              </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:comment select="concat('default sort &#10;',$ac,' ',$default-collation)"/>
                              <xsl:for-each select="record">
                                    <xsl:sort collation="{$default-collation}" select="f:lower-remove-accents-word(i)"/>
                                    <xsl:sort collation="{$default-collation}" select="d"/>
                                    <xsl:copy>
                                          <xsl:apply-templates/>
                                    </xsl:copy>
                              </xsl:for-each>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:copy>
      </xsl:template>
</xsl:stylesheet>
