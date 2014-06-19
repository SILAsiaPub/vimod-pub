<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	vimod-projecttasks2variable.xslt
    # Purpose:		Generate a XSLT that takes the project.tasks file and make var in there into param. Also includes xvarset files and xarray files as param and adds xslt files as includes in project.xslt 
    # Part of:      	Vimod Pub - http://projects.palaso.org/projects/vimod-pub
    # Author:       	Ian McQuay <ian_mcquay.org>
    # Created:      	2014- -
    # Copyright:    	(c) 2013 SIL International
    # Licence:      	<LPGL>
    ################################################################
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions">
      <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:param name="projectpath"/>
      <xsl:variable name="projecttaskuri" select="concat(f:file2uri($projectpath),'/setup/project.tasks')"/>
      <xsl:variable name="projecttask" select="tokenize(unparsed-text($projecttaskuri),'\r?\n')"/>
      <xsl:variable name="cd" select="substring-before($projectpath,'\data\')"/>
      <xsl:template match="/">
            <xsl:element name="xsl:stylesheet">
                  <xsl:element name="xsl:param">
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
                  <xsl:for-each select="$projecttask">
                        <!-- copy the root folder files pub.cmd and local_var.cmd -->
                        <xsl:call-template name="parseline">
                              <xsl:with-param name="line" select="."/>
                        </xsl:call-template>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="parseline">
            <xsl:param name="line"/>
            <xsl:variable name="comment" select="substring-before($line,';')"/>
            <xsl:variable name="commandstring" select="substring-after($line,';')"/>
            <xsl:variable name="postcommand" select="substring-after($commandstring,'\s+')"/>
            <xsl:variable name="param1" select="substring-before($postcommand,'\s+')"/>
            <xsl:variable name="postparam1" select="substring-after($param1,'\s+')"/>
            <xsl:variable name="part" select="tokenize($commandstring,'\s+')"/>
            <xsl:variable name="command" select="lower-case($part[1])"/>
            <xsl:variable name="name" select="$part[2]"/>
            <!-- <xsl:variable name="value" select="substring-after($commandstring,concat($name,'\s+'))"/> -->
            <xsl:variable name="value" select="normalize-space($postparam1)"/>
            <xsl:variable name="onevar">
                  <xsl:if test="matches($value,'^%[\w\d\-_]+%$')">
                        <xsl:text>onevar</xsl:text>
                  </xsl:if>
            </xsl:variable>
            <xsl:choose>
                  <xsl:when test="matches($line,'^#')"/>
                  <!-- the above removes comment lines so lines tha contain commented out things are not processed -->
                  <xsl:when test="matches($command,'xinclude')">
                        <xsl:element name="xsl:include">
                              <xsl:attribute name="href">
                                    <xsl:value-of select="$part[2]"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:when>
                  <xsl:when test="matches($command,'xarray')">
                        <xsl:variable name="params" select="substring-after($commandstring,'\s+')"/>
                        <xsl:variable name="xarrayfile" select="normalize-space(replace(concat('..\..\',$part[3]),'&#34;',''))"/>
                        <xsl:variable name="xarrayuri" select="f:file2uri($xarrayfile)"/>
                        <xsl:variable name="xarray" select="unparsed-text($xarrayuri)"/>
                        <xsl:call-template name="writeparam">
                              <xsl:with-param name="name" select="$name"/>
                              <xsl:with-param name="value" select="$xarray"/>

                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="matches($command,'xvarset')">
                        <!-- this is to add variables in an existing line separated, then = separated list like vimod.variable -->
                        <xsl:variable name="xvarsetfile" select="concat('..\..\',replace($part[2],'&#34;',''))"/>
                        <xsl:variable name="xvarseturi" select="f:file2uri($xvarsetfile)"/>
                        <xsl:variable name="xvarset" select="tokenize(unparsed-text($xvarseturi),'\r?\n')"/>
                        <xsl:for-each select="$xvarset">
                              <xsl:variable name="item1" select="substring-before(.,'=')"/>
                              <xsl:variable name="item2" select="substring-after(.,'=')"/>
                              <xsl:choose>
                                    <xsl:when test="matches(.,'^#')"/>
                                    <!-- incase there is a comment line -->
                                    <xsl:when test="string-length(.) = 0"/>
                                    <xsl:otherwise>
                                          <!-- when there is a line to process -->
                                          <xsl:call-template name="writeparam">
                                                <xsl:with-param name="name" select="$item1"/>
                                                <xsl:with-param name="value" select="$item2"/>

                                          </xsl:call-template>
                                    </xsl:otherwise>
                              </xsl:choose>
                        </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="matches($command,'var')">
                        <!-- variable line -->
                        <xsl:call-template name="writeparam">
                              <xsl:with-param name="name" select="$name"/>
                              <xsl:with-param name="value">
                                    <xsl:choose>
                                          <xsl:when test="matches($value,'^%.*:.*=.*%')">
                                                <xsl:variable name="vpart" select="tokenize($value,':')"/>
                                                <xsl:variable name="fpart" select="tokenize($vpart[2],'=')"/>
                                                <xsl:variable name="varname" select="replace($vpart[1],'%','')"/>
                                                <xsl:variable name="find" select="$fpart[1]"/>
                                                <xsl:variable name="replace" select="replace($fpart[2],'%','')"/>
                                                <xsl:text>replace($</xsl:text>
                                                <xsl:value-of select="$varname"/>
                                                <xsl:text>,'</xsl:text>
                                                <xsl:value-of select="$find"/>
                                                <xsl:text>','</xsl:text>
                                                <xsl:value-of select="$replace"/>
                                                <xsl:text>')</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="matches($value,'%[\w\d\-_]+%')">
                                                <xsl:text>concat(</xsl:text>
                                                <xsl:analyze-string select="replace($value,'&#34;','')" regex="%[\w\d\-_]+%">
                                                      <xsl:matching-substring>
                                                            <xsl:if test="position() gt 1">
                                                                  <xsl:text>,</xsl:text>
                                                            </xsl:if>
                                                            <xsl:text>$</xsl:text>
                                                            <xsl:value-of select="replace(.,'%','')"/>
                                                      </xsl:matching-substring>
                                                      <xsl:non-matching-substring>
                                                            <xsl:choose>
                                                                  <xsl:when test="position() = 1">
                                                                        <xsl:text>'</xsl:text>
                                                                  </xsl:when>
                                                                  <xsl:otherwise>
                                                                        <xsl:text>,'</xsl:text>
                                                                  </xsl:otherwise>
                                                            </xsl:choose>
                                                            <xsl:value-of select="."/>
                                                            <xsl:text>'</xsl:text>
                                                      </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                                <xsl:if test="$onevar = 'onevar'">
                                                      <!-- This is incase there is only one variable passed to another variable, rare but possible -->
                                                      <xsl:text>,''</xsl:text>
                                                </xsl:if>
                                                <xsl:text>)</xsl:text>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:value-of select="replace($part[3],'&#34;','')"/>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </xsl:with-param>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise/>
            </xsl:choose>
      </xsl:template>
      <xsl:template name="writeparam">
            <xsl:param name="name"/>
            <xsl:param name="value"/>
            <xsl:param name="iscommand"/>
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
      </xsl:template>
</xsl:stylesheet>