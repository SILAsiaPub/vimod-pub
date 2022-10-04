<?xml version="1.0" encoding="utf-8"?> <!--
    #############################################################
    # Name:     	.xslt
    # Purpose:  	.
    # Part of:  	Xrunner - https://github.com/SILAsiaPub/xrunner
    # Author:   	Ian McQuay <ian_mcquay@sil.org>
    # Created:  	2022- -
    # Copyright:	(c) 2022 SIL International
    # Licence:  	<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
<xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" />

      <!-- Part of the SILP Dictionary Creator
Used to sort a xml dictionary source form SIL Philippines SFM code. But could work with MDF sfm also.
See Inculde below for essential other files.
Written by Ian McQuay
Created: 5/08/2012
Modified: 21/08/2012

 -->
      <xsl:output method="xml" indent="yes" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
      <xsl:include href='dict-custom-collation.xslt'/>
      <xsl:include href="inc-lower-remove-accents.xslt"/>
      <xsl:include href="inc-copy-anything.xslt"/>
      <xsl:include href="project.xslt"/>
      <!-- project.xslt contains all the paramaters for this xslt
collationname 
secondarysort
 -->
      <xsl:variable name="ac" select="'àáâãāçèéêëēìíîïɨīùúûüūòóôõöōŏőɴ'"/>
      <xsl:variable name="un" select="'aaaaaceeeeeiiiiiiuuuuuoooooooon'"/>
      <xsl:variable name="numbers" select="'0123456789'"/>
      <xsl:variable name="or-digraph">
            <xsl:choose>
                  <xsl:when test="string-length($digraphlist) gt 0">
                        <xsl:value-of select="replace($digraphlist,' ','|')"/>
                        <xsl:text>|</xsl:text>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:variable>
      <xsl:variable name="removefromstart">&#34;\-(“~\[,‘;&#39;#&#42;&#47;<xsl:value-of select="$removechar" /></xsl:variable>
      <xsl:variable name="default-collation" select="'http://saxon.sf.net/collation?lang=en-US;strength=primary'"/>
      <xsl:character-map name="xul">
            <xsl:output-character character="&#38;" string='&#38;'/>
      </xsl:character-map>
      <xsl:template match="/*">
            <data>
                  <xsl:choose>
                        <xsl:when test="$collationname != ''">
                              <xsl:comment select="concat('remove accent visual feedback &#10;',$ac,'&#10; Changed to &#10;',cite:lower-remove-accents($ac),'&#10;')"/>
                              <xsl:comment select="concat('custom sort = [',$customcollation,']')"/>
                              <xsl:for-each select="lxGroup">
                                    <xsl:sort collation="http://saxon.sf.net/collation?rules={encode-for-uri($customcollation)}" select="cite:lower-remove-accents-word(cite:word-no-number(lx))"/>
                                    <xsl:sort collation="{$default-collation}" select="cite:hom-number(lx)"/>
                                    <xsl:sort collation="{$default-collation}" select="*[name() = $secondarysort]"/>
                                    <xsl:copy>
                                          <xsl:apply-templates/>
                                    </xsl:copy>
                              </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:comment select="concat('default sort &#10;',$ac,' ',$default-collation)"/>
                              <xsl:for-each select="lxGroup">
                                    <xsl:sort collation="{$default-collation}" select="cite:lower-remove-accents-word(lx)"/>
                                    <xsl:sort collation="{$default-collation}" select="*[name() = $secondarysort]"/>
                                    <xsl:copy>
                                          <xsl:apply-templates/>
                                    </xsl:copy>
                              </xsl:for-each>
                        </xsl:otherwise>
                  </xsl:choose>
            </data>
      </xsl:template>
      <xsl:function name="f:lower-remove-accents">
            <xsl:param name="input"/>
            <xsl:variable name="findnremoveatstart" select="concat('^[\d\* ',$removefromstart,']*(',$or-digraph,'\w)(\w*)') "/>
            <xsl:variable name="lcinput" select="lower-case($input)"/>
            <xsl:variable name="trimmedinput" select="replace($lcinput,$findnremoveatstart,'$1$2')"/>
            <xsl:choose>
                  <xsl:when test="$translateaccents = 'yes'">
                        <xsl:sequence select="translate($trimmedinput,$ac,$un)"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:sequence select="$trimmedinput"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:function>
      <xsl:function name="f:word-no-number">
            <xsl:param name="input"/>
            <xsl:sequence select="translate($input,$numbers,'')"/>
      </xsl:function>
      <xsl:function name="f:no-space">
            <xsl:param name="input"/>
            <xsl:sequence select="translate($input,' ','')"/>
      </xsl:function>
      <xsl:function name="f:hom-number">
            <!-- used in dict-sort-with-custom-collation.xslt and index-group-n-sort.xslt -->
            <xsl:param name="input"/>
            <xsl:sequence select="substring-after($input,translate($input,$numbers,''))"/>
      </xsl:function>
</xsl:stylesheet>
