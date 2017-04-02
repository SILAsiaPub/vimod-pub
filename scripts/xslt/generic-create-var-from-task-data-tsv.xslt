<?xml version="1.0" encoding="utf-8"?>
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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:param name="data_file"/>
      <xsl:param name="task_file"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:variable name="line" select="f:file2lines($data_file)"/>
      <xsl:variable name="task" select="f:file2lines($task_file)"/>
      <xsl:variable name="lang-field" select="tokenize('form self custom',' ')"/>
      <xsl:variable name="spaces" select="'                                                  '"/>
      <xsl:template match="/*">
            <!-- output file header start =========================== -->
            <xsl:text># The following are auto generated from the table &#13;&#10;# </xsl:text>
            <xsl:value-of select="$task_file"/>
            <xsl:text> and also &#13;&#10;# </xsl:text>
            <xsl:value-of select="$data_file"/>
            <xsl:text>&#13;&#10;# do not manually edit or you may overwrite it if you recreate it.</xsl:text>
            <!-- output file header end ============================ -->
            <xsl:for-each select="$task[position() gt 1]">
                  <xsl:variable name="part" select="tokenize(.,'\t')"/>
                  <xsl:call-template name="line-writer">
                        <xsl:with-param name="varname" select="$part[1]"/>
                        <xsl:with-param name="condtype" select="$part[2]"/>
                        <xsl:with-param name="cond1" select="$part[3]"/>
                        <xsl:with-param name="cond2" select="$part[4]"/>
                        <xsl:with-param name="col1" select="$part[5]"/>
                        <xsl:with-param name="col2" select="$part[6]"/>
                        <xsl:with-param name="separator" select="  replace(replace($part[7],'space',' '),'underscore','_')"/>
                        <xsl:with-param name="altcomment" select="$part[8]"/>
                  </xsl:call-template>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="line-writer">
            <xsl:param name="varname"/>
            <xsl:param name="condtype"/>
            <xsl:param name="cond1"/>
            <xsl:param name="cond2"/>
            <xsl:param name="col1"/>
            <xsl:param name="col2"/>
            <xsl:param name="separator"/>
            <xsl:param name="altcomment"/>
            <xsl:variable name="ca" select="tokenize($cond1,' ')"/>
            <xsl:variable name="cb" select="tokenize($cond2,' ')"/>
            <xsl:variable name="list">
                  <xsl:for-each select="$line[position() gt 1]">
                        <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                        <xsl:choose>
                              <xsl:when test="$condtype = 'equalequal'">
                                    <xsl:if test="$cell[number($ca[1])] = $ca[2] and $cell[number($cb[1])] = $cb[2]">
                                          <xsl:value-of select="$cell[number($col1)]"/>
                                          <xsl:if test="number($col2) gt 0">
                                                <xsl:text>=</xsl:text>
                                                <xsl:value-of select="$cell[number($col2)]"/>
                                          </xsl:if>
                                          <xsl:value-of select="$separator"/>
                                    </xsl:if>
                              </xsl:when>
                              <xsl:when test="$condtype = 'equalnotequal'">
                                    <xsl:if test="$cell[number($ca[1])] = $ca[2] and $cell[number($cb[1])] ne $cb[2]">
                                          <xsl:value-of select="$cell[number($col1)]"/>
                                          <xsl:if test="number($col2) gt 0">
                                                <xsl:text>=</xsl:text>
                                                <xsl:value-of select="$cell[number($col2)]"/>
                                          </xsl:if>
                                          <xsl:value-of select="$separator"/>
                                    </xsl:if>
                              </xsl:when>
                              <xsl:when test="$condtype = 'notempty'">
                                    <xsl:if test="string-length($cell[number($ca[1])]) gt 0">
                                          <xsl:value-of select="$cell[number($col1)]"/>
                                          <xsl:if test="number($col2) gt 0">
                                                <xsl:text>=</xsl:text>
                                                <xsl:value-of select="$cell[number($col2)]"/>
                                          </xsl:if>
                                          <xsl:value-of select="$separator"/>
                                    </xsl:if>
                              </xsl:when>
                              <xsl:when test="$condtype = 'equalnotempty'">
                                    <xsl:if test="$cell[number($ca[1])] = $ca[2] and string-length($cell[number($cb[1])]) gt 0">
                                          <xsl:value-of select="$cell[number($col1)]"/>
                                          <xsl:if test="number($col2) gt 0">
                                                <xsl:text>=</xsl:text>
                                                <xsl:value-of select="$cell[number($col2)]"/>
                                          </xsl:if>
                                          <xsl:value-of select="$separator"/>
                                    </xsl:if>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:if test="$cell[number($ca[1])] = $ca[2]">
                                          <xsl:value-of select="$cell[number($col1)]"/>
                                          <xsl:if test="number($col2) gt 0">
                                                <xsl:text>=</xsl:text>
                                                <xsl:value-of select="$cell[number($col2)]"/>
                                          </xsl:if>
                                          <xsl:value-of select="$separator"/>
                                    </xsl:if>
                              </xsl:otherwise>
                        </xsl:choose>
                  </xsl:for-each>
            </xsl:variable>
            <xsl:choose>
                  <xsl:when test="$condtype = 'blank'">
                        <xsl:text>&#13;&#10;</xsl:text>
                  </xsl:when>
                  <xsl:when test="$condtype = 'comment'">
                        <xsl:text>&#13;&#10;# </xsl:text>
                        <xsl:value-of select="$varname"/>
                  </xsl:when>
                  <xsl:otherwise>
                        <xsl:value-of select="f:buildline($varname,if ($separator = '_') then '_underscore-list' else '_list',$altcomment)"/>
                        <xsl:value-of select=" replace($list,'^(.+).$','$1')"/>
                        <xsl:text>"</xsl:text>
                  </xsl:otherwise>
            </xsl:choose>
      </xsl:template>
      <xsl:function name="f:buildline">
            <xsl:param name="var"/>
            <xsl:param name="list"/>
            <xsl:param name="altcomment"/>
            <xsl:variable name="comment">
                  <xsl:choose>
                        <xsl:when test="string-length(concat('define ',$var,' ',$altcomment)) lt 51">
                              <xsl:value-of select="concat('define ',$var,' ',$altcomment)"/>
                        </xsl:when>
                        <xsl:when test="string-length(concat($var,' ',$altcomment)) lt 51">
                              <xsl:value-of select="concat($var,' ',$altcomment)"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:value-of select="$altcomment"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <xsl:variable name="comment-filled" select="substring(concat($comment,$spaces),1,50)"/>
            <xsl:text>&#13;&#10;</xsl:text>
            <xsl:value-of select="$comment-filled"/>
            <xsl:text>;var </xsl:text>
            <xsl:value-of select="$var"/>
            <xsl:value-of select="$list"/>
            <xsl:text> "</xsl:text>
      </xsl:function>
      <!-- <xsl:template name="fields-to-remove">
            <xsl:value-of select="f:buildline('fields-to-remove','_list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'delete'">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy"</xsl:text>
      </xsl:template>
      <xsl:template name="se-node">
            <xsl:value-of select="f:buildline('se-node','_list')"/>
            <xsl:for-each select="$line">
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'form' and $cell[6] = 'lexical-unit'">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy"</xsl:text>
            <xsl:value-of select="f:buildline('se-group-node','_list')"/>
            <xsl:for-each select="$line">
                 
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'form' and $cell[6] = 'lexical-unit'">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>Group </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy"</xsl:text>
      </xsl:template>
      <xsl:template name="relation-node">
            <xsl:value-of select="f:buildline('relation-node','_underscore-list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[6] = 'relation'">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[8]"/>
                              <xsl:text>_</xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy=endlist"</xsl:text>
      </xsl:template>
      <xsl:template name="form-node">
            <xsl:value-of select="f:buildline('form-node','_list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'form'">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy"</xsl:text>
      </xsl:template>
      <xsl:template name="form-host-node">
            <xsl:value-of select="f:buildline('form-host-node','_list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'form' and string-length($cell[6]) gt 0">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[6]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy=endlist"</xsl:text>
      </xsl:template>
      <xsl:template name="form-host-attrib-name">
            <xsl:value-of select="f:buildline('form-host-attrib-name','_list')"/>
            <xsl:for-each select="$line">
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'form' and string-length($cell[7]) gt 0">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[7]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy=endlist"</xsl:text>
      </xsl:template>
      <xsl:template name="form-host-attrib-value">
            <xsl:value-of select="f:buildline('form-host-attrib-value','_underscore-list')"/>
            <xsl:for-each select="$line">
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'form' and string-length($cell[7]) gt 0">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[8]"/>
                              <xsl:text>_</xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy=endlist"</xsl:text>
      </xsl:template>
      <xsl:template name="node-lang">
            <xsl:value-of select="f:buildline('node-lang','_list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = $lang-field">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[4]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy=listend"</xsl:text>
      </xsl:template>
      <xsl:template name="simple-group">
            <xsl:value-of select="f:buildline('simple-group','_list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'simple-group'">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[6]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy=listend"</xsl:text>
      </xsl:template>
      <xsl:template name="simple-group-attrib-name">
            <xsl:value-of select="f:buildline('simple-group-attrib-name','_list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'simple-group' and string-length($cell[7]) gt 0">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[7]"/>
                              <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy"</xsl:text>
      </xsl:template>
      <xsl:template name="simple-group-attrib-value">
            <xsl:value-of select="f:buildline('simple-group-attrib-value','_underscore-list')"/>
            <xsl:for-each select="$line">
                  
                  <xsl:variable name="cell" select="tokenize(.,'\t')"/>
                  <xsl:choose>
                        <xsl:when test="$cell[5] = 'simple-group' and string-length($cell[7]) gt 0">
                              <xsl:value-of select="$cell[1]"/>
                              <xsl:text>=</xsl:text>
                              <xsl:value-of select="$cell[8]"/>
                              <xsl:text>_</xsl:text>
                        </xsl:when>
                        <xsl:otherwise/>
                  </xsl:choose>
            </xsl:for-each>
            <xsl:text>dummy"</xsl:text>
      </xsl:template> -->
</xsl:stylesheet>
