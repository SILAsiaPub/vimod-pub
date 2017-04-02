@echo off
:: Title: pub.cmd
:: Title Description: Vimod-Pub batch file with menus and tasklist processing
:: Author: Ian McQuay
:: Created: 2012-03
:: Last Modified: 2016-010-12
:: Source: https://github.com/silasiapub/vimod-pub
:: Commandline startup options:
:: pub  - normal usage for menu starting at the data root.
:: pub tasklist tasklistname.tasks -  process a particular tasklist, no menus used. Used with Electron Vimod-Pub GUI
:: pub menu menupath - Start projet.menu at a particular path
:: pub debug function_name - Just run a particular function to debug


:main
:: Description: Starting point of pub.cmd, test commandline options if present
:: Class: command - internal - startup
:: Optional parameters:
:: projectpath or debugfunc - project path must contain a sub folder setup containing a project.menu or dubugfunc must be "debug"
:: functiontodebug
:: * - more debug parameters
:: Depends on:
:: setup
:: tasklist
:: menu
:: * - In debug mode can call any function
rem set the codepage to unicode to handle special characters in parameters
set debugstack=00
if "%PUBLIC%" == "C:\Users\Public" (
      rem if "%PUBLIC%" == "C:\Users\Public" above is to prevent the following command running on Windows XP
      if not defined skipsettings chcp 65001
      )
echo.
if not defined skipsettings echo                        Vimod-Pub
if not defined skipsettings echo     Various inputs multiple outputs digital publishing
if not defined skipsettings echo       https://github.com/silasiapub/vimod-pub
echo    ----------------------------------------------------
if defined echofromstart echo on
set overridetype=%1
set projectpath=%2
set functiontodebug=%2
set inputtasklist=%3
set params=%3 %4 %5 %6 %7 %8 %9
if defined projectpath set drive=%~d2
if not defined projectpath set drive=c:
if "%overridetype%" == "tasklist" (
  rem when this is moved in with the other parameters, there are some errors.
  rem @echo on
  set count=0
  if defined projectpath %drive%
  cd %~p0 
  call :setup
  set setuppath=%projectpath%\setup
  call :tasklist %inputtasklist%
  echo Finished running %inputtasklist%
  exit /b 0
)
call :setup
if not defined overridetype (
  rem default option with base menu
  call :menu data\%projectsetupfolder%\project.menu "Choose Group?"
) else ( 
if "%overridetype%" == "debug" (
    @echo debugging %functiontodebug%
    call :%functiontodebug% %params%
  ) else if "%overridetype%" == "menu" (
    rem this option when a valid menu is chosen
    if exist "%projectpath%\%projectsetupfolder%\project.menu" (
      call :menu "%projectpath%\%projectsetupfolder%\project.menu" "Choose project action?"
    )
  ) else (
    @echo Unknown parameter override word: %overridetype%
    @echo Valid override words: tasklist, menu, debug
    @echo Usage: pub tasklist pathtotasklist/tasklistname.tasks 
    @echo Usage: pub menu pathtomenu/project.menu
    @echo Usage: pub debug funcname [parameters]
  )
) 
goto :eof

rem Menuing and control functions ==============================================

:menu
:: Description: starts a menu
:: Revised: 2016-05-04
:: Class: command - menu
:: Required parameters:
:: newmenulist
:: title
:: forceprojectpath
:: Depends on:
:: funcdebug
:: ext
:: removeCommonAtStart
:: menuwriteoption
:: writeuifeedback
:: checkifvimodfolder
:: menu
:: menueval
set debugstack=0
if defined masterdebug call :funcdebug %0
set newmenulist=%~1
set title=%~2
set errorlevel=
set forceprojectpath=%~3
set skiplines=%~4
set defaultprojectpath=%~dp1
set defaultjustprojectpath=%~p1
set prevprojectpath=%projectpath%
set prevmenu=%menulist%
set letters=%lettersmaster%
set tasklistnumb=
set count=0
set varvalue=
if defined echomenuparams echo menu params=%~0 "%~1" "%~2" "%~3" "%~4"
::call :ext %newmenulist%
rem detect if projectpath should be forced or not
if defined forceprojectpath (
    if defined echoforceprojectpath echo forceprojectpath=%forceprojectpath%
    set setuppath=%forceprojectpath%\%projectsetupfolder%
    set projectpath=%forceprojectpath%
    if exist "setup-pub\%newmenulist%" (
            set menulist=setup-pub\%newmenulist%
            set menutype=settings
    ) else (
            set menulist=%commonmenufolder%\%newmenulist%
            set menutype=commonmenutype
    )
) else (

    if defined echoforceprojectpath echo forceprojectpath=%forceprojectpath%
    set projectpathbackslash=%defaultprojectpath:~0,-6%
    set projectpath=%defaultprojectpath:~0,-7%
    if defined userelativeprojectpath call :removeCommonAtStart projectpath "%projectpathbackslash%"
    set setuppath=%defaultprojectpath:~0,-1%
    rem echo off
    if exist "%newmenulist%" (
        set menulist=%newmenulist%
        set menutype=projectmenu
    ) else (
          set menutype=createdynamicmenu
          set menulist=created
    )
)
if defined breakpointmenu1 pause
if defined echomenulist echo menulist=%menulist%
if defined echomenutype echo menutype=%menutype%
if defined echoprojectpath echo %projectpath%
rem ==== start menu layout =====
set title=                     %~2
set menuoptions=
echo.
echo %title%
if defined echomenufile echo menu=%~1
if defined echomenufile echo menu=%~1
echo.
rem process the menu types to generate the menu items.
if "%menutype%" == "projectmenu" FOR /F "eol=# tokens=1,2 delims=;" %%i in (%menulist%) do set action=%%j&call :menuwriteoption "%%i" %%j
if "%menutype%" == "commonmenutype" FOR /F "eol=# tokens=1,2 delims=;" %%i in (%menulist%) do set action=%%j&call :menuwriteoption "%%i" %%j
if "%menutype%" == "settings" call :writeuifeedback "%menulist%" %skiplines%
if "%menutype%" == "createdynamicmenu" for /F "eol=# delims=" %%i in ('dir "%projectpath%" /b/ad') do (
    set action=menu "%projectpath%\%%i\%projectsetupfolder%\project.menu" "%%i project"
    call :checkifvimodfolder %%i
    if not defined skipwriting call :menuwriteoption %%i
)
if "%menulist%" neq "utilities.menu" (
    if defined echoutilities echo.
    if defined echoutilities echo        %utilityletter%. Utilities
)
echo.
if defined breakpointmenu2 pause
if "%newmenulist%" == "data\%projectsetupfolder%\project.menu" (
    echo        %exitletter%. Exit batch menu
) else (
    if "%newmenulist%" == "%commonmenufolder%\utilities.menu" (
      echo        %exitletter%. Return to Groups menu
    ) else (
      echo        %exitletter%. Return to calling menu
    )
)
echo.
rem SET /P prompts for input and sets the variable to whatever the user types
SET Choice=
SET /P Choice=Type the letter and press Enter: 
rem The syntax in the next line extracts the substring
rem starting at 0 (the beginning) and 1 character long
IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%
IF /I '%Choice%' == '%utilityletter%' call :menu utilities.menu "Utilities Menu" "%projectpath%"
IF /I '%Choice%'=='%exitletter%' (
    if "%menulist%" == "%commonmenufolder%\utilities.menu" (
      set skipsettings=on
      pub
    ) else (
        echo ...exit menu &goto :eof
    )
)

:: Loop to evaluate the input and start the correct process.
:: the following line processes the choice
if defined breakpointmenu3 pause
FOR /D %%c IN (%menuoptions%) DO call :menueval %%c
if defined masterdebug call :funcdebug %0 end
goto :menu

:menuwriteoption
:: Description: writes menu option to screen
:: Class: command - internal - menu
:: Required preset variable:
:: letters
:: action
:: Required parameters:
:: menuitem
:: checkfunc
:: submenu
:: Depends on:
:: * - Could call any function but most likely tasklist
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set menuitem=%~1
set checkfunc=%~2
set submenu=%~3
rem check for common menu
if /%checkfunc%/ == /commonmenu/ (
  call :%action%
  goto :eof
) else if /%checkfunc%/ == /menublank/ ( 
 rem check for menublank
  call :%action%
  goto :eof
) 
rem write the menu item
set let=%letters:~0,1%
if "%let%" == "%stopmenubefore%" goto :eof
      echo        %let%. %menuitem%
set letters=%letters:~1%
rem set the option letter
set option%let%=%action%
rem make the letter list
set menuoptions=%let% %menuoptions%
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof

:commonmenu
:: Description: Will write menu lines from a menu file in the %commonmenufolder% folder
:: Class: command - menu
:: Used by: menu
:: Required parameters:
:: commonmenu
:: Depends on:
:: menuwriteoption
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set commonmenu=%~1
FOR /F "eol=# tokens=1,2 delims=;" %%i in (%commonmenufolder%\%commonmenu%) do set action=%%j&call :menuwriteoption "%%i" %%j
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof


