<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:         	vimod-projecttasks2variable.xslt
    # Purpose:		Generate a XSLT that takes the project.tasks file and make var in there into param. Also includes xvarset files and xarray files as param and adds xslt files as includes in project.xslt 
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
      <xsl:variable name="projecttask" select="f:file2lines(concat($projectpath,'/setup/project.tasks'))"/>
      <!-- <xsl:variable name="projecttask" select="tokenize(unparsed-text($projecttaskuri),'\r?\n')"/> -->
      <xsl:variable name="cd" select="substring-before($projectpath,'\data\')"/>
      <xsl:variable name="varparser" select="'^([^;]+);([^ ]+)[ \t]+([^ \t]+)[ \t]+(.+)'"/>
      <xsl:variable name="var" select="tokenize('var xvar',' ')"/>
      <xsl:variable name="lists" select="'_semicolon-list|_list|_underscore-list|_equal-list|_file-list'"/>
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
                              <xsl:with-param name="sub" select="'-'"/>
                              <xsl:with-param name="curpos" select="position()"/>
                        </xsl:call-template>
                  </xsl:for-each>
            </xsl:element>
      </xsl:template>
      <xsl:template name="parseline">
            <xsl:param name="line"/>
            <xsl:param name="sub"/>
            <xsl:param name="curpos"/>
            <xsl:variable name="label" select="concat('comment',$sub,position())"/>
            <xsl:variable name="comment" select="substring-before($line,';')"/>
            <xsl:variable name="commandstring" select="substring-after($line,';')"/>
            <xsl:variable name="command" select="tokenize($commandstring,' ')[1]"/>
            <xsl:variable name="name" select="tokenize($commandstring,' ')[2]"/>
            <xsl:variable name="value">
                  <xsl:for-each select="tokenize($commandstring,' ')[position() gt 2]">
                        <xsl:if test="position() gt 1">
                              <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="."/>
                  </xsl:for-each>
            </xsl:variable>
            <!-- <xsl:comment select="concat('comment=',$comment)"/> -->
            <!-- <xsl:comment select="concat('command=',$command)"/> -->
            <!-- <xsl:comment select="concat('name=',$name)"/> -->
            <!-- <xsl:comment select="concat('value=',$value)"/> -->
            <xsl:variable name="commonuri" select="f:file2uri(concat($cd,'\tasks\',$name))"/>
            <xsl:variable name="projecturi" select="f:file2uri(concat($projectpath,'\setup\',$name))"/>
            <!-- <xsl:comment select="$projecturi"/> -->
            <xsl:variable name="onevar">
                  <xsl:if test="matches($value,'^%[\w\d\-_]+%$') or matches($value,'^&#34;%[\w\d\-_]+%&#34;$')">
                        <xsl:text>onevar</xsl:text>
                  </xsl:if>
            </xsl:variable>
            <xsl:choose>
                  <xsl:when test="matches($line,'^#.*$')">
                        <!-- the above removes comment lines so lines that contain commented out things are not processed -->
                        <xsl:element name="xsl:variable">
                              <xsl:attribute name="name">
                                    <xsl:value-of select="$label"/>
                              </xsl:attribute>
                              <xsl:attribute name="select">
                                    <xsl:value-of select="concat($sq,replace($line,$sq,' '),$sq)"/>
                              </xsl:attribute>
                        </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:choose>
                              <xsl:when test="matches($command,'xinclude')">
                                    <xsl:element name="xsl:variable">
                                          <xsl:attribute name="name">
                                                <xsl:value-of select="$label"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="$line"/>
                                    </xsl:element>
                                    <xsl:element name="xsl:include">
                                          <xsl:attribute name="href">
                                                <xsl:value-of select="$name"/>
                                          </xsl:attribute>
                                    </xsl:element>
                              </xsl:when>
                              <xsl:when test="matches($command,'xarray')">
                                    <xsl:variable name="params" select="substring-after($commandstring,'\s+')"/>
                                    <xsl:variable name="xarrayfile" select="normalize-space(replace(concat('..\..\',$value),'&#34;',''))"/>
                                    <xsl:variable name="xarrayuri" select="f:file2uri($xarrayfile)"/>
                                    <xsl:variable name="xarray" select="unparsed-text($xarrayuri)"/>
                                    <xsl:element name="xsl:variable">
                                          <xsl:attribute name="name">
                                                <xsl:value-of select="$label"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="$comment"/>
                                    </xsl:element>
                                    <xsl:call-template name="writeparam">
                                          <xsl:with-param name="name" select="$name"/>
                                          <xsl:with-param name="value" select="$xarray"/>
                                    </xsl:call-template>
                              </xsl:when>
                              <xsl:when test="matches($command,'xvarset')">
                                    <!-- this is to add variables in an existing line separated, then = separated list like vimod.variable -->
                                    <xsl:variable name="xvarsetfile" select="concat('..\..\',replace($name,'&#34;',''))"/>
                                    <xsl:variable name="xvarset" select="f:file2lines($xvarsetfile)"/>
                                    <!-- <xsl:variable name="xvarset" select="tokenize(unparsed-text($xvarseturi),'\r?\n')"/> -->
                                    <xsl:element name="xsl:variable">
                                          <xsl:attribute name="name">
                                                <xsl:value-of select="$label"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="select">
                                                <xsl:value-of select="concat($sq,$comment,$sq)"/>
                                          </xsl:attribute>
                                    </xsl:element>
                                    <xsl:for-each select="$xvarset">
                                          <xsl:variable name="item" select="tokenize(.,'=')"/>
                                          <!-- <xsl:variable name="item2" select="substring-after(.,'=')"/> -->
                                          <xsl:choose>
                                                <xsl:when test="matches(.,'^#')"/>
                                                <!-- incase there is a comment line -->
                                                <xsl:when test="string-length(.) = 0"/>
                                                <xsl:otherwise>
                                                      <!-- when there is a line to process -->
                                                      <xsl:call-template name="writeparam">
                                                            <xsl:with-param name="name" select="$item[1]"/>
                                                            <xsl:with-param name="value" select="$item[2]"/>
                                                      </xsl:call-template>
                                                </xsl:otherwise>
                                          </xsl:choose>
                                    </xsl:for-each>
                              </xsl:when>
                              <xsl:when test="matches($command,'tasklist')">
                                    <xsl:element name="xsl:variable">
                                          <xsl:attribute name="name">
                                                <xsl:value-of select="$label"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="select">
                                                <xsl:value-of select="concat($sq,$comment,$sq)"/>
                                          </xsl:attribute>
                                    </xsl:element>
                                    <xsl:choose>
                                          <xsl:when test="unparsed-text-available($projecturi)">
                                                <xsl:variable name="projecttask" select="tokenize(unparsed-text($projecturi),'\r?\n')"/>
                                                <xsl:for-each select="$projecttask">
                                                      <!-- copy the root folder files pub.cmd and local_var.cmd -->
                                                      <xsl:call-template name="parseline">
                                                            <xsl:with-param name="line" select="."/>
                                                            <xsl:with-param name="curpos" select="$curpos"/>
                                                            <xsl:with-param name="sub" select="concat('-sub',$curpos,'-')"/>
                                                      </xsl:call-template>
                                                </xsl:for-each>
                                          </xsl:when>
                                          <xsl:when test="unparsed-text-available($commonuri)">
                                                <xsl:variable name="projecttask" select="tokenize(unparsed-text($commonuri),'\r?\n')"/>
                                                <xsl:for-each select="$projecttask">
                                                      <!-- copy the root folder files pub.cmd and local_var.cmd -->
                                                      <xsl:call-template name="parseline">
                                                            <xsl:with-param name="line" select="."/>
                                                      </xsl:call-template>
                                                </xsl:for-each>
                                          </xsl:when>
                                          <xsl:otherwise>
                                                <xsl:text disable-output-escaping="yes">&lt;!-- </xsl:text>
                                                <xsl:value-of select="$command"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="$name"/>
                                                <xsl:text disable-output-escaping="yes"> not found --&gt;</xsl:text>
                                          </xsl:otherwise>
                                    </xsl:choose>
                              </xsl:when>
                              <xsl:when test="matches($command,'projectxslt')">
                                    <xsl:element name="xsl:variable">
                                          <xsl:attribute name="name">
                                                <xsl:value-of select="$label"/>
                                          </xsl:attribute>
                                          <xsl:attribute name="select">
                                                <xsl:value-of select="concat($sq,$comment,$sq)"/>
                                          </xsl:attribute>
                                    </xsl:element>
                              </xsl:when>
                              <xsl:when test="$command = $var">
                                    <!-- variable line -->
                                    <xsl:element name="xsl:variable">
                                          <xsl:attribute name="name">
                                                <xsl:value-of select="$label"/>
                                          </xsl:attribute>
                                          <xsl:value-of select="$comment"/>
                                    </xsl:element>
                                    <xsl:text>&#10;</xsl:text>
                                    <xsl:call-template name="writeparam">
                                          <xsl:with-param name="name" select="$name"/>
                                          <xsl:with-param name="value">
                                                <xsl:choose>
                                                      <xsl:when test="matches($value,'%semicolon%')">
                                                            <xsl:text>';'</xsl:text>
                                                      </xsl:when>
                                                      <xsl:when test="matches($value,'^&#34;?%[\w\d\-_]+:.*=.*%&#34;?$')">
                                                            <!-- Matches batch variable with a find and replace structure -->
                                                            <xsl:variable name="re" select="'^&#34;?%([\w\d\-_]+):(.*)=(.*)%&#34;?$'"/>
                                                            <xsl:text>replace(</xsl:text>
                                                            <xsl:value-of select="replace($value,$re,'\$$1')"/>
                                                            <xsl:text>,'</xsl:text>
                                                            <xsl:value-of select="replace($value,$re,'$2')"/>
                                                            <xsl:text>','</xsl:text>
                                                            <xsl:value-of select="replace($value,$re,'$3')"/>
                                                            <xsl:text>')</xsl:text>
                                                      </xsl:when>
                                                      <xsl:when test="matches($value,'%[\w\d\-_]+%')">
                                                            <!-- variable -->
                                                            <xsl:text>concat(</xsl:text>
                                                            <xsl:analyze-string select="replace($value,'&#34;','')" regex="%[\w\d\-_]+%">
                                                                  <!-- match variable string -->
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
                                                            <xsl:value-of select="replace($value,'&#34;','')"/>
                                                      </xsl:otherwise>
                                                </xsl:choose>
                                          </xsl:with-param>
                                          <xsl:with-param name="iscommand">
                                                <!-- looks for patterns that will need to be handled  as commands and not text -->
                                                <xsl:choose>
                                                      <xsl:when test="matches($value,'%[\w\d\-_]+%')">
                                                            <!-- contains batch variables -->
                                                            <xsl:text>on</xsl:text>
                                                      </xsl:when>
                                                      <xsl:when test="matches($value,'%[\w\d\-_]+:.*=.*%')">
                                                            <!-- contains batch variables that are using replace function-->
                                                            <xsl:text>on</xsl:text>
                                                      </xsl:when>
                                                      <xsl:when test="matches($value,'^&#34;\(.+\)&#34;$')">
                                                            <!-- contains string enclosed in braces -->
                                                            <xsl:text>on</xsl:text>
                                                      </xsl:when>
                                                      <xsl:otherwise/>
                                                </xsl:choose>
                                          </xsl:with-param>
                                    </xsl:call-template>
                              </xsl:when>
                              <xsl:otherwise/>
                        </xsl:choose>
                  </xsl:otherwise>
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
            <xsl:if test="matches($name,'_list$')">
                  <!-- space (\s+) delimited list -->
                  <xsl:call-template name="write-tokenize-var">
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="value" select="$value"/>
                        <xsl:with-param name="separator" select="' '"/>
                  </xsl:call-template>
            </xsl:if>
            <xsl:if test="matches($name,'_semicolon-list$')">
                  <!-- semicolon delimited list -->
                  <xsl:call-template name="write-tokenize-var">
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="value" select="$value"/>
                        <xsl:with-param name="separator" select="';'"/>
                  </xsl:call-template>
            </xsl:if>
            <xsl:if test="matches($name,'_underscore-list$')">
                  <!-- unerescore delimied list -->
                  <xsl:call-template name="write-tokenize-var">
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="value" select="$value"/>
                        <xsl:with-param name="separator" select="'_'"/>
                  </xsl:call-template>
            </xsl:if>
            <xsl:if test="matches($name,'_file-list$')">
                  <!-- adds a tokenized list from a file. Good for when the list is too long for batch line -->
                  <xsl:variable name="separator" select="'(\r?\n)'"/>
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
                  <xsl:element name="xsl:variable">
                        <xsl:attribute name="name">
                              <xsl:value-of select="replace($name,concat('(',$lists,')$'),'-key')"/>
                        </xsl:attribute>
                        <xsl:attribute name="select">
                              <xsl:value-of select="concat('tokenize(',$value,',',$sq,'=[^',$separator,']+[',$separator,'$]',$sq,')')"/>
                        </xsl:attribute>
                  </xsl:element>
            </xsl:if>
            <xsl:if test="matches($name,'_equal-list$')">
                  <!-- equals delimited list -->
                  <xsl:call-template name="write-tokenize-var">
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="value" select="$value"/>
                        <xsl:with-param name="separator" select="'='"/>
                  </xsl:call-template>
            </xsl:if>
      </xsl:template>
      <xsl:template name="write-tokenize-var">
            <xsl:param name="name"/>
            <xsl:param name="value"/>
            <xsl:param name="separator"/>
            <xsl:element name="xsl:variable">
                  <xsl:attribute name="name">
                        <xsl:value-of select="replace($name,concat('(',$lists,')$'),'')"/>
                  </xsl:attribute>
                  <xsl:attribute name="select">
                        <xsl:value-of select="concat('tokenize($',$name,',',$sq,$separator,$sq,')')"/>
                  </xsl:attribute>
            </xsl:element>
            <!--  now send to test if there are = in the list and make a key var array -->
            <xsl:if test="matches($value,'=') and matches($separator,'[^=]')">
                  <xsl:call-template name="write-key-var">
                        <xsl:with-param name="name" select="$name"/>
                        <xsl:with-param name="value" select="$value"/>
                        <xsl:with-param name="separator" select="$separator"/>
                  </xsl:call-template>
            </xsl:if>
      </xsl:template>
      <xsl:template name="write-key-var">
            <xsl:param name="name"/>
            <xsl:param name="value"/>
            <xsl:param name="separator"/>
            <xsl:element name="xsl:variable">
                  <xsl:attribute name="name">
                        <xsl:value-of select="replace($name,concat('(',$lists,')$'),'-key')"/>
                  </xsl:attribute>
                  <xsl:attribute name="select">
                        <xsl:value-of select="concat('tokenize($',$name,',',$sq,'=[^',$separator,']+[',$separator,']?',$sq,')')"/>
                  </xsl:attribute>
            </xsl:element>
      </xsl:template>
</xsl:stylesheet>
