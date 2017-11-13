<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:   		vimod-generate-inno-files.xslt
    # Purpose:		Takes vimod project path as input and generates an Inno installer file.
    # Part of:		Vimod Pub - https://github.com/SILAsiaPub/vimod-pub
    # Author:		Ian McQuay <ian_mcquay@sil.org>
    # Created:		2017-10-21
    # Copyright:   	(c) 2017 SIL International
    # Licence:		<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
      <xsl:output method="text" encoding="utf-8"/>
      <xsl:include href="inc-file2uri.xslt"/>
      <xsl:include href="inc-lookup.xslt"/>
      <xsl:param name="projectpath" select="'D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk\data\Ventura\ventura2usfm_o-z\sample'"/>
      <xsl:param name="OutputBaseFilename" select="'ventruatt2usfm'"/>
      <xsl:param name="AppName" select="'VenturaTagText to USFM'"/>
      <xsl:param name="AppVersion" select="'1.0'"/>
      <xsl:param name="DefaultDirName" select="'C:\programs\VimodPub'"/>
      <xsl:param name="DisableDirPage" select="'true'"/>
      <xsl:param name="DefaultGroupName" select="'Publishing'"/>
      <xsl:param name="UninstallDisplayIcon" select="'{app}\u.ico'"/>
      <xsl:param name="Compression" select="'lzma2'"/>
      <xsl:param name="SolidCompression" select="'yes'"/>
      <xsl:variable name="vimodpath" select="substring-before($projectpath,'\data')"/>
      <xsl:variable name="relprojectPath" select="substring-after($projectpath,'trunk\')"/>
      <xsl:variable name="projectsetupPath" select="concat(substring-after($projectpath,'trunk\'),'\setup')"/>
      <xsl:variable name="menufile" select="concat($projectpath,'\setup\project.menu')"/>
      <xsl:variable name="tasksmatch">
            <xsl:text>.+[ &quot;&apos;]([\w\-_]+\.tasks).*</xsl:text>
      </xsl:variable>
      <xsl:variable name="xsltmatch">
            <xsl:text>.+[;&quot;]xslt ([\w\-_]+)[ &quot;&apos;\r\n]?.*</xsl:text>
      </xsl:variable>
      <xsl:variable name="inno-text">
            <xsl:call-template name="vimod-parser">
                  <xsl:with-param name="file" select="$menufile"/>
            </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="inno-line" select="tokenize($inno-text,'\r?\n')"/>
      <xsl:template match="/*">
            <!-- Start output -->
            <xsl:call-template name="pre"/>
            <xsl:call-template name="setup"/>
            <xsl:call-template name="prefiles"/>
            <xsl:text>&#10;; files found to include </xsl:text>
            <xsl:for-each-group select="$inno-line" group-by=".">
                  <xsl:sort select="."/>
                  <xsl:value-of select="current-group()[1]"/>
                  <xsl:text>&#10;</xsl:text>
            </xsl:for-each-group>
            <xsl:call-template name="postfiles"/>
            <xsl:call-template name="post"/>
      </xsl:template>
      <xsl:template name="vimod-parser">
            <xsl:param name="file"/>
            <xsl:variable name="projecttasks" select="f:file2uri(concat($projectpath,'\setup\',$file))"/>
            <xsl:variable name="commontasks" select="f:file2uri(concat($vimodpath,'\tasks\',$file))"/>
            <xsl:variable name="projectmenu" select="f:file2uri(concat($projectpath,'\setup\',$file))"/>
            <xsl:variable name="commonmenu" select="f:file2uri(concat($vimodpath,'\menus\',$file))"/>
            <xsl:variable name="fileuri">
                  <xsl:choose>
                        <xsl:when test="unparsed-text-available($projecttasks)">
                              <xsl:value-of select="$projecttasks"/>
                        </xsl:when>
                        <xsl:when test="unparsed-text-available($commontasks)">
                              <xsl:value-of select="$commontasks"/>
                        </xsl:when>
                        <xsl:when test="unparsed-text-available($projectmenu)">
                              <xsl:value-of select="$projectmenu"/>
                        </xsl:when>
                        <xsl:when test="unparsed-text-available($commonmenu)">
                              <xsl:value-of select="$commonmenu"/>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:text>; error tasks or menu file not found&#10;</xsl:text>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <!--  -->
            <!-- <xsl:variable name="fileuri" select="f:file2uri($file)"/> -->
            <xsl:variable name="line" select="f:file2lines($fileuri)"/>
            <xsl:variable name="fileext" select="$file"/>
            <xsl:variable name="relpath">
                  <xsl:choose>
                        <xsl:when test="matches($fileuri,'/data/')">
                              <xsl:text>{#projectsetupPath}</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches($fileuri,'/tasks/')">
                              <xsl:text>{#commontasksPath}</xsl:text>
                        </xsl:when>
                        <xsl:when test="matches($fileuri,'/menus/')">
                              <xsl:text>{#commonmenuPath}</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                              <xsl:text>; No relpath match&#10;</xsl:text>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:variable>
            <!-- output the file being handled comment -->
            <xsl:value-of select="concat('; found ',$file,'&#10;')"/>
            <xsl:call-template name="inno-file-writer">
                  <xsl:with-param name="relpath" select="$relpath"/>
                  <xsl:with-param name="file2copy" select="$fileext"/>
            </xsl:call-template>
            <xsl:for-each select="$line">
                  <xsl:variable name="line_part" select="tokenize(.,';')"/>
                  <xsl:variable name="command_part" select="tokenize($line_part[2],' ')"/>
                  <xsl:variable name="command" select="lower-case($command_part[1])"/>
                  <xsl:variable name="param1" select="$command_part[2]"/>
                  <xsl:variable name="param2" select="$command_part[3]"/>
                  <xsl:variable name="param3" select="$command_part[4]"/>
                  <!--<xsl:comment select="."/>
                  <xsl:text>&#10;</xsl:text> -->
                  <xsl:choose>
                        <!-- Matches comment line -->
                        <xsl:when test="matches(.,'^#')"/>
                        <!-- match empty line -->
                        <xsl:when test="matches(.,'^$')"/>
                        <xsl:when test="$command = 'projectvar'">
                              <xsl:variable name="projecttasks" select="f:file2uri(concat($projectpath,'\setup\project.tasks'))"/>
                              <xsl:if test="unparsed-text-available($projecttasks)">
                                    <xsl:call-template name="vimod-parser">
                                          <xsl:with-param name="file" select="'project.tasks'"/>
                                    </xsl:call-template>
                              </xsl:if>
                        </xsl:when>
                        <xsl:when test="matches($line_part[2],$tasksmatch)">
                              <xsl:value-of select="f:numb2digit(concat('; ',$fileext,'-'),position(),concat('   &lt;',.,'&gt; ==== &#10;'))"/>
                              <!-- Match anything with with tasklist pattern. generic catch all tasklist files -->
                              <!-- retrieve tasklist name -->
                              <xsl:variable name="tasklist" select=" replace(.,$tasksmatch,'$1')"/>
                              <!-- call tasklist template -->
                              <xsl:call-template name="vimod-parser">
                                    <xsl:with-param name="file" select="$tasklist"/>
                              </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$command = 'menu'">
                              <xsl:variable name="projectmenu" select="f:file2uri(concat($projectpath,'\setup\',$param1))"/>
                              <xsl:if test="unparsed-text-available($projectmenu)">
                                    <xsl:call-template name="vimod-parser">
                                          <xsl:with-param name="file" select="$param1"/>
                                    </xsl:call-template>
                              </xsl:if>
                        </xsl:when>
                        <xsl:when test="$command = 'commonmenu'">
                              <xsl:variable name="commonmenu" select="f:file2uri(concat($vimodpath,'\menus\',$param1))"/>
                              <xsl:call-template name="vimod-parser">
                                    <xsl:with-param name="file" select="$param1"/>
                              </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="matches($line_part[2],$xsltmatch)">
                              <!-- Match anything with xslt pattern. generic catch all xslt files -->
                              <!-- retrieve tasklist name -->
                              <xsl:variable name="xslt" select=" replace(.,$xsltmatch,'$1')"/>
                              <!-- call tasklist template -->
                              <xsl:call-template name="inno-file-writer">
                                    <xsl:with-param name="relpath" select="'{#xsltPath}'"/>
                                    <xsl:with-param name="file2copy" select="concat($xslt,'.xslt')"/>
                              </xsl:call-template>
                              <xsl:call-template name="xslt-inc">
                                    <xsl:with-param name="file" select="concat($vimodpath,'\scripts\xslt\',$xslt,'.xslt')"/>
                              </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$command = 'cct'">
                              <!-- cct line -->
                              <xsl:variable name="cct" select="tokenize($param1,',')"/>
                              <xsl:value-of select="f:numb2digit(concat('; ',$fileext,'-'),position(),concat('   &lt;',.,'&gt; ==== &#10;'))"/>
                              <xsl:for-each select="$cct">
                                    <xsl:call-template name="inno-file-writer">
                                          <xsl:with-param name="relpath" select="'{#cctPath}'"/>
                                          <xsl:with-param name="file2copy" select="$param1"/>
                                    </xsl:call-template>
                              </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                              <!-- output the line being handled -->
                              <xsl:value-of select="f:numb2digit(concat('; ',$fileext,'-'),position(),concat('   &lt;',.,'&gt; ### no match &#10;'))"/>
                        </xsl:otherwise>
                  </xsl:choose>
            </xsl:for-each>
      </xsl:template>
      <xsl:template name="inno-file-writer">
            <xsl:param name="relpath"/>
            <xsl:param name="file2copy"/>
            <xsl:param name="flags"/>
            <xsl:param name="destname"/>
            <xsl:param name="check"/>
            <!-- Source: "{#sourcePath}{#tasksPath}\ventura2usfm-vp2xml-multifile.tasks"; DestDir: "{app}\{#tasksPath}" ; Flags: onlyifdoesntexist; -->
            <xsl:text>Source: "{#sourcePath}</xsl:text>
            <xsl:value-of select="$relpath"/>
            <xsl:text>\</xsl:text>
            <xsl:value-of select="$file2copy"/>
            <xsl:text>"; DestDir: "{app}\</xsl:text>
            <xsl:value-of select="$relpath"/>
            <xsl:text>" ; </xsl:text>
            <xsl:if test="$destname">
                  <xsl:text>DestName: "</xsl:text>
                  <xsl:value-of select="$destname"/>
                  <xsl:text>"&#10;</xsl:text>
            </xsl:if>
            <xsl:if test="$check">
                  <xsl:text>Check: "</xsl:text>
                  <xsl:value-of select="$check"/>
                  <xsl:text>"&#10;</xsl:text>
            </xsl:if>
            <xsl:if test="$flags">
                  <xsl:text>Flags: </xsl:text>
                  <xsl:value-of select="$flags"/>
                  <xsl:text>; </xsl:text>
            </xsl:if>
            <xsl:text>&#10;</xsl:text>
      </xsl:template>
      <xsl:template name="xslt-inc">
            <xsl:param name="file"/>
            <xsl:apply-templates select="doc(f:file2uri($file))//xsl:include"/>
      </xsl:template>
      <xsl:template match="xsl:include">
            <xsl:call-template name="inno-file-writer">
                  <xsl:with-param name="relpath" select="'{#xsltPath}'"/>
                  <xsl:with-param name="file2copy" select="@href"/>
                  <xsl:with-param name="flags" select="''"/>
            </xsl:call-template>
      </xsl:template>
      <xsl:template name="setup">
            <xsl:value-of select="concat('#define relprojectPath &quot;',$relprojectPath,'&quot;&#10;')"/>
            <xsl:value-of select="concat('#define projectsetupPath &quot;',$projectsetupPath,'&quot;&#10;&#10;')"/>
            <xsl:text>[Setup]&#10;</xsl:text>
            <xsl:value-of select="concat('OutputBaseFilename=',$OutputBaseFilename,'&#10;')"/>
            <xsl:value-of select="concat('AppName=',$AppName,'&#10;')"/>
            <xsl:value-of select="concat('AppVersion=',$AppVersion,'&#10;')"/>
            <xsl:value-of select="concat('DefaultDirName=',$DefaultDirName,'&#10;')"/>
            <xsl:value-of select="concat('DisableDirPage=',$DisableDirPage,'&#10;')"/>
            <xsl:value-of select="concat('DefaultGroupName=',$DefaultGroupName,'&#10;')"/>
            <xsl:value-of select="concat('UninstallDisplayIcon=',$UninstallDisplayIcon,'&#10;')"/>
            <xsl:value-of select="concat('Compression=',$Compression,'&#10;')"/>
            <xsl:value-of select="concat('SolidCompression=',$SolidCompression,'&#10;')"/>
      </xsl:template>
      <xsl:template name="pre">
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; Input absolute paths
#define sourcePath "D:\All-SIL-Publishing\github-SILAsiaPub\vimod-pub\trunk\"
#define toolsPath "D:\All-SIL-Publishing\installer-tools"
#define pspadProgPath "C:\programs\pspad"
; Relatives paths
#define setuppub "setup-pub"
#define commontasksPath "tasks"
#define commonmenuPath "menus"
#define xsltPath "scripts\xslt"
#define cctPath "scripts\cct"
#define saxon "tools\saxon"
#define toolsbin "tools\bin"
#define winmerge32 "C:\Program Files (x86)\WinMerge\WinMergeU.exe"

; Versioned files
#define pspadzip "pspad462en.zip"
#define winmerge "WinMerge-2.14.0-Setup.exe"
#define java64 "jre-8u141-windows-x64.exe"
#define unzip "unzip.exe"
#define saxonzip "SaxonHE9-8-0-3J.zip"
</xsl:template>
      <xsl:template name="prefiles">[Files]
;Source: "{#sourcePath}ventruatt2usfm.hta"; DestDir: "{app}"
Source: "{#sourcePath}pub.cmd"; DestDir: "{app}"
Source: "{#sourcePath}*.ico"; DestDir: "{app}"
;Source: "{#sourcePath}*.md"; DestDir: "{app}"
;Source: "{#sourcePath}*.html"; DestDir: "{app}"
Source: "{#sourcePath}*.txt"; DestDir: "{app}" ; Flags: onlyifdoesntexist;
Source: "{#sourcePath}blank.xml"; DestDir: "{app}" ; Flags: onlyifdoesntexist;
</xsl:template>
      <xsl:template name="postfiles">
; pub setup
Source: "{#sourcePath}{#setuppub}\vimod_installer.variables"; DestDir: "{app}\{#setuppub}" ; DestName: "vimod.variables"; Flags: onlyifdoesntexist;
Source: "{#sourcePath}{#setuppub}\user_installed_installer.tools"; DestDir: "{app}\{#setuppub}" ; DestName: "user_installed.tools"; Flags: onlyifdoesntexist;
Source: "{#sourcePath}{#setuppub}\essential_installed_installer.tools"; DestDir: "{app}\{#setuppub}" ; DestName: "essential_installed.tools"; Flags: onlyifdoesntexist;
Source: "{#sourcePath}{#setuppub}\functiondebug.settings"; DestDir: "{app}\{#setuppub}" ; DestName: "functiondebug.settings"; Flags: onlyifdoesntexist;
Source: "{#sourcePath}{#setuppub}\user_feedback.settings"; DestDir: "{app}\{#setuppub}" ; DestName: "user_feedback.settings"; Flags: onlyifdoesntexist;

; tools
Source: "{#toolsPath}\{#winmerge}"; DestDir: "{tmp}"; Check: IsWin64 ; Flags: deleteafterinstall
Source: "{#toolsPath}\fnr.exe"; DestDir: "{app}\{#toolsbin}"; DestName: "fnr.exe"; 
Source: "{#toolsPath}\iconv.exe"; DestDir: "{app}\{#toolsbin}"; DestName: "iconv.exe"; 
Source: "{#toolsPath}\{#saxonzip}"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "{#toolsPath}\{#unzip}"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "{#toolsPath}\{#java64}"; DestDir: "{tmp}"; Check: IsWin64 AND InstallJava(); Flags: deleteafterinstall
Source: "{#toolsPath}\{#winmerge}"; DestDir: "{tmp}";  Flags: deleteafterinstall
Source: "{#toolsPath}\{#pspadzip}"; DestDir: "{tmp}";  Flags: deleteafterinstall

; PsPad mod files
Source: "{#sourcePath}{#setuppub}\pspad.ini"; DestDir: "{tmp}"; Check: IsWin64 AND InstallJava(); Flags: deleteafterinstall
Source: "{#pspadProgPath}\Syntax\Vimod Pub.ini"; DestDir: "{tmp}"; DestName: "VimodPub.ini"; Check: IsWin64 AND InstallJava(); Flags: deleteafterinstall

[Icons]
Name: "{group}\Vimod Pub"; Filename: "{app}\pub.cmd"; IconFilename: "{app}\v.ico" 
Name: "{group}\Uninstall vp2usfm"; Filename: "{uninstallexe}" ; IconFilename: "{app}\u.ico"
</xsl:template>
      <xsl:template name="post">
            <xsl:text>Name: "{group}\</xsl:text>
            <xsl:value-of select="$AppName"/>
            <xsl:text>"; Filename: "{app}\</xsl:text>
            <xsl:value-of select="$OutputBaseFilename"/>
            <xsl:text>.hta"; IconFilename: "{app}\v.ico"&#10;</xsl:text>
            <xsl:text>Name: "{group}\Uninstall </xsl:text>
            <xsl:value-of select="$AppName"/>
            <xsl:text>"; Filename: "{uninstallexe}" ; IconFilename: "{app}\u.ico"&#10;</xsl:text>
            <xsl:text>
[Run]
Filename: "{tmp}\{#unzip}"; Parameters: "{tmp}\{#saxonzip} -d {app}\{#saxon}" ;  Check: FileDoesNotExist('{app}\{#saxon}\saxon9he.jar');
Filename: "{tmp}\{#unzip}"; Parameters: "{tmp}\{#pspadzip} -d {#pspadProgPath}";  Check: FileDoesNotExist('{#pspadProgPath}\bin\pspad.exe');
; copy pspad vimodPub files into pspad.
Filename: "copy"; Parameters: "{tmp}\VimodPub.ini {#pspadProgPath}\Syntax"; Flags: nowait postinstall runhidden runascurrentuser; 
Filename: "copy"; Parameters: "{tmp}\pspad.ini {#pspadProgPath}"; Flags: nowait postinstall runhidden runascurrentuser; 
Filename: "{tmp}\{#java64}"; Parameters: "/s"; Flags: nowait postinstall runhidden runascurrentuser; Check: InstallJava() ;
Filename: "{tmp}\{#winmerge}"; Parameters: "/s"; Flags: nowait postinstall runhidden runascurrentuser; Check: FileDoesNotExist('{#winmerge32}');

[Code]        
function FileDoesNotExist(file: string): Boolean;
begin
  if (FileExists(ExpandConstant(file))) then
    begin
      Result := False;
    end
  else
    begin
      Result := True;
    end;
end;

procedure DecodeVersion(verstr: String; var verint: array of Integer);
var
  i,p: Integer; s: string;
begin
  { initialize array }
  verint := [0,0,0,0];
  i := 0;
  while ((Length(verstr) &gt; 0) and (i &lt; 4)) do
  begin
    p := pos ('.', verstr);
    if p > 0 then
    begin
      if p = 1 then s:= '0' else s:= Copy (verstr, 1, p - 1);
      verint[i] := StrToInt(s);
      i := i + 1;
      verstr := Copy (verstr, p+1, Length(verstr));
    end
    else
    begin
      verint[i] := StrToInt (verstr);
      verstr := '';
    end;
  end;
end;


function CompareVersion (ver1, ver2: String) : Integer;
var
  verint1, verint2: array of Integer;
  i: integer;
begin
  SetArrayLength (verint1, 4);
  DecodeVersion (ver1, verint1);

  SetArrayLength (verint2, 4);
  DecodeVersion (ver2, verint2);

  Result := 0; i := 0;
  while ((Result = 0) and ( i &lt; 4 )) do
  begin
    if verint1[i] &gt; verint2[i] then
      Result := 1
    else
      if verint1[i] &lt; verint2[i] then
        Result := -1
      else
        Result := 0;
    i := i + 1;
  end;
end;

function InstallJava() : Boolean;
var
  JVer: String;
  InstallJ: Boolean;
begin
  RegQueryStringValue(
    HKLM, 'SOFTWARE\JavaSoft\Java Runtime Environment', 'CurrentVersion', JVer);
  InstallJ := true;
  if Length( JVer ) &gt; 0 then
  begin
    if CompareVersion(JVer, '1.8') &gt;= 0 then
    begin
      InstallJ := false;
    end;
  end;
  Result := InstallJ;
end;
</xsl:text>
      </xsl:template>
      <xsl:template name="scrap">
<!--
                        <xsl:when test="matches($command,'loopdir|loopfiles|loopfileset|loopstring') and matches($param2,'\.tasks')">
                              <xsl:call-template name="tasks-type">
                                    <xsl:with-param name="param1" select="$param2"/>
                              </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$command = 'tasklist'">
                              <xsl:call-template name="tasks-type">
                                    <xsl:with-param name="param1" select="$param1"/>
                              </xsl:call-template>
                        </xsl:when>

                        <xsl:when test="$command = 'xslt'">
                              
                              <xsl:call-template name="inno-file-writer">
                                    <xsl:with-param name="relpath" select="'{#xsltPath}'"/>
                                    <xsl:with-param name="file2copy" select="concat($param1,'.xslt')"/>
                                    <xsl:with-param name="flags" select="''"/>
                              </xsl:call-template>
                              <xsl:call-template name="xslt-inc">
                                    <xsl:with-param name="file" select="concat($vimodpath,'\scripts\xslt\',$param1,'.xslt')"/>
                              </xsl:call-template>
                        </xsl:when> 
      <xsl:template name="tasklist">
            <xsl:param name="tasklist"/>
            <xsl:variable name="projecttasks" select="f:file2uri(concat($projectpath,'\setup\',$tasklist))"/>
            <xsl:variable name="commontasks" select="f:file2uri(concat($vimodpath,'\tasks\',$tasklist))"/>
            <xsl:choose>
                  <xsl:when test="unparsed-text-available($projecttasks)">
                        <xsl:call-template name="inno-file-writer">
                              <xsl:with-param name="relpath" select="'{#projectsetupPath}'"/>
                              <xsl:with-param name="file2copy" select="$tasklist"/>
                              <xsl:with-param name="flags" select="''"/>
                        </xsl:call-template>
                        <xsl:call-template name="vimod-parser">
                              <xsl:with-param name="file" select="$projecttasks"/>
                        </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="unparsed-text-available($commontasks)">
                        <xsl:call-template name="inno-file-writer">
                              <xsl:with-param name="relpath" select="'{#commontasksPath}'"/>
                              <xsl:with-param name="file2copy" select="$tasklist"/>
                              <xsl:with-param name="flags" select="''"/>
                        </xsl:call-template>
                        <xsl:call-template name="vimod-parser">
                              <xsl:with-param name="file" select="$commontasks"/>
                        </xsl:call-template>
                  </xsl:when>
            </xsl:choose>
      </xsl:template>
-->


</xsl:template>
      <xsl:function name="f:numb2digit">
            <xsl:param name="front"/>
            <xsl:param name="mid"/>
            <xsl:param name="back"/>
            <xsl:value-of select="$front"/>
            <xsl:number value="number($mid)" format="01"/>
            <xsl:value-of select="$back"/>
      </xsl:function>
</xsl:stylesheet>