:menuvaluechooser
:: Description: Will write menu lines from a menu file in the commonmenu folder
:: Class: command - internal - menu
:: Used by: menu
:: Required parameters:
:: commonmenu
:: Depends on:
:: menuvaluechooseroptions
:: menuvaluechooserevaluation
:: menuevaluation
rem echo on
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set list=%~1
set menuoptions=
set option=
set letters=%lettersmaster%
echo.
echo %title%
echo.
FOR /F %%i in (%commonmenupath%\%list%) do call :menuvaluechooseroptions %%i
echo.
rem SET /P prompts for input and sets the variable to whatever the user types
SET Choice=
SET /P Choice=Type the letter and press Enter: 
rem The syntax in the next line extracts the substring
rem starting at 0 (the beginning) and 1 character long
IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%

rem Loop to evaluate the input and start the correct process.
rem the following line processes the choice
rem    echo on
FOR /D %%c IN (%menuoptions%) DO call :menuvaluechooserevaluation %%c
echo off
echo outside loop
rem call :menuevaluation %%c
echo %valuechosen%
pause
if "%varvalue%" == "set" goto :eof
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof

:menuvaluechooseroptions
:: Description: Processes the choices
:: Class: command - internal - menu
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set menuitem=%~1
set let=%letters:~0,1%
set value%let%=%~1
if "%let%" == "%stopmenubefore%" goto :eof
      echo        %let%. %menuitem%
set letters=%letters:~1%
rem set the option letter
rem make the letter list
set menuoptions=%menuoptions% %let%
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof

:menuvaluechooserevaluation
:: Class: command - internal - menu
rem echo on
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
if defined varvalue goto :eof
set let=%~1
IF /I '%Choice%'=='a' set valuechosen=%valuea%& set varvalue=set& goto :eof
IF /I '%Choice%'=='b' set valuechosen=%valueb%& set varvalue=set& goto :eof
IF /I '%Choice%'=='c' set valuechosen=%valuec%& set varvalue=set& goto :eof
IF /I '%Choice%'=='d' set valuechosen=%valued%& set varvalue=set& goto :eof
IF /I '%Choice%'=='e' set valuechosen=%valuee%& set varvalue=set& goto :eof
IF /I '%Choice%'=='f' set valuechosen=%valuef%& set varvalue=set& goto :eof
IF /I '%Choice%'=='g' set valuechosen=%valueg%& set varvalue=set& goto :eof
IF /I '%Choice%'=='h' set valuechosen=%valueh%& set varvalue=set& goto :eof
IF /I '%Choice%'=='i' set valuechosen=%valuei%& set varvalue=set& goto :eof
IF /I '%Choice%'=='j' set valuechosen=%valuej%& set varvalue=set& goto :eof
IF /I '%Choice%'=='k' set valuechosen=%valuek%& set varvalue=set& goto :eof
IF /I '%Choice%'=='l' set valuechosen=%valuel%& set varvalue=set& goto :eof
IF /I '%Choice%'=='m' set valuechosen=%valuem%& set varvalue=set& goto :eof
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof


:menueval
:: Description: resolves the users entered letter and starts the appropriate function
:: run through the choices to find a match then calls the selected option
:: Required preset variable:
:: choice
:: Required parameters:
:: let
if defined masterdebug call :funcdebug %0
if defined varvalue goto :eof
set let=%~1
set option=option%let%
:: /I makes the IF comparison case-insensitive
IF /I '%Choice%'=='%let%' call :%%%option%%%
if defined masterdebug call :funcdebug %0 end
goto :eof

rem inc is included so that an xslt transformation can also process this tasklist. Not all tasklists may need processing into params.
:inc
:: Depreciated: use tasklist
call :tasklist "%~1"
goto :eof

:tasklist
:: Discription: Processes a tasks file.
:: Required preset variables:
:: projectlog
:: setuppath
:: commontaskspath
:: Required parameters:
:: tasklistname
:: Func calls:
:: funcdebugstart
:: funcdebugend
:: nameext
:: * - tasks from tasks file
if defined breaktasklist1 echo on
if defined masterdebug call :funcdebug %0
set tasklistname=%~1
set /A tasklistnumb=%tasklistnumb%+1
if "%tasklistnumb%" == "1" set errorsuspendprocessing=
if defined breaktasklist1 pause
call :checkdir "%projectpath%\xml"
call :checkdir "%projectpath%\logs"
set projectlog="%projectpath%\logs\%curdate%-build.log"
:: checks if the list is in the commontaskspath, setuppath (default), if not then tries what is there.
if exist "%setuppath%\%tasklistname%" (
    set tasklist=%setuppath%\%tasklistname%
    if defined echotasklist call :echolog "[---- tasklist%tasklistnumb% project %tasklistname% ---- %time% ---- "
    if defined echotasklist echo.
) else (
    if exist "%commontaskspath%\%tasklistname%" (
        set tasklist=%commontaskspath%\%tasklistname%
        if defined echotasklist call :echolog "[---- tasklist%tasklistnumb% common  %tasklistname% ---- %time% ----"
        if defined echotasklist echo.
    ) else (
        echo tasklist "%tasklistname%" not found
        pause
        goto :eof
    )
)
if exist "%setuppath%\project.variables" (
      call :variableslist "%setuppath%\project.variables"
)
if defined breaktasklist2 pause
FOR /F "eol=# tokens=2 delims=;" %%i in (%tasklist%) do call :%%i  %errorsuspendprocessing%

if defined breaktasklist3 pause
if defined echotasklistend call :echolog "  -------------------  tasklist%tasklistnumb% ended.  %time%]"
@if defined masterdebug call :funcdebug %0 end
set /A tasklistnumb=%tasklistnumb%-1
goto :eof

:tasklists
:: Description: run serial tasklists
:: Required parameters:
:: list
:: Note: The list must have extension
set list=%~1
call :loopstring tasklist "%list%"
goto :eof

:detectdateformat
:: Description: Get the date format from the Registery: 0=US 1=AU 2=iso
set KEY_DATE="HKCU\Control Panel\International"
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY %KEY_DATE% /v iDate`) DO set dateformat=%%A
rem get the date separator: / or -
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY %KEY_DATE% /v sDate`) DO set dateseparator=%%A
rem get the time separator: : or ?
FOR /F "usebackq skip=2 tokens=3" %%A IN (`REG QUERY %KEY_DATE% /v sTime`) DO set timeseparator=%%A
rem set project log file name by date
goto :eof


:setup
:: Description: sets variables for the batch file
:: Revised: 2016-05-04
:: Required prerequisite variables
:: projectpath
:: htmlpath
:: localvar
:: Func calls:
:: checkdir
set beginfuncstring=++ debugging is on ++++++++++++ starting func
set beginfuncstringtail=++++++++++++++
if exist setup-pub\functiondebug.settings if not defined skipsettings call :variableslist setup-pub\functiondebug.settings
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set basepath=%cd%
set projectbat="%projectpath%\logs\%curdate%-build.bat"
set endfuncstring=-------------------------------------- end func
rem check if logs directory exist and create if not there  DO NOT change to checkdir
if not exist "%cd%\logs" md "%cd%\logs"


rem set project log file name by date
call :detectdateformat
call :date
set projectlog=logs\%curdate%-build.log

rem set the predefined variables
call :variableslist setup-pub\vimod.variables

rem selfvalue is set so the list of path installed tools will become: set ccw32=ccw32. They are used this way so that if an absolute path is needed it can be set in user_installed.tools
rem the following line is removed as path tools moved back into user_installed.tools
rem set selfvalue=on

rem remove this for now
rem if exist setup-pub\user_path_installed.tools call :variableslist setup-pub\user_path_installed.tools

rem test if essentials exist
call :variableslist setup-pub\essential_installed.tools fatal
rem added to aid new users in setting up
if exist setup-pub\user_installed.tools call :variableslist setup-pub\user_installed.tools
if exist setup-pub\user_feedback.settings if not defined skipsettings call :variableslist setup-pub\user_feedback.settings
if exist setup-pub\functiondebug.settings if not defined skipsettings call :variableslist setup-pub\functiondebug.settings
if exist setup-pub\my.settings if not defined skipsettings call :variableslist setup-pub\my.settings
rem if not defined java call :testjava
set classpath=%classpath%;%extendclasspath%
call :checkdir %cd%\data\logs
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:checkdir
:: Description: checks if dir exists if not it is created
:: See also: ifnotexist
:: Required preset variabes:
:: projectlog
:: Optional preset variables:
:: echodirnotfound
:: Required parameters:
:: dir
:: Depends on:
:: funcdebugstart
:: funcdebugend
if defined masterdebug call :funcdebug %0
set dir=%~1
if not defined dir echo missing required directory parameter & goto :eof
set report=Checking dir %dir%
if exist "%dir%" (
      echo . . . Found! %dir% >>%projectlog%
) else (
    rem call :removecommonatstart dirout "%dir%"
    if defined echodirnotfound echo Creating . . . %dirout%
    echo . . . not found. %dir% >>%projectlog%
    echo mkdir %dir% >>%projectlog%
    mkdir "%dir%"
)
if defined masterdebug call :funcdebug %0 end
goto :eof

:validatevar
:: validate variables passed in
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set testvar=%~1
if not defined testvar (
            echo No %~1 var found defined
            echo Please add this to the setup-pub\user_installed.tools
            echo The program will exit after this pause.
            pause
            goto :eof
      )
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

