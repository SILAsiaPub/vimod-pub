<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         .xslt
    # Purpose:
    # Part of:      Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       Ian McQuay <ian_mcquay@sil.org>
    # Created:      2015- -
    # Copyright:    (c) 2015 SIL International
    # Licence:      <LGPL>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs f">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="project.xslt"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <!-- <xsl:include href="inc-csv-tokenize.xslt"/> -->
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:param name="months"/>
      <xsl:variable name="month_list">
            <xsl:choose>
                  <xsl:when test="$months = 'current'">
                        <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]')"/>
                  </xsl:when>
                  <xsl:when test="$months = 'previous'">
                        <xsl:value-of select="format-date(current-date() - xs:dayTimeDuration(concat('P', day-from-date(current-date()), 'D')),'[Y0001]-[M01]')"/>
                  </xsl:when>
                  <xsl:when test="string-length($months) gt 0">
                        <xsl:value-of select="$months"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:text>2012-01 2012-02 2012-03 2012-04 2012-05 2012-06 2012-07 2012-08 2012-09 2012-10 2012-11 2012-12 2013-01 2013-02 2013-03 2013-04 2013-05 2013-06 2013-07 2013-08 2013-09 2013-10 2013-11 2013-12 2014-01 2014-02 2014-03 2014-04 2014-05 2014-06 2014-07 2014-08 2014-09 2014-10 2014-11 2014-12 2015-01 2015-02 2015-03 2015-04 2015-05 2015-06 2015-07 2015-08 2015-09 2015-10 2015-11 2015-12 2016-01 2016-02 2016-03 2016-04 2016-05 2016-06 2016-07 2016-08 2016-09 2016-10 2016-11 2016-12 2017-01 2017-02</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>
      <xsl:variable name="filename_list" select="'chapter-requests-by-country.csv chapter-requests-by-version.csv offline-by-country.csv offline-by-version.csv offline-downloads-by-user-by-version.csv shared-verses-by-version.csv switches-by-version.csv unique-chapter-requests.csv unique-switches-by-version.csv'"/>
      <!-- <xsl:variable name="filename_list" select="'offline-downloads-by-user-by-version.csv'"/> -->
      <xsl:variable name="asialang" select="concat($basepath,'/Languages.txt')"/>
      <xsl:variable name="asiaversion" select="concat($basepath,'/versions.txt')"/>
      <xsl:variable name="langtext" select="unparsed-text($asialang)"/>
      <xsl:variable name="versiontext" select="unparsed-text($asiaversion)"/>
      <xsl:variable name="lang" select="tokenize($langtext, '\r?\n')"/>
      <xsl:variable name="version" select="tokenize($versiontext, '\r?\n')"/>
      <xsl:variable name="month" select="tokenize($month_list, ' ')"/>
      <xsl:variable name="period">
            <xsl:choose>
                  <xsl:when test="$month[1]=$month[last()]">
                        <xsl:value-of select="$month[1]"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="concat($month[1],'-',$month[last()])"/>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:variable>
      <xsl:variable name="filename" select="tokenize($filename_list, ' ')"/>
      <!-- The following f:subsetarray subsets a two dimentional array, into a one dimentional array. Returning the field selected in a new array.
		  This is important if the parent is large and used in a lookup. i.e. a 2500 line by 3 field array, 
		   in a regular lookup takes 3.5 min but reduces to less than 30 seconds if subseted first. -->
      <xsl:variable name="findlanguage" select="f:subsetarray($lang,'&#9;',3)"/>
      <xsl:variable name="findiso" select="f:subsetarray($lang,'&#9;',2)"/>
      <xsl:variable name="returncountry" select="f:subsetarray($lang,'&#9;',1)"/>
      <xsl:variable name="findversion" select="f:subsetarray($version,'&#9;',3)"/>
      <xsl:variable name="returnlang" select="f:subsetarray($version,'&#9;',2)"/>
      <xsl:variable name="returncountry2" select="f:subsetarray($version,'&#9;',1)"/>
      <xsl:template match="/*">
            <xsl:element name="database">
                  <xsl:for-each select="$month">
                        <xsl:variable name="curmonth" select="."/>
                        <xsl:for-each select="$filename">
                              <!-- <xsl:variable name="curcsv" select="."/> -->
                              <xsl:call-template name="getmonth">
                                    <xsl:with-param name="curmth" select="$curmonth"/>
                                    <xsl:with-param name="curcsv" select="."/>
                              </xsl:call-template>
                        </xsl:for-each>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="getmonth">
            <xsl:param name="curmth"/>
            <xsl:param name="curcsv"/>
            <xsl:variable name="table" select="tokenize($curcsv,'\.')[1]"/>
            <xsl:variable name="href" select="f:file2uri(concat($basepath,'/',$curmth,'/',$curcsv))"/>
            <xsl:if test="unparsed-text-available($href)">
                  <xsl:variable name="text" select="unparsed-text($href)"/>
                  <xsl:variable name="line" select="tokenize($text,'\r?\n')"/>
                  <xsl:variable name="label" select="f:csvTokenize($line[1])"/>
                  <xsl:for-each select="$line[position() gt 1]">
                        <xsl:variable name="cell" select="f:csvTokenize(.)"/>
                        <xsl:if test="string-length($cell[1]) gt 0">
                              <xsl:element name="{$table}">
                                    <xsl:element name="yyyy-mm">
                                          <xsl:value-of select="$curmth"/>
                                    </xsl:element>
                                    <xsl:for-each select="$label">
                                          <xsl:variable name="pos" select="position()"/>
                                          <xsl:element name="{.}">
                                                <xsl:value-of select="$cell[$pos]"/>
                                          </xsl:element>
                                    </xsl:for-each>
                              </xsl:element>
                        </xsl:if>
                  </xsl:for-each>
            </xsl:if>
      </xsl:template>
</xsl:stylesheet>
