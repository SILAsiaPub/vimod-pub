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
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f" xmlns:HTA="HyperTextApplication">
      <xsl:output method="html" version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
      <xsl:character-map name="silp">
            <xsl:output-character character="&amp;" string="&amp;"/>
      </xsl:character-map>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:param name="title"/>
      <xsl:variable name="projectvar" select="f:file2lines('project.txt')"/>
      <xsl:variable name="projectlabel" select="f:file2lines('labels.txt')"/>
      <xsl:variable name="sq">
            <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:variable name="dq">
            <xsl:text>"</xsl:text>
      </xsl:variable>
      <xsl:variable name="apos">
            <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:template match="/">
            <html>
                  <head>
                        <xsl:comment select="'   Create GUI for bat file.      '"/>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                        <title>Transformation runner for Lift mods</title>
                        <HTA:application applicationName="transform app" singleinstance="yes" Icon="kig.ico"/>
                        <style type="text/css">
                              <xsl:call-template name="css"/>
                        </style>
                        <xsl:call-template name="vbscript"/>
                        <SCRIPT language="JavaScript">window.resizeTo(700,600);</SCRIPT>
                  </head>
                  <body>
                        <div class="floatright">
                              <button onclick="editProject" name="LoadValues" class="inibutton">Edit project</button>
                        </div>
                        <iframe src="project.txt" width="600" height="300" frameborder="2"></iframe>
                        <button onclick="RunScript()" class="sample" id="t1">Run transformation</button>
                  </body>
            </html>
      </xsl:template>
      <xsl:template name="css">
            <xsl:text>
  BODY {
    background:rgb(240,248,255);
    border: thin white solid;
    margin: 10px 10px 10px 10px;
    font: 11px Verdana;  
  }
  .widebutton {width:400px}
  .inibutton {width:200px}
  .label {padding-top:10pt}
  .sample {width:154px;height:123px;}
  .floatright {float:right}
 </xsl:text>
      </xsl:template>
      <xsl:template name="vbscript">
            <script language="vbscript">
                  <xsl:call-template name="dimvars"/>
                  <xsl:call-template name="runScript"/>
                  <xsl:call-template name="editProject"/>
            </script>
      </xsl:template>
      <xsl:template name="dimvars">
            <xsl:text>Option Explicit
</xsl:text>
            <xsl:comment select="'define variables'"/>
            <xsl:text>
Dim strPath, dquote, WScript, shell, objShell, cmdline, projIni, labelIni, strUserProfile 
</xsl:text>
            <xsl:comment select="'set some values'"/>
            <xsl:text>
projIni = "project.txt"
labelIni = "label.txt"
Set objShell = CreateObject("Wscript.Shell")
dquote = chr(34)
strUserProfile = objShell.ExpandEnvironmentStrings( "%userprofile%" )
</xsl:text>
      </xsl:template>
      <xsl:template name="runScript">
            <xsl:text>
Sub RunScript()
    'writeProjIni projIni,"variables",styleout
    cmdline = "cmd.exe /c run.cmd"
    objShell.run(cmdline)
End Sub
</xsl:text>
      </xsl:template>
      <xsl:template name="editProject">
            <xsl:text>
Sub editProject()
    cmdline = "notepad project.txt"
    objShell.run(cmdline)
End Sub
</xsl:text>
      </xsl:template>
</xsl:stylesheet>