rem built in commandline functions =============================================
:command
:: Description: A way of passing any commnand from a tasklist. It does not use infile and outfile.
:: Usage: call :usercommand "copy /y 'c:\patha\file.txt' 'c:\pathb\file.txt'" ["path to run  command in"   "output file to test for"]
:: Limitations: When command line needs single quote.
:: Required parameters:
:: curcommand
:: Optional parameters:
:: commandpath
:: testoutfile
:: Depends on:
:: funcdebugstart
:: funcdebugend
:: inccount
:: echolog
if defined errorsuspendprocessing goto :eof
if defined masterdebug call :funcdebug %0
call :inccount
set curcommand=%~1
if not defined curcommand echo missing curcommand & goto :eof
set commandpath=%~2
set testoutfile=%~3
if defined testoutfile set outfile=%testoutfile%
set curcommand=%curcommand:'="%
echo %curcommand%>>%projectlog%
set drive=%~d2
if not defined drive set drive=c:
if defined testoutfile (
  rem the next line 'if "%commandpath%" neq "" %drive%'' must be set with a value even if it is not used or cmd fails. Hence the two lines before this if statement
  if "%commandpath%" neq "" %drive%
  if defined commandpath cd "%commandpath%"
  call :before
  %curcommand%
  call :after
  if defined commandpath cd "%basepath%"
) else (
  if defined echousercommand echo %curcommand%
  %curcommand%
)
if defined masterdebug call :funcdebug %0 end
goto :eof

:spaceremove
set string=%~1
set spaceremoved=%string: =%
if defined masterdebug call :funcdebug %0
goto :eof



rem External tools functions ===================================================



:cct
:: Description: Privides interface to CCW32.
:: Required preset variables:
:: ccw32
:: Optional preset variables:
:: Required parameters:
:: script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc"
:: Optional parameters:
:: infile
:: outfile
:: Depends on:
:: infile
:: outfile
:: inccount
:: before
:: after
if defined errorsuspendprocessing goto :eof
if defined masterdebug call :funcdebug %0
set script=%~1
if not defined script echo CCT missing! & goto :eof
call :infile "%~2"
if defined missinginput echo missing input file & goto :eof
if not exist "%ccw32%" echo missing ccw32.exe file & goto :eof
set scriptout=%script:.cct,=_%
call :inccount
call :outfile "%~3" "%projectpath%\xml\%pcode%-%count%-%scriptout%.xml"
set basepath=%cd%
rem if not defined ccw32 set ccw32=ccw32
set curcommand="%ccw32%" %cctparam% -t "%script%" -o "%outfile%" "%infile%"
call :before
cd %cctpath%
%curcommand%
cd %basepath%
call :after "Consistent Changes"
if defined masterdebug call :funcdebug %0 end
goto :eof


:xslt
:: Description: Provides interface to xslt2 by saxon9.jar
:: Required preset variables:
:: java
:: saxon9
:: Required parameters:
:: scriptname
:: Optional parameters:
:: allparam
:: infile
:: outfile
:: Func calls:
:: inccount
:: infile
:: outfile
:: quoteinquote
:: before
:: after
if defined errorsuspendprocessing goto :eof
if defined masterdebug call :funcdebug %0
call :inccount
set script=%xsltpath%\%~1.xslt
set param=
set allparam=
set allparam=%~2
if defined allparam set param=%allparam:'="%
call :infile "%~3"
call :outfile "%~4" "%projectpath%\xml\%pcode%-%count%-%~1.xml"
set trace=
if defined echojavatrace set trace=-t
if not defined resolvexhtml (
      set curcommand="%java%" -jar "%cd%\%saxon9%" -o:"%outfile%" "%infile%" "%script%" %param%

) else (
      set curcommand="%java%" %loadcat%=%cat% net.sf.saxon.Transform %trace% %usecatalog1% %usecatalog2% -o:"%outfile%" "%infile%" "%script%" %param%
)
call :before
%curcommand%
call :after "XSLT transformation"
if defined masterdebug call :funcdebug %0 end
goto :eof


:projectvar
:: Description: get the variables from project.tasks file
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
call :ifexist "%projectpath%\setup\project.tasks" utf-8
call :tasklist project.tasks
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:projectxslt
:: Description: make project.xslt from project.tasks
:: Required preset variables:
:: projectpath
:: Depends on:
:: getdatetime
:: xslt
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set makenewprojectxslt=
call :getfiledatetime tasksdate "%projectpath%\setup\project.tasks"
call :getfiledatetime xsltdate "%cd%\scripts\xslt\project.xslt"
call :getfiledatetime xsltscriptdate "%cd%\scripts\xslt\vimod-projecttasks2variable.xslt"
rem firstly check if this is the last project run
if "%lastprojectpath%" == "%projectpath%" (
  rem then check if the project.tasks is newer than the project.xslt
  set /A tasksdate-=%xsltdate%
  if "%tasksdate%" GTR "%xsltdate%" (
    rem if the project.tasks is newer then remake the project.xslt
    echo  project.tasks newer: remaking project.xslt %tasksdate% ^> %xsltdate%
    echo.
    set makenewprojectxslt=on
  ) else (
    if "%xsltscriptdate%" GTR "%xsltdate%" (
      echo.
      echo vimod-projecttasks2variable.xslt is newer. %xsltscriptdate% ^> %xsltdate% project.xslt
      echo Remaking project.xslt
      echo.
      set makenewprojectxslt=on
    ) else (
      call :inccount
      rem nothing has changed so don't remake project.xslt
      echo 1 project.xslt is newer. %xsltdate% ^> %tasksdate% project.tasks
      rem echo     Project.tasks  ^< %xsltdate% project.xslt.
      echo.
    )
  )
) else (
  rem the project is not the same as the last one or Vimod has just been started. So remake project.xslt
  if defined lastprojectpath echo Project changed from "%lastprojectpath:~37%" to "%projectpath:~37%"
  if not defined lastprojectpath echo New session for project: %projectpath:~37%
  echo.
  echo Remaking project.xslt
  echo.
  set makenewprojectxslt=on
)
if defined makenewprojectxslt call :encoding "%projectpath%\setup\project.tasks" validate utf-8
if defined makenewprojectxslt call :xslt vimod-projecttasks2variable "projectpath='%projectpath%'" blank.xml "%cd%\scripts\xslt\project.xslt"
set lastprojectpath=%projectpath%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:copy
:: Description: Provides copying with exit on failure
:: Required preset variables:
:: ccw32
:: Optional preset variables:
:: Required parameters:
:: script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc"
:: Optional parameters:
:: infile
:: outfile
:: appendfile
:: Depends on:
:: infile
:: outfile
:: inccount
:: before
:: after
if defined masterdebug call :funcdebug %0
call :infile "%~1"
set appendfile=%~3
if defined missinginput echo missing input file & goto :eof
call :inccount
call :outfile "%~2"
if defined appendfile (
  set curcommand=copy /y "%outfile%"+"%infile%" "%outfile%" 
) else (
  set curcommand=copy /y "%infile%" "%outfile%" 
)
call :before
%curcommand%
call :after Copy Changes"
if defined masterdebug call :funcdebug %0 end
goto :eof

:md5compare
:: no current use
:: Description: Compares the MD5 of the current project.tasks with the previous one, if different then the project.xslt is remade
:: Purpose: to see if the project.xslt needs remaking
:: Required preset variables:
:: cd
:: projectpath
:: Depends on:
:: md5create
:: getline
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set md5check=diff
if exist "%cd%\logs\project-tasks-cur-md5.txt" del "%cd%\logs\project-tasks-cur-md5.txt"
call :md5create "%projectpath%\setup\project.tasks" "%cd%\logs\project-tasks-cur-md5.txt"
if exist  "%cd%\logs\project-tasks-last-md5.txt" (
  call :getline 4 "%cd%\logs\project-tasks-last-md5.txt"
  set lastmd5=%getline%
  call :getline 4 "%cd%\logs\project-tasks-cur-md5.txt"
  rem clear getline var
  set getline=
  if "%lastmd5%" == "%getline%" (
    set md5check=same
  )
)
del "%cd%\logs\project-tasks-last-md5.txt"
ren "%cd%\logs\project-tasks-cur-md5.txt" "project-tasks-last-md5.txt"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:md5create
:: no current use
:: Description: Make a md5 check file
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
call fciv "%~1" >"%~2"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:xquery
:: Description: Provides interface to xquery by saxon9.jar
:: Required preset variables:
:: java
:: saxon9
:: Required parameters:
:: scriptname
:: Optional parameters:
:: allparam
:: infile
:: outfile
:: Func calls:
:: inccount
:: infile
:: outfile
:: quoteinquote
:: before
:: after
:: created: 2013-08-20
if defined masterdebug call :funcdebug %0
set scriptname=%~1
set allparam=%~2
call :infile "%~3"
call :outfile "%~4" "%projectpath%\xml\%pcode%-%writecount%-%scriptname%.xml"
call :inccount
set script=scripts\xquery\%scriptname%.xql
call :quoteinquote param "%allparam%"
set curcommand="%java%" net.sf.saxon.Query -o:"%outfile%" -s:"%infile%" "%script%" %param%
call :before
%curcommand%
call :after "XQuery transformation"
if defined masterdebug call :funcdebug %0 end
goto :eof

