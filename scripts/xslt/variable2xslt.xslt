<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	variable2xslt.xslt
    # Purpose:		Generate a XSLT that takes the project.txt file and make var in there into param. Also includes xvarset files and xarray files as param and adds xslt files as includes in project.xslt 
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay.org>
    # Created:      	2014- -
    # Copyright:    	(c) 2013 SIL International
    # Licence:      	<LGPL>
    ################################################################-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:param name="projectpath"/>
      <!--<xsl:variable name="projecttaskuri" select="concat(f:file2uri($projectpath),'/setup/project.tasks')"/> -->
      <xsl:variable name="projecttask" select="f:file2lines(concat($projectpath,'project.txt'))"/>
      <!-- <xsl:variable name="projecttask" select="tokenize(unparsed-text($projecttaskuri),'\r?\n')"/> -->
      <xsl:variable name="cd" select="substring-before($projectpath,'\data\')"/>
      <xsl:variable name="varparser" select="'^([^;]+);([^ ]+)[ \t]+([^ \t]+)[ \t]+(.+)'"/>
      <xsl:variable name="var" select="tokenize('var xvar',' ')"/>
      <xsl:variable name="sq">
            <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:template match="/">
            <xsl:element name="xsl:stylesheet">
                  <xsl:attribute name="version">
                        <xsl:text>2.0</xsl:text>
                  </xsl:attribute>
                  <xsl:namespace name="f" select="'myfunctions'"/>
                  <xsl:attribute name="exclude-result-prefixes">
                        <xsl:text>f</xsl:text>
                  </xsl:attribute>
                  <xsl:element name="xsl:variable">
                        <!-- Declare projectpath -->
                        <xsl:attribute name="name">
                              <xsl:text>projectpath</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:text>'</xsl:text>
                              <xsl:value-of select="$projectpath"/>
                              <xsl:text>'</xsl:text>
                        </xsl:attribute>
                  </xsl:element>
                  <!-- <xsl:element name="xsl:include">
                        <xsl:attribute name="href">
                              <xsl:text>inc-lookup.xslt</xsl:text>
                        </xsl:attribute>
                  </xsl:element> -->
                  <xsl:element name="xsl:variable">
                        <!-- Declare projectpath -->
                        <xsl:attribute name="name">
                              <xsl:text>cd</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:text>'</xsl:text>
                              <xsl:value-of select="$cd"/>
                              <xsl:text>'</xsl:text>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:element name="xsl:variable">
                        <!-- Declare projectpath -->
                        <xsl:attribute name="name">
                              <xsl:text>sq</xsl:text>
                        </xsl:attribute>
                        <xsl:text>'</xsl:text>
                  </xsl:element>
                  <xsl:element name="xsl:variable">
                        <!-- Declare projectpath -->
                        <xsl:attribute name="name">
                              <xsl:text>dq</xsl:text>
                        </xsl:attribute>
                        <xsl:text>"</xsl:text>
                  </xsl:element>
                  <xsl:element name="xsl:variable">
                        <!-- Declare pubpath -->
                        <xsl:attribute name="name">
                              <xsl:text>pubpath</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:text>'</xsl:text>
                              <xsl:value-of select="$cd"/>
                              <xsl:text>'</xsl:text>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:text>tokenize('true yes on 1','\s+')</xsl:text>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:for-each select="$projecttask">
                        <!-- copy the root folder files pub.cmd and local_var.cmd -->
                        <xsl:call-template name="parseline">
                              <xsl:with-param name="line" select="."/>
                              <xsl:with-param name="curpos" select="position()"/>
                        </xsl:call-template>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="parseline">
            <xsl:param name="line"/>
            <xsl:param name="curpos"/>
            <xsl:variable name="part" select="tokenize($line,'=')"/>
            <xsl:choose>
                  <xsl:when test="matches($part[1],'^#.*$')">
                        <xsl:element name="xsl:variable">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="concat('comment',$curpos)"/>
                              </xsl:attribute>
                              <xsl:attribute name="select">
                                    <xsl:value-of select="$line"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:element name="xsl:variable">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="$part[1]"/>
                              </xsl:attribute>
                              <xsl:value-of select="$part[2]"/>
                        </xsl:element>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="writeparam">
            <xsl:param name="name"/>
            <xsl:param name="value"/>
            <xsl:param name="iscommand"/>
            <xsl:variable name="apos">
                  <xsl:text>'</xsl:text>
            </xsl:variable>
            <xsl:element name="xsl:param">
                  <xsl:attribute name="name">
                        <xsl:value-of select="$name"/>
                  </xsl:attribute>
                  <xsl:attribute name="select">
                        <xsl:if test="string-length($iscommand) = 0">
                              <xsl:text>'</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="$value"/>
                        <xsl:if test="string-length($iscommand) = 0">
                              <xsl:text>'</xsl:text>
                        </xsl:if>
                  </xsl:attribute>
            </xsl:element>
            <xsl:if test="matches($name,'_list$')">
                  <!-- space (\s+) delimited list -->
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:value-of select="replace($name,'_list','')"/>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:value-of select="concat('tokenize($',$name,',',$apos,'\s+',$apos,')')"/>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:if test="matches($value,'=')">
                        <xsl:element name="xsl:variable">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="replace($name,'_list','-key')"/>
                              </xsl:attribute>
                              <xsl:attribute name="select">
                                    <xsl:value-of select="concat('tokenize($',$name,',',$apos,'=[^\s]+\s?',$apos,')')"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:if>
            </xsl:if>
            <xsl:if test="matches($name,'_file-list$')">
                  <!-- adds a tokenized list from a file. Good for when the list is too long for batch line -->
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:value-of select="replace($name,'_file-list','')"/>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:text>f:file2lines($</xsl:text>
                              <xsl:value-of select="$name"/>
                              <xsl:text>)</xsl:text>
                        </xsl:attribute>
                  </xsl:element>
            </xsl:if>
            <xsl:if test="matches($name,'_underscore-list$')">
                  <!-- unerescore delimied list -->
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:value-of select="replace($name,'_underscore-list','')"/>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:value-of select="concat('tokenize($',$name,',',$apos,'_',$apos,')')"/>
                        </xsl:attribute>
                  </xsl:element>
                  <xsl:if test="matches($value,'=')">
                        <xsl:element name="xsl:variable">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="replace($name,'_underscore-list','-key')"/>
                              </xsl:attribute>
                              <xsl:attribute name="select">
                                    <xsl:value-of select="concat('tokenize($',$name,',',$apos,'=[^_]+_?',$apos,')')"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:if>
            </xsl:if>
            <xsl:if test="matches($name,'_equal-list$')">
                  <!-- equals delimited list -->
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:value-of select="replace($name,'_equal-list','')"/>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:value-of select="concat('tokenize($',$name,',',$apos,'=',$apos,')')"/>
                        </xsl:attribute>
                  </xsl:element>
            </xsl:if>
            <xsl:if test="matches($name,'_semicolon-list$')">
                  <!-- semicolon delimited list -->
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:value-of select="replace($name,'_semicolon-list','')"/>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:value-of select="concat('tokenize($',$name,',',$apos,';',$apos,')')"/>
                        </xsl:attribute>
                  </xsl:element>
                  <!--  now test if there are = in the list and make a key list -->
                  <xsl:if test="matches($value,'=')">
                        <xsl:variable name="key" select="tokenize($value,'=.*_?')"/>
                        <xsl:element name="xsl:variable">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="replace($name,'_semicolon-list','-key')"/>
                              </xsl:attribute>
                              <xsl:attribute name="select">
                                    <xsl:value-of select="concat('tokenize($',$name,',',$apos,'=[^;]+;?',$apos,')')"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:if>
            </xsl:if>
      </xsl:template>
</xsl:stylesheet>
