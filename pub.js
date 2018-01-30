@write("off")
// Title: pub.cmd
// Title Description: Vimod-Pub batch file with menus and tasklist processing
// Author: Ian McQuay
// Created: 2012-03
// Last Modified: 2016-010-12
// Source: https://github.com/silasiapub/vimod-pub
// Commandline startup options:
// pub  - normal usage for menu starting at the data root.
// pub tasklist tasklistname.tasks -  process a particular tasklist, no menus used. Used with Electron Vimod-Pub GUI
// pub menu menupath - Start projet.menu at a particular path
// pub debug function_name - Just run a particular function to debug
goto :main


function after() {
// Description: Checks if outfile is created. Reports failures logs actions. Restors previous output file on failure.
// Class: command - internal
// Required preset variables:
// outfile
// projectlog
// writecount
// Optional parameters:
// report3
// message
// Func calls:
// nameext
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
@rem @write("on")
var message=%~1;
nameext("outfile", $4)
if  [ ! -f "outfile" ]; then
var     errorlevel=1
    write("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  >>projectlog")
    write("message failed to create nameext.                           >>projectlog")
    write("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  >>projectlog")
    echo. >>projectlog
    echo.
    color E0
    write("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    write("message failed to create nameext.")
    if  [ ! -d nopauseerror ]; then
        echo.
        write("Read error above and resolve issue then try again.")
        write("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        echo.
        pause
        echo.
var         errorsuspendprocessing=true
    fi
    if  [ -d nopauseerror ]; then
    	write("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    fi
    color 07
else
    if  [ -d echoafterspacepre ]; then
    	echo.
    fi
    echolog() writecount Created:   nameext

    if  [ -d echoafterspacepost ]; then
    	echo.
    fi
    write("---------------------------------------------------------------- >>projectlog")
    // echo. >>projectlog
    if  [ -f "outfile.pre.txt" ]; then
    	del "outfile.pre.txt"
    fi
fi
@rem @write("off")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function ampmhour() {
// Description: Converts AM/PM time to 24hour format. Also splits
// Created: 2016-05-04 
// Used by: getfiledatetime 
// Required parameters:
// ampm
// thh
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var ampm=%~1;
var thh=%~2;
if [ fix me "ampm" == "AM" ]; then
  if [ fix me "thh" == "12" ]; then
var     fhh=00
  else
var     fhh=thh
  fi
fi else if "ampm" == "PM" (
  if [ fix me "thh" == "12" ]; then
var     fhh=12
  else
    // added handling to prevent octal number error caused by leading zero
    if [ fix me "${thh:0:1}" == "0" ]; then
    	set /A fhh=%thh:~-1%+12
    fi
    if [ fix me "${thh:0:1}" neq "0" ]; then
    	set /A fhh=thh + "+12"
    fi
  fi
fi else  (
var   fhh=thh
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function appendtofile() {
// Description: Func to append text to a file or append text from another file
// Class: command
// Optional predefined variables:
// newfile
// Required parameters:
// file
// text
// quotes
// filetotype
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var file=%~1;
if  [ ! -d file ]; then
	write("file parameter not supplied &goto :eof")
fi
var text=%~2;
var quotes=%~3;
var filetotype=%~5;
if  [ ! -d newfile ]; then
	set newfile=%~4
fi
if  [ -d quotes ]; then
	set text=%text:'="%
fi
if  [ ! -d filetotype ]; then
  if  [ -d newfile ]; then
    write("text>file")
  else
    write("text>>file")
  fi
else
  if  [ -d newfile ]; then
    type "filetotype" > file
  else
    type "filetotype" >> file
  fi
fi
var newfile=;
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

// UI and Debugging functions ========================================================

function before() {
// Description: Checks if outfile exists, renames it if it does. Logs actions.
// Class: command - internal
// Required preset variables:
// projectlog
// projectbat
// curcommand
// Optional preset variables:
// outfile
// curcommand
// writebat
// Optional variables:
// echooff
// Func calls: 
// funcdebugstart
// funcdebugend
// nameext
// @write("on")
var echooff=%~1;
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
if  [ -d echocommandtodo ]; then
	write("Command to be attempted:")
fi
if  [ -d echocommandtodo ]; then
	write("curcommand")
fi
if  [ ! -d echooff ]; then
	write(""Command to be attempted:" >>projectlog")
fi
write(""curcommand" >>projectlog")
if  [ -d writebat ]; then
	write("curcommand>>projectbat")
fi
echo. >>projectlog
if  [ -f "outfile" ]; then
	nameext("outfile", $4)
fi
if  [ -f "outfile.pre.txt" ]; then
	del "outfile.pre.txt"
fi
if  [ -f "outfile" ]; then
	ren "outfile" "nameext.pre.txt"
fi
var echooff=;
// @write("off")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function cct() {
// Description: Privides interface to CCW32.
// Required preset variables:
// ccw32
// Optional preset variables:
// Required parameters:
// script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc"
// Optional parameters:
// infile
// outfile
// Depends on:
// infile
// outfile
// inccount
// before
// after
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var script=%~1;
if  [ ! -d script ]; then
	write("CCT missing! & goto :eof")
fi
infile("%~2", $4)
if  [ -d missinginput ]; then
	write("missing input file & goto :eof")
fi
if  [ ! -f "ccw32" ]; then
	write("missing ccw32.exe file & goto :eof")
fi
var scriptout=%script:.cct,=_%;
inccount()
outfile("%~3", "projectpath\xml\pcode-count-scriptout.xml")
var basepath=cd + ";"
// if not defined ccw32 set ccw32=ccw32
var curcommand="ccw32" cctparam -t "script" -o "outfile" "infile";
before()
cd cctpath
curcommand
cd basepath
after("Consistent, Changes")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}


function checkdir() {
// Description: checks if dir exists if not it is created
// See also: ifnotexist
// Required preset variabes:
// projectlog
// Optional preset variables:
// echodirnotfound
// Required parameters:
// dir
// Depends on:
// funcdebugstart
// funcdebugend
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var dir=%~1;
if  [ ! -d dir ]; then
	write("missing required directory parameter & goto :eof")
fi
var report=Checking dir dir;
if  [ -f "dir" ]; then
      write(". . . Found! dir >>projectlog")
else
    // removecommonatstart(dirout, "dir")
    if  [ -d echodirnotfound ]; then
    	write("Creating . . . dirout")
    fi
    write(". . . not found. dir >>projectlog")
    write("mkdir dir >>projectlog")
    mkdir "dir"
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function checkifvimodfolder() {
// Description: set the variable skipwriting so that the calling function does not write a menu line.
// Used by: menu
// Optional preset variables:
// echomenuskipping
// Required parameters:
// project
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var project=%~1;
var skipwriting=;

if [ fix me "project" == "projectsetupfolder" ]; then
    if  [ -d echomenuskipping ]; then
    	write("skipping dir: project")
    fi
var     skipwriting=on
fi
if [ fix me "project" == "xml" ]; then
    if  [ -d echomenuskipping ]; then
    	write("skipping dir: project")
    fi
var     skipwriting=on
fi
if [ fix me "project" == "logs" ]; then
    if  [ -d echomenuskipping ]; then
    	write("skipping dir: project")
    fi
var     skipwriting=on
fi
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function command() {
// Description: A way of passing any commnand from a tasklist. It does not use infile and outfile.
// Usage: usercommand() "copy /y 'c:\patha\file.txt' 'c:\pathb\file.txt'" ["path to run  command in"   "output file to test for"]
// Limitations: When command line needs single quote.
// Required parameters:
// curcommand
// Optional parameters:
// commandpath
// testoutfile
// Depends on:
// funcdebugstart
// funcdebugend
// inccount
// echolog
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
inccount()
var curcommand=%~1;
if  [ ! -d curcommand ]; then
	write("missing curcommand & goto :eof")
fi
var commandpath=%~2;
var testoutfile=%~3;
if  [ -d testoutfile ]; then
	set outfile=testoutfile
fi
var curcommand=%curcommand:'="%;
write("curcommand>>projectlog")
var drive=%~d2;
if  [ ! -d drive ]; then
	set drive=c:
fi
if  [ -d testoutfile ]; then
  // the next line 'if "commandpath" neq "" drive'' must be set with a value even if it is not used or cmd fails. Hence the two lines before this if statement
  if "commandpath" neq "" drive
  if  [ -d commandpath ]; then
  	cd "commandpath"
  fi
  before()
  curcommand
  after()
  if  [ -d commandpath ]; then
  	cd "basepath"
  fi
else
  if  [ -d echousercommand ]; then
  	write("curcommand")
  fi
  curcommand
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function command2file() {
// Description: Used with commands that only give stdout, so they can be captued in a file.
// Class: command - dos - to file
// Required parameters:
// command
// outfile
// Optional parameters:
// commandpath
// Depends on:
// inccount
// before
// after
// outfile
// funcdebug
// Note: This command does its own expansion of single quotes to double quotes so cannont be fed directly from a ifdefined or ifnotdefined. Instead define a task that is fired by the ifdefined.
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
inccount()
var command=%~1;
var out=%~2;
if  [ ! -d command ]; then
	write("missing command & goto :eof")
fi
outfile("out", "projectpath\xml\pcode-count-command2file.xml")
var commandpath=%~3;
var append=%~4;
// the following is used for the feed back but not for the actual command
if  [ ! -d append ]; then
var   curcommand=%command:'="% ^^^> "outfile"
else
var   curcommand=%command:'="% ^^^>^^^> "outfile"
fi

before()
var curcommand=%command:'="%;
if "commandpath" neq "" (
var   startdir=cd
var   drive=${commandpath:0:2}
  drive
  cd "commandpath"
fi
if  [ ! -d append ]; then
  call curcommand > "outfile"
else
  call curcommand >> "outfile"
fi

if "commandpath" neq "" (
var   drive=${startdir:0:2}
  drive
  cd "startdir"
var   dive=
fi
after() "command with stdout curcommand complete"
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}


function command2var() {
// Description: creates a variable from the command line
// Class: command - loop
// Required parameters:
// varname
// command
// comment
// Depends on:
// funcdebug
// * - Maybe any function but most likely a tasklist
// Note: Either preset or command parameters can be used
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var commandline=%~1;
var varname=%~2;
var invalid=%~3;
var comment=%~4;
if  [ ! -d varname ]; then
	write("missing varname parameter & goto :eof")
fi
if  [ ! -d commandline ]; then
	write("missing list parameter & goto :eof")
fi
var commandline=%commandline:'="%;
if  [ -d comment ]; then
	write("comment")
fi
FOR /F %%s IN ('commandline') DO set varname=%%s
var varname=;
var commandline=;
var comment=;
if [ fix me "varname" == "invalid" ]; then
	write("invalid & set skip=on")
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function commonmenu() {
// Description: Will write menu lines from a menu file in the commonmenufolder folder
// Class: command - menu
// Used by: menu
// Required parameters:
// commonmenu
// Depends on:
// menuwriteoption
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var commonmenu=%~1;
FOR /F "eol=# tokens=1,2 delims=;" %%i in (commonmenufolder\commonmenu) do set action=%%j&menuwriteoption("%%i", %%j)
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function copy() {
// Description: Provides copying with exit on failure
// Required preset variables:
// ccw32
// Optional preset variables:
// Required parameters:
// script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc"
// Optional parameters:
// infile
// outfile
// appendfile
// Depends on:
// infile
// outfile
// inccount
// before
// after
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
infile("%~1", $4)
var appendfile=%~3;
if  [ -d missinginput ]; then
	write("missing input file & goto :eof")
fi
inccount()
outfile("%~2", $4)
if  [ -d appendfile ]; then
var   curcommand=copy /y "outfile"+"infile" "outfile" 
else
var   curcommand=copy /y "infile" "outfile" 
fi
before()
curcommand
after(Copy, Changes")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function date() {
// Description: Returns multiple variables with date in three formats, the year in wo formats, month and day date.
// Revised: 2016-05-04
// Classs: command - internal - date -time
// Required preset variables:
// dateformat
// dateseparator
// got this from: http://www.robvanderwoude.com/datetiment.php#IDate
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
FOR /F "tokens=1-4 delims=dateseparator " %%A IN ("date") DO (
    IF "dateformat"=="0" (
        SET fdd=%%C
        SET fmm=%%B
        SET fyyyy=%%D
    fi
    IF "dateformat"=="1" (
        SET fdd=%%B
        SET fmm=%%C
        SET fyyyy=%%D
    fi
    IF "dateformat"=="2" (
        SET fdd=%%D
        SET fmm=%%C
        SET fyyyy=%%B
    fi
fi
var curdate=fyyyy + "-fmm-fdd;"
var curisodate=fyyyy + "-fmm-fdd;"
var curyyyymmdd=fyyyy + "fmmfdd;"
var curyymmdd=%fyyyy:~2%fmmfdd;
var curUSdate=fmm + "/fdd/fyyyy;"
var curAUdate=fdd + "/fmm/fyyyy;"
var curyyyy=fyyyy + ";"
var curyy=%fyyyy:~2%;
var curmm=fmm + ";"
var curdd=fdd + ";"
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function debugpause() {
// Description: Sets the debug pause to on
// Class: command - debug
// Optional Parameters:
// changedebugpause
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
write("on")
var changedebugpause=%~1;
if  [ -d debugpause ]; then
  write("debugging pause")
  pause
else
  if [ fix me "changedebugpause" == "off" ]; then
var     debugpause=
  fi else if defined changedebugpause (
var     debugpause=on
  fi
fi
write("off")
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function detectdateformat() {
// Description: Get the date format from the Registery: 0=US 1=AU 2=iso
var KEY_DATE="HKCU\Control Panel\International";
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY KEY_DATE /v iDate`) DO set dateformat=%%A
// get the date separator: / or -
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY KEY_DATE /v sDate`) DO set dateseparator=%%A
// get the time separator: : or ?
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY KEY_DATE /v sTime`) DO set timeseparator=%%A
// set project log file name by date
}


function dirlist() {
// Description: Creates a directory list in a file
// Depreciated: not in current usage
// Class: Command - external
// Depends on:
// dirpath
// dirlist - a file path and name
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var dirpath=%~1;
if  [ ! -d dirpath ]; then
	write("missing dirpath input & goto :eof")
fi
var dirlist=%~2;
dir /b "dirpath" > "dirlist"
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function donothing() {
// Description: Do nothing
}

function drive() {
// Description: returns the drive
var drive=%~d1;

}


function drivepath() {
// Description: returns the drive and path from a full drive:\path\filename
// Class: command - parameter manipulation
// Required parameters:
// Group type: parameter manipulation
// drive:\path\name.ext or path\name.ext
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var drivepath=%~dp1;
if  [ -d echodrivepath ]; then
	write("drivepath")
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function echo() {
// Description: generic handling echo
// Modified: 2016-05-05
// Class: command - internal
// Possible required preset parameters:
// projectlog
// Required parameters:
// echotask or message
// Optional parameters:
// message
// add2file
// Depends on:
// funcdebug
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var echotask=%~1;
if  [ ! -d echotask ]; then
	write("Missing echotask parameter & goto :eof")
fi
var message=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9;
if 'echotask' == 'on' (
  @write("on")
fi else if 'echotask' == 'off' (
  @write("off")
fi else if 'echotask' == 'add2file' (
  @write("%~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 >> "add2file"")
fi else if 'echotask' == 'log' (
  if  [ -d echoecholog ]; then
  	write("message")
  fi
  write("curdateTtime >>projectlog")
  write("message >>projectlog")
var   message=                
fi else if 'echotask' == '.' (
  echo.
else
  write("message")
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function echolog() {
// Description: echoes a message to log file and to screen
// Class: command - internal
// Required preset variables:
// projectlog
// Required parameters:
// message
// Depends on:
// funcdebug
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var message=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9;
if  [ -d echoecholog ]; then
	write("message")
fi
write("curdateTtime >>projectlog")
write("message >>projectlog")
var message=;
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}



function encoding() {
// Description: to check the encoding of a file
// Created: 2016-05-17
// Required parameters:
// file
// activity = validate or check
// Optional parameters:
// validateagainst
// Depends on:
// infile
// nameext
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
if  [ ! -d encodingchecker ]; then
	write("Encoding not checked. &goto :eof")
fi
if  [ ! -f "encodingchecker" ]; then
	write("file.exe not found! fileext &echo Encoding not checked. & goto :eof")
fi
var testfile=%~1;
var activity=%~2;
var validateagainst=%~3;
infile("testfile", $4)
nameext("infile", $4)
var command=encodingchecker -m magic --mime-encoding "infile";
FOR /F "tokens=1-2" %%A IN ('command') DO set fencoding=%%B

if [ fix me "activity" == "validate" ]; then
    if "fencoding" == "validateagainst"  (
        write("Encoding is fencoding for file nameext.")
      fi else if "fencoding" == "us-ascii" (
        write("Encoding is fencoding not validateagainst but is usable.")
      else
      write("File nameext encoding is invalid! ")
      write("Encoding found to be fencoding! But it was expected to be validateagainst.")
var       errorsuspendprocessing=on
  fi
fi else  (              
    write("Encoding is: fencoding for file nameext.")
fi 
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function ext() {
// Description: returns file extension from a full drive:\path\filename
// Class: command - parameter manipulation
// Required parameters:
// drive:\path\name.ext or path\name.ext or name.ext
// created variable:
// nameext
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var ext=%~x1;
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function externalfunctions() {
// Depreciated: can't find usage
// Description: non-conditional based on defined variable
// Class: command - extend - external
// Required parameters:
// extcmd
// function
// params
// Depends on:
// inccount
// infile
// outfile
// before
// after
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
inccount()
var extcmd=%~1;
if  [ ! -d extcmd ]; then
	write("Missing extcmd parameter & goto :eof")
fi
var function=%~2;
var params=%~3;
infile("%~4", $4)
outfile("%~5", "outputdefault")
var curcommand=call extcmd function "params" "infile" "outfile";
before()
curcommand
after("externalfunctions, function, complete")
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function file2uri() {
// Description: transforms dos path to uri path. i.e. c:\path\file.ext to file:///c:/path/file.ext  not needed for XSLT
// Class: command - parameter manipulation
// Required parameters:  1
// pathfile
// Optional parameters:
// number
// created variables:
// urinumber
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
setvar(pathfile, "%~1")
var numb=%~2;
var urinumb=file:///%pathfile:\=/%;
var return=file:///%pathfile:\=/%;
if  [ -d echofile2uri ]; then
	echolog()       urinumb=${return:0:25} . . . %return:~-30%
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function funcdebug() {
// Description: Debug function run at the start of a function
// Class: command - internal - debug
// Required parameters:
// entryfunc
@write("off")
@if defined debugfuncdebug @write("on")
var entryfunc=%~1;
var debugend=%~2;
if  [ ! -d entryfunc ]; then
	write("entryfunc is missing, skipping this function & goto :eof")
fi
var testfunc=debug%entryfunc:~1%;
if [ fix me "debugend" == "end" ]; then
var   debugstack=%debugstack:~1%
var   nextdebug=${debugstack:0:1}
  if  [ -d masterdebug ]; then
  	@write("endfuncstring %~1 debugstack")
  fi
  if 'nextdebug' == '1' (@write("on) else (@echo off)")
else
  if  [ -d testfunc ]; then
  	set debugstack="1" + debugstack
  fi
  if  [ ! -d testfunc ]; then
  	set debugstack="0" + debugstack
  fi
  if  [ -d masterdebug ]; then
  	@write("beginfuncstring %~1  debugstack beginfuncstringtail")
  fi
  if [ fix me "${debugstack:0:1}" == "1" ]; then@write("on) else (@echo off)")
fi
}


function getfiledatetime() {
// Description: Returns a variable with a files modification date and time in yyMMddhhmm  similar to setdatetime. Note 4 digit year makes comparison number too big for batch to handle.
// Revised: 2016-05-04
// Classs: command - internal - date -time
// Required parameters:
// varname
// file
// Depends on:
// ampmhour
// write("on")
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var varname=%~1;
if  [ ! -d varname ]; then
	write("missing varname parameter & goto :eof")
fi
var file=%~2;
if  [ ! -f "file" ]; then
	set varname=0 &goto :eof
fi
var filedate=%~t2;
// got and mofified this from: http://www.robvanderwoude.com/datetiment.php#IDate
FOR /F "tokens=1-6 delims=":" + dateseparator " %%A IN ("%~t2") DO (
  IF "dateformat"=="0" (
      SET fdd=%%B
      SET fmm=%%A
      SET fyyyy=%%C
  fi
  IF "dateformat"=="1" (
      SET fdd=%%A
      SET fmm=%%B
      SET fyyyy=%%C
  fi
  IF "dateformat"=="2" (
      SET fdd=%%C
      SET fmm=%%B
      SET fyyyy=%%A
  fi
var   fnn=%%E
  ampmhour(%%F, %%D)
fi
var varname=%fyyyy:~2%fMMfddfhhfnn;
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function getline() {
// Description: Get a specific line from a file
// Class: command - internal
// Required parameters:
// linetoget
// file
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
if  [ -d echogetline ]; then
	write("on")
fi
var linetoget=%~1;
var file=%~2;
if  [ ! -d linetoget ]; then
	write("missing linetoget parameter & goto :eof")
fi
if  [ ! -d file ]; then
	write("missing file parameter & goto :eof")
fi
var count=%~1-1;
if [ fix me "count" == "0" ]; then
    while [ fix me %~2 (  /f %%i in ]; do
    	$5
done
var         getline=%%i
        goto :eof
    fi
else
    while [ fix me %~2 (  /f "skip=count " %%i in ]; do
    	$5
done
var         getline=%%i
        goto :eof
    fi
fi
@write("off")
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}




function hour() {
// Description: Converts AM/PM time to 24hour format. Also splits
// Created: 2016-05-04 used by revised :getfiledatetime 
// Required parameters:
// ampm
// thh
var ampm=%~1;
var thh=%~2;
if "ampm" == "AM"  (
  if [ fix me "thh" == "12" ]; then
var     fhh=24
  else
var     fhh=thh
  fi
fi else if "ampm" == "PM" (
  if [ fix me "thh" == "12" ]; then
var     fhh=12
  else
var     fhh=thh + "+12"
  fi
else
var   fhh=thh
fi
}


function html2xml() {
// Description: Convert HTML to xml for post processing as xml. it removes the doctype header.
// Required external program: HTML Tidy in variable tidy5
// Required parameters:
// infile
// Optional Parameters:
// outfile
// Depends on:
// infile
// outfile
// before
// after
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
infile("%~1", $4)
if  [ -d missinginput ]; then
	write("missing input file & goto :eof")
fi
outfile("%~2", "projectpath\xml\pcode-count-html2xml.xml")
var curcommand=call xml fo -H -D "infile";
// set curcommand=call "tidy5" -o "outfile" "infile"
before()
curcommand > "outfile"
after()
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function ifdefined() {
// Description: conditional based on defined variable
// Class: command - condition
// Required parameters:
// test
// func
// funcparams - up to 7 aditional
// Depends on:
// tasklist
// Depends on:
// * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var test=%~1;
var func=%~2;
if  [ ! -d test ]; then
	write("missing test parameter & goto :eof")
fi
if  [ ! -d func ]; then
	write("missing func parameter & goto :eof")
fi
var func=%func:'="%;
var funcparams=%~3;
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if  [ -d test ]; then
	func(funcparams, $4)
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function ifequal() {
// Description: to do something on the basis of two items being equal
// Required Parameters:
// equal1
// equal2
// func
// params
// Depends on:
// * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var equal1=%~1;
var equal2=%~2;
var func=%~3;
var funcparams=%~4;
if  [ ! -d equal1 ]; then
	write("missing equal1 parameter & goto :eof")
fi
if  [ ! -d equal2 ]; then
	write("missing equal2 parameter & goto :eof")
fi
if  [ ! -d func ]; then
	write("missing func parameter & goto :eof")
fi
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if [ fix me "equal1" == "equal2" ]; then
	func(funcparams, $4)
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function ifexist() {
// Description: Tests if file exists and takes prescribed if it does
// Class: command - condition
// Required parameters: 2-3
// testfile
// action - xcopy, copy, move, rename, del, command, tasklist, func or fatal
// Optional parameters:
// param3 - a multi use param
// param4 - a multi use param resolves internal single quotes to double quotes
// Depends on:
// funcdebug
// nameext
// command
// tasklist
// * - maybe any function
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var testfile=%~1;
var action=%~2;
var param3=%~3;
var param4=%~4;
var param5=%~5;
var param6=%~6;
if  [ ! -d testfile ]; then
	write("missing testfile parameter & goto :eof")
fi
if  [ ! -d action ]; then
	write("missing action parameter & goto :eof")
fi
// if defined param4 set param4=%param4:'="%

nameext("%~1", $4)

if  [ -f "testfile" ]; then
  if [ fix me "param3" == "%param3: =%" ]; then
     // prevent param3 with space trying to match these actions
     if [ fix me "action" == "func" ]; then
     	write("param3("param4""), $4)
     fi
     if [ fix me "action" == "addtext" ]; then
     	write(" echo param3 ^>^> "param4"")
     fi
     if [ fix me "action" == "func" ]; then
     	param3("param4", $4)
     fi
     if [ fix me "action" == "addtext" ]; then
     	write("param3 >> "param4"")
     fi
  fi
  // say what will happen
  if [ fix me "action" == "xcopy" ]; then
  	write("action param4 "testfile" "param3"")
  fi
  if [ fix me "action" == "copy" ]; then
  	write("action param4 "testfile" "param3"")
  fi
  if [ fix me "action" == "move" ]; then
  	write("action param4 "testfile" "param3"")
  fi
  if [ fix me "action" == "rename" ]; then
  	write("action "testfile" "param3"")
  fi
  if [ fix me "action" == "del" ]; then
  	write("action param4 "testfile"")
  fi
  
  if [ fix me "action" == "command" ]; then
  	write("command() "param3" "param4"  "param5"")
  fi
  if [ fix me "action" == "command2file" ]; then
  	write("command2file() "param3" "param4" "param5" "param6"")
  fi
  if [ fix me "action" == "tasklist" ]; then
  	write("tasklist("param3", "param4""))
  fi
  if [ fix me "action" == "append" ]; then
  	write("copy "param3"+"testfile" "param3"")
  fi
  if [ fix me "action" == "appendtext" ]; then
  	write("copy /A "param3"+"testfile" "param3"")
  fi
  if [ fix me "action" == "appendbin" ]; then
  	write("copy /b "param3"+"testfile" "param3"")
  fi
  
  if [ fix me "action" == "type" ]; then
  	write("type "testfile" ^>^> "param3"")
  fi
  if [ fix me "action" == "emptyfile" ]; then
  	write("echo. ^> "testfile"")
  fi
  // now do what was said
  if "action" == "xcopy"  action param4 "testfile" "param3"
  if "action" == "copy" action param4 "testfile" "param3" "param5"
  if "action" == "move" action param4 "testfile" "param3"
  if "action" == "rename" action "testfile" "param3"
  if "action" == "del" action /Q "testfile"
  
  if [ fix me "action" == "command" ]; then
  	command() "param3" "param4"  "param5"
  fi
  if [ fix me "action" == "command2file" ]; then
  	command2file() "param3" "param4" "param5" "param6"
  fi
  if [ fix me "action" == "tasklist" ]; then
  	tasklist("param3", "param4")
  fi
  if [ fix me "action" == "append" ]; then
  	copy "param3"+"testfile" "param3"
  fi
  if [ fix me "action" == "appendtext" ]; then
  	copy /A "param3"+"testfile" /A "param3" /A
  fi
  if [ fix me "action" == "append" ]; then
  	copy /b "param3"+"testfile" /b "param3" /b
  fi
  
  if [ fix me "action" == "type" ]; then
  	type "testfile" >> "param3"
  fi
  if [ fix me "action" == "emptyfile" ]; then
  	echo.  > "testfile"
  fi
  if [ fix me "action" == "fatal" ]; then
    echolog() "File not found! message"
    write("message")
    write("The script will end.")
    echo.
    pause
    goto :eof
  fi
else
  write(""testfile" was not found to action")
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function ifnotdefined() {
// Description: non-conditional based on defined variable
// Class: command - condition
// Required parameters:
// test
// func
// Optional parametes:
// funcparams
// Depends on:
// * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var test=%~1;
var func=%~2;
var funcparams=%~3;
if  [ ! -d test ]; then
	write("missing test parameter & goto :eof")
fi
if  [ ! -d func ]; then
	write("missing func parameter & goto :eof")
fi
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if  [ ! -d test ]; then
	func(funcparams, $4)
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function ifnotequal() {
// Description: to do something on the basis of two items being equal
// Required Parameters:
// equal1
// equal2
// func
// funcparams
// Depends on:
// * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var equal1=%~1;
var equal2=%~2;
var func=%~3;
var funcparams=%~4;
if  [ ! -d equal1 ]; then
	write("missing equal1 parameter & goto :eof")
fi
if  [ ! -d equal2 ]; then
	write("missing equal2 parameter & goto :eof")
fi
if  [ ! -d func ]; then
	write("missing func parameter & goto :eof")
fi
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if [ fix me "equal1" neq "equal2" ]; then
	func(funcparams, $4)
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function ifnotexist() {
// Description: If a file or folder do not exist, then performs an action.
// Required parameters:
// testfile
// action - xcopy, copy, del, call, command, tasklist, func or fatal
// param3
// Optional parameters:
// param4
// Depends on:
// funcdebug
// echolog
// command
// tasklist
// * - Any function
// Usage 
// ;ifnotexist testfile copy infileif [switches]
// ;ifnotexist testfile xcopy infileif [switches]
// ;ifnotexist testfile del infileif [switches]
// ;ifnotexist testfile tasklist param3 param4
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var testfile=%~1;
var action=%~2;
var param3=%~3;
var param4=%~4;
var param5=%~5;
if  [ ! -d testfile ]; then
	write("missing testfile parameter & goto :eof")
fi
if  [ ! -d action ]; then
	write("missing action parameter & goto :eof")
fi
if  [ -d param4 ]; then
	set param4=%param4:'="%
fi
if not exist  "testfile" (
  if [ fix me "action" == "xcopy" ]; then
  	echolog() "File not found! testfile"    & action param4 "param3" "testfile"
  fi
  if [ fix me "action" == "copy" ]; then
  	echolog() "File not found! testfile"     & action param4 "param3" "testfile"
  fi
  if [ fix me "action" == "resources" ]; then
  	echolog() "File not found! testfile"     & xcopy /e/y "resources\param3" "param4"
  fi
  if [ fix me "action" == "del" ]; then
  	echolog() "File not found! testfile"      & action param4 "param3"
  fi
  if [ fix me "action" == "report" ]; then
  	echolog() "File not found! testfile - param3"
  fi
  if [ fix me "action" == "recover" ]; then
  	echolog() "File not found! testfile - param3"  & goto :eof
  fi
  if [ fix me "action" == "command" ]; then
  	echolog() "File not found! testfile"  & command("param3", "param4")
  fi
  if [ fix me "action" == "tasklist" ]; then
  	echolog() "File not found! testfile" & tasklist("param3", "param4")
  fi
//  if "action" == "func" echolog() "File not found! testfile"     & param3("param4", "param5")
  if [ fix me "action" == "createfile" ]; then
  	echolog() "File not found! testfile" Create empty file.    & echo. > "testfile"
  fi
  if [ fix me "action" == "fatal" ]; then
  echolog() "File not found! message"
  write("message")
  write("The script will end.")
  echo.
  pause
  goto :eof
  fi

fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function inc() {
// Depreciated: use tasklist
tasklist("%~1", $4)
}

function inccount() {
// Description: iIncrements the count variable
// Class: command - internal - parameter manipulation
// Required preset variables:
// space
// count - on second and subsequent use
// Optional preset variables:
// count - on first use
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var count=count + "+1;"
var writecount=count + ";"
if count lss 10 set writecount=space + "count"
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function infile() {
// Description: If infile is specifically set then uses that else uses previous outfile.
// Class: command - internal - pipeline - parameter
// Required parameters:
// testinfile
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var testinfile=%~1;
if "testinfile" == "" (
var infile=outfile + ";"
else
var infile=testinfile + ";"
fi
if  [ ! -f "infile" ]; then
	set missinginput=on
fi
if  [ -f "infile" ]; then
	set missinginput=
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function inputfile() {
// Description: Sets the starting file of a serial tasklist, by assigning it to the var outfile
// Class: command - variable
// Optional preset variables:
// writebat
// projectbat
// Required parameters:
// outfile
// Added handling so that a preset var writebat, will cause the item to be written to a batch file
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var outfile=%~1;
if  [ ! -d outfile ]; then
	write("missing outfile parameter & goto :eof")
fi
if [ fix me "writebat" == "yes" ]; then
	write("set outfile=%~1 >>projectbat")
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


// Loops ======================================================================

function lookup() {
// Description: Lookup a value in a file before the = and get value after the =
// Required parameters:
// findval
// datafile
// if defined skip goto :eof
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
SET findval=%~1
var datafile=%~2;
var lookupreturn=%~3;
FOR /F "tokens=1-2" %%i IN (datafile) DO IF "%%i" EQU "findval" SET lookupreturn=%%j
@write("lookup of findval returned: lookupreturn")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function loop() {
// Description: a general loop, review parametes before using, other dedcated loops may be easier to use.
// Calss: command - loop
// Required preset variables:
// looptype - Can be any of these: string, listinfile or command
// comment
// string or file or command
// function
// Optional preset variables:
// foroptions - eg "eol=; tokens=2,3* delims=, slip=10"
// Depends on:
// tasklist
// * - Maybe any function but most likely a tasklist
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
if  [ -d echoloopcomment ]; then
	write(""comment"")
fi
if "looptype" == "" write("looptype not defined, skipping this task& goto :eof")
// the command type may be used to process files from a command like: dir /b *.txt
if [ fix me "looptype" == "command" ]; then
	set command=%command:'="%
fi
if [ fix me "looptype" == "command" ]; then
      FOR /F %%s IN ('command') DO function("%%s", $4)
fi
// the listinfile type may be used to process the lines of a file.
if [ fix me "looptype" == "listinfilespaced" ]; then
      FOR /F "foroptions" %%s IN (file) DO function("%%s", %%t, %%u)
fi
// the listinfile type may be used to process the lines of a file.
if [ fix me "looptype" == "listinfile" ]; then
      FOR /F "eol=# delims=" %%s IN (file) DO function("%%s", $4)
fi
// the string type is used to process a space sepparated string.
if [ fix me "looptype" == "string" ]; then
      FOR /F "foroptions" %%s IN ("string") DO function("%%s", $4)
fi
// clear function and tasklist variables in case of later use.
var function=;
var tasks=;
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function loopcommand() {
// Description: loops through a list created from a command like dir and passes that as a param to a tasklist.
// Class: command - loop
// Required parameters:
// comment
// list
// action
// Depends on:
// funcdebug
// * - Maybe any function but most likely a tasklist
// Note: Either preset or command parameters can be used
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
if "%~1" neq "" set action=%~1
if "%~2" neq "" set list=%~2
if "%~3" neq "" set comment=%~3
if  [ ! -d action ]; then
	write("missing action parameter & goto :eof")
fi
if  [ ! -d list ]; then
	write("missing list parameter & goto :eof")
fi
var action=%action:'="%;
write(""comment"")
//write("on")
FOR /F %%s IN ('list') DO action("%%s", $4)
var action=;
var list=;
var comment=;
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function loopdir() {
// Description: Loops through all files in a directory
// Class: command - loop
// Required parameters:
// action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks
// basedir
// comment
// Depends on:
// * - May be any function but probably tasklist
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var action=%~1;
var basedir=%~2;
var comment=%~3;
if  [ ! -d action ]; then
	write("Missing action parameter & goto :eof")
fi
if  [ ! -d basedir ]; then
	write("Missing basedir parameter & goto :eof")
fi
var action=%action:'="%;
if  [ -d comment ]; then
	write("comment")
fi
FOR /F " delims=" %%s IN ('dir /b /a:-d basedir') DO action("%%s", $4)
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function loopfiles() {
// Description: Used to loop through a subset of files specified by the filespec from a single directory
// Class:  command - loop
// Required parameters:
// action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks
// filespec
// Optional parameters:
// comment
// Depends on:
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var action=%~1;
var filespec=%~2;
var comment=%~3;
if  [ ! -d action ]; then
	write("Missing action parameter & goto :eof")
fi
if  [ ! -d filespec ]; then
	write("Missing filespec parameter & goto :eof")
fi
var action=%action:'="%;
if  [ -d comment ]; then
	write("comment")
fi
FOR /F " delims=" %%s IN ('dir /b /a:-d /o:n filespec') DO action("%%s", $4)
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function loopfileset() {
// Description: Loops through a list of files supplied by a file.
// Class: command - loop
// Required parameters:
// action
// fileset
// comment
// Note: 
// Either preset or command parameters can be used
// Depends on:
// funcdebug
// * - Maybe any function but most likely a tasklist
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var action=%~1;
var fileset=%~2;
var comment=%~3;
if  [ ! -d action ]; then
	write("Missing action parameter & goto :eof")
fi
if  [ ! -d fileset ]; then
	write("Missing fileset parameter & goto :eof")
fi
var action=%action:'="%;
if  [ -d comment ]; then
	write("comment")
fi
FOR /F %%s IN (fileset) DO action(%%s, $4)
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function loopstring() {
// Description: Loops through a list supplied in a string.
// Class: command - loop
// Required parameters:
// action
// string
// comment
// Note: 
// Either preset or command parameters can be used
// Depends on:
// funcdebug
// * - May be any function but a tasklist most likely
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var action=%~1;
var string=%~2;
var comment=%~3;
if  [ ! -d action ]; then
	write("Missing action parameter & goto :eof")
fi
if  [ ! -d string ]; then
	write("Missing string parameter & goto :eof")
fi
var action=%action:'="%;
write("comment")
//write("on")
FOR /F "delims= " %%s IN ("string") DO action(%%s&, write("param, %%s"))
// clear variables
var action=;
var string=;
var comment=;
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}



function looptasks() {
// Description: loop through tasks acording to list
// Class: command
// Optional preset variables:
// list
// comment
// Required parameters:
// tasklistfile
// list
// comment
// Depends on:
// funcdebug
// tasklist
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var tasklistfile=%~1;
if  [ ! -d list ]; then
	set list=%~2
fi
if  [ ! -d comment ]; then
	set comment=%~3
fi
if  [ ! -d tasklistfile ]; then
	write("Missing tasklistfile parameter & goto :eof")
fi
if  [ ! -d list ]; then
	write("Missing list parameter & goto :eof")
fi
var tasklistfile=%tasklistfile:'="%;
write(""comment"")
FOR /F %%s IN (list) DO tasklist("tasklistfile", %%s)
var list=;
var comment=;
write("=====^> end looptasks")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function main() {
// Description: Starting point of pub.cmd, test commandline options if present
// Class: command - internal - startup
// Optional parameters:
// projectpath or debugfunc - project path must contain a sub folder setup containing a project.menu or dubugfunc must be "debug"
// functiontodebug
// * - more debug parameters
// Depends on:
// setup
// tasklist
// menu
// * - In debug mode can call any function
// set the codepage to unicode to handle special characters in parameters
var debugstack=00;
if [ fix me "PUBLIC" == "C:\Users\Public" ]; then
      // if "PUBLIC" == "C:\Users\Public" above is to prevent the following command running on Windows XP
      if  [ ! -d skipsettings ]; then
      	chcp 65001
      fi
      fi
echo.
if  [ ! -d skipsettings ]; then
	write("                       Vimod-Pub")
fi
if  [ ! -d skipsettings ]; then
	write("    Various inputs multiple outputs digital publishing")
fi
if  [ ! -d skipsettings ]; then
	write("      https://github.com/silasiapub/vimod-pub")
fi
write("   ----------------------------------------------------")
if  [ -d echofromstart ]; then
	write("on")
fi
var overridetype=%1;
var projectpath=%2;
var functiontodebug=%2;
var inputtasklist=%3;
var params=%3 %4 %5 %6 %7 %8 %9;
if  [ -d projectpath ]; then
	set drive=%~d2
fi
if  [ ! -d projectpath ]; then
	set drive=c:
fi
if [ fix me "overridetype" == "tasklist" ]; then
  // when this is moved in with the other parameters, there are some errors.
  // @write("on")
var   count=0
  if  [ -d projectpath ]; then
  	drive
  fi
  cd %~p0 
  setup()
var   setuppath=projectpath + "\setup"
  tasklist(inputtasklist, $4)
  write("Finished running inputtasklist")
  exit /b 0
fi
setup()
if  [ ! -d overridetype ]; then
  // default option with base menu
  menu(data\projectsetupfolder\project.menu, "Choose, Group?")
else 
if [ fix me "overridetype" == "debug" ]; then
    @write("debugging functiontodebug")
    functiontodebug(params, $4)
  fi else if "overridetype" == "menu" (
    // this option when a valid menu is chosen
    if  [ -f "projectpath\projectsetupfolder\project.menu" ]; then
      menu() "projectpath\projectsetupfolder\project.menu" "Choose project action?"
    fi
  else
    @write("Unknown parameter override word: overridetype")
    @write("Valid override words: tasklist, menu, debug")
    @write("Usage: pub tasklist pathtotasklist/tasklistname.tasks ")
    @write("Usage: pub menu pathtomenu/project.menu")
    @write("Usage: pub debug funcname [parameters]")
  fi
fi 
}

// Menuing and control functions ==============================================

function manyparam() {
// Description: Allows spreading of long commands accross many line in a tasks file. Needed for wkhtmltopdf.
// Class: command - exend
// Required preset variables:
// first - set for all after the first of manyparam
// Optional preset variables:
// first - Not required for first of a series
// Required parameters:
// newparam
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var newparam=%~1;
if  [ ! -d newparam ]; then
	write("Missing newparam parameter & goto :eof")
fi
var param=param newparam;
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function manyparamcmd() {
// Description: places the command before all the serial parameters Needed for wkhtmltopdf.
// Class: command - exend
// Required preset variables:
// param
// Optional preset variables:
// Required parameters:
// command
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var command=%~1;
if  [ ! -d command ]; then
	write("Missing command parameter & goto :eof")
fi
// this can't work here: quoteinquote(param, param)
if  [ -d param ]; then
	set param=%param:'="%
fi
echolog("command", param)
"command"  param
// clear the first variable
var param=;
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}



// Tools sub functions ========================================================

function md5compare() {
// no current use
// Description: Compares the MD5 of the current project.tasks with the previous one, if different then the project.xslt is remade
// Purpose: to see if the project.xslt needs remaking
// Required preset variables:
// cd
// projectpath
// Depends on:
// md5create
// getline
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var md5check=diff;
if  [ -f "cd\logs\project-tasks-cur-md5.txt" ]; then
	del "cd\logs\project-tasks-cur-md5.txt"
fi
md5create("projectpath\setup\project.tasks", "cd\logs\project-tasks-cur-md5.txt")
if exist  "cd\logs\project-tasks-last-md5.txt" (
  getline(4, "cd\logs\project-tasks-last-md5.txt")
var   lastmd5=getline
  getline(4, "cd\logs\project-tasks-cur-md5.txt")
  // clear getline var
var   getline=
  if [ fix me "lastmd5" == "getline" ]; then
var     md5check=same
  fi
fi
del "cd\logs\project-tasks-last-md5.txt"
ren "cd\logs\project-tasks-cur-md5.txt" "project-tasks-last-md5.txt"
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function md5create() {
// no current use
// Description: Make a md5 check file
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
call fciv "%~1" >"%~2"
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function menu() {
// Description: starts a menu
// Revised: 2016-05-04
// Class: command - menu
// Required parameters:
// newmenulist
// title
// forceprojectpath
// Depends on:
// funcdebug
// ext
// removeCommonAtStart
// menuwriteoption
// writeuifeedback
// checkifvimodfolder
// menu
// menueval
var debugstack=0;
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var newmenulist=%~1;
var title=%~2;
var errorlevel=;
var forceprojectpath=%~3;
var skiplines=%~4;
var defaultprojectpath=%~dp1;
var defaultjustprojectpath=%~p1;
var prevprojectpath=projectpath + ";"
var prevmenu=menulist + ";"
var letters=lettersmaster + ";"
var tasklistnumb=;
var count=0;
var varvalue=;
if  [ -d echomenuparams ]; then
	write("menu params=%~0 "%~1" "%~2" "%~3" "%~4"")
fi
//ext(newmenulist, $4)
// detect if projectpath should be forced or not
if  [ -d forceprojectpath ]; then
    if  [ -d echoforceprojectpath ]; then
    	write("forceprojectpath=forceprojectpath")
    fi
var     setuppath=forceprojectpath + "\projectsetupfolder"
var     projectpath=forceprojectpath
    if  [ -f "setup-pub\newmenulist" ]; then
var             menulist="setup-pub\" + newmenulist
var             menutype=settings
    else
var             menulist=commonmenufolder + "\newmenulist"
var             menutype=commonmenutype
    fi
else

    if  [ -d echoforceprojectpath ]; then
    	write("forceprojectpath=forceprojectpath")
    fi
var     projectpathbackslash=${defaultprojectpath:0:-6}
var     projectpath=${defaultprojectpath:0:-7}
    if  [ -d userelativeprojectpath ]; then
    	removeCommonAtStart(projectpath, "projectpathbackslash")
    fi
var     setuppath=${defaultprojectpath:0:-1}
    // write("off")
    if  [ -f "newmenulist" ]; then
var         menulist=newmenulist
var         menutype=projectmenu
    else
var           menutype=createdynamicmenu
var           menulist=created
    fi
fi
if  [ -d breakpointmenu1 ]; then
	pause
fi
if  [ -d echomenulist ]; then
	write("menulist=menulist")
fi
if  [ -d echomenutype ]; then
	write("menutype=menutype")
fi
if  [ -d echoprojectpath ]; then
	write("projectpath")
fi
// ==== start menu layout =====
var title=                     %~2;
var menuoptions=;
echo.
write("title")
if  [ -d echomenufile ]; then
	write("menu=%~1")
fi
if  [ -d echomenufile ]; then
	write("menu=%~1")
fi
echo.
// process the menu types to generate the menu items.
if "menutype" == "projectmenu" FOR /F "eol=# tokens=1,2 delims=;" %%i in (menulist) do set action=%%j&menuwriteoption("%%i", %%j)
if "menutype" == "commonmenutype" FOR /F "eol=# tokens=1,2 delims=;" %%i in (menulist) do set action=%%j&menuwriteoption("%%i", %%j)
if [ fix me "menutype" == "settings" ]; then
	writeuifeedback("menulist", skiplines)
fi
if [ fix me "menutype" == "createdynamicmenu" ]; then
	for /F "eol=# delims=" %%i in ('dir "projectpath" /b/ad') do (
fi
var     action=menu "projectpath\%%i\projectsetupfolder\project.menu" "%%i project"
    checkifvimodfolder(%%i, $4)
    if  [ ! -d skipwriting ]; then
    	menuwriteoption(%%i, $4)
    fi
fi
if [ fix me "menulist" neq "contextmenu.menu" ]; then
    if  [ -d echoutilities ]; then
    	echo.
    fi
    if  [ -d echoutilities ]; then
    	write("       utilityletter. Utilities")
    fi
fi
echo.
if  [ -d breakpointmenu2 ]; then
	pause
fi
if [ fix me "newmenulist" == "data\projectsetupfolder\project.menu" ]; then
    write("       exitletter. Exit batch menu")
else
    if [ fix me "newmenulist" == "commonmenufolder\contextmenu.menu" ]; then
      write("       exitletter. Return to Groups menu")
    else
      write("       exitletter. Return to calling menu")
    fi
fi
echo.
// SET /P prompts for input and sets the variable to whatever the user types
SET Choice=
SET /P Choice=Type the letter and press Enter: 
// The syntax in the next line extracts the substring
// starting at 0 (the beginning) and 1 character long
IF NOT 'Choice'=='' SET Choice=${Choice:0:1}
IF /I 'Choice' == 'utilityletter' menu() contextmenu.menu "Context Menu" "projectpath"
IF /I 'Choice'="='" + exitletter + "'" (
    if [ fix me "menulist" == "commonmenufolder\contextmenu.menu" ]; then
var       skipsettings=on
      pub
    else
        write("...exit menu &goto :eof")
    fi
fi

// Loop to evaluate the input and start the correct process.
// the following line processes the choice
if  [ -d breakpointmenu3 ]; then
	pause
fi
FOR /D %%c IN (menuoptions) DO menueval(%%c, $4)
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
goto :menu

function menublank() {
// Description: used to create a blank line in a menu and if supplied a sub menu title
// Optional parameters:
// blanktitle
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
  echo.
  if  [ -d blanktitle ]; then
  	write("          blanktitle")
  fi
  if  [ -d blanktitle ]; then
  	echo.
  fi
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}



function menueval() {
// Description: resolves the users entered letter and starts the appropriate function
// run through the choices to find a match then calls the selected option
// Required preset variable:
// choice
// Required parameters:
// let
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
if  [ -d varvalue ]; then
	goto :eof
fi
var let=%~1;
var option="option" + let + ";"
// /I makes the IF comparison case-insensitive
IF /I 'Choice'="='" + let + "'" %%option%%()
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

// inc is included so that an xslt transformation can also process this tasklist. Not all tasklists may need processing into params.
function menuvaluechooser() {
// Description: Will write menu lines from a menu file in the commonmenu folder
// Class: command - internal - menu
// Used by: menu
// Required parameters:
// commonmenu
// Depends on:
// menuvaluechooseroptions
// menuvaluechooserevaluation
// menuevaluation
// write("on")
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var list=%~1;
var menuoptions=;
var option=;
var letters=lettersmaster + ";"
echo.
write("title")
echo.
FOR /F %%i in (commonmenupath\list) do menuvaluechooseroptions(%%i, $4)
echo.
// SET /P prompts for input and sets the variable to whatever the user types
SET Choice=
SET /P Choice=Type the letter and press Enter: 
// The syntax in the next line extracts the substring
// starting at 0 (the beginning) and 1 character long
IF NOT 'Choice'=='' SET Choice=${Choice:0:1}

// Loop to evaluate the input and start the correct process.
// the following line processes the choice
//    write("on")
FOR /D %%c IN (menuoptions) DO menuvaluechooserevaluation(%%c, $4)
write("off")
write("outside loop")
// menuevaluation(%%c, $4)
write("valuechosen")
pause
if [ fix me "varvalue" == "set" ]; then
	goto :eof
fi
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function menuvaluechooserevaluation() {
// Class: command - internal - menu
// write("on")
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
if  [ -d varvalue ]; then
	goto :eof
fi
var let=%~1;
IF /I 'Choice'=='a' set valuechosen=valuea + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='b' set valuechosen=valueb + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='c' set valuechosen=valuec + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='d' set valuechosen=valued + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='e' set valuechosen=valuee + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='f' set valuechosen=valuef + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='g' set valuechosen=valueg + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='h' set valuechosen=valueh + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='i' set valuechosen=valuei + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='j' set valuechosen=valuej + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='k' set valuechosen=valuek + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='l' set valuechosen=valuel + "&" set varvalue=set& goto :eof
IF /I 'Choice'=='m' set valuechosen=valuem + "&" set varvalue=set& goto :eof
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function menuvaluechooseroptions() {
// Description: Processes the choices
// Class: command - internal - menu
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var menuitem=%~1;
var let=${letters:0:1};
var valuelet=%~1;
if [ fix me "let" == "stopmenubefore" ]; then
	goto :eof
fi
      write("       let. menuitem")
var letters=%letters:~1%;
// set the option letter
// make the letter list
var menuoptions=menuoptions let;
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function menuwriteoption() {
// Description: writes menu option to screen
// Class: command - internal - menu
// Required preset variable:
// letters
// action
// Required parameters:
// menuitem
// checkfunc
// submenu
// Depends on:
// * - Could call any function but most likely tasklist
if  [ -d debugmenufunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var menuitem=%~1;
var checkfunc=%~2;
var submenu=%~3;
// check for common menu
if /checkfunc/ == /commonmenu/ (
  action()
  goto :eof
fi else if /checkfunc/ == /menublank/ ( 
 // check for menublank
  action()
  goto :eof
fi 
// write the menu item
var let=${letters:0:1};
if [ fix me "let" == "stopmenubefore" ]; then
	goto :eof
fi
      write("       let. menuitem")
var letters=%letters:~1%;
// set the option letter
var optionlet=action + ";"
// make the letter list
var menuoptions=let menuoptions;
if  [ -d debugmenufunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function name() {
// Description: Gets the name of a file (no extension) from a full drive:\path\filename
// Class: command - parameter manipulation
// Required parameters:
// drive:\path\name.ext or path\name.ext or name.ext
// Created variable:
// name
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var name=%~n1;
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function nameext() {
// Description: returns name and extension from a full drive:\path\filename
// Class: command - parameter manipulation
// Required parameters: 
// drive:\path\name.ext or path\name.ext or name.ext
// created variable:
// nameext
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var nameext=%~nx1;
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function outfile() {
// Description: If out file is specifically set then uses that else uses supplied name.
// Class: command - internal - pipeline- parameter
// Required parameters:
// testoutfile
// defaultoutfile
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var testoutfile=%~1;
var defaultoutfile=%~2;
if "testoutfile" == "" (
var outfile=defaultoutfile + ";"
else
var outfile=testoutfile + ";"
fi
drivepath("outfile", $4)
checkdir("drivepath", $4)
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function outputfile() {
// Description: Copies last out file to new name. Used to make a static name other tasklists can use.
// Class: command
// Required preset variables:
// outfile
// Required parameters:
// filename
// Func calls:
// inccount
// drivepath
// nameext
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
inccount()
var infile=outfile + ";"
var filename=%~1;
drivepath("filename", $4)
checkdir("drivepath", $4)
nameext("filename", $4)
var outfile=drivepath + "nameext;"
var curcommand=copy /Y "infile" "outfile";
before(off, $4)
curcommand
after() "Copied "infile" to "outfile"
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function pause() {
// Description: Pauses work until user interaction
// Class: command - user interaction
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
pause
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function plugin() {
// Depreciated: not used. Just create a tasklist to cusmoize a new file-operator
// Description: used to access external plugins
// Class: command - external - extend
// Optional preset variables:
// outputdefault
// Required parameters:
// action
// Optional parameters:
// pluginsubtask
// params
// infile
// outfile
// Depends on:
// infile
// outfile
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
inccount()
var plugin=%~1;
var pluginsubtask=%~2;
var params=%~3;
// if (params) neq (%params:'=%) set params=%params:'="%
if  [ -d params ]; then
	set params=%params:'="%
fi
infile("%~4", $4)
outfile("%~5", "outputdefault")
var curcommand=call plugins\plugin;
before()
curcommand
after("plugin, plugin, complete")
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function projectvar() {
// Description: get the variables from project.tasks file
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
ifexist("projectpath\setup\project.tasks", utf-8)
tasklist(project.tasks, $4)
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function projectxslt() {
// Description: make project.xslt from project.tasks
// Required preset variables:
// projectpath
// Depends on:
// getdatetime
// xslt
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var makenewprojectxslt=;
getfiledatetime(tasksdate, "projectpath\setup\project.tasks")
getfiledatetime(xsltdate, "cd\scripts\xslt\project.xslt")
getfiledatetime(xsltscriptdate, "cd\scripts\xslt\vimod-projecttasks2variable.xslt")
// firstly check if this is the last project run
if [ fix me "lastprojectpath" == "projectpath" ]; then
  // then check if the project.tasks is newer than the project.xslt
var   tasksdate-=xsltdate
  if [ fix me "tasksdate" GTR "xsltdate" ]; then
    // if the project.tasks is newer then remake the project.xslt
    write(" project.tasks newer: remaking project.xslt tasksdate ^> xsltdate")
    echo.
var     makenewprojectxslt=on
  else
    if [ fix me "xsltscriptdate" GTR "xsltdate" ]; then
      echo.
      write("vimod-projecttasks2variable.xslt is newer. xsltscriptdate ^> xsltdate project.xslt")
      write("Remaking project.xslt")
      echo.
var       makenewprojectxslt=on
    else
      inccount()
      // nothing has changed so don't remake project.xslt
      write("1 project.xslt is newer. xsltdate ^> tasksdate project.tasks")
      // write("    Project.tasks  ^< xsltdate project.xslt.")
      echo.
    fi
  fi
else
  // the project is not the same as the last one or Vimod has just been started. So remake project.xslt
  if  [ -d lastprojectpath ]; then
  	write("Project changed from "%lastprojectpath:~37%" to "%projectpath:~37%"")
  fi
  if  [ ! -d lastprojectpath ]; then
  	write("New session for project: %projectpath:~37%")
  fi
  echo.
  write("Remaking project.xslt")
  echo.
var   makenewprojectxslt=on
fi
if  [ -d makenewprojectxslt ]; then
	encoding("projectpath\setup\project.tasks", validate, utf-8)
fi
if  [ -d makenewprojectxslt ]; then
	xslt() vimod-projecttasks2variable "projectpath="'" + projectpath + "'"" blank.xml "cd\scripts\xslt\project.xslt"
fi
var lastprojectpath=projectpath + ";"
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function quoteinquote() {
// Description: Resolves single quotes withing double quotes. Surrounding double quotes dissapea, singles be come doubles.
// Class: command - internal - parameter manipulation
// Required parameters:
// varname
// paramstring
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var varname=%~1;
var paramstring=%~2;
if  [ -d paramstring ]; then
	set varname=%paramstring:'="%
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function removeCommonAtStart() {
// Depreciated: probably not needed
// Description: loops through two strings and sets new variable representing unique data
// Class: command - internal
// Required parameters:
// name - name of the variable to be returned
// test - string to have common data removed from start
// Optional parameters:
// remove - string if not defined then use cd as string.
// Depends on:
// removelet
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var name=%~1;
var test=%~2;
var remove=%~3;
if  [ ! -d remove ]; then
	set remove=cd
fi
var endmatch=;
FOR /L %%l IN (0,1,100) DO if not defined notequal (
      removelet()
      else
      goto :eof
      fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function removelet() {
// Depreciated: probably not needed
// Description: called by removeCommonAtStart to remove one letter from the start of two string variables
// Class: command - internal
// Required preset variables:
// test
// remove
// name
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var test=%test:~1%;
var name=%test:~1%;
var remove=%remove:~1%;
if [ fix me "${test:0:1}" neq "${remove:0:1}" ]; then
	set notequal=on&goto :eof
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function requiredparam() {
// Description: Ensure parameter is present
// Required parameters:
// 
}


function resolve() {
// depreciated: use var
var("%~1", "%~2")
}

function runloop() {
// Description: run loop with parameters
// Class: command - loop - depreciated
// Depends on:
// * - May be any loop type
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var looptype=%~1;
var action=%~2;
var string=%~3;
var fileset=%~3;
var list=%~3;
var comment=%~4;
var string=%string:'="%;
looptype()
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function serialtasks() {
// Depeciated: use looptasks
looptasks("%~1", "%~2", "%~3")
}

function setdefaultoptions() {
// Description: Sets default options if not specifically set
// class: command - parameter - fallback
// Required parameters:
// testoption
// defaultoption
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var testoption=%~1;
var defaultoption=%~2;
if "testoption" == "" (
var   options=defaultoption
else
var options=testoption + ";"
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function setup() {
// Description: sets variables for the batch file
// Revised: 2016-05-04
// Required prerequisite variables
// projectpath
// htmlpath
// localvar
// Func calls:
// checkdir
var beginfuncstring=++ debugging is on ++++++++++++ starting func;
var beginfuncstringtail=++++++++++++++;
if  [ -f setup-pub\functiondebug.settings ]; then
	if not defined skipsettings variableslist(setup-pub\functiondebug.settings, $4)
fi
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var basepath=cd + ";"
var projectbat="projectpath\logs\curdate-build.bat";
var endfuncstring=-------------------------------------- end func;
// check if logs directory exist and create if not there  DO NOT change to checkdir
if  [ ! -f "cd\logs" ]; then
	md "cd\logs"
fi


// set project log file name by date
detectdateformat()
date()
var projectlog="logs\" + curdate + "-build.log;"

// set the predefined variables
variableslist(setup-pub\vimod.variables, $4)

// selfvalue is set so the list of path installed tools will become: set ccw32=ccw32. They are used this way so that if an absolute path is needed it can be set in user_installed.tools
// the following line is removed as path tools moved back into user_installed.tools
// set selfvalue=on

// remove this for now
// if exist setup-pub\user_path_installed.tools variableslist(setup-pub\user_path_installed.tools, $4)

// test if essentials exist
variableslist(setup-pub\essential_installed.tools, fatal)
// added to aid new users in setting up
if  [ -f setup-pub\user_installed.tools ]; then
	variableslist(setup-pub\user_installed.tools, $4)
fi
if  [ -f setup-pub\user_feedback.settings ]; then
	if not defined skipsettings variableslist(setup-pub\user_feedback.settings, $4)
fi
if  [ -f setup-pub\functiondebug.settings ]; then
	if not defined skipsettings variableslist(setup-pub\functiondebug.settings, $4)
fi
if  [ -f setup-pub\my.settings ]; then
	if not defined skipsettings variableslist(setup-pub\my.settings, $4)
fi
// if not defined java testjava()
var classpath=classpath + ";extendclasspath;"
checkdir(cd\data\logs, $4)
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function setvar() {
// depreciated: use var
var("%~1", "%~2")
}


function setvarlist() {
// depreciated: use var
var("%~1", "%~2")
}

function spaceremove() {
var string=%~1;
var spaceremoved=%string: =%;
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
}



// External tools functions ===================================================



function spinoffproject() {
// Description: spinofff a project from whole build system
// Class: command - condition
// Required parameters:
// Created: 2013-08-10
// depreciated doing with tasks file
// Depends on:
// xslt
// joinfile
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var copytext=projectpath + "\logs\copyresources*.txt;"
var copybat=projectpath + "\logs\copyresources.cmd;"
if  [ -f "copytext" ]; then
	del "copytext"
fi
if  [ -f "copybat" ]; then
	del "copybat"
fi
write(":: vimod-spinoff-project generated file>>"copybat"")
if "%~1" == "" (
var outpath=C:\vimod-spinoff-project;
else
var outpath=%~1;
fi
if "%~2" neq "" set projectpath=%~2

dir /a-d/b "projectpath\*.*">"projectpath\logs\files.txt"
xslt() vimod-spinoff-project "projectpath="'" + projectpath + "'" outpath="'" + outpath + "'" projfilelist="'" + projectpath + "\logs\files.txt'"" scripts/xslt/blank.xml "projectpath\logs\spin-off-project-report.txt"
FOR /L %%n IN (0,1,100) DO joinfile(%%n, $4)
if  [ -f "copybat" ]; then
	call "copybat"
fi
//command(xcopy, "'projectpath\*.*', 'outpath")
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}



function start() {
// Description: Start a file in the default program or supply the program and file
// Required parameters:
// var1
// Optional parameters:
// var2
// var3
// var4
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var var1=%~1;
var var2=%~2;
var var3=%~3;
var var4=%~4;
if  [ -d var1 ]; then
  if [ fix me "var1" == "%var1: =%" ]; then
   start "var1" "var2" "var3" "var4"
  else
   start "" "var1" "var2" "var3" "var4"
  fi
else
  start "var1" "var2" "var3" "var4"
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function startfile() {
// Depreciated: use inputfile
}

function tasklist() {
// Discription: Processes a tasks file.
// Required preset variables:
// projectlog
// setuppath
// commontaskspath
// Required parameters:
// tasklistname
// Func calls:
// funcdebugstart
// funcdebugend
// nameext
// * - tasks from tasks file
if  [ -d breaktasklist1 ]; then
	write("on")
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var tasklistname=%~1;
var tasklistnumb=tasklistnumb + "+1;"
if [ fix me "tasklistnumb" == "1" ]; then
	set errorsuspendprocessing=
fi
if  [ -d breaktasklist1 ]; then
	pause
fi
checkdir("projectpath\xml", $4)
checkdir("projectpath\logs", $4)
var projectlog="projectpath\logs\curdate-build.log";
// checks if the list is in the commontaskspath, setuppath (default), if not then tries what is there.
if  [ -f "setuppath\tasklistname" ]; then
var     tasklist=setuppath + "\tasklistname"
    if  [ -d echotasklist ]; then
    	echolog() "[---- tasklisttasklistnumb project tasklistname ---- time ---- "
    fi
    if  [ -d echotasklist ]; then
    	echo.
    fi
else
    if  [ -f "commontaskspath\tasklistname" ]; then
var         tasklist=commontaskspath + "\tasklistname"
        if  [ -d echotasklist ]; then
        	echolog() "[---- tasklisttasklistnumb common  tasklistname ---- time ----"
        fi
        if  [ -d echotasklist ]; then
        	echo.
        fi
    else
        write("tasklist "tasklistname" not found")
        pause
        goto :eof
    fi
fi
if  [ -f "setuppath\project.variables" ]; then
      variableslist("setuppath\project.variables", $4)
fi
if  [ -d breaktasklist2 ]; then
	pause
fi
FOR /F "eol=# tokens=2 delims=;" %%i in (tasklist) do %%i()  errorsuspendprocessing

if  [ -d breaktasklist3 ]; then
	pause
fi
if  [ -d echotasklistend ]; then
	echolog() "  -------------------  tasklisttasklistnumb ended.  time]"
fi
@if defined masterdebug funcdebug(%0, end)
var tasklistnumb=tasklistnumb + "-1;"
}

function tasklists() {
// Description: run serial tasklists
// Required parameters:
// list
// Note: The list must have extension
var list=%~1;
loopstring(tasklist, "list")
}

function testjava() {
// Description: Test if java is installed. Attempt to use local java.exe otherwise it will exit with a warning.
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var javainstalled=;
where java /q
if "errorlevel" ==  "0" set javainstalled=yes
// if defined JAVA_HOME set javainstalled=yes
if  [ ! -d javainstalled ]; then
      if  [ -f altjre ]; then
var             java=altjre
      else
            write("No java found installed nor was java.exe found inVimod-Pub tools\java folder.")
            write("Please install Java on your machine.")
            write("Get it here: http://www.java.com/en/download/")
            write("The program will exit after this pause.")
            pause
            goto :eof
      fi
else
var       java=java
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}




function time() {
// Description: Retrieve time in several shorter formats than time provides
// Created: 2016-05-05
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
FOR /F "tokens=1-4 delims=":" + timeseparator + "."" %%A IN ("time") DO (
var   curhhmm=%A%B
var   curhhmmss=%AB%C
var   curhh_mm=%%A:%%B
var   curhh_mm_ss=%%A:%%B:%%C
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function userinputvar() {
// Description: provides method to interactively input a variable
// Class: command - interactive
// Required parameters:
// varname
// question
// Depends on:
// funcdebug
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var varname=%~1;
var question=%~2;
var /P varname=question + ":;"
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}



//copyresources now in ifnotexist


//copyresourcesifneeded now in ifnotexist


function validatevar() {
// validate variables passed in
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var testvar=%~1;
if  [ ! -d testvar ]; then
            write("No %~1 var found defined")
            write("Please add this to the setup-pub\user_installed.tools")
            write("The program will exit after this pause.")
            pause
            goto :eof
      fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

// built in commandline functions =============================================
function var() {
// Description: sets the variable
// class: command - parameter
// Required parameters:
// varname
// value
// Added handling so that a third param called write("will echo the variable back.")
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var varname=%~1;
var value=%~2;
var varname=value + ";"
if [ fix me "%~3" == "echo" ]; then
	write("varname=value")
fi
if [ fix me "%~3" == "required" ]; then
  if "value" == "" write("Missing varname parameter & set fatalerror=on")
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function variableslist() {
// Description: Handles variables list supplied in a file.
// Class: command - loop
// Optional preset variables:
// selvalue - used to set a value equals itself ie set ccw32=ccw32 from just ccw32. Used for path tools
// echovariableslist
// echoeachvariablelistitem
// Required parameters:
// list - a filename with name=value on each line of the file
// checktype - for use with ifnotexist
// Depends on:
// drivepath
// nameext
// ifnotexist
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
if  [ -d echovariableslist ]; then
	write("==== Processing variable list %~1 ====")
fi
var list=%~1;
var checktype=%~2;
// make sure testvalue is not set
var testvalue=;
FOR /F "eol=# delims== tokens=1,2" %%s IN (list) DO (
var     name=
var     val=
    // selfvalue is set to let a value equal itself like in user_path_installed.tools
    if  [ ! -d selfvalue ]; then
var       %%s=%%t
    else
var       %%s=%%s
    fi
    if  [ -d echoeachvariablelistitem ]; then
    	write("%%s=%%t")
    fi
    if  [ -d checktype ]; then
        drivepath(%%t, $4)
        // the following tests if the value is a path
        if [ fix me "drivepath" neq "cd" ]; then
            // seems redundant nameext(%%t, $4)
            ifnotexist() "%%t" checktype "nameext tool not found in drivepath."
            fi
        fi
    fi
if  [ -d selfvalue ]; then
	set selfvalue=
fi
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}


function writeuifeedback() {
// Description: Produce a menu from a list to allow the user to change default list settings
// Class: command - internal - menu
// Usage: writeuifeedback(list, [skiplines])
// Required parameters:
// list
// Optional parameters:
// skiplines
// Depends on:
// menuwriteoption
// write("on")
if  [ -d debugdefinefunc ]; then
	write("beginfuncstring %0 debugstack beginfuncstringtail")
fi
var list=%~1;
var skiplines=%~2;
if  [ ! -d skiplines ]; then
	set skiplines=1
fi
FOR /F "eol=# tokens=1 skip=skiplines delims==" %%i in (list) do (
    if  [ -d %%i ]; then
var           action=var %%i
          menuwriteoption() "ON  - Turn off %%i?"
    else
var           action=var %%i on
          menuwriteoption() "    - Turn on  %%i?"
    fi
fi
// write("off")
if  [ -d debugdefinefunc ]; then
	write("endfuncstring %0 debugstack")
fi
}

function xarray() {
// Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
// Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
// xarray param is a file
}

function xinclude() {
// Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
// Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
}

function xquery() {
// Description: Provides interface to xquery by saxon9.jar
// Required preset variables:
// java
// saxon9
// Required parameters:
// scriptname
// Optional parameters:
// allparam
// infile
// outfile
// Func calls:
// inccount
// infile
// outfile
// quoteinquote
// before
// after
// created: 2013-08-20
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
var scriptname=%~1;
var allparam=%~2;
infile("%~3", $4)
outfile("%~4", "projectpath\xml\pcode-writecount-scriptname.xml")
inccount()
var script="scripts\xquery\" + scriptname + ".xql;"
quoteinquote(param, "allparam")
var curcommand="java" net.sf.saxon.Query -o:"outfile" -s:"infile" "script" param;
before()
curcommand
after("XQuery, transformation")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}

function xslt() {
// Description: Provides interface to xslt2 by saxon9.jar
// Required preset variables:
// java
// saxon9
// Required parameters:
// scriptname
// Optional parameters:
// allparam
// infile
// outfile
// Func calls:
// inccount
// infile
// outfile
// quoteinquote
// before
// after
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug(%0, $4)
fi
inccount()
var script=xsltpath + "\%~1.xslt;"
var param=;
var allparam=;
var allparam=%~2;
if  [ -d allparam ]; then
	set param=%allparam:'="%
fi
infile("%~3", $4)
outfile("%~4", "projectpath\xml\pcode-count-%~1.xml")
var trace=;
if  [ -d echojavatrace ]; then
	set trace=-t
fi
if  [ ! -d resolvexhtml ]; then
var       curcommand="java" -jar "cd\saxon9" -o:"outfile" "infile" "script" param

else
var       curcommand="java" loadcat=cat net.sf.saxon.Transform trace usecatalog1 usecatalog2 -o:"outfile" "infile" "script" param
fi
before()
curcommand
after("XSLT, transformation")
if  [ -d masterdebug ]; then
	funcdebug(%0, end)
fi
}


function xvar() {
// Description: This is an XSLT only instruction to process a param, DOS variables not allowed in set.
// Note: not used by this batch command. The xvar only creates an XSLT variable but not a DOS variable. Can be used when there are long variables intended for XSLT only.
}

function xvarset() {
// Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
// Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
}