:testjava
:: Description: Test if java is installed. Attempt to use local java.exe otherwise it will exit with a warning.
if defined masterdebug call :funcdebug %0
set javainstalled=
where java /q
if "%errorlevel%" ==  "0" set javainstalled=yes
rem if defined JAVA_HOME set javainstalled=yes
if not defined javainstalled (
      if exist %altjre% (
            set java=%altjre%
      ) else (
            echo No java found installed nor was java.exe found inVimod-Pub tools\java folder.
            echo Please install Java on your machine.
            echo Get it here: http://www.java.com/en/download/
            echo The program will exit after this pause.
            pause
            goto :eof
      )
) else (
      set java=java
)
if defined masterdebug call :funcdebug %0 end
goto :eof




:manyparam
:: Description: Allows spreading of long commands accross many line in a tasks file. Needed for wkhtmltopdf.
:: Class: command - exend
:: Required preset variables:
:: first - set for all after the first of manyparam
:: Optional preset variables:
:: first - Not required for first of a series
:: Required parameters:
:: newparam
if defined masterdebug call :funcdebug %0
set newparam=%~1
if not defined newparam echo Missing newparam parameter & goto :eof
set param=%param% %newparam%
if defined masterdebug call :funcdebug %0 end
goto :eof

:manyparamcmd
:: Description: places the command before all the serial parameters Needed for wkhtmltopdf.
:: Class: command - exend
:: Required preset variables:
:: param
:: Optional preset variables:
:: Required parameters:
:: command
if defined masterdebug call :funcdebug %0
set command=%~1
if not defined command echo Missing command parameter & goto :eof
rem this can't work here: call :quoteinquote param %param%
if defined param set param=%param:'="%
call :echolog "%command%" %param%
"%command%"  %param%
rem clear the first variable
set param=
if defined masterdebug call :funcdebug %0 end
goto :eof



rem Tools sub functions ========================================================

:before
:: Description: Checks if outfile exists, renames it if it does. Logs actions.
:: Class: command - internal
:: Required preset variables:
:: projectlog
:: projectbat
:: curcommand
:: Optional preset variables:
:: outfile
:: curcommand
:: writebat
:: Optional variables:
:: echooff
:: Func calls: 
:: funcdebugstart
:: funcdebugend
:: nameext
rem @echo on
set echooff=%~1
if defined masterdebug call :funcdebug %0
if defined echocommandtodo echo Command to be attempted:
if defined echocommandtodo echo %curcommand%
if not defined echooff echo "Command to be attempted:" >>%projectlog%
echo "%curcommand%" >>%projectlog%
if defined writebat echo %curcommand%>>%projectbat%
echo. >>%projectlog%
if exist "%outfile%" call :nameext "%outfile%"
if exist "%outfile%.pre.txt" del "%outfile%.pre.txt"
if exist "%outfile%" ren "%outfile%" "%nameext%.pre.txt"
set echooff=
rem @echo off
if defined masterdebug call :funcdebug %0 end
goto :eof

:after
:: Description: Checks if outfile is created. Reports failures logs actions. Restors previous output file on failure.
:: Class: command - internal
:: Required preset variables:
:: outfile
:: projectlog
:: writecount
:: Optional parameters:
:: report3
:: message
:: Func calls:
:: nameext
if defined masterdebug call :funcdebug %0
@rem @echo on
set message=%~1
call :nameext "%outfile%"
if not exist "%outfile%" (
    set errorlevel=1
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  >>%projectlog%
    echo %message% failed to create %nameext%.                           >>%projectlog%
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  >>%projectlog%
    echo. >>%projectlog%
    echo.
    color E0
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    echo %message% failed to create %nameext%.
    if not defined nopauseerror (
        echo.
        echo Read error above and resolve issue then try again.
        echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        echo.
        pause
        echo.
        set errorsuspendprocessing=true
    )
    if defined nopauseerror echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    color 07
) else (
    if defined echoafterspacepre echo.
    call :echolog %writecount% Created:   %nameext%

    if defined echoafterspacepost echo.
    echo ---------------------------------------------------------------- >>%projectlog%
    rem echo. >>%projectlog%
    if exist "%outfile%.pre.txt" del "%outfile%.pre.txt"
)
@rem @echo off
if defined masterdebug call :funcdebug %0 end
goto :eof

:nameext
:: Description: returns name and extension from a full drive:\path\filename
:: Class: command - parameter manipulation
:: Required parameters: 
:: drive:\path\name.ext or path\name.ext or name.ext
:: created variable:
:: nameext
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set nameext=%~nx1
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:ext
:: Description: returns file extension from a full drive:\path\filename
:: Class: command - parameter manipulation
:: Required parameters:
:: drive:\path\name.ext or path\name.ext or name.ext
:: created variable:
:: nameext
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set ext=%~x1
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:name
:: Description: Gets the name of a file (no extension) from a full drive:\path\filename
:: Class: command - parameter manipulation
:: Required parameters:
:: drive:\path\name.ext or path\name.ext or name.ext
:: Created variable:
:: name
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set name=%~n1
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:drivepath
:: Description: returns the drive and path from a full drive:\path\filename
:: Class: command - parameter manipulation
:: Required parameters:
:: Group type: parameter manipulation
:: drive:\path\name.ext or path\name.ext
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set drivepath=%~dp1
if defined echodrivepath echo %drivepath%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:file2uri
:: Description: transforms dos path to uri path. i.e. c:\path\file.ext to file:///c:/path/file.ext  not needed for XSLT
:: Class: command - parameter manipulation
:: Required parameters:  1
:: pathfile
:: Optional parameters:
:: number
:: created variables:
:: uri%number%
if defined masterdebug call :funcdebug %0
call :setvar pathfile "%~1"
set numb=%~2
set uri%numb%=file:///%pathfile:\=/%
set return=file:///%pathfile:\=/%
if defined echofile2uri call :echolog       uri%numb%=%return:~0,25% . . . %return:~-30%
if defined masterdebug call :funcdebug %0 end
goto :eof

:inccount
:: Description: iIncrements the count variable
:: Class: command - internal - parameter manipulation
:: Required preset variables:
:: space
:: count - on second and subsequent use
:: Optional preset variables:
:: count - on first use
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set /A count=%count%+1
set writecount=%count%
if %count% lss 10 set writecount=%space%%count%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:outputfile
:: Description: Copies last out file to new name. Used to make a static name other tasklists can use.
:: Class: command
:: Required preset variables:
:: outfile
:: Required parameters:
:: newfilename
:: Func calls:
:: inccount
:: drivepath
:: nameext
if defined errorsuspendprocessing goto :eof
if defined masterdebug call :funcdebug %0
call :inccount
set infile=%outfile%
set filename=%~1
call :drivepath "%filename%"
call :nameext "%filename%"
set outfile=%drivepath%%nameext%
set curcommand=copy /Y "%infile%" "%outfile%"
call :before off
%curcommand%
call :after "Copied "%infile%" to "%outfile%"
if defined masterdebug call :funcdebug %0 end
goto :eof

