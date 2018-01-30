@echo "off"
# Title: pub.cmd
# Title Description: Vimod-Pub batch file with menus and tasklist processing
# Author: Ian McQuay
# Created: 2012-03
# Last Modified: 2016-010-12
# Source: https://github.com/silasiapub/vimod-pub
# Commandline startup options:
# pub  - normal usage for menu starting at the data root.
# pub tasklist tasklistname.tasks -  process a particular tasklist, no menus used. Used with Electron Vimod-Pub GUI
# pub menu menupath - Start projet.menu at a particular path
# pub debug function_name - Just run a particular function to debug
goto :main


function after {
# Description: Checks if outfile is created. Reports failures logs actions. Restors previous output file on failure.
# Class: command - internal
# Required preset variables:
# outfile
# projectlog
# writecount
# Optional parameters:
# report3
# message
# Func calls:
# nameext
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
@rem @echo "on"
message=$1
nameext() "$outfile"
if  [ ! -f "$outfile" ]; then
    errorlevel=1
    echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  >>$projectlog"
    echo "$message failed to create $nameext.                           >>$projectlog"
    echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  >>$projectlog"
    echo. >>$projectlog
    echo.
    color E0
    echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    echo "$message failed to create $nameext."
    if  [ ! -d nopauseerror ]; then
        echo.
        echo "Read error above and resolve issue then try again."
        echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        echo.
        pause
        echo.
        errorsuspendprocessing=true
    fi
    if  [ -d nopauseerror ]; then
    	echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    fi
    color 07
else
    if  [ -d echoafterspacepre ]; then
    	echo.
    fi
    echolog() $writecount Created:   $nameext

    if  [ -d echoafterspacepost ]; then
    	echo.
    fi
    echo "---------------------------------------------------------------- >>$projectlog"
    #echo. >>$projectlog
    if  [ -f "$outfile.pre.txt" ]; then
    	del "$outfile.pre.txt"
    fi
fi
@rem @echo "off"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function ampmhour {
# Description: Converts AM/PM time to 24hour format. Also splits
# Created: 2016-05-04 
# Used by: getfiledatetime 
# Required parameters:
# ampm
# thh
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
ampm=$1
thh=$2
if [ fix me "$ampm" == "AM" ]; then
  if [ fix me "$thh" == "12" ]; then
    fhh=00
  else
    fhh=$thh
  fi
fi else if "$ampm" == "PM" (
  if [ fix me "$thh" == "12" ]; then
    fhh=12
  else
    #added handling to prevent octal number error caused by leading zero
    if [ fix me "${thh:0:1}" == "0" ]; then
    	set /A fhh=%thh:~-1%+12
    fi
    if [ fix me "${thh:0:1}" neq "0" ]; then
    	set /A fhh=$thh+12
    fi
  fi
fi else  (
  fhh=$thh
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function appendtofile {
# Description: Func to append text to a file or append text from another file
# Class: command
# Optional predefined variables:
# newfile
# Required parameters:
# file
# text
# quotes
# filetotype
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
file=$1
if  [ ! -d file ]; then
	echo "file parameter not supplied &goto :eof"
fi
text=$2
quotes=$3
filetotype=$5
if  [ ! -d newfile ]; then
	set newfile=$4
fi
if  [ -d quotes ]; then
	set text=%text:'="%
fi
if  [ ! -d filetotype ]; then
  if  [ -d newfile ]; then
    echo "$text>$file"
  else
    echo "$text>>$file"
  fi
else
  if  [ -d newfile ]; then
    type "$filetotype" > $file
  else
    type "$filetotype" >> $file
  fi
fi
newfile=
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

#UI and Debugging functions ========================================================

function before {
# Description: Checks if outfile exists, renames it if it does. Logs actions.
# Class: command - internal
# Required preset variables:
# projectlog
# projectbat
# curcommand
# Optional preset variables:
# outfile
# curcommand
# writebat
# Optional variables:
# echooff
# Func calls: 
# funcdebugstart
# funcdebugend
# nameext
#@echo "on"
echooff=$1
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
if  [ -d echocommandtodo ]; then
	echo "Command to be attempted:"
fi
if  [ -d echocommandtodo ]; then
	echo "$curcommand"
fi
if  [ ! -d echooff ]; then
	echo ""Command to be attempted:" >>$projectlog"
fi
echo ""$curcommand" >>$projectlog"
if  [ -d writebat ]; then
	echo "$curcommand>>$projectbat"
fi
echo. >>$projectlog
if  [ -f "$outfile" ]; then
	nameext() "$outfile"
fi
if  [ -f "$outfile.pre.txt" ]; then
	del "$outfile.pre.txt"
fi
if  [ -f "$outfile" ]; then
	ren "$outfile" "$nameext.pre.txt"
fi
echooff=
#@echo "off"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function cct {
# Description: Privides interface to CCW32.
# Required preset variables:
# ccw32
# Optional preset variables:
# Required parameters:
# script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc"
# Optional parameters:
# infile
# outfile
# Depends on:
# infile
# outfile
# inccount
# before
# after
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
script=$1
if  [ ! -d script ]; then
	echo "CCT missing! & goto :eof"
fi
infile() "$2"
if  [ -d missinginput ]; then
	echo "missing input file & goto :eof"
fi
if  [ ! -f "$ccw32" ]; then
	echo "missing ccw32.exe file & goto :eof"
fi
scriptout=%script:.cct,=_%
inccount()
outfile() "$3" "$projectpath\xml\$pcode-$count-$scriptout.xml"
basepath=$cd
#if not defined ccw32 set ccw32=ccw32
curcommand="$ccw32" $cctparam -t "$script" -o "$outfile" "$infile"
before()
cd $cctpath
$curcommand
cd $basepath
after() "Consistent Changes"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}


function checkdir {
# Description: checks if dir exists if not it is created
# See also: ifnotexist
# Required preset variabes:
# projectlog
# Optional preset variables:
# echodirnotfound
# Required parameters:
# dir
# Depends on:
# funcdebugstart
# funcdebugend
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
dir=$1
if  [ ! -d dir ]; then
	echo "missing required directory parameter & goto :eof"
fi
report=Checking dir $dir
if  [ -f "$dir" ]; then
      echo ". . . Found! $dir >>$projectlog"
else
    #removecommonatstart() dirout "$dir"
    if  [ -d echodirnotfound ]; then
    	echo "Creating . . . $dirout"
    fi
    echo ". . . not found. $dir >>$projectlog"
    echo "mkdir $dir >>$projectlog"
    mkdir "$dir"
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function checkifvimodfolder {
# Description: set the variable skipwriting so that the calling function does not write a menu line.
# Used by: menu
# Optional preset variables:
# echomenuskipping
# Required parameters:
# project
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
project=$1
skipwriting=

if [ fix me "$project" == "$projectsetupfolder" ]; then
    if  [ -d echomenuskipping ]; then
    	echo "skipping dir: $project"
    fi
    skipwriting=on
fi
if [ fix me "$project" == "xml" ]; then
    if  [ -d echomenuskipping ]; then
    	echo "skipping dir: $project"
    fi
    skipwriting=on
fi
if [ fix me "$project" == "logs" ]; then
    if  [ -d echomenuskipping ]; then
    	echo "skipping dir: $project"
    fi
    skipwriting=on
fi
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function command {
# Description: A way of passing any commnand from a tasklist. It does not use infile and outfile.
# Usage: usercommand() "copy /y 'c:\patha\file.txt' 'c:\pathb\file.txt'" ["path to run  command in"   "output file to test for"]
# Limitations: When command line needs single quote.
# Required parameters:
# curcommand
# Optional parameters:
# commandpath
# testoutfile
# Depends on:
# funcdebugstart
# funcdebugend
# inccount
# echolog
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
inccount()
curcommand=$1
if  [ ! -d curcommand ]; then
	echo "missing curcommand & goto :eof"
fi
commandpath=$2
testoutfile=$3
if  [ -d testoutfile ]; then
	set outfile=$testoutfile
fi
curcommand=%curcommand:'="%
echo "$curcommand>>$projectlog"
drive=$d2
if  [ ! -d drive ]; then
	set drive=c:
fi
if  [ -d testoutfile ]; then
  #the next line 'if "$commandpath" neq "" $drive'' must be set with a value even if it is not used or cmd fails. Hence the two lines before this if statement
  if "$commandpath" neq "" $drive
  if  [ -d commandpath ]; then
  	cd "$commandpath"
  fi
  before()
  $curcommand
  after()
  if  [ -d commandpath ]; then
  	cd "$basepath"
  fi
else
  if  [ -d echousercommand ]; then
  	echo "$curcommand"
  fi
  $curcommand
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function command2file {
# Description: Used with commands that only give stdout, so they can be captued in a file.
# Class: command - dos - to file
# Required parameters:
# command
# outfile
# Optional parameters:
# commandpath
# Depends on:
# inccount
# before
# after
# outfile
# funcdebug
# Note: This command does its own expansion of single quotes to double quotes so cannont be fed directly from a ifdefined or ifnotdefined. Instead define a task that is fired by the ifdefined.
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
inccount()
command=$1
out=$2
if  [ ! -d command ]; then
	echo "missing command & goto :eof"
fi
outfile() "$out" "$projectpath\xml\$pcode-$count-command2file.xml"
commandpath=$3
append=$4
#the following is used for the feed back but not for the actual command
if  [ ! -d append ]; then
  curcommand=%command:'="% ^^^> "$outfile"
else
  curcommand=%command:'="% ^^^>^^^> "$outfile"
fi

before()
curcommand=%command:'="%
if "$commandpath" neq "" (
  startdir=$cd
  drive=${commandpath:0:2}
  $drive
  cd "$commandpath"
fi
if  [ ! -d append ]; then
  call $curcommand > "$outfile"
else
  call $curcommand >> "$outfile"
fi

if "$commandpath" neq "" (
  drive=${startdir:0:2}
  $drive
  cd "$startdir"
  dive=
fi
after() "command with stdout $curcommand complete"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}


function command2var {
# Description: creates a variable from the command line
# Class: command - loop
# Required parameters:
# varname
# command
# comment
# Depends on:
# funcdebug
# * - Maybe any function but most likely a tasklist
# Note: Either preset or command parameters can be used
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
commandline=$1
varname=$2
invalid=$3
comment=$4
if  [ ! -d varname ]; then
	echo "missing varname parameter & goto :eof"
fi
if  [ ! -d commandline ]; then
	echo "missing list parameter & goto :eof"
fi
commandline=%commandline:'="%
if  [ -d comment ]; then
	echo "$comment"
fi
FOR /F %%s IN ('$commandline') DO set $varname=%%s
varname=
commandline=
comment=
if [ fix me "$varname" == "$invalid" ]; then
	echo "invalid & set skip=on"
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function commonmenu {
# Description: Will write menu lines from a menu file in the $commonmenufolder folder
# Class: command - menu
# Used by: menu
# Required parameters:
# commonmenu
# Depends on:
# menuwriteoption
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
commonmenu=$1
FOR /F "eol=# tokens=1,2 delims=;" %%i in ($commonmenufolder\$commonmenu) do set action=%%j&menuwriteoption() "%%i" %%j
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function copy {
# Description: Provides copying with exit on failure
# Required preset variables:
# ccw32
# Optional preset variables:
# Required parameters:
# script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc"
# Optional parameters:
# infile
# outfile
# appendfile
# Depends on:
# infile
# outfile
# inccount
# before
# after
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
infile() "$1"
appendfile=$3
if  [ -d missinginput ]; then
	echo "missing input file & goto :eof"
fi
inccount()
outfile() "$2"
if  [ -d appendfile ]; then
  curcommand=copy /y "$outfile"+"$infile" "$outfile" 
else
  curcommand=copy /y "$infile" "$outfile" 
fi
before()
$curcommand
after() Copy Changes"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function date {
# Description: Returns multiple variables with date in three formats, the year in wo formats, month and day date.
# Revised: 2016-05-04
# Classs: command - internal - date -time
# Required preset variables:
# dateformat
# dateseparator
#got this from: http://www.robvanderwoude.com/datetiment.php#IDate
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
FOR /F "tokens=1-4 delims=$dateseparator " %%A IN ("$date") DO (
    IF "$dateformat"=="0" (
        SET fdd=%%C
        SET fmm=%%B
        SET fyyyy=%%D
    fi
    IF "$dateformat"=="1" (
        SET fdd=%%B
        SET fmm=%%C
        SET fyyyy=%%D
    fi
    IF "$dateformat"=="2" (
        SET fdd=%%D
        SET fmm=%%C
        SET fyyyy=%%B
    fi
fi
curdate=$fyyyy-$fmm-$fdd
curisodate=$fyyyy-$fmm-$fdd
curyyyymmdd=$fyyyy$fmm$fdd
curyymmdd=%fyyyy:~2%$fmm$fdd
curUSdate=$fmm/$fdd/$fyyyy
curAUdate=$fdd/$fmm/$fyyyy
curyyyy=$fyyyy
curyy=%fyyyy:~2%
curmm=$fmm
curdd=$fdd
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function debugpause {
# Description: Sets the debug pause to on
# Class: command - debug
# Optional Parameters:
# changedebugpause
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
echo "on"
changedebugpause=$1
if  [ -d debugpause ]; then
  echo "debugging pause"
  pause
else
  if [ fix me "$changedebugpause" == "off" ]; then
    debugpause=
  fi else if defined changedebugpause (
    debugpause=on
  fi
fi
echo "off"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function detectdateformat {
# Description: Get the date format from the Registery: 0=US 1=AU 2=iso
KEY_DATE="HKCU\Control Panel\International"
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY $KEY_DATE /v iDate`) DO set dateformat=%%A
#get the date separator: / or -
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY $KEY_DATE /v sDate`) DO set dateseparator=%%A
#get the time separator: : or ?
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY $KEY_DATE /v sTime`) DO set timeseparator=%%A
#set project log file name by date
}


function dirlist {
# Description: Creates a directory list in a file
# Depreciated: not in current usage
# Class: Command - external
# Depends on:
# dirpath
# dirlist - a file path and name
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
dirpath=$1
if  [ ! -d dirpath ]; then
	echo "missing dirpath input & goto :eof"
fi
dirlist=$2
dir /b "$dirpath" > "$dirlist"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function donothing {
# Description: Do nothing
}

function drive {
# Description: returns the drive
drive=$d1

}


function drivepath {
# Description: returns the drive and path from a full drive:\path\filename
# Class: command - parameter manipulation
# Required parameters:
# Group type: parameter manipulation
# drive:\path\name.ext or path\name.ext
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
drivepath=$(dirname "${1}")
if  [ -d echodrivepath ]; then
	echo "$drivepath"
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function echo {
# Description: generic handling echo
# Modified: 2016-05-05
# Class: command - internal
# Possible required preset parameters:
# projectlog
# Required parameters:
# echotask or message
# Optional parameters:
# message
# add2file
# Depends on:
# funcdebug
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
echotask=$1
if  [ ! -d echotask ]; then
	echo "Missing echotask parameter & goto :eof"
fi
message=$1 $2 $3 $4 $5 $6 $7 $8 $9
if '$echotask' == 'on' (
  @echo "on"
fi else if '$echotask' == 'off' (
  @echo "off"
fi else if '$echotask' == 'add2file' (
  @echo "$2 $3 $4 $5 $6 $7 $8 $9 >> "$add2file""
fi else if '$echotask' == 'log' (
  if  [ -d echoecholog ]; then
  	echo "$message"
  fi
  echo "$curdateT$time >>$projectlog"
  echo "$message >>$projectlog"
  message=                
fi else if '$echotask' == '.' (
  echo.
else
  echo "$message"
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function echolog {
# Description: echoes a message to log file and to screen
# Class: command - internal
# Required preset variables:
# projectlog
# Required parameters:
# message
# Depends on:
# funcdebug
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
message=$1 $2 $3 $4 $5 $6 $7 $8 $9
if  [ -d echoecholog ]; then
	echo "$message"
fi
echo "$curdateT$time >>$projectlog"
echo "$message >>$projectlog"
message=
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}



function encoding {
# Description: to check the encoding of a file
# Created: 2016-05-17
# Required parameters:
# file
# activity = validate or check
# Optional parameters:
# validateagainst
# Depends on:
# infile
# nameext
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
if  [ ! -d encodingchecker ]; then
	echo "Encoding not checked. &goto :eof"
fi
if  [ ! -f "$encodingchecker" ]; then
	echo "file.exe not found! $fileext &echo Encoding not checked. & goto :eof"
fi
testfile=$1
activity=$2
validateagainst=$3
infile() "$testfile"
nameext() "$infile"
command=$encodingchecker -m $magic --mime-encoding "$infile"
FOR /F "tokens=1-2" %%A IN ('$command') DO set fencoding=%%B

if [ fix me "$activity" == "validate" ]; then
    if "$fencoding" == "$validateagainst"  (
        echo "Encoding is $fencoding for file $nameext."
      fi else if "$fencoding" == "us-ascii" (
        echo "Encoding is $fencoding not $validateagainst but is usable."
      else
      echo "File $nameext encoding is invalid! "
      echo "Encoding found to be $fencoding! But it was expected to be $validateagainst."
      errorsuspendprocessing=on
  fi
fi else  (              
    echo "Encoding is: $fencoding for file $nameext."
fi 
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function ext {
# Description: returns file extension from a full drive:\path\filename
# Class: command - parameter manipulation
# Required parameters:
# drive:\path\name.ext or path\name.ext or name.ext
# created variable:
# nameext
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
ext=$x1
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function externalfunctions {
# Depreciated: can't find usage
# Description: non-conditional based on defined variable
# Class: command - extend - external
# Required parameters:
# extcmd
# function
# params
# Depends on:
# inccount
# infile
# outfile
# before
# after
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
inccount()
extcmd=$1
if  [ ! -d extcmd ]; then
	echo "Missing extcmd parameter & goto :eof"
fi
function=$2
params=$3
infile() "$4"
outfile() "$5" "$outputdefault"
curcommand=call $extcmd $function "$params" "$infile" "$outfile"
before()
$curcommand
after() "externalfunctions $function complete"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function file2uri {
# Description: transforms dos path to uri path. i.e. c:\path\file.ext to file:///c:/path/file.ext  not needed for XSLT
# Class: command - parameter manipulation
# Required parameters:  1
# pathfile
# Optional parameters:
# number
# created variables:
# uri$number
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
setvar() pathfile "$1"
numb=$2
uri$numb=file:///%pathfile:\=/%
return=file:///%pathfile:\=/%
if  [ -d echofile2uri ]; then
	echolog()       uri$numb=${return:0:25} . . . %return:~-30%
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function funcdebug {
# Description: Debug function run at the start of a function
# Class: command - internal - debug
# Required parameters:
# entryfunc
@echo "off"
@if defined debugfuncdebug @echo "on"
entryfunc=$1
debugend=$2
if  [ ! -d entryfunc ]; then
	echo "entryfunc is missing, skipping this function & goto :eof"
fi
testfunc=debug%entryfunc:~1%
if [ fix me "$debugend" == "end" ]; then
  debugstack=%debugstack:~1%
  nextdebug=${debugstack:0:1}
  if  [ -d masterdebug ]; then
  	@echo "$endfuncstring $1 $debugstack"
  fi
  if '$nextdebug' == '1' (@echo "on) else (@echo off)"
else
  if  [ -d $testfunc ]; then
  	set debugstack=1$debugstack
  fi
  if  [ ! -d $testfunc ]; then
  	set debugstack=0$debugstack
  fi
  if  [ -d masterdebug ]; then
  	@echo "$beginfuncstring $1  $debugstack $beginfuncstringtail"
  fi
  if [ fix me "${debugstack:0:1}" == "1" ]; then@echo "on) else (@echo off)"
fi
}


function getfiledatetime {
# Description: Returns a variable with a files modification date and time in yyMMddhhmm  similar to setdatetime. Note 4 digit year makes comparison number too big for batch to handle.
# Revised: 2016-05-04
# Classs: command - internal - date -time
# Required parameters:
# varname
# file
# Depends on:
# ampmhour
#echo "on"
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
varname=$1
if  [ ! -d varname ]; then
	echo "missing varname parameter & goto :eof"
fi
file=$2
if  [ ! -f "$file" ]; then
	set $varname=0 &goto :eof
fi
filedate=$t2
#got and mofified this from: http://www.robvanderwoude.com/datetiment.php#IDate
FOR /F "tokens=1-6 delims=:$dateseparator " %%A IN ("$t2") DO (
  IF "$dateformat"=="0" (
      SET fdd=%%B
      SET fmm=%%A
      SET fyyyy=%%C
  fi
  IF "$dateformat"=="1" (
      SET fdd=%%A
      SET fmm=%%B
      SET fyyyy=%%C
  fi
  IF "$dateformat"=="2" (
      SET fdd=%%C
      SET fmm=%%B
      SET fyyyy=%%A
  fi
  fnn=%%E
  ampmhour() %%F %%D
fi
$varname=%fyyyy:~2%$fMM$fdd$fhh$fnn
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function getline {
# Description: Get a specific line from a file
# Class: command - internal
# Required parameters:
# linetoget
# file
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
if  [ -d echogetline ]; then
	echo "on"
fi
linetoget=$1
file=$2
if  [ ! -d linetoget ]; then
	echo "missing linetoget parameter & goto :eof"
fi
if  [ ! -d file ]; then
	echo "missing file parameter & goto :eof"
fi
count=$1-1
if [ fix me "$count" == "0" ]; then
    while [ fix me $2 (  /f %%i in ]; do
    	$5
done
        getline=%%i
        goto :eof
    fi
else
    while [ fix me $2 (  /f "skip=$count " %%i in ]; do
    	$5
done
        getline=%%i
        goto :eof
    fi
fi
@echo "off"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}




function hour {
# Description: Converts AM/PM time to 24hour format. Also splits
# Created: 2016-05-04 used by revised :getfiledatetime 
# Required parameters:
# ampm
# thh
ampm=$1
thh=$2
if "$ampm" == "AM"  (
  if [ fix me "$thh" == "12" ]; then
    fhh=24
  else
    fhh=$thh
  fi
fi else if "$ampm" == "PM" (
  if [ fix me "$thh" == "12" ]; then
    fhh=12
  else
    fhh=$thh+12
  fi
else
  fhh=$thh
fi
}


function html2xml {
# Description: Convert HTML to xml for post processing as xml. it removes the doctype header.
# Required external program: HTML Tidy in variable $tidy5
# Required parameters:
# infile
# Optional Parameters:
# outfile
# Depends on:
# infile
# outfile
# before
# after
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
infile() "$1"
if  [ -d missinginput ]; then
	echo "missing input file & goto :eof"
fi
outfile() "$2" "$projectpath\xml\$pcode-$count-html2xml.xml"
curcommand=call xml fo -H -D "$infile"
#set curcommand=call "$tidy5" -o "$outfile" "$infile"
before()
$curcommand > "$outfile"
after()
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function ifdefined {
# Description: conditional based on defined variable
# Class: command - condition
# Required parameters:
# test
# func
# funcparams - up to 7 aditional
# Depends on:
# tasklist
# Depends on:
# * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
test=$1
func=$2
if  [ ! -d test ]; then
	echo "missing test parameter & goto :eof"
fi
if  [ ! -d func ]; then
	echo "missing func parameter & goto :eof"
fi
func=%func:'="%
funcparams=$3
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if  [ -d $test ]; then
	$func() $funcparams
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function ifequal {
# Description: to do something on the basis of two items being equal
# Required Parameters:
# equal1
# equal2
# func
# params
# Depends on:
# * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
equal1=$1
equal2=$2
func=$3
funcparams=$4
if  [ ! -d equal1 ]; then
	echo "missing equal1 parameter & goto :eof"
fi
if  [ ! -d equal2 ]; then
	echo "missing equal2 parameter & goto :eof"
fi
if  [ ! -d func ]; then
	echo "missing func parameter & goto :eof"
fi
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if [ fix me "$equal1" == "$equal2" ]; then
	$func() $funcparams
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function ifexist {
# Description: Tests if file exists and takes prescribed if it does
# Class: command - condition
# Required parameters: 2-3
# testfile
# action - xcopy, copy, move, rename, del, command, tasklist, func or fatal
# Optional parameters:
# param3 - a multi use param
# param4 - a multi use param resolves internal single quotes to double quotes
# Depends on:
# funcdebug
# nameext
# command
# tasklist
# * - maybe any function
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
testfile=$1
action=$2
param3=$3
param4=$4
param5=$5
param6=$6
if  [ ! -d testfile ]; then
	echo "missing testfile parameter & goto :eof"
fi
if  [ ! -d action ]; then
	echo "missing action parameter & goto :eof"
fi
#if defined param4 set param4=%param4:'="%

nameext() "$1"

if  [ -f "$testfile" ]; then
  if [ fix me "$param3" == "%param3: =%" ]; then
     #prevent param3 with space trying to match these actions
     if [ fix me "$action" == "func" ]; then
     	echo "$param3() "$param4""
     fi
     if [ fix me "$action" == "addtext" ]; then
     	echo " echo $param3 ^>^> "$param4""
     fi
     if [ fix me "$action" == "func" ]; then
     	$param3() "$param4"
     fi
     if [ fix me "$action" == "addtext" ]; then
     	echo "$param3 >> "$param4""
     fi
  fi
  #say what will happen
  if [ fix me "$action" == "xcopy" ]; then
  	echo "$action $param4 "$testfile" "$param3""
  fi
  if [ fix me "$action" == "copy" ]; then
  	echo "$action $param4 "$testfile" "$param3""
  fi
  if [ fix me "$action" == "move" ]; then
  	echo "$action $param4 "$testfile" "$param3""
  fi
  if [ fix me "$action" == "rename" ]; then
  	echo "$action "$testfile" "$param3""
  fi
  if [ fix me "$action" == "del" ]; then
  	echo "$action $param4 "$testfile""
  fi
  
  if [ fix me "$action" == "command" ]; then
  	echo "command() "$param3" "$param4"  "$param5""
  fi
  if [ fix me "$action" == "command2file" ]; then
  	echo "command2file() "$param3" "$param4" "$param5" "$param6""
  fi
  if [ fix me "$action" == "tasklist" ]; then
  	echo "tasklist() "$param3" "$param4""
  fi
  if [ fix me "$action" == "append" ]; then
  	echo "copy "$param3"+"$testfile" "$param3""
  fi
  if [ fix me "$action" == "appendtext" ]; then
  	echo "copy /A "$param3"+"$testfile" "$param3""
  fi
  if [ fix me "$action" == "appendbin" ]; then
  	echo "copy /b "$param3"+"$testfile" "$param3""
  fi
  
  if [ fix me "$action" == "type" ]; then
  	echo "type "$testfile" ^>^> "$param3""
  fi
  if [ fix me "$action" == "emptyfile" ]; then
  	echo "echo. ^> "$testfile""
  fi
  #now do what was said
  if "$action" == "xcopy"  $action $param4 "$testfile" "$param3"
  if "$action" == "copy" $action $param4 "$testfile" "$param3" "$param5"
  if "$action" == "move" $action $param4 "$testfile" "$param3"
  if "$action" == "rename" $action "$testfile" "$param3"
  if "$action" == "del" $action /Q "$testfile"
  
  if [ fix me "$action" == "command" ]; then
  	command() "$param3" "$param4"  "$param5"
  fi
  if [ fix me "$action" == "command2file" ]; then
  	command2file() "$param3" "$param4" "$param5" "$param6"
  fi
  if [ fix me "$action" == "tasklist" ]; then
  	tasklist() "$param3" "$param4"
  fi
  if [ fix me "$action" == "append" ]; then
  	copy "$param3"+"$testfile" "$param3"
  fi
  if [ fix me "$action" == "appendtext" ]; then
  	copy /A "$param3"+"$testfile" /A "$param3" /A
  fi
  if [ fix me "$action" == "append" ]; then
  	copy /b "$param3"+"$testfile" /b "$param3" /b
  fi
  
  if [ fix me "$action" == "type" ]; then
  	type "$testfile" >> "$param3"
  fi
  if [ fix me "$action" == "emptyfile" ]; then
  	echo.  > "$testfile"
  fi
  if [ fix me "$action" == "fatal" ]; then
    echolog() "File not found! $message"
    echo "$message"
    echo "The script will end."
    echo.
    pause
    goto :eof
  fi
else
  echo ""$testfile" was not found to $action"
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function ifnotdefined {
# Description: non-conditional based on defined variable
# Class: command - condition
# Required parameters:
# test
# func
# Optional parametes:
# funcparams
# Depends on:
# * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
test=$1
func=$2
funcparams=$3
if  [ ! -d test ]; then
	echo "missing test parameter & goto :eof"
fi
if  [ ! -d func ]; then
	echo "missing func parameter & goto :eof"
fi
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if  [ ! -d $test ]; then
	$func() $funcparams
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function ifnotequal {
# Description: to do something on the basis of two items being equal
# Required Parameters:
# equal1
# equal2
# func
# funcparams
# Depends on:
# * - Maybe any function but likely tasklist
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
equal1=$1
equal2=$2
func=$3
funcparams=$4
if  [ ! -d equal1 ]; then
	echo "missing equal1 parameter & goto :eof"
fi
if  [ ! -d equal2 ]; then
	echo "missing equal2 parameter & goto :eof"
fi
if  [ ! -d func ]; then
	echo "missing func parameter & goto :eof"
fi
if  [ -d funcparams ]; then
	set funcparams=%funcparams:'="%
fi
if [ fix me "$equal1" neq "$equal2" ]; then
	$func() $funcparams
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function ifnotexist {
# Description: If a file or folder do not exist, then performs an action.
# Required parameters:
# testfile
# action - xcopy, copy, del, call, command, tasklist, func or fatal
# param3
# Optional parameters:
# param4
# Depends on:
# funcdebug
# echolog
# command
# tasklist
# * - Any function
# Usage 
# ;ifnotexist testfile copy infileif [switches]
# ;ifnotexist testfile xcopy infileif [switches]
# ;ifnotexist testfile del infileif [switches]
# ;ifnotexist testfile tasklist param3 param4
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
testfile=$1
action=$2
param3=$3
param4=$4
param5=$5
if  [ ! -d testfile ]; then
	echo "missing testfile parameter & goto :eof"
fi
if  [ ! -d action ]; then
	echo "missing action parameter & goto :eof"
fi
if  [ -d param4 ]; then
	set param4=%param4:'="%
fi
if not exist  "$testfile" (
  if [ fix me "$action" == "xcopy" ]; then
  	echolog() "File not found! $testfile"    & $action $param4 "$param3" "$testfile"
  fi
  if [ fix me "$action" == "copy" ]; then
  	echolog() "File not found! $testfile"     & $action $param4 "$param3" "$testfile"
  fi
  if [ fix me "$action" == "resources" ]; then
  	echolog() "File not found! $testfile"     & xcopy /e/y "resources\$param3" "$param4"
  fi
  if [ fix me "$action" == "del" ]; then
  	echolog() "File not found! $testfile"      & $action $param4 "$param3"
  fi
  if [ fix me "$action" == "report" ]; then
  	echolog() "File not found! $testfile - $param3"
  fi
  if [ fix me "$action" == "recover" ]; then
  	echolog() "File not found! $testfile - $param3"  & goto :eof
  fi
  if [ fix me "$action" == "command" ]; then
  	echolog() "File not found! $testfile"  & command() "$param3" "$param4"
  fi
  if [ fix me "$action" == "tasklist" ]; then
  	echolog() "File not found! $testfile" & tasklist() "$param3" "$param4"
  fi
# if "$action" == "func" echolog() "File not found! $testfile"     & $param3() "$param4" "$param5"
  if [ fix me "$action" == "createfile" ]; then
  	echolog() "File not found! $testfile" Create empty file.    & echo. > "$testfile"
  fi
  if [ fix me "$action" == "fatal" ]; then
  echolog() "File not found! $message"
  echo "$message"
  echo "The script will end."
  echo.
  pause
  goto :eof
  fi

fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function inc {
# Depreciated: use tasklist
tasklist() "$1"
}

function inccount {
# Description: iIncrements the count variable
# Class: command - internal - parameter manipulation
# Required preset variables:
# space
# count - on second and subsequent use
# Optional preset variables:
# count - on first use
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
count=$count+1
writecount=$count
if $count lss 10 set writecount=$space$count
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function infile {
# Description: If infile is specifically set then uses that else uses previous outfile.
# Class: command - internal - pipeline - parameter
# Required parameters:
# testinfile
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
testinfile=$1
if "$testinfile" == "" (
infile=$outfile
else
infile=$testinfile
fi
if  [ ! -f "$infile" ]; then
	set missinginput=on
fi
if  [ -f "$infile" ]; then
	set missinginput=
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function inputfile {
# Description: Sets the starting file of a serial tasklist, by assigning it to the var outfile
# Class: command - variable
# Optional preset variables:
# writebat
# projectbat
# Required parameters:
# outfile
# Added handling so that a preset var $writebat, will cause the item to be written to a batch file
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
outfile=$1
if  [ ! -d outfile ]; then
	echo "missing outfile parameter & goto :eof"
fi
if [ fix me "$writebat" == "yes" ]; then
	echo "set outfile=$1 >>$projectbat"
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


#Loops ======================================================================

function lookup {
# Description: Lookup a value in a file before the = and get value after the =
# Required parameters:
# findval
# datafile
#if defined skip goto :eof
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
SET findval=$1
datafile=$2
lookupreturn=$3
FOR /F "tokens=1-2" %%i IN ($datafile) DO IF "%%i" EQU "$findval" SET lookupreturn=%%j
@echo "lookup of $findval returned: $lookupreturn"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function loop {
# Description: a general loop, review parametes before using, other dedcated loops may be easier to use.
# Calss: command - loop
# Required preset variables:
# looptype - Can be any of these: string, listinfile or command
# comment
# string or file or command
# function
# Optional preset variables:
# foroptions - eg "eol=; tokens=2,3* delims=, slip=10"
# Depends on:
# tasklist
# * - Maybe any function but most likely a tasklist
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
if  [ -d echoloopcomment ]; then
	echo ""$comment""
fi
if "$looptype" == "" echo "looptype not defined, skipping this task& goto :eof"
#the command type may be used to process files from a command like: dir /b *.txt
if [ fix me "$looptype" == "command" ]; then
	set command=%command:'="%
fi
if [ fix me "$looptype" == "command" ]; then
      FOR /F %%s IN ('$command') DO $function() "%%s"
fi
#the listinfile type may be used to process the lines of a file.
if [ fix me "$looptype" == "listinfilespaced" ]; then
      FOR /F "$foroptions" %%s IN ($file) DO $function() "%%s" %%t %%u
fi
#the listinfile type may be used to process the lines of a file.
if [ fix me "$looptype" == "listinfile" ]; then
      FOR /F "eol=# delims=" %%s IN ($file) DO $function() "%%s"
fi
#the string type is used to process a space sepparated string.
if [ fix me "$looptype" == "string" ]; then
      FOR /F "$foroptions" %%s IN ("$string") DO $function() "%%s"
fi
#clear function and tasklist variables in case of later use.
function=
tasks=
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function loopcommand {
# Description: loops through a list created from a command like dir and passes that as a param to a tasklist.
# Class: command - loop
# Required parameters:
# comment
# list
# action
# Depends on:
# funcdebug
# * - Maybe any function but most likely a tasklist
# Note: Either preset or command parameters can be used
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
if "$1" neq "" set action=$1
if "$2" neq "" set list=$2
if "$3" neq "" set comment=$3
if  [ ! -d action ]; then
	echo "missing action parameter & goto :eof"
fi
if  [ ! -d list ]; then
	echo "missing list parameter & goto :eof"
fi
action=%action:'="%
echo ""$comment""
#echo "on"
FOR /F %%s IN ('$list') DO $action() "%%s"
action=
list=
comment=
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function loopdir {
# Description: Loops through all files in a directory
# Class: command - loop
# Required parameters:
# action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks
# basedir
# comment
# Depends on:
# * - May be any function but probably tasklist
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
action=$1
basedir=$2
comment=$3
if  [ ! -d action ]; then
	echo "Missing action parameter & goto :eof"
fi
if  [ ! -d basedir ]; then
	echo "Missing basedir parameter & goto :eof"
fi
action=%action:'="%
if  [ -d comment ]; then
	echo "$comment"
fi
FOR /F " delims=" %%s IN ('dir /b /a:-d $basedir') DO $action() "%%s"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function loopfiles {
# Description: Used to loop through a subset of files specified by the filespec from a single directory
# Class:  command - loop
# Required parameters:
# action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks
# filespec
# Optional parameters:
# comment
# Depends on:
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
action=$1
filespec=$2
comment=$3
if  [ ! -d action ]; then
	echo "Missing action parameter & goto :eof"
fi
if  [ ! -d filespec ]; then
	echo "Missing filespec parameter & goto :eof"
fi
action=%action:'="%
if  [ -d comment ]; then
	echo "$comment"
fi
FOR /F " delims=" %%s IN ('dir /b /a:-d /o:n $filespec') DO $action() "%%s"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function loopfileset {
# Description: Loops through a list of files supplied by a file.
# Class: command - loop
# Required parameters:
# action
# fileset
# comment
# Note: 
# Either preset or command parameters can be used
# Depends on:
# funcdebug
# * - Maybe any function but most likely a tasklist
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
action=$1
fileset=$2
comment=$3
if  [ ! -d action ]; then
	echo "Missing action parameter & goto :eof"
fi
if  [ ! -d fileset ]; then
	echo "Missing fileset parameter & goto :eof"
fi
action=%action:'="%
if  [ -d comment ]; then
	echo "$comment"
fi
FOR /F %%s IN ($fileset) DO $action() %%s
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function loopstring {
# Description: Loops through a list supplied in a string.
# Class: command - loop
# Required parameters:
# action
# string
# comment
# Note: 
# Either preset or command parameters can be used
# Depends on:
# funcdebug
# * - May be any function but a tasklist most likely
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
action=$1
string=$2
comment=$3
if  [ ! -d action ]; then
	echo "Missing action parameter & goto :eof"
fi
if  [ ! -d string ]; then
	echo "Missing string parameter & goto :eof"
fi
action=%action:'="%
echo "$comment"
#echo "on"
FOR /F "delims= " %%s IN ("$string") DO $action() %%s& echo "param %%s"
#clear variables
action=
string=
comment=
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}



function looptasks {
# Description: loop through tasks acording to $list
# Class: command
# Optional preset variables:
# list
# comment
# Required parameters:
# tasklistfile
# list
# comment
# Depends on:
# funcdebug
# tasklist
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
tasklistfile=$1
if  [ ! -d list ]; then
	set list=$2
fi
if  [ ! -d comment ]; then
	set comment=$3
fi
if  [ ! -d tasklistfile ]; then
	echo "Missing tasklistfile parameter & goto :eof"
fi
if  [ ! -d list ]; then
	echo "Missing list parameter & goto :eof"
fi
tasklistfile=%tasklistfile:'="%
echo ""$comment""
FOR /F %%s IN ($list) DO tasklist() "$tasklistfile" %%s
list=
comment=
echo "=====^> end looptasks"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function main {
# Description: Starting point of pub.cmd, test commandline options if present
# Class: command - internal - startup
# Optional parameters:
# projectpath or debugfunc - project path must contain a sub folder setup containing a project.menu or dubugfunc must be "debug"
# functiontodebug
# * - more debug parameters
# Depends on:
# setup
# tasklist
# menu
# * - In debug mode can call any function
#set the codepage to unicode to handle special characters in parameters
debugstack=00
if [ fix me "$PUBLIC" == "C:\Users\Public" ]; then
      #if "$PUBLIC" == "C:\Users\Public" above is to prevent the following command running on Windows XP
      if  [ ! -d skipsettings ]; then
      	chcp 65001
      fi
      fi
echo.
if  [ ! -d skipsettings ]; then
	echo "                       Vimod-Pub"
fi
if  [ ! -d skipsettings ]; then
	echo "    Various inputs multiple outputs digital publishing"
fi
if  [ ! -d skipsettings ]; then
	echo "      https://github.com/silasiapub/vimod-pub"
fi
echo "   ----------------------------------------------------"
if  [ -d echofromstart ]; then
	echo "on"
fi
overridetype=%1
projectpath=%2
functiontodebug=%2
inputtasklist=%3
params=%3 %4 %5 %6 %7 %8 %9
if  [ -d projectpath ]; then
	set drive=$d2
fi
if  [ ! -d projectpath ]; then
	set drive=c:
fi
if [ fix me "$overridetype" == "tasklist" ]; then
  #when this is moved in with the other parameters, there are some errors.
  #@echo "on"
  count=0
  if  [ -d projectpath ]; then
  	$drive
  fi
  cd $(dirname "${0}") 
  setup()
  setuppath=$projectpath\setup
  tasklist() $inputtasklist
  echo "Finished running $inputtasklist"
  exit /b 0
fi
setup()
if  [ ! -d overridetype ]; then
  #default option with base menu
  menu() data\$projectsetupfolder\project.menu "Choose Group?"
else 
if [ fix me "$overridetype" == "debug" ]; then
    @echo "debugging $functiontodebug"
    $functiontodebug() $params
  fi else if "$overridetype" == "menu" (
    #this option when a valid menu is chosen
    if  [ -f "$projectpath\$projectsetupfolder\project.menu" ]; then
      menu() "$projectpath\$projectsetupfolder\project.menu" "Choose project action?"
    fi
  else
    @echo "Unknown parameter override word: $overridetype"
    @echo "Valid override words: tasklist, menu, debug"
    @echo "Usage: pub tasklist pathtotasklist/tasklistname.tasks "
    @echo "Usage: pub menu pathtomenu/project.menu"
    @echo "Usage: pub debug funcname [parameters]"
  fi
fi 
}

#Menuing and control functions ==============================================

function manyparam {
# Description: Allows spreading of long commands accross many line in a tasks file. Needed for wkhtmltopdf.
# Class: command - exend
# Required preset variables:
# first - set for all after the first of manyparam
# Optional preset variables:
# first - Not required for first of a series
# Required parameters:
# newparam
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
newparam=$1
if  [ ! -d newparam ]; then
	echo "Missing newparam parameter & goto :eof"
fi
param=$param $newparam
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function manyparamcmd {
# Description: places the command before all the serial parameters Needed for wkhtmltopdf.
# Class: command - exend
# Required preset variables:
# param
# Optional preset variables:
# Required parameters:
# command
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
command=$1
if  [ ! -d command ]; then
	echo "Missing command parameter & goto :eof"
fi
#this can't work here: quoteinquote() param $param
if  [ -d param ]; then
	set param=%param:'="%
fi
echolog() "$command" $param
"$command"  $param
#clear the first variable
param=
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}



#Tools sub functions ========================================================

function md5compare {
# no current use
# Description: Compares the MD5 of the current project.tasks with the previous one, if different then the project.xslt is remade
# Purpose: to see if the project.xslt needs remaking
# Required preset variables:
# cd
# projectpath
# Depends on:
# md5create
# getline
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
md5check=diff
if  [ -f "$cd\logs\project-tasks-cur-md5.txt" ]; then
	del "$cd\logs\project-tasks-cur-md5.txt"
fi
md5create() "$projectpath\setup\project.tasks" "$cd\logs\project-tasks-cur-md5.txt"
if exist  "$cd\logs\project-tasks-last-md5.txt" (
  getline() 4 "$cd\logs\project-tasks-last-md5.txt"
  lastmd5=$getline
  getline() 4 "$cd\logs\project-tasks-cur-md5.txt"
  #clear getline var
  getline=
  if [ fix me "$lastmd5" == "$getline" ]; then
    md5check=same
  fi
fi
del "$cd\logs\project-tasks-last-md5.txt"
ren "$cd\logs\project-tasks-cur-md5.txt" "project-tasks-last-md5.txt"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function md5create {
# no current use
# Description: Make a md5 check file
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
call fciv "$1" >"$2"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function menu {
# Description: starts a menu
# Revised: 2016-05-04
# Class: command - menu
# Required parameters:
# newmenulist
# title
# forceprojectpath
# Depends on:
# funcdebug
# ext
# removeCommonAtStart
# menuwriteoption
# writeuifeedback
# checkifvimodfolder
# menu
# menueval
debugstack=0
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
newmenulist=$1
title=$2
errorlevel=
forceprojectpath=$3
skiplines=$4
defaultprojectpath=$(dirname "${1}")
defaultjustprojectpath=$(dirname "${1}")
prevprojectpath=$projectpath
prevmenu=$menulist
letters=$lettersmaster
tasklistnumb=
count=0
varvalue=
if  [ -d echomenuparams ]; then
	echo "menu params=$0 "$1" "$2" "$3" "$4""
fi
#ext() $newmenulist
#detect if projectpath should be forced or not
if  [ -d forceprojectpath ]; then
    if  [ -d echoforceprojectpath ]; then
    	echo "forceprojectpath=$forceprojectpath"
    fi
    setuppath=$forceprojectpath\$projectsetupfolder
    projectpath=$forceprojectpath
    if  [ -f "setup-pub\$newmenulist" ]; then
            menulist=setup-pub\$newmenulist
            menutype=settings
    else
            menulist=$commonmenufolder\$newmenulist
            menutype=commonmenutype
    fi
else

    if  [ -d echoforceprojectpath ]; then
    	echo "forceprojectpath=$forceprojectpath"
    fi
    projectpathbackslash=${defaultprojectpath:0:-6}
    projectpath=${defaultprojectpath:0:-7}
    if  [ -d userelativeprojectpath ]; then
    	removeCommonAtStart() projectpath "$projectpathbackslash"
    fi
    setuppath=${defaultprojectpath:0:-1}
    #echo "off"
    if  [ -f "$newmenulist" ]; then
        menulist=$newmenulist
        menutype=projectmenu
    else
          menutype=createdynamicmenu
          menulist=created
    fi
fi
if  [ -d breakpointmenu1 ]; then
	pause
fi
if  [ -d echomenulist ]; then
	echo "menulist=$menulist"
fi
if  [ -d echomenutype ]; then
	echo "menutype=$menutype"
fi
if  [ -d echoprojectpath ]; then
	echo "$projectpath"
fi
#==== start menu layout =====
title=                     $2
menuoptions=
echo.
echo "$title"
if  [ -d echomenufile ]; then
	echo "menu=$1"
fi
if  [ -d echomenufile ]; then
	echo "menu=$1"
fi
echo.
#process the menu types to generate the menu items.
if "$menutype" == "projectmenu" FOR /F "eol=# tokens=1,2 delims=;" %%i in ($menulist) do set action=%%j&menuwriteoption() "%%i" %%j
if "$menutype" == "commonmenutype" FOR /F "eol=# tokens=1,2 delims=;" %%i in ($menulist) do set action=%%j&menuwriteoption() "%%i" %%j
if [ fix me "$menutype" == "settings" ]; then
	writeuifeedback() "$menulist" $skiplines
fi
if [ fix me "$menutype" == "createdynamicmenu" ]; then
	for /F "eol=# delims=" %%i in ('dir "$projectpath" /b/ad') do (
fi
    action=menu "$projectpath\%%i\$projectsetupfolder\project.menu" "%%i project"
    checkifvimodfolder() %%i
    if  [ ! -d skipwriting ]; then
    	menuwriteoption() %%i
    fi
fi
if [ fix me "$menulist" neq "$contextmenu.menu" ]; then
    if  [ -d echoutilities ]; then
    	echo.
    fi
    if  [ -d echoutilities ]; then
    	echo "       $utilityletter. Utilities"
    fi
fi
echo.
if  [ -d breakpointmenu2 ]; then
	pause
fi
if [ fix me "$newmenulist" == "data\$projectsetupfolder\project.menu" ]; then
    echo "       $exitletter. Exit batch menu"
else
    if [ fix me "$newmenulist" == "$commonmenufolder\$contextmenu.menu" ]; then
      echo "       $exitletter. Return to Groups menu"
    else
      echo "       $exitletter. Return to calling menu"
    fi
fi
echo.
#SET /P prompts for input and sets the variable to whatever the user types
SET Choice=
SET /P Choice=Type the letter and press Enter: 
#The syntax in the next line extracts the substring
#starting at 0 (the beginning) and 1 character long
IF NOT '$Choice'=='' SET Choice=${Choice:0:1}
IF /I '$Choice' == '$utilityletter' menu() $contextmenu.menu "Context Menu" "$projectpath"
IF /I '$Choice'=='$exitletter' (
    if [ fix me "$menulist" == "$commonmenufolder\$contextmenu.menu" ]; then
      skipsettings=on
      pub
    else
        echo "...exit menu &goto :eof"
    fi
fi

# Loop to evaluate the input and start the correct process.
# the following line processes the choice
if  [ -d breakpointmenu3 ]; then
	pause
fi
FOR /D %%c IN ($menuoptions) DO menueval() %%c
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
goto :menu

function menublank {
# Description: used to create a blank line in a menu and if supplied a sub menu title
# Optional parameters:
# blanktitle
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
  echo.
  if  [ -d blanktitle ]; then
  	echo "          $blanktitle"
  fi
  if  [ -d blanktitle ]; then
  	echo.
  fi
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}



function menueval {
# Description: resolves the users entered letter and starts the appropriate function
# run through the choices to find a match then calls the selected option
# Required preset variable:
# choice
# Required parameters:
# let
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
if  [ -d varvalue ]; then
	goto :eof
fi
let=$1
option=option$let
# /I makes the IF comparison case-insensitive
IF /I '$Choice'=='$let' %%$option%%()
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

#inc is included so that an xslt transformation can also process this tasklist. Not all tasklists may need processing into params.
function menuvaluechooser {
# Description: Will write menu lines from a menu file in the commonmenu folder
# Class: command - internal - menu
# Used by: menu
# Required parameters:
# commonmenu
# Depends on:
# menuvaluechooseroptions
# menuvaluechooserevaluation
# menuevaluation
#echo "on"
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
list=$1
menuoptions=
option=
letters=$lettersmaster
echo.
echo "$title"
echo.
FOR /F %%i in ($commonmenupath\$list) do menuvaluechooseroptions() %%i
echo.
#SET /P prompts for input and sets the variable to whatever the user types
SET Choice=
SET /P Choice=Type the letter and press Enter: 
#The syntax in the next line extracts the substring
#starting at 0 (the beginning) and 1 character long
IF NOT '$Choice'=='' SET Choice=${Choice:0:1}

#Loop to evaluate the input and start the correct process.
#the following line processes the choice
#   echo "on"
FOR /D %%c IN ($menuoptions) DO menuvaluechooserevaluation() %%c
echo "off"
echo "outside loop"
#menuevaluation() %%c
echo "$valuechosen"
pause
if [ fix me "$varvalue" == "set" ]; then
	goto :eof
fi
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function menuvaluechooserevaluation {
# Class: command - internal - menu
#echo "on"
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
if  [ -d varvalue ]; then
	goto :eof
fi
let=$1
IF /I '$Choice'=='a' set valuechosen=$valuea& set varvalue=set& goto :eof
IF /I '$Choice'=='b' set valuechosen=$valueb& set varvalue=set& goto :eof
IF /I '$Choice'=='c' set valuechosen=$valuec& set varvalue=set& goto :eof
IF /I '$Choice'=='d' set valuechosen=$valued& set varvalue=set& goto :eof
IF /I '$Choice'=='e' set valuechosen=$valuee& set varvalue=set& goto :eof
IF /I '$Choice'=='f' set valuechosen=$valuef& set varvalue=set& goto :eof
IF /I '$Choice'=='g' set valuechosen=$valueg& set varvalue=set& goto :eof
IF /I '$Choice'=='h' set valuechosen=$valueh& set varvalue=set& goto :eof
IF /I '$Choice'=='i' set valuechosen=$valuei& set varvalue=set& goto :eof
IF /I '$Choice'=='j' set valuechosen=$valuej& set varvalue=set& goto :eof
IF /I '$Choice'=='k' set valuechosen=$valuek& set varvalue=set& goto :eof
IF /I '$Choice'=='l' set valuechosen=$valuel& set varvalue=set& goto :eof
IF /I '$Choice'=='m' set valuechosen=$valuem& set varvalue=set& goto :eof
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function menuvaluechooseroptions {
# Description: Processes the choices
# Class: command - internal - menu
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
menuitem=$1
let=${letters:0:1}
value$let=$1
if [ fix me "$let" == "$stopmenubefore" ]; then
	goto :eof
fi
      echo "       $let. $menuitem"
letters=%letters:~1%
#set the option letter
#make the letter list
menuoptions=$menuoptions $let
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function menuwriteoption {
# Description: writes menu option to screen
# Class: command - internal - menu
# Required preset variable:
# letters
# action
# Required parameters:
# menuitem
# checkfunc
# submenu
# Depends on:
# * - Could call any function but most likely tasklist
if  [ -d debugmenufunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
menuitem=$1
checkfunc=$2
submenu=$3
#check for common menu
if /$checkfunc/ == /commonmenu/ (
  $action()
  goto :eof
fi else if /$checkfunc/ == /menublank/ ( 
 #check for menublank
  $action()
  goto :eof
fi 
#write the menu item
let=${letters:0:1}
if [ fix me "$let" == "$stopmenubefore" ]; then
	goto :eof
fi
      echo "       $let. $menuitem"
letters=%letters:~1%
#set the option letter
option$let=$action
#make the letter list
menuoptions=$let $menuoptions
if  [ -d debugmenufunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function name {
# Description: Gets the name of a file (no extension) from a full drive:\path\filename
# Class: command - parameter manipulation
# Required parameters:
# drive:\path\name.ext or path\name.ext or name.ext
# Created variable:
# name
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
name=$n1
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function nameext {
# Description: returns name and extension from a full drive:\path\filename
# Class: command - parameter manipulation
# Required parameters: 
# drive:\path\name.ext or path\name.ext or name.ext
# created variable:
# nameext
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
nameext=$nx1
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function outfile {
# Description: If out file is specifically set then uses that else uses supplied name.
# Class: command - internal - pipeline- parameter
# Required parameters:
# testoutfile
# defaultoutfile
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
testoutfile=$1
defaultoutfile=$2
if "$testoutfile" == "" (
outfile=$defaultoutfile
else
outfile=$testoutfile
fi
drivepath() "$outfile"
checkdir() "$drivepath"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function outputfile {
# Description: Copies last out file to new name. Used to make a static name other tasklists can use.
# Class: command
# Required preset variables:
# outfile
# Required parameters:
# filename
# Func calls:
# inccount
# drivepath
# nameext
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
inccount()
infile=$outfile
filename=$1
drivepath() "$filename"
checkdir() "$drivepath"
nameext() "$filename"
outfile=$drivepath$nameext
curcommand=copy /Y "$infile" "$outfile"
before() off
$curcommand
after() "Copied "$infile" to "$outfile"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function pause {
# Description: Pauses work until user interaction
# Class: command - user interaction
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
pause
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function plugin {
# Depreciated: not used. Just create a tasklist to cusmoize a new file-operator
# Description: used to access external plugins
# Class: command - external - extend
# Optional preset variables:
# outputdefault
# Required parameters:
# action
# Optional parameters:
# pluginsubtask
# params
# infile
# outfile
# Depends on:
# infile
# outfile
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
inccount()
plugin=$1
pluginsubtask=$2
params=$3
#if ($params) neq (%params:'=%) set params=%params:'="%
if  [ -d params ]; then
	set params=%params:'="%
fi
infile() "$4"
outfile() "$5" "$outputdefault"
curcommand=call plugins\$plugin
before()
$curcommand
after() "$plugin plugin complete"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function projectvar {
# Description: get the variables from project.tasks file
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
ifexist() "$projectpath\setup\project.tasks" utf-8
tasklist() project.tasks
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function projectxslt {
# Description: make project.xslt from project.tasks
# Required preset variables:
# projectpath
# Depends on:
# getdatetime
# xslt
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
makenewprojectxslt=
getfiledatetime() tasksdate "$projectpath\setup\project.tasks"
getfiledatetime() xsltdate "$cd\scripts\xslt\project.xslt"
getfiledatetime() xsltscriptdate "$cd\scripts\xslt\vimod-projecttasks2variable.xslt"
#firstly check if this is the last project run
if [ fix me "$lastprojectpath" == "$projectpath" ]; then
  #then check if the project.tasks is newer than the project.xslt
  tasksdate-=$xsltdate
  if [ fix me "$tasksdate" GTR "$xsltdate" ]; then
    #if the project.tasks is newer then remake the project.xslt
    echo " project.tasks newer: remaking project.xslt $tasksdate ^> $xsltdate"
    echo.
    makenewprojectxslt=on
  else
    if [ fix me "$xsltscriptdate" GTR "$xsltdate" ]; then
      echo.
      echo "vimod-projecttasks2variable.xslt is newer. $xsltscriptdate ^> $xsltdate project.xslt"
      echo "Remaking project.xslt"
      echo.
      makenewprojectxslt=on
    else
      inccount()
      #nothing has changed so don't remake project.xslt
      echo "1 project.xslt is newer. $xsltdate ^> $tasksdate project.tasks"
      #echo "    Project.tasks  ^< $xsltdate project.xslt."
      echo.
    fi
  fi
else
  #the project is not the same as the last one or Vimod has just been started. So remake project.xslt
  if  [ -d lastprojectpath ]; then
  	echo "Project changed from "%lastprojectpath:~37%" to "%projectpath:~37%""
  fi
  if  [ ! -d lastprojectpath ]; then
  	echo "New session for project: %projectpath:~37%"
  fi
  echo.
  echo "Remaking project.xslt"
  echo.
  makenewprojectxslt=on
fi
if  [ -d makenewprojectxslt ]; then
	encoding() "$projectpath\setup\project.tasks" validate utf-8
fi
if  [ -d makenewprojectxslt ]; then
	xslt() vimod-projecttasks2variable "projectpath='$projectpath'" blank.xml "$cd\scripts\xslt\project.xslt"
fi
lastprojectpath=$projectpath
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function quoteinquote {
# Description: Resolves single quotes withing double quotes. Surrounding double quotes dissapea, singles be come doubles.
# Class: command - internal - parameter manipulation
# Required parameters:
# varname
# paramstring
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
varname=$1
paramstring=$2
if  [ -d paramstring ]; then
	set $varname=%paramstring:'="%
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function removeCommonAtStart {
# Depreciated: probably not needed
# Description: loops through two strings and sets new variable representing unique data
# Class: command - internal
# Required parameters:
# name - name of the variable to be returned
# test - string to have common data removed from start
# Optional parameters:
# remove - string if not defined then use $cd as string.
# Depends on:
# removelet
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
name=$1
test=$2
remove=$3
if  [ ! -d remove ]; then
	set remove=$cd
fi
endmatch=
FOR /L %%l IN (0,1,100) DO if not defined notequal (
      removelet()
      else
      goto :eof
      fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function removelet {
# Depreciated: probably not needed
# Description: called by removeCommonAtStart to remove one letter from the start of two string variables
# Class: command - internal
# Required preset variables:
# test
# remove
# name
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
test=%test:~1%
$name=%test:~1%
remove=%remove:~1%
if [ fix me "${test:0:1}" neq "${remove:0:1}" ]; then
	set notequal=on&goto :eof
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function requiredparam {
# Description: Ensure parameter is present
# Required parameters:
# 
}


function resolve {
# depreciated: use var
var() "$1" "$2"
}

function runloop {
# Description: run loop with parameters
# Class: command - loop - depreciated
# Depends on:
# * - May be any loop type
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
looptype=$1
action=$2
string=$3
fileset=$3
list=$3
comment=$4
string=%string:'="%
$looptype()
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function serialtasks {
# Depeciated: use looptasks
looptasks() "$1" "$2" "$3"
}

function setdefaultoptions {
# Description: Sets default options if not specifically set
# class: command - parameter - fallback
# Required parameters:
# testoption
# defaultoption
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
testoption=$1
defaultoption=$2
if "$testoption" == "" (
  options=$defaultoption
else
options=$testoption
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function setup {
# Description: sets variables for the batch file
# Revised: 2016-05-04
# Required prerequisite variables
# projectpath
# htmlpath
# localvar
# Func calls:
# checkdir
beginfuncstring=++ debugging is on ++++++++++++ starting func
beginfuncstringtail=++++++++++++++
if  [ -f setup-pub\functiondebug.settings ]; then
	if not defined skipsettings variableslist() setup-pub\functiondebug.settings
fi
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
basepath=$cd
projectbat="$projectpath\logs\$curdate-build.bat"
endfuncstring=-------------------------------------- end func
#check if logs directory exist and create if not there  DO NOT change to checkdir
if  [ ! -f "$cd\logs" ]; then
	md "$cd\logs"
fi


#set project log file name by date
detectdateformat()
date()
projectlog=logs\$curdate-build.log

#set the predefined variables
variableslist() setup-pub\vimod.variables

#selfvalue is set so the list of path installed tools will become: set ccw32=ccw32. They are used this way so that if an absolute path is needed it can be set in user_installed.tools
#the following line is removed as path tools moved back into user_installed.tools
#set selfvalue=on

#remove this for now
#if exist setup-pub\user_path_installed.tools variableslist() setup-pub\user_path_installed.tools

#test if essentials exist
variableslist() setup-pub\essential_installed.tools fatal
#added to aid new users in setting up
if  [ -f setup-pub\user_installed.tools ]; then
	variableslist() setup-pub\user_installed.tools
fi
if  [ -f setup-pub\user_feedback.settings ]; then
	if not defined skipsettings variableslist() setup-pub\user_feedback.settings
fi
if  [ -f setup-pub\functiondebug.settings ]; then
	if not defined skipsettings variableslist() setup-pub\functiondebug.settings
fi
if  [ -f setup-pub\my.settings ]; then
	if not defined skipsettings variableslist() setup-pub\my.settings
fi
#if not defined java testjava()
classpath=$classpath;$extendclasspath
checkdir() $cd\data\logs
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function setvar {
# depreciated: use var
var() "$1" "$2"
}


function setvarlist {
# depreciated: use var
var() "$1" "$2"
}

function spaceremove {
string=$1
spaceremoved=%string: =%
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
}



#External tools functions ===================================================



function spinoffproject {
# Description: spinofff a project from whole build system
# Class: command - condition
# Required parameters:
# Created: 2013-08-10
# depreciated doing with tasks file
# Depends on:
# xslt
# joinfile
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
copytext=$projectpath\logs\copyresources*.txt
copybat=$projectpath\logs\copyresources.cmd
if  [ -f "$copytext" ]; then
	del "$copytext"
fi
if  [ -f "$copybat" ]; then
	del "$copybat"
fi
echo ":: vimod-spinoff-project generated file>>"$copybat""
if "$1" == "" (
outpath=C:\vimod-spinoff-project
else
outpath=$1
fi
if "$2" neq "" set projectpath=$2

dir /a-d/b "$projectpath\*.*">"$projectpath\logs\files.txt"
xslt() vimod-spinoff-project "projectpath='$projectpath' outpath='$outpath' projfilelist='$projectpath\logs\files.txt'" scripts/xslt/blank.xml "$projectpath\logs\spin-off-project-report.txt"
FOR /L %%n IN (0,1,100) DO joinfile() %%n
if  [ -f "$copybat" ]; then
	call "$copybat"
fi
#command() xcopy "'$projectpath\*.*' '$outpath"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}



function start {
# Description: Start a file in the default program or supply the program and file
# Required parameters:
# var1
# Optional parameters:
# var2
# var3
# var4
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
var1=$1
var2=$2
var3=$3
var4=$4
if  [ -d var1 ]; then
  if [ fix me "$var1" == "%var1: =%" ]; then
   start "$var1" "$var2" "$var3" "$var4"
  else
   start "" "$var1" "$var2" "$var3" "$var4"
  fi
else
  start "$var1" "$var2" "$var3" "$var4"
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function startfile {
# Depreciated: use inputfile
}

function tasklist {
# Discription: Processes a tasks file.
# Required preset variables:
# projectlog
# setuppath
# commontaskspath
# Required parameters:
# tasklistname
# Func calls:
# funcdebugstart
# funcdebugend
# nameext
# * - tasks from tasks file
if  [ -d breaktasklist1 ]; then
	echo "on"
fi
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
tasklistname=$1
tasklistnumb=$tasklistnumb+1
if [ fix me "$tasklistnumb" == "1" ]; then
	set errorsuspendprocessing=
fi
if  [ -d breaktasklist1 ]; then
	pause
fi
checkdir() "$projectpath\xml"
checkdir() "$projectpath\logs"
projectlog="$projectpath\logs\$curdate-build.log"
# checks if the list is in the commontaskspath, setuppath (default), if not then tries what is there.
if  [ -f "$setuppath\$tasklistname" ]; then
    tasklist=$setuppath\$tasklistname
    if  [ -d echotasklist ]; then
    	echolog() "[---- tasklist$tasklistnumb project $tasklistname ---- $time ---- "
    fi
    if  [ -d echotasklist ]; then
    	echo.
    fi
else
    if  [ -f "$commontaskspath\$tasklistname" ]; then
        tasklist=$commontaskspath\$tasklistname
        if  [ -d echotasklist ]; then
        	echolog() "[---- tasklist$tasklistnumb common  $tasklistname ---- $time ----"
        fi
        if  [ -d echotasklist ]; then
        	echo.
        fi
    else
        echo "tasklist "$tasklistname" not found"
        pause
        goto :eof
    fi
fi
if  [ -f "$setuppath\project.variables" ]; then
      variableslist() "$setuppath\project.variables"
fi
if  [ -d breaktasklist2 ]; then
	pause
fi
FOR /F "eol=# tokens=2 delims=;" %%i in ($tasklist) do %%i()  $errorsuspendprocessing

if  [ -d breaktasklist3 ]; then
	pause
fi
if  [ -d echotasklistend ]; then
	echolog() "  -------------------  tasklist$tasklistnumb ended.  $time]"
fi
@if defined masterdebug funcdebug() %0 end
tasklistnumb=$tasklistnumb-1
}

function tasklists {
# Description: run serial tasklists
# Required parameters:
# list
# Note: The list must have extension
list=$1
loopstring() tasklist "$list"
}

function testjava {
# Description: Test if java is installed. Attempt to use local java.exe otherwise it will exit with a warning.
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
javainstalled=
where java /q
if "$errorlevel" ==  "0" set javainstalled=yes
#if defined JAVA_HOME set javainstalled=yes
if  [ ! -d javainstalled ]; then
      if  [ -f $altjre ]; then
            java=$altjre
      else
            echo "No java found installed nor was java.exe found inVimod-Pub tools\java folder."
            echo "Please install Java on your machine."
            echo "Get it here: http://www.java.com/en/download/"
            echo "The program will exit after this pause."
            pause
            goto :eof
      fi
else
      java=java
fi
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}




function time {
# Description: Retrieve time in several shorter formats than $time provides
# Created: 2016-05-05
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
FOR /F "tokens=1-4 delims=:$timeseparator." %%A IN ("$time") DO (
  curhhmm=%$A%B
  curhhmmss=%$A$B%C
  curhh_mm=%%A:%%B
  curhh_mm_ss=%%A:%%B:%%C
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function userinputvar {
# Description: provides method to interactively input a variable
# Class: command - interactive
# Required parameters:
# varname
# question
# Depends on:
# funcdebug
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
varname=$1
question=$2
/P $varname=$question:
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}



#copyresources now in ifnotexist


#copyresourcesifneeded now in ifnotexist


function validatevar {
# validate variables passed in
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
testvar=$1
if  [ ! -d testvar ]; then
            echo "No $1 var found defined"
            echo "Please add this to the setup-pub\user_installed.tools"
            echo "The program will exit after this pause."
            pause
            goto :eof
      fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

#built in commandline functions =============================================
function var {
# Description: sets the variable
# class: command - parameter
# Required parameters:
# varname
# value
# Added handling so that a third param called echo "will echo the variable back."
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
varname=$1
value=$2
$varname=$value
if [ fix me "$3" == "echo" ]; then
	echo "$varname=$value"
fi
if [ fix me "$3" == "required" ]; then
  if "$value" == "" echo "Missing $varname parameter & set fatalerror=on"
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function variableslist {
# Description: Handles variables list supplied in a file.
# Class: command - loop
# Optional preset variables:
# selvalue - used to set a value equals itself ie set ccw32=ccw32 from just ccw32. Used for path tools
# echovariableslist
# echoeachvariablelistitem
# Required parameters:
# list - a filename with name=value on each line of the file
# checktype - for use with ifnotexist
# Depends on:
# drivepath
# nameext
# ifnotexist
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
if  [ -d echovariableslist ]; then
	echo "==== Processing variable list $1 ===="
fi
list=$1
checktype=$2
#make sure testvalue is not set
testvalue=
FOR /F "eol=# delims== tokens=1,2" %%s IN ($list) DO (
    name=
    val=
    #selfvalue is set to let a value equal itself like in user_path_installed.tools
    if  [ ! -d selfvalue ]; then
      %%s=%%t
    else
      %%s=%%s
    fi
    if  [ -d echoeachvariablelistitem ]; then
    	echo "%%s=%%t"
    fi
    if  [ -d checktype ]; then
        drivepath() %%t
        #the following tests if the value is a path
        if [ fix me "$drivepath" neq "$cd" ]; then
            #seems redundant nameext() %%t
            ifnotexist() "%%t" $checktype "$nameext tool not found in $drivepath."
            fi
        fi
    fi
if  [ -d selfvalue ]; then
	set selfvalue=
fi
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}


function writeuifeedback {
# Description: Produce a menu from a list to allow the user to change default list settings
# Class: command - internal - menu
# Usage: writeuifeedback() list [skiplines]
# Required parameters:
# list
# Optional parameters:
# skiplines
# Depends on:
# menuwriteoption
#echo "on"
if  [ -d debugdefinefunc ]; then
	echo "$beginfuncstring %0 $debugstack $beginfuncstringtail"
fi
list=$1
skiplines=$2
if  [ ! -d skiplines ]; then
	set skiplines=1
fi
FOR /F "eol=# tokens=1 skip=$skiplines delims==" %%i in ($list) do (
    if  [ -d %%i ]; then
          action=var %%i
          menuwriteoption() "ON  - Turn off %%i?"
    else
          action=var %%i on
          menuwriteoption() "    - Turn on  %%i?"
    fi
fi
#echo "off"
if  [ -d debugdefinefunc ]; then
	echo "$endfuncstring %0 $debugstack"
fi
}

function xarray {
# Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
# Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
#xarray param is a file
}

function xinclude {
# Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
# Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
}

function xquery {
# Description: Provides interface to xquery by saxon9.jar
# Required preset variables:
# java
# saxon9
# Required parameters:
# scriptname
# Optional parameters:
# allparam
# infile
# outfile
# Func calls:
# inccount
# infile
# outfile
# quoteinquote
# before
# after
# created: 2013-08-20
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
scriptname=$1
allparam=$2
infile() "$3"
outfile() "$4" "$projectpath\xml\$pcode-$writecount-$scriptname.xml"
inccount()
script=scripts\xquery\$scriptname.xql
quoteinquote() param "$allparam"
curcommand="$java" net.sf.saxon.Query -o:"$outfile" -s:"$infile" "$script" $param
before()
$curcommand
after() "XQuery transformation"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}

function xslt {
# Description: Provides interface to xslt2 by saxon9.jar
# Required preset variables:
# java
# saxon9
# Required parameters:
# scriptname
# Optional parameters:
# allparam
# infile
# outfile
# Func calls:
# inccount
# infile
# outfile
# quoteinquote
# before
# after
if  [ -d errorsuspendprocessing ]; then
	goto :eof
fi
if  [ -d masterdebug ]; then
	funcdebug() %0
fi
inccount()
script=$xsltpath\$1.xslt
param=
allparam=
allparam=$2
if  [ -d allparam ]; then
	set param=%allparam:'="%
fi
infile() "$3"
outfile() "$4" "$projectpath\xml\$pcode-$count-$1.xml"
trace=
if  [ -d echojavatrace ]; then
	set trace=-t
fi
if  [ ! -d resolvexhtml ]; then
      curcommand="$java" -jar "$cd\$saxon9" -o:"$outfile" "$infile" "$script" $param

else
      curcommand="$java" $loadcat=$cat net.sf.saxon.Transform $trace $usecatalog1 $usecatalog2 -o:"$outfile" "$infile" "$script" $param
fi
before()
$curcommand
after() "XSLT transformation"
if  [ -d masterdebug ]; then
	funcdebug() %0 end
fi
}


function xvar {
# Description: This is an XSLT only instruction to process a param, DOS variables not allowed in set.
# Note: not used by this batch command. The xvar only creates an XSLT variable but not a DOS variable. Can be used when there are long variables intended for XSLT only.
}

function xvarset {
# Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
# Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
}