:pause
:: Description: Pauses work until user interaction
:: Class: command - user interaction
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
pause
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:debugpause
:: Description: Sets the debug pause to on
:: Class: command - debug
:: Optional Parameters:
:: changedebugpause
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
echo on
set changedebugpause=%~1
if defined debugpause (
  echo debugging pause
  pause
) else (
  if "%changedebugpause%" == "off" (
    set debugpause=
  ) else if defined changedebugpause (
    set debugpause=on
  )
)
echo off
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:plugin
:: Depreciated: not used. Just create a tasklist to cusmoize a new file-operator
:: Description: used to access external plugins
:: Class: command - external - extend
:: Optional preset variables:
:: outputdefault
:: Required parameters:
:: action
:: Optional parameters:
:: pluginsubtask
:: params
:: infile
:: outfile
:: Depends on:
:: infile
:: outfile
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
call :inccount
set plugin=%~1
set pluginsubtask=%~2
set params=%~3
rem if (%params%) neq (%params:'=%) set params=%params:'="%
if defined params set params=%params:'="%
call :infile "%~4"
call :outfile "%~5" "%outputdefault%"
set curcommand=call plugins\%plugin%
call :before
%curcommand%
call :after "%plugin% plugin complete"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:dirlist
:: Description: Creates a directory list in a file
:: Depreciated: not in current usage
:: Class: Command - external
:: Depends on:
:: dirpath
:: dirlist - a file path and name
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set dirpath=%~1
if not defined dirpath echo missing dirpath input & goto :eof
set dirlist=%~2
dir /b "%dirpath%" > "%dirlist%"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:infile
:: Description: If infile is specifically set then uses that else uses previous outfile.
:: Class: command - internal - pipeline - parameter
:: Required parameters:
:: testinfile
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set testinfile=%~1
if "%testinfile%" == "" (
set infile=%outfile%
) else (
set infile=%testinfile%
)
if not exist "%infile%" set missinginput=on
if exist "%infile%" set missinginput=
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:outfile
:: Description: If out file is specifically set then uses that else uses supplied name.
:: Class: command - internal - pipeline- parameter
:: Required parameters:
:: testoutfile
:: defaultoutfile
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set testoutfile=%~1
set defaultoutfile=%~2
if "%testoutfile%" == "" (
set outfile=%defaultoutfile%
) else (
set outfile=%testoutfile%
)
call :drivepath "%outfile%"
call :checkdir "%drivepath%"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:setdefaultoptions
:: Description: Sets default options if not specifically set
:: class: command - parameter - fallback
:: Required parameters:
:: testoption
:: defaultoption
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set testoption=%~1
set defaultoption=%~2
if "%testoption%" == "" (
  set options=%defaultoption%
) else (
set options=%testoption%
)
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:setvarlist
:: depreciated: use var
call :var "%~1" "%~2"
goto :eof

:resolve
:: depreciated: use var
call :var "%~1" "%~2"
goto :eof

:setvar
:: depreciated: use var
call :var "%~1" "%~2"
goto :eof


:var
:: Description: sets the variable
:: class: command - parameter
:: Required parameters:
:: varname
:: value
:: Added handling so that a third param called echo will echo the variable back.
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set varname=%~1
set value=%~2
set %varname%=%value%
if "%~3" == "echo" echo %varname%=%value%
if "%~3" == "required" (
  if "%value%" == "" echo Missing %varname% parameter & set fatalerror=on
)
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:xvar
:: Description: This is an XSLT only instruction to process a param, DOS variables not allowed in set.
:: Note: not used by this batch command. The xvar only creates an XSLT variable but not a DOS variable. Can be used when there are long variables intended for XSLT only.
goto :eof

:quoteinquote
:: Description: Resolves single quotes withing double quotes. Surrounding double quotes dissapea, singles be come doubles.
:: Class: command - internal - parameter manipulation
:: Required parameters:
:: varname
:: paramstring
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set varname=%~1
set paramstring=%~2
if defined paramstring set %varname%=%paramstring:'="%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:startfile
:: Depreciated: use inputfile
goto :eof

:inputfile
:: Description: Sets the starting file of a serial tasklist, by assigning it to the var outfile
:: Class: command - variable
:: Optional preset variables:
:: writebat
:: projectbat
:: Required parameters:
:: outfile
:: Added handling so that a preset var %writebat%, will cause the item to be written to a batch file
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set outfile=%~1
if not defined outfile echo missing outfile parameter & goto :eof
if "%writebat%" == "yes" echo set outfile=%~1 >>%projectbat%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


rem Loops ======================================================================

:serialtasks
:: Depeciated: use looptasks
call :looptasks "%~1" "%~2" "%~3"
goto :eof

:looptasks
:: Description: loop through tasks acording to %list%
:: Class: command
:: Optional preset variables:
:: list
:: comment
:: Required parameters:
:: tasklistfile
:: list
:: comment
:: Depends on:
:: funcdebug
:: tasklist
if defined masterdebug call :funcdebug %0
set tasklistfile=%~1
if not defined list set list=%~2
if not defined comment set comment=%~3
if not defined tasklistfile echo Missing tasklistfile parameter & goto :eof
if not defined list echo Missing list parameter & goto :eof
echo "%comment%"
FOR /F %%s IN (%list%) DO call :tasklist "%tasklistfile%" %%s
set list=
set comment=
echo =====^> end looptasks
if defined masterdebug call :funcdebug %0 end
goto :eof

:loop
:: Description: a general loop, review parametes before using, other dedcated loops may be easier to use.
:: Calss: command - loop
:: Required preset variables:
:: looptype - Can be any of these: string, listinfile or command
:: comment
:: string or file or command
:: function
:: Optional preset variables:
:: foroptions - eg "eol=; tokens=2,3* delims=, slip=10"
:: Depends on:
:: tasklist
:: * - Maybe any function but most likely a tasklist
if defined masterdebug call :funcdebug %0
if defined echoloopcomment echo "%comment%"
if "%looptype%" == "" echo looptype not defined, skipping this task& goto :eof
rem the command type may be used to process files from a command like: dir /b *.txt
if "%looptype%" == "command" set command=%command:'="%
if "%looptype%" == "command" (
      FOR /F %%s IN ('%command%') DO call :%function% "%%s"
)
rem the listinfile type may be used to process the lines of a file.
if "%looptype%" == "listinfilespaced" (
      FOR /F "%foroptions%" %%s IN (%file%) DO call :%function% "%%s" %%t %%u
)
rem the listinfile type may be used to process the lines of a file.
if "%looptype%" == "listinfile" (
      FOR /F "eol=# delims=" %%s IN (%file%) DO call :%function% "%%s"
)
rem the string type is used to process a space sepparated string.
if "%looptype%" == "string" (
      FOR /F "%foroptions%" %%s IN ("%string%") DO call :%function% "%%s"
)
rem clear function and tasklist variables in case of later use.
set function=
set tasks=
if defined masterdebug call :funcdebug %0 end
goto :eof

:loopcommand
:: Description: loops through a list created from a command like dir and passes that as a param to a tasklist.
:: Class: command - loop
:: Required parameters:
:: comment
:: list
:: action
:: Depends on:
:: funcdebug
:: * - Maybe any function but most likely a tasklist
:: Note: Either preset or command parameters can be used
if defined masterdebug call :funcdebug %0
if "%~1" neq "" set action=%~1
if "%~2" neq "" set list=%~2
if "%~3" neq "" set comment=%~3
if not defined action echo missing action parameter & goto :eof
if not defined list echo missing list parameter & goto :eof
echo "%comment%"
::echo on
FOR /F %%s IN ('%list%') DO call :%action% "%%s"
set action=
set list=
set comment=
if defined masterdebug call :funcdebug %0 end
goto :eof

:command2var
:: Description: creates a variable from the command line
:: Class: command - loop
:: Required parameters:
:: varname
:: command
:: comment
:: Depends on:
:: funcdebug
:: * - Maybe any function but most likely a tasklist
:: Note: Either preset or command parameters can be used
if defined masterdebug call :funcdebug %0
set commandline=%~1
set varname=%~2
set invalid=%~3
if not defined varname echo missing varname parameter & goto :eof
if not defined commandline echo missing list parameter & goto :eof
if defined comment echo %comment%
FOR /F %%s IN ('%commandline%') DO set %varname%=%%s
set varname=
set commandline=
set comment=
if "%varname%" == "%invalid%" echo invalid & set skip=on
if defined masterdebug call :funcdebug %0 end
goto :eof

:loopfileset
:: Description: Loops through a list of files supplied by a file.
:: Class: command - loop
:: Required parameters:
:: action
:: fileset
:: comment
:: Note: 
:: Either preset or command parameters can be used
:: Depends on:
:: funcdebug
:: * - Maybe any function but most likely a tasklist
if defined masterdebug call :funcdebug %0
set action=%~1
set fileset=%~2
set comment=%~3
if not defined action echo Missing action parameter & goto :eof
if not defined fileset echo Missing fileset parameter & goto :eof
if defined comment echo %comment%
FOR /F %%s IN (%fileset%) DO call :%action% %%s
if defined masterdebug call :funcdebug %0 end
goto :eof

:loopstring
:: Description: Loops through a list supplied in a string.
:: Class: command - loop
:: Required parameters:
:: action
:: string
:: comment
:: Note: 
:: Either preset or command parameters can be used
:: Depends on:
:: funcdebug
:: * - May be any function but a tasklist most likely
if defined masterdebug call :funcdebug %0
set action=%~1
set string=%~2
set comment=%~3
if not defined action echo Missing action parameter & goto :eof
if not defined string echo Missing string parameter & goto :eof
echo %comment%
::echo on
FOR /F "delims= " %%s IN ("%string%") DO call :%action% %%s& echo param %%s
rem clear variables
set action=
set string=
set comment=
if defined masterdebug call :funcdebug %0 end
goto :eof

:runloop
:: Description: run loop with parameters
:: Class: command - loop - depreciated
:: Depends on:
:: * - May be any loop type
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set looptype=%~1
set action=%~2
set string=%~3
set fileset=%~3
set list=%~3
set comment=%~4
set string=%string:'="%
call :%looptype%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:spinoffproject
:: Description: spinofff a project from whole build system
:: Class: command - condition
:: Required parameters:
:: Created: 2013-08-10
:: depreciated doing with tasks file
:: Depends on:
:: xslt
:: joinfile
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set copytext=%projectpath%\logs\copyresources*.txt
set copybat=%projectpath%\logs\copyresources.cmd
if exist "%copytext%" del "%copytext%"
if exist "%copybat%" del "%copybat%"
echo :: vimod-spinoff-project generated file>>"%copybat%"
if "%~1" == "" (
set outpath=C:\vimod-spinoff-project
) else (
set outpath=%~1
)
if "%~2" neq "" set projectpath=%~2

dir /a-d/b "%projectpath%\*.*">"%projectpath%\logs\files.txt"
call :xslt vimod-spinoff-project "projectpath='%projectpath%' outpath='%outpath%' projfilelist='%projectpath%\logs\files.txt'" scripts/xslt/blank.xml "%projectpath%\logs\spin-off-project-report.txt"
FOR /L %%n IN (0,1,100) DO call :joinfile %%n
if exist "%copybat%" call "%copybat%"
::call :command xcopy "'%projectpath%\*.*' '%outpath%"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof



:ifexist
:: Description: Tests if file exists and takes prescribed if it does
:: Class: command - condition
:: Required parameters: 2-3
:: testfile
:: action - xcopy, copy, move, rename, del, command, tasklist, func or fatal
:: Optional parameters:
:: param3 - a multi use param
:: param4 - a multi use param resolves internal single quotes to double quotes
:: Depends on:
:: funcdebug
:: nameext
:: command
:: tasklist
:: * - maybe any function
if defined masterdebug call :funcdebug %0
set testfile=%~1
set action=%~2
set param3=%~3
set param4=%~4
set param5=%~5
set param6=%~6
if not defined testfile echo missing testfile parameter & goto :eof
if not defined action echo missing action parameter & goto :eof
rem if defined param4 set param4=%param4:'="%

call :nameext "%~1"

if exist "%testfile%" (
  rem say what will happen
  if "%action%" == "xcopy" echo %action% %param4% "%testfile%" "%param3%"
  if "%action%" == "copy" echo %action% %param4% "%testfile%" "%param3%"
  if "%action%" == "move" echo %action% %param4% "%testfile%" "%param3%"
  if "%action%" == "rename" echo %action% "%testfile%" "%param3%"
  if "%action%" == "del" echo %action% %param4% "%testfile%"
  rem if "%action%" == "func" echo call :%param3% "%param4%"
  if "%action%" == "command" echo call :command "%param3%" "%param4%"  "%param5%"
  if "%action%" == "command2file" echo call :command2file "%param3%" "%param4%" "%param5%" "%param6%"
  if "%action%" == "tasklist" echo call :tasklist "%param3%" "%param4%"
  if "%action%" == "append" echo copy "%param3%"+"%testfile%" "%param3%"
  if "%action%" == "appendtext" echo copy /A "%param3%"+"%testfile%" "%param3%"
  if "%action%" == "appendbin" echo copy /b "%param3%"+"%testfile%" "%param3%"
  rem if "%action%" == "addtext" echo  echo %param3% ^>^> "%param4%"
  if "%action%" == "type" echo type "%testfile%" ^>^> "%param3%"
  if "%action%" == "emptyfile" echo echo. ^> "%testfile%"
  rem now do what was said
  if "%action%" == "xcopy"  %action% %param4% "%testfile%" "%param3%"
  if "%action%" == "copy" %action% %param4% "%testfile%" "%param3%" "%param5%"
  if "%action%" == "move" %action% %param4% "%testfile%" "%param3%"
  if "%action%" == "rename" %action% "%testfile%" "%param3%"
  if "%action%" == "del" %action% /Q "%testfile%"
  rem if "%action%" == "func" call :%param3% "%param4%"
  if "%action%" == "command" call :command "%param3%" "%param4%"  "%param5%"
  if "%action%" == "command2file" call :command2file "%param3%" "%param4%" "%param5%" "%param6%"
  if "%action%" == "tasklist" call :tasklist "%param3%" "%param4%"
  if "%action%" == "append" copy "%param3%"+"%testfile%" "%param3%"
  if "%action%" == "appendtext" copy /A "%param3%"+"%testfile%" /A "%param3%" /A
  if "%action%" == "append" copy /b "%param3%"+"%testfile%" /b "%param3%" /b
  rem if "%action%" == "addtext" echo %param3% >> "%param4%"
  if "%action%" == "type" type "%testfile%" >> "%param3%"
  if "%action%" == "emptyfile" echo.  > "%testfile%"
  if "%action%" == "fatal" (
    call :echolog "File not found! %message%"
    echo %message%
    echo The script will end.
    echo.
    pause
    goto :eof
  )
) else (
  echo "%testfile%" was not found to %action%
)
if defined masterdebug call :funcdebug %0 end
goto :eof

:ifnotexist
:: Description: If a file or folder do not exist, then performs an action.
:: Required parameters:
:: testfile
:: action - xcopy, copy, del, call, command, tasklist, func or fatal
:: param3
:: Optional parameters:
:: param4
:: Depends on:
:: funcdebug
:: echolog
:: command
:: tasklist
:: * - Any function
:: Usage 
:: ;ifnotexist testfile copy infileif [switches]
:: ;ifnotexist testfile xcopy infileif [switches]
:: ;ifnotexist testfile del infileif [switches]
:: ;ifnotexist testfile tasklist param3 param4
if defined masterdebug call :funcdebug %0
set testfile=%~1
set action=%~2
set param3=%~3
set param4=%~4
set param5=%~5
if not defined testfile echo missing testfile parameter & goto :eof
if not defined action echo missing action parameter & goto :eof
if defined param4 set param4=%param4:'="%
if not exist  "%testfile%" (
  if "%action%" == "xcopy" call :echolog "File not found! %testfile%"    & %action% %param4% "%param3%" "%testfile%"
  if "%action%" == "copy" call :echolog "File not found! %testfile%"     & %action% %param4% "%param3%" "%testfile%"
  if "%action%" == "resources" call :echolog "File not found! %testfile%"     & xcopy /e/y "resources\%param3%" "%param4%"
  if "%action%" == "del" call :echolog "File not found! %testfile%"      & %action% %param4% "%param3%"
  if "%action%" == "report" call :echolog "File not found! %testfile% - %param3%"
  if "%action%" == "recover" call :echolog "File not found! %testfile% - %param3%"  & goto :eof
  if "%action%" == "command" call :echolog "File not found! %testfile%"  & call :command "%param3%" "%param4%"
  if "%action%" == "tasklist" call :echolog "File not found! %testfile%" & call :tasklist "%param3%" "%param4%"
  if "%action%" == "func" call :echolog "File not found! %testfile%"     & call :%param3% "%param4%" "%param5%"
  if "%action%" == "createfile" call :echolog "File not found! %testfile%" Create empty file.    & echo. > "%testfile%"
  if "%action%" == "fatal" (
  call :echolog "File not found! %message%"
  echo %message%
  echo The script will end.
  echo.
  pause
  goto :eof
  )

)
if defined masterdebug call :funcdebug %0 end
goto :eof

:echo
:: Description: generic handling echo
:: Modified: 2016-05-05
:: Class: command - internal
:: Possible required preset parameters:
:: projectlog
:: Required parameters:
:: echotask or message
:: Optional parameters:
:: message
:: add2file
:: Depends on:
:: funcdebug
if defined masterdebug call :funcdebug %0
set echotask=%~1
if not defined echotask echo Missing echotask parameter & goto :eof
set message=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9
if '%echotask%' == 'on' (
  @echo on
) else if '%echotask%' == 'off' (
  @echo off
) else if '%echotask%' == 'add2file' (
  @echo %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9 >> "%add2file%"
) else if '%echotask%' == 'log' (
  if defined echoecholog echo %message%
  echo %curdate%T%time% >>%projectlog%
  echo %message% >>%projectlog%
  set message=                
) else if '%echotask%' == '.' (
  echo.
) else (
  echo %message%
)
if defined masterdebug call :funcdebug %0 end
goto :eof

:echolog
:: Description: echoes a message to log file and to screen
:: Class: command - internal
:: Required preset variables:
:: projectlog
:: Required parameters:
:: message
:: Depends on:
:: funcdebug
if defined masterdebug call :funcdebug %0
set message=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9
if defined echoecholog echo %message%
echo %curdate%T%time% >>%projectlog%
echo %message% >>%projectlog%
set message=
if defined masterdebug call :funcdebug %0 end
goto :eof



:userinputvar
:: Description: provides method to interactively input a variable
:: Class: command - interactive
:: Required parameters:
:: varname
:: question
:: Depends on:
:: funcdebug
if defined masterdebug call :funcdebug %0
set varname=%~1
set question=%~2
set /P %varname%=%question%:
if defined masterdebug call :funcdebug %0 end
goto :eof



::copyresources now in ifnotexist


::copyresourcesifneeded now in ifnotexist


:requiredparam
:: Description: Ensure parameter is present
:: Required parameters:
:: 
goto :eof


:variableslist
:: Description: Handles variables list supplied in a file.
:: Class: command - loop
:: Optional preset variables:
:: selvalue - used to set a value equals itself ie set ccw32=ccw32 from just ccw32. Used for path tools
:: echovariableslist
:: echoeachvariablelistitem
:: Required parameters:
:: list - a filename with name=value on each line of the file
:: checktype - for use with ifnotexist
:: Depends on:
:: drivepath
:: nameext
:: ifnotexist
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
if defined echovariableslist echo ==== Processing variable list %~1 ====
set list=%~1
set checktype=%~2
rem make sure testvalue is not set
set testvalue=
FOR /F "eol=# delims== tokens=1,2" %%s IN (%list%) DO (
    set name=
    set val=
    rem selfvalue is set to let a value equal itself like in user_path_installed.tools
    if not defined selfvalue (
      set %%s=%%t
    ) else (
      set %%s=%%s
    )
    if defined echoeachvariablelistitem echo %%s=%%t
    if defined checktype (
        call :drivepath %%t
        rem the following tests if the value is a path
        if "%drivepath%" neq "%cd%" (
            rem seems redundant call :nameext %%t
            call :ifnotexist "%%t" %checktype% "%nameext% tool not found in %drivepath%."
            )
        )
    )
if defined selfvalue set selfvalue=
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:appendtofile
:: Description: Func to append text to a file or append text from another file
:: Class: command
:: Optional predefined variables:
:: newfile
:: Required parameters:
:: file
:: text
:: quotes
:: filetotype
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set file=%~1
if not defined file echo file parameter not supplied &goto :eof
set text=%~2
set quotes=%~3
set filetotype=%~5
if not defined newfile set newfile=%~4
if defined quotes set text=%text:'="%
if not defined filetotype (
  if defined newfile (
    echo %text%>%file%
  ) else (
    echo %text%>>%file%
  )
) else (
  if defined newfile (
    type "%filetotype%" > %file%
  ) else (
    type "%filetotype%" >> %file%
  )
)
set newfile=
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

rem UI and Debugging functions ========================================================

:writeuifeedback
:: Description: Produce a menu from a list to allow the user to change default list settings
:: Class: command - internal - menu
:: Usage: call :writeuifeedback list [skiplines]
:: Required parameters:
:: list
:: Optional parameters:
:: skiplines
:: Depends on:
:: menuwriteoption
rem echo on
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set list=%~1
set skiplines=%~2
if not defined skiplines set skiplines=1
FOR /F "eol=# tokens=1 skip=%skiplines% delims==" %%i in (%list%) do (
    if defined %%i (
          set action=var %%i
          call :menuwriteoption "ON  - Turn off %%i?"
    ) else (
          set action=var %%i on
          call :menuwriteoption "    - Turn on  %%i?"
    )
)
rem echo off
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:funcdebug
:: Description: Debug function run at the start of a function
:: Class: command - internal - debug
:: Required parameters:
:: entryfunc
@echo off
@if defined debugfuncdebug @echo on
set entryfunc=%~1
set debugend=%~2
if not defined entryfunc echo entryfunc is missing, skipping this function & goto :eof
set testfunc=debug%entryfunc:~1%
if "%debugend%" == "end" (
  set debugstack=%debugstack:~1%
  set nextdebug=%debugstack:~0,1%
  if defined masterdebug @echo %endfuncstring% %~1 %debugstack%
  if '%nextdebug%' == '1' (@echo on) else (@echo off)
) else (
  if defined %testfunc% set debugstack=1%debugstack%
  if not defined %testfunc% set debugstack=0%debugstack%
  if defined masterdebug @echo %beginfuncstring% %~1  %debugstack% %beginfuncstringtail%
  if "%debugstack:~0,1%" == "1" (@echo on) else (@echo off)
)
goto :eof


:removeCommonAtStart
:: Depreciated: probably not needed
:: Description: loops through two strings and sets new variable representing unique data
:: Class: command - internal
:: Required parameters:
:: name - name of the variable to be returned
:: test - string to have common data removed from start
:: Optional parameters:
:: remove - string if not defined then use %cd% as string.
:: Depends on:
:: removelet
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set name=%~1
set test=%~2
set remove=%~3
if not defined remove set remove=%cd%
set endmatch=
FOR /L %%l IN (0,1,100) DO if not defined notequal (
      call :removelet
      ) else (
      goto :eof
      )
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:removelet
:: Depreciated: probably not needed
:: Description: called by removeCommonAtStart to remove one letter from the start of two string variables
:: Class: command - internal
:: Required preset variables:
:: test
:: remove
:: name
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set test=%test:~1%
set %name%=%test:~1%
set remove=%remove:~1%
if "%test:~0,1%" neq "%remove:~0,1%" set notequal=on&goto :eof
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:getline
:: Description: Get a specific line from a file
:: Class: command - internal
:: Required parameters:
:: linetoget
:: file
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
if defined echogetline echo on
set linetoget=%~1
set file=%~2
if not defined linetoget echo missing linetoget parameter & goto :eof
if not defined file echo missing file parameter & goto :eof
set /A count=%~1-1
if "%count%" == "0" (
    for /f %%i in (%~2) do (
        set getline=%%i
        goto :eof
    )
) else (
    for /f "skip=%count% " %%i in (%~2) do (
        set getline=%%i
        goto :eof
    )
)
@echo off
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:ifdefined
:: Description: conditional based on defined variable
:: Class: command - condition
:: Required parameters:
:: test
:: func
:: funcparams - up to 7 aditional
:: Depends on:
:: tasklist
:: Depends on:
:: * - Maybe any function but likely tasklist
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set test=%~1
set func=%~2
if not defined test echo missing test parameter & goto :eof
if not defined func echo missing func parameter & goto :eof
set func=%func:'="%
set funcparams=%~3
if defined funcparams set funcparams=%funcparams:'="%
if defined %test% call :%func% %funcparams%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:ifnotdefined
:: Description: non-conditional based on defined variable
:: Class: command - condition
:: Required parameters:
:: test
:: func
:: Optional parametes:
:: funcparams
:: Depends on:
:: * - Maybe any function but likely tasklist
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set test=%~1
set func=%~2
set funcparams=%~3
if not defined test echo missing test parameter & goto :eof
if not defined func echo missing func parameter & goto :eof
if defined funcparams set funcparams=%funcparams:'="%
if not defined %test% call :%func% %funcparams%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:ifequal
:: Description: to do something on the basis of two items being equal
:: Required Parameters:
:: equal1
:: equal2
:: func
:: params
:: Depends on:
:: * - Maybe any function but likely tasklist
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set equal1=%~1
set equal2=%~2
set func=%~3
set funcparams=%~4
if not defined equal1 echo missing equal1 parameter & goto :eof
if not defined equal2 echo missing equal2 parameter & goto :eof
if not defined func echo missing func parameter & goto :eof
if defined funcparams set funcparams=%funcparams:'="%
if "%equal1%" == "%equal2%" call :%func% %funcparams%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:ifnotequal
:: Description: to do something on the basis of two items being equal
:: Required Parameters:
:: equal1
:: equal2
:: func
:: funcparams
:: Depends on:
:: * - Maybe any function but likely tasklist
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set equal1=%~1
set equal2=%~2
set func=%~3
set funcparams=%~4
if not defined equal1 echo missing equal1 parameter & goto :eof
if not defined equal2 echo missing equal2 parameter & goto :eof
if not defined func echo missing func parameter & goto :eof
if defined funcparams set funcparams=%funcparams:'="%
if "%equal1%" neq "%equal2%" call :%func% %funcparams%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof



rem shift
rem shift
rem set extraparam=
rem if ""%~1""=="""" goto :ifNotDefinedDoneStart
rem set extraparam='%~1'
rem shift
rem :ifNotDefinedArgs
rem if ""%1""=="""" goto :ifNotDefinedDoneStart
rem set extraparam=%extraparam% '%1'
rem shift
rem goto :ifNotdefinedArgs
rem :ifNotDefinedDoneStart
rem set extraparam=%extraparam:'="%

:externalfunctions
:: Depreciated: can't find usage
:: Description: non-conditional based on defined variable
:: Class: command - extend - external
:: Required parameters:
:: extcmd
:: function
:: params
:: Depends on:
:: inccount
:: infile
:: outfile
:: before
:: after
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
call :inccount
set extcmd=%~1
if not defined extcmd echo Missing extcmd parameter & goto :eof
set function=%~2
set params=%~3
call :infile "%~4"
call :outfile "%~5" "%outputdefault%"
set curcommand=call %extcmd% %function% "%params%" "%infile%" "%outfile%"
call :before
%curcommand%
call :after "externalfunctions %function% complete"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:loopdir
:: Description: Loops through all files in a directory
:: Class: command - loop
:: Required parameters:
:: action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks
:: extension
:: comment
:: Depends on:
:: * - May be any function but probably tasklist
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set action=%~1
set basedir=%~2
set comment=%~3
if not defined action echo Missing action parameter & goto :eof
if not defined basedir echo Missing basedir parameter & goto :eof
if defined comment echo %comment%
FOR /F " delims=" %%s IN ('dir /b /a:-d %basedir%') DO call :%action% "%%s"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:loopfiles
:: Description: Used to loop through a subset of files specified by the filespec from a single directory
:: Class:  command - loop
:: Required parameters:
:: action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks
:: filespec
:: Optional parameters:
:: comment
:: Depends on:
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set action=%~1
set filespec=%~2
set comment=%~3
if not defined action echo Missing action parameter & goto :eof
if not defined filespec echo Missing filespec parameter & goto :eof
if defined comment echo %comment%
FOR /F " delims=" %%s IN ('dir /b /a:-d /o:n %filespec%') DO call :%action% "%%s"
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:command2file
:: Description: Used with commands that only give stdout, so they can be captued in a file.
:: Class: command - dos - to file
:: Required parameters:
:: command
:: outfile
:: Optional parameters:
:: commandpath
:: Depends on:
:: inccount
:: before
:: after
:: outfile
:: funcdebug
:: Note: This command does its own expansion of single quotes to double quotes so cannont be fed directly from a ifdefined or ifnotdefined. Instead define a task that is fired by the ifdefined.
if defined errorsuspendprocessing goto :eof
if defined masterdebug call :funcdebug %0
call :inccount
set command=%~1
set out=%~2
if not defined command echo missing command & goto :eof
call :outfile "%out%" "%projectpath%\xml\%pcode%-%count%-command2file.xml"
set commandpath=%~3
set append=%~4
rem the following is used for the feed back but not for the actual command
if not defined append (
  set curcommand=%command:'="% ^^^> "%outfile%"
) else (
  set curcommand=%command:'="% ^^^>^^^> "%outfile%"
)

call :before
set curcommand=%command:'="%
if "%commandpath%" neq "" (
  set startdir=%cd%
  set drive=%commandpath:~0,2%
  %drive%
  cd "%commandpath%"
)
if not defined append (
  call %curcommand% > "%outfile%"
) else (
  call %curcommand% >> "%outfile%"
)

if "%commandpath%" neq "" (
  set drive=%startdir:~0,2%
  %drive%
  cd "%startdir%"
  set dive=
)
call :after "command with stdout %curcommand% complete"
if defined masterdebug call :funcdebug %0 end
goto :eof


:donothing
:: Description: Do nothing
goto :eof

:xvarset
:: Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
:: Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
goto :eof

:xinclude
:: Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
:: Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
goto :eof

:xarray
:: Description: This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set.
:: Note: not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line.
rem xarray param is a file
goto :eof

:menublank
:: Description: used to create a blank line in a menu and if supplied a sub menu title
:: Optional parameters:
:: blanktitle
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
  echo.
  if defined blanktitle echo           %blanktitle%
  if defined blanktitle echo.
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof



:getfiledatetime
:: Description: Returns a variable with a files modification date and time in yyMMddhhmm  similar to setdatetime. Note 4 digit year makes comparison number too big for batch to handle.
:: Revised: 2016-05-04
:: Classs: command - internal - date -time
:: Required parameters:
:: varname
:: file
:: Depends on:
:: ampmhour
rem echo on
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set varname=%~1
if not defined varname echo missing varname parameter & goto :eof
set file=%~2
if not exist "%file%" set %varname%=0 &goto :eof
set filedate=%~t2
rem got and mofified this from: http://www.robvanderwoude.com/datetiment.php#IDate
FOR /F "tokens=1-6 delims=:%dateseparator% " %%A IN ("%~t2") DO (
  IF "%dateformat%"=="0" (
      SET fdd=%%B
      SET fmm=%%A
      SET fyyyy=%%C
  )
  IF "%dateformat%"=="1" (
      SET fdd=%%A
      SET fmm=%%B
      SET fyyyy=%%C
  )
  IF "%dateformat%"=="2" (
      SET fdd=%%C
      SET fmm=%%B
      SET fyyyy=%%A
  )
  set fnn=%%E
  call :ampmhour %%F %%D
)
set %varname%=%fyyyy:~2%%fMM%%fdd%%fhh%%fnn%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:ampmhour
:: Description: Converts AM/PM time to 24hour format. Also splits
:: Created: 2016-05-04 
:: Used by: getfiledatetime 
:: Required parameters:
:: ampm
:: thh
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set ampm=%~1
set thh=%~2
if "%ampm%" == "AM" (
  if "%thh%" == "12" (
    set fhh=00
  ) else (
    set fhh=%thh%
  )
) else if "%ampm%" == "PM" (
  if "%thh%" == "12" (
    set fhh=12
  ) else (
    rem added handling to prevent octal number error caused by leading zero
    if "%thh:~0,1%" == "0" set /A fhh=%thh:~-1%+12
    if "%thh:~0,1%" neq "0" set /A fhh=%thh%+12
  )
) else  (
  set fhh=%thh%
)
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:encoding
:: Description: to check the encoding of a file
:: Created: 2016-05-17
:: Required parameters:
:: file
:: activity = validate or check
:: Optional parameters:
:: validateagainst
:: Depends on:
:: infile
:: nameext
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
if not defined encodingchecker echo Encoding not checked. &goto :eof
if not exist "%encodingchecker%" echo file.exe not found! %fileext% &echo Encoding not checked. & goto :eof
set testfile=%~1
set activity=%~2
set validateagainst=%~3
call :infile "%testfile%"
call :nameext "%infile%"
set command=%encodingchecker% -m %magic% --mime-encoding "%infile%"
FOR /F "tokens=1-2" %%A IN ('%command%') DO set fencoding=%%B

if "%activity%" == "validate" (
    if "%fencoding%" == "%validateagainst%"  (
        echo Encoding is %fencoding% for file %nameext%.
      ) else if "%fencoding%" == "us-ascii" (
        echo Encoding is %fencoding% not %validateagainst% but is usable.
      ) else (
      echo File %nameext% encoding is invalid! 
      echo Encoding found to be %fencoding%! But it was expected to be %validateagainst%.
      set errorsuspendprocessing=on
  )
) else  (              
    echo Encoding is: %fencoding% for file %nameext%.
) 
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:time
:: Description: Retrieve time in several shorter formats than %time% provides
:: Created: 2016-05-05
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
FOR /F "tokens=1-4 delims=:%timeseparator%." %%A IN ("%time%") DO (
  set curhhmm=%%A%%B
  set curhhmmss=%%A%%B%%C
  set curhh_mm=%%A:%%B
  set curhh_mm_ss=%%A:%%B:%%C
)
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:date
:: Description: Returns multiple variables with date in three formats, the year in wo formats, month and day date.
:: Revised: 2016-05-04
:: Classs: command - internal - date -time
:: Required preset variables:
:: dateformat
:: dateseparator
rem got this from: http://www.robvanderwoude.com/datetiment.php#IDate
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
FOR /F "tokens=1-4 delims=%dateseparator% " %%A IN ("%date%") DO (
    IF "%dateformat%"=="0" (
        SET fdd=%%C
        SET fmm=%%B
        SET fyyyy=%%D
    )
    IF "%dateformat%"=="1" (
        SET fdd=%%B
        SET fmm=%%C
        SET fyyyy=%%D
    )
    IF "%dateformat%"=="2" (
        SET fdd=%%D
        SET fmm=%%C
        SET fyyyy=%%B
    )
)
set curdate=%fyyyy%-%fmm%-%fdd%
set curisodate=%fyyyy%-%fmm%-%fdd%
set curyyyymmdd=%fyyyy%%fmm%%fdd%
set curyymmdd=%fyyyy:~2%%fmm%%fdd%
set curUSdate=%fmm%/%fdd%/%fyyyy%
set curAUdate=%fdd%/%fmm%/%fyyyy%
set curyyyy=%fyyyy%
set curyy=%fyyyy:~2%
set curmm=%fmm%
set curdd=%fdd%
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:html2xml
:: Description: Convert HTML to xml for post processing as xml. it removes the doctype header.
:: Required external program: HTML Tidy in variable %tidy5%
:: Required parameters:
:: infile
:: Optional Parameters:
:: outfile
:: Depends on:
:: infile
:: outfile
:: before
:: after
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
call :infile "%~1"
if defined missinginput echo missing input file & goto :eof
call :outfile "%~2"
set curcommand=call xml fo -H -D "%infile%"
rem set curcommand=call "%tidy5%" -o "%outfile%" "%infile%"
call :before
%curcommand% > "%outfile%"
call :after
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof


:lookup
:: Description: Lookup a value in a file before the = and get value after the =
:: Required parameters:
:: findval
:: datafile
rem if defined skip goto :eof
if defined masterdebug call :funcdebug %0
SET findval=%~1
set datafile=%~2
set lookupreturn=
FOR /F "tokens=1-2" %%i IN (%datafile%) DO IF "%%i" EQU "%findval%" SET lookupreturn=%%j
@echo lookup of %findval% returned: %lookupreturn%
if defined masterdebug call :funcdebug %0 end
goto :eof

:start
:: Description: Start a file in the default program or supply the program and file
:: Required parameters:
:: var1
:: Optional parameters:
:: var2
:: var3
:: var4
if defined debugdefinefunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set var1=%~1
set var2=%~2
set var3=%~3
set var4=%~4
if defined var1 (
  if "%var1%" == "%var1: =%" (
   start "%var1%" "%var2%" "%var3%" "%var4%"
  ) else (
   start "" "%var1%" "%var2%" "%var3%" "%var4%"
  )
) else (
  start "%var1%" "%var2%" "%var3%" "%var4%"
)
if defined debugdefinefunc echo %endfuncstring% %0 %debugstack%
goto :eof

:checkifvimodfolder
:: Description: set the variable skipwriting so that the calling function does not write a menu line.
:: Used by: menu
:: Optional preset variables:
:: echomenuskipping
:: Required parameters:
:: project
if defined debugmenufunc echo %beginfuncstring% %0 %debugstack% %beginfuncstringtail%
set project=%~1
set skipwriting=

if "%project%" == "%projectsetupfolder%" (
    if defined echomenuskipping echo skipping dir: %project%
    set skipwriting=on
)
if "%project%" == "xml" (
    if defined echomenuskipping echo skipping dir: %project%
    set skipwriting=on
)
if "%project%" == "logs" (
    if defined echomenuskipping echo skipping dir: %project%
    set skipwriting=on
)
if defined debugmenufunc echo %endfuncstring% %0 %debugstack%
goto :eof

