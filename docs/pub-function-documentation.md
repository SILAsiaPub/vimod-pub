# Vimod-Pub Commands Documentation

---

## Main Vimod-Pub repository

* [Vimod-Pub][0]

## Projects using Vimod-Pub

* [Vimod-Pub creating Bible concordance PDF via PrinceXML][1]
* [Vimod-Pub SFM dictionary to PDF via PrinceXML][2]
* [Vimod-Pub SFM dictionary to Web pages][3]
* [Vimod-Pub generate a book by book report of USFM markers from USX][4]
* [Vimod-Pub demo email][5]

## Command Index 

* [aainfo][6]
* [after][7]
* [ampmhour][8]
* [appendtofile][9]
* [before][10]
* [cct][11]
* [checkdir][12]
* [checkifvimodfolder][13]
* [command][14]
* [command2file][15]
* [commonmenu][16]
* [copy][17]
* [date][18]
* [debugpause][19]
* [dirlist][20]
* [donothing][21]
* [drivepath][22]
* [echo][23]
* [echolog][24]
* [encoding][25]
* [ext][26]
* [externalfunctions][27]
* [file2uri][28]
* [funcdebug][29]
* [getfiledatetime][30]
* [getline][31]
* [html2xml][32]
* [ifdefined][33]
* [ifequal][34]
* [ifexist][35]
* [ifnotdefined][36]
* [ifnotequal][37]
* [ifnotexist][38]
* [inc][39]
* [inccount][40]
* [infile][41]
* [inputfile][42]
* [lookup][43]
* [loop][44]
* [loopcommand][45]
* [loopdir][46]
* [loopfiles][47]
* [loopfileset][48]
* [loopstring][49]
* [looptasks][50]
* [main ][51]
* [manyparam][52]
* [manyparamcmd][53]
* [md5compare][54]
* [md5create][55]
* [menu][56]
* [menublank][57]
* [menueval][58]
* [menuvaluechooser][59]
* [menuvaluechooserevaluation][60]
* [menuvaluechooseroptions][61]
* [menuwriteoption][62]
* [name][63]
* [nameext][64]
* [outfile][65]
* [outputfile][66]
* [pause][67]
* [plugin][68]
* [projectvar][69]
* [projectxslt][70]
* [quoteinquote][71]
* [removeCommonAtStart][72]
* [removelet][73]
* [requiredparam][74]
* [resolve][75]
* [runloop][76]
* [serialtasks][77]
* [setdefaultoptions][78]
* [setup][79]
* [setvar][80]
* [setvarlist][81]
* [spaceremove][82]
* [spinoffproject][83]
* [start][84]
* [startfile][85]
* [tasklist][86]
* [testjava][87]
* [time][88]
* [userinputvar][89]
* [validatevar][90]
* [var][91]
* [variableslist][92]
* [writeuifeedback][93]
* [xarray][94]
* [xinclude][95]
* [xquery][96]
* [xslt][97]
* [xvarset][98]

## aainfo [^^][99]

**Title**

> pub.cmd 

**Title Description**

> Vimod-Pub batch file with menus and tasklist processing 

**Author**

> Ian McQuay 

**Created**

> 2012-03 

**Last Modified**

> 2016-010-12 

**Source**

> https://github.com/silasiapub/vimod-pub 

**Commandline startup options**

> pub - normal usage for menu starting at the data root. 

> pub tasklist tasklistname.tasks - process a particular tasklist, no menus used. Used with Electron Vimod-Pub GUI 

> pub menu menupath - Start projet.menu at a particular path 

> pub debug function\_name - Just run a particular function to debug 

## after [^^][100]

**Description**

> Checks if outfile is created. Reports failures logs actions. Restors previous output file on failure. 

**Class**

> command - internal 

**Required preset variables**

> outfile 

> projectlog 

> writecount 

**Optional parameters**

> report3 

> message 

**Func calls**

> nameext 

## ampmhour [^^][101]

**Description**

> Converts AM/PM time to 24hour format. Also splits 

**Created**

> 2016-05-04 

**Used by**

> getfiledatetime 

**Required parameters**

> ampm 

> thh 

## appendtofile [^^][102]

**Description**

> Func to append text to a file or append text from another file 

**Class**

> command 

**Optional predefined variables**

> newfile 

**Required parameters**

> file 

> text 

> quotes 

> filetotype 

## before [^^][103]

**Description**

> Checks if outfile exists, renames it if it does. Logs actions. 

**Class**

> command - internal 

**Required preset variables**

> projectlog 

> projectbat 

> curcommand 

**Optional preset variables**

> outfile 

> curcommand 

> writebat 

**Optional variables**

> echooff 

**Func calls**

> 

> funcdebugstart 

> funcdebugend 

> nameext 

## cct [^^][104]

**Description**

> Privides interface to CCW32\. 

**Required preset variables**

> ccw32 

**Optional preset variables**

**Required parameters**

> script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc" 

**Optional parameters**

> infile 

> outfile 

**Depends on**

> infile 

> outfile 

> inccount 

> before 

> after 

## checkdir [^^][105]

**Description**

> checks if dir exists if not it is created 

**See also**

> ifnotexist 

**Required preset variabes**

> projectlog 

**Optional preset variables**

> echodirnotfound 

**Required parameters**

> dir 

**Depends on**

> funcdebugstart 

> funcdebugend 

## checkifvimodfolder [^^][106]

**Description**

> set the variable skipwriting so that the calling function does not write a menu line. 

**Used by**

> menu 

**Optional preset variables**

> echomenuskipping 

**Required parameters**

> project 

## command [^^][107]

**Description**

> A way of passing any commnand from a tasklist. It does not use infile and outfile. 

**Usage**

> call :usercommand "copy /y 'c:\\patha\\file.txt' 'c:\\pathb\\file.txt'" \["path to run command in" "output file to test for"\] 

**Limitations**

> When command line needs single quote. 

**Required parameters**

> curcommand 

**Optional parameters**

> commandpath 

> testoutfile 

**Depends on**

> funcdebugstart 

> funcdebugend 

> inccount 

> echolog 

## command2file [^^][108]

**Description**

> Used with commands that only give stdout, so they can be captued in a file. 

**Class**

> command - dos - to file 

**Required parameters**

> command 

> outfile 

**Optional parameters**

> commandpath 

**Depends on**

> inccount 

> before 

> after 

> outfile 

> funcdebug 

**Note**

> This command does its own expansion of single quotes to double quotes so cannont be fed directly from a ifdefined or ifnotdefined. Instead define a task that is fired by the ifdefined. 

## commonmenu [^^][109]

**Description**

> Will write menu lines from a menu file in the %commonmenufolder% folder 

**Class**

> command - menu 

**Used by**

> menu 

**Required parameters**

> commonmenu 

**Depends on**

> menuwriteoption 

## copy [^^][110]

**Description**

> Provides copying with exit on failure 

**Required preset variables**

> ccw32 

**Optional preset variables**

**Required parameters**

> script - can be one script.cct or serial comma separated "script1.cct,script2.cct,etc" 

**Optional parameters**

> infile 

> outfile 

> appendfile 

**Depends on**

> infile 

> outfile 

> inccount 

> before 

> after 

## date [^^][111]

**Description**

> Returns multiple variables with date in three formats, the year in wo formats, month and day date. 

**Revised**

> 2016-05-04 

**Classs**

> command - internal - date -time 

**Required preset variables**

> dateformat 

> dateseparator 

## debugpause [^^][112]

**Description**

> Sets the debug pause to on 

**Class**

> command - debug 

**Optional Parameters**

> changedebugpause 

## dirlist [^^][113]

**Description**

> Creates a directory list in a file 

**Depreciated**

> not in surrent usage 

**Class**

> Command - external 

**Depends on**

> dirpath 

> dirlist - a file path and name 

## donothing [^^][114]

**Description**

> Do nothing 

## drivepath [^^][115]

**Description**

> returns the drive and path from a full drive:\\path\\filename 

**Class**

> command - parameter manipulation 

**Required parameters**

**Group type**

> parameter manipulation 

**drive**

> \\path\\name.ext or path\\name.ext 

## echo [^^][116]

**Description**

> generic handling echo 

**Modified**

> 2016-05-05 

**Class**

> command - internal 

**Possible required preset parameters**

> projectlog 

**Required parameters**

> echotask or message 

**Optional parameters**

> message 

> add2file 

**Depends on**

> funcdebug 

## echolog [^^][117]

**Description**

> echoes a message to log file and to screen 

**Class**

> command - internal 

**Required preset variables**

> projectlog 

**Required parameters**

> message 

**Depends on**

> funcdebug 

## encoding [^^][118]

**Description**

> to check the encoding of a file 

**Created**

> 2016-05-17 

**Required parameters**

> activity = validate or check 

> file 

**Optional parameters**

> validateagainst 

**Depends on**

> infile 

> nameext 

## ext [^^][119]

**Description**

> returns file extension from a full drive:\\path\\filename 

**Class**

> command - parameter manipulation 

**Required parameters**

**drive**

> \\path\\name.ext or path\\name.ext or name.ext 

**created variable**

> nameext 

## externalfunctions [^^][120]

**Depreciated**

> can't find usage 

**Description**

> non-conditional based on defined variable 

**Class**

> command - extend - external 

**Required parameters**

> extcmd 

> function 

> params 

**Depends on**

> inccount 

> infile 

> outfile 

> before 

> after 

## file2uri [^^][121]

**Description**

> transforms dos path to uri path. i.e. c:\\path\\file.ext to file:///c:/path/file.ext not needed for XSLT 

**Class**

> command - parameter manipulation 

**Required parameters**

> 1 

> pathfile 

**Optional parameters**

> number 

**created variables**

> uri%number% 

## funcdebug [^^][122]

**Description**

> Debug function run at the start of a function 

**Class**

> command - internal - debug 

**Required parameters**

> entryfunc 

## getfiledatetime [^^][123]

**Description**

> Returns a variable with a files modification date and time in yyMMddhhmm similar to setdatetime. Note 4 digit year makes comparison number too big for batch to handle. 

**Revised**

> 2016-05-04 

**Classs**

> command - internal - date -time 

**Required parameters**

> varname 

> file 

**Depends on**

> ampmhour 

## getline [^^][124]

**Description**

> Get a specific line from a file 

**Class**

> command - internal 

**Required parameters**

> linetoget 

> file 

## html2xml [^^][125]

**Description**

> Convert HTML to xml for post processing as xml. it removes the doctype header. 

**Required external program**

> HTML Tidy in variable %tidy5% 

**Required parameters**

> infile 

**Optional Parameters**

> outfile 

**Depends on**

> infile 

> outfile 

> before 

> after 

## ifdefined [^^][126]

**Description**

> conditional based on defined variable 

**Class**

> command - condition 

**Required parameters**

> test 

> func 

> funcparams - up to 7 aditional 

**Depends on**

> tasklist 

**Depends on**

> \* - Maybe any function but likely tasklist 

## ifequal [^^][127]

**Description**

> to do something on the basis of two items being equal 

**Required Parameters**

> equal1 

> equal2 

> func 

> params 

**Depends on**

> \* - Maybe any function but likely tasklist 

## ifexist [^^][128]

**Description**

> Tests if file exists and takes prescribed if it does 

**Class**

> command - condition 

**Required parameters**

> 2-3 

> testfile 

> action - xcopy, copy, move, rename, del, command, tasklist, func or fatal 

**Optional parameters**

> param3 - a multi use param 

> param4 - a multi use param resolves internal single quotes to double quotes 

**Depends on**

> funcdebug 

> nameext 

> command 

> tasklist 

> \* - maybe any function 

## ifnotdefined [^^][129]

**Description**

> non-conditional based on defined variable 

**Class**

> command - condition 

**Required parameters**

> test 

> func 

**Optional parametes**

> funcparams 

**Depends on**

> \* - Maybe any function but likely tasklist 

## ifnotequal [^^][130]

**Description**

> to do something on the basis of two items being equal 

**Required Parameters**

> equal1 

> equal2 

> func 

> funcparams 

**Depends on**

> \* - Maybe any function but likely tasklist 

## ifnotexist [^^][131]

**Description**

> If a file or folder do not exist, then performs an action. 

**Required parameters**

> testfile 

> action - xcopy, copy, del, call, command, tasklist, func or fatal 

> param3 

**Optional parameters**

> param4 

**Depends on**

> funcdebug 

> echolog 

> command 

> tasklist 

> \* - Any function 

> Usage 

> ;ifnotexist testfile copy infileif \[switches\] 

> ;ifnotexist testfile xcopy infileif \[switches\] 

> ;ifnotexist testfile del infileif \[switches\] 

> ;ifnotexist testfile tasklist param3 param4 

## inc [^^][132]

> 

**Discription**

> Processes a tasks file. 

**Required preset variables**

> projectlog 

> setuppath 

> commontaskspath 

**Required parameters**

> tasklistname 

**Func calls**

> funcdebugstart 

> funcdebugend 

> nameext 

> \* - tasks from tasks file 

## inccount [^^][133]

**Description**

> iIncrements the count variable 

**Class**

> command - internal - parameter manipulation 

**Required preset variables**

> space 

> count - on second and subsequent use 

**Optional preset variables**

> count - on first use 

## infile [^^][134]

**Description**

> If infile is specifically set then uses that else uses previous outfile. 

**Class**

> command - internal - pipeline - parameter 

**Required parameters**

> testinfile 

## inputfile [^^][135]

**Description**

> Sets the starting file of a serial tasklist, by assigning it to the var outfile 

**Class**

> command - variable 

**Optional preset variables**

> writebat 

> projectbat 

**Required parameters**

> outfile 

> Added handling so that a preset var %writebat%, will cause the item to be written to a batch file 

## lookup [^^][136]

**Description**

> Lookup a value in a file before the = and get value after the = 

**Required parameters**

> findval 

> datafile 

## loop [^^][137]

**Description**

> a general loop, review parametes before using, other dedcated loops may be easier to use. 

**Calss**

> command - loop 

**Required preset variables**

**looptype - Can be any of these**

> string, listinfile or command 

> comment 

> string or file or command 

> function 

**Optional preset variables**

> foroptions - eg "eol=; tokens=2,3\* delims=, slip=10" 

**Depends on**

> tasklist 

> \* - Maybe any function but most likely a tasklist 

## loopcommand [^^][138]

**Description**

> loops through a list created from a command like dir and passes that as a param to a tasklist. 

**Class**

> command - loop 

**Required parameters**

> comment 

> list 

> action 

**Depends on**

> funcdebug 

> \* - Maybe any function but most likely a tasklist 

**Note**

> Either preset or command parameters can be used 

## loopdir [^^][139]

**Description**

> Loops through all files in a directory 

**Class**

> command - loop 

**Required parameters**

> action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks 

> extension 

> comment 

**Depends on**

> \* - May be any function but probably tasklist 

## loopfiles [^^][140]

**Description**

> Used to loop through a subset of files specified by the filespec from a single directory 

**Class**

> command - loop 

**Required parameters**

> action - can be any Vimod-Pub command like i.e. tasklist dothis.tasks 

> filespec 

**Optional parameters**

> comment 

**Depends on**

## loopfileset [^^][141]

**Description**

> Loops through a list of files supplied by a file. 

**Class**

> command - loop 

**Required parameters**

> action 

> fileset 

> comment 

**Note**

> 

> Either preset or command parameters can be used 

**Depends on**

> funcdebug 

> \* - Maybe any function but most likely a tasklist 

## loopstring [^^][142]

**Description**

> Loops through a list supplied in a string. 

**Class**

> command - loop 

**Required parameters**

> action 

> string 

> comment 

**Note**

> 

> Either preset or command parameters can be used 

**Depends on**

> funcdebug 

> \* - May be any function but a tasklist most likely 

## looptasks [^^][143]

**Description**

> loop through tasks acording to %list% 

**Class**

> command 

**Optional preset variables**

> list 

> comment 

**Required parameters**

> tasklistfile 

> list 

> comment 

**Depends on**

> funcdebug 

> tasklist 

## main  [^^][144]

**Description**

> Starting point of pub.cmd, test commandline options if present 

**Class**

> command - internal - startup 

**Optional parameters**

> projectpath or debugfunc - project path must contain a sub folder setup containing a project.menu or dubugfunc must be "debug" 

> functiontodebug 

> \* - more debug parameters 

**Depends on**

> setup 

> tasklist 

> menu 

> \* - In debug mode can call any function 

## manyparam [^^][145]

**Description**

> Allows spreading of long commands accross many line in a tasks file. Needed for wkhtmltopdf. 

**Class**

> command - exend 

**Required preset variables**

> first - set for all after the first of manyparam 

**Optional preset variables**

> first - Not required for first of a series 

**Required parameters**

> newparam 

## manyparamcmd [^^][146]

**Description**

> places the command before all the serial parameters Needed for wkhtmltopdf. 

**Class**

> command - exend 

**Required preset variables**

> param 

**Optional preset variables**

**Required parameters**

> command 

## md5compare [^^][147]

> no current use 

**Description**

> Compares the MD5 of the current project.tasks with the previous one, if different then the project.xslt is remade 

**Purpose**

> to see if the project.xslt needs remaking 

**Required preset variables**

> cd 

> projectpath 

**Depends on**

> md5create 

> getline 

## md5create [^^][148]

> no current use 

**Description**

> Make a md5 check file 

## menu [^^][149]

**Description**

> starts a menu 

**Revised**

> 2016-05-04 

**Class**

> command - menu 

**Required parameters**

> newmenulist 

> title 

> forceprojectpath 

**Depends on**

> funcdebug 

> ext 

> removeCommonAtStart 

> menuwriteoption 

> writeuifeedback 

> checkifvimodfolder 

> menu 

> menueval 

## menublank [^^][150]

**Description**

> used to create a blank line in a menu and if supplied a sub menu title 

**Optional parameters**

> blanktitle 

## menueval [^^][151]

**Description**

> resolves the users entered letter and starts the appropriate function 

> run through the choices to find a match then calls the selected option 

**Required preset variable**

> choice 

**Required parameters**

> let 

## menuvaluechooser [^^][152]

**Description**

> Will write menu lines from a menu file in the commonmenu folder 

**Class**

> command - internal - menu 

**Used by**

> menu 

**Required parameters**

> commonmenu 

**Depends on**

> menuvaluechooseroptions 

> menuvaluechooserevaluation 

> menuevaluation 

## menuvaluechooserevaluation [^^][153]

**Class**

> command - internal - menu 

## menuvaluechooseroptions [^^][154]

**Description**

> Processes the choices 

**Class**

> command - internal - menu 

## menuwriteoption [^^][155]

**Description**

> writes menu option to screen 

**Class**

> command - internal - menu 

**Required preset variable**

> letters 

> action 

**Required parameters**

> menuitem 

> checkfunc 

> submenu 

**Depends on**

> \* - Could call any function but most likely tasklist 

## name [^^][156]

**Description**

> Gets the name of a file (no extension) from a full drive:\\path\\filename 

**Class**

> command - parameter manipulation 

**Required parameters**

**drive**

> \\path\\name.ext or path\\name.ext or name.ext 

**Created variable**

> name 

## nameext [^^][157]

**Description**

> returns name and extension from a full drive:\\path\\filename 

**Class**

> command - parameter manipulation 

**Required parameters**

> 

**drive**

> \\path\\name.ext or path\\name.ext or name.ext 

**created variable**

> nameext 

## outfile [^^][158]

**Description**

> If out file is specifically set then uses that else uses supplied name. 

**Class**

> command - internal - pipeline- parameter 

**Required parameters**

> testoutfile 

> defaultoutfile 

## outputfile [^^][159]

**Description**

> Copies last out file to new name. Used to make a static name other tasklists can use. 

**Class**

> command 

**Required preset variables**

> outfile 

**Required parameters**

> newfilename 

**Func calls**

> inccount 

> drivepath 

> nameext 

## pause [^^][160]

**Description**

> Pauses work until user interaction 

**Class**

> command - user interaction 

## plugin [^^][161]

**Description**

> used to access external plugins 

**Class**

> command - external - extend 

**Optional preset variables**

> outputdefault 

**Required parameters**

> action 

**Optional parameters**

> pluginsubtask 

> params 

> infile 

> outfile 

**Depends on**

> infile 

> outfile 

## projectvar [^^][162]

**Description**

> get the variables from project.tasks file 

## projectxslt [^^][163]

**Description**

> make project.xslt from project.tasks 

**Required preset variables**

> projectpath 

**Depends on**

> getdatetime 

> xslt 

## quoteinquote [^^][164]

**Description**

> Resolves single quotes withing double quotes. Surrounding double quotes dissapea, singles be come doubles. 

**Class**

> command - internal - parameter manipulation 

**Required parameters**

> varname 

> paramstring 

## removeCommonAtStart [^^][165]

**Depreciated**

> probably not needed 

**Description**

> loops through two strings and sets new variable representing unique data 

**Class**

> command - internal 

**Required parameters**

> name - name of the variable to be returned 

> test - string to have common data removed from start 

**Optional parameters**

> remove - string if not defined then use %cd% as string. 

**Depends on**

> removelet 

## removelet [^^][166]

**Depreciated**

> probably not needed 

**Description**

> called by removeCommonAtStart to remove one letter from the start of two string variables 

**Class**

> command - internal 

**Required preset variables**

> test 

> remove 

> name 

## requiredparam [^^][167]

**Description**

> Ensure parameter is present 

**Required parameters**

> 

## resolve [^^][168]

**depreciated**

> use var 

> 

> 

**Description**

> sets the variable 

**class**

> command - parameter 

**Required parameters**

> varname 

> value 

> Added handling so that a third param called echo will echo the variable back. 

## runloop [^^][169]

**Description**

> run loop with parameters 

**Class**

> command - loop - depreciated 

**Depends on**

> \* - May be any loop type 

## serialtasks [^^][170]

**Depeciated**

> use looptasks 

## setdefaultoptions [^^][171]

**Description**

> Sets default options if not specifically set 

**class**

> command - parameter - fallback 

**Required parameters**

> testoption 

> defaultoption 

## setup [^^][172]

**Description**

> sets variables for the batch file 

**Revised**

> 2016-05-04 

> Required rerequisite variables 

> projectpath 

> htmlpath 

> localvar 

**Func calls**

> checkdir 

## setvar [^^][173]

> 

**Description**

> sets the variable 

**class**

> command - parameter 

**Required parameters**

> varname 

> value 

> Added handling so that a third param called echo will echo the variable back. 

## setvarlist [^^][174]

**depreciated**

> use var 

> 

**depreciated**

> use var 

> 

> 

**Description**

> sets the variable 

**class**

> command - parameter 

**Required parameters**

> varname 

> value 

> Added handling so that a third param called echo will echo the variable back. 

## spaceremove [^^][175]

## spinoffproject [^^][176]

**Description**

> spinofff a project from whole build system 

**Class**

> command - condition 

**Required parameters**

**Created**

> 2013-08-10 

> depreciated doing with tasks file 

**Depends on**

> xslt 

> joinfile 

## start [^^][177]

**Description**

> Start a file in the default program or supply the program and file 

**Required parameters**

> var1 

**Optional parameters**

> var2 

> var3 

> var4 

## startfile [^^][178]

**Depreciated**

> use inputfile 

## tasklist [^^][179]

**Discription**

> Processes a tasks file. 

**Required preset variables**

> projectlog 

> setuppath 

> commontaskspath 

**Required parameters**

> tasklistname 

**Func calls**

> funcdebugstart 

> funcdebugend 

> nameext 

> \* - tasks from tasks file 

## testjava [^^][180]

**Description**

> Test if java is installed. Attempt to use local java.exe otherwise it will exit with a warning. 

## time [^^][181]

**Description**

> Retrieve time in several shorter formats than %time% provides 

**Created**

> 2016-05-05 

## userinputvar [^^][182]

**Description**

> provides method to interactively input a variable 

**Class**

> command - interactive 

**Required parameters**

> varname 

> question 

**Depends on**

> funcdebug 

## validatevar [^^][183]

> validate variables passed in 

## var [^^][184]

**Description**

> sets the variable 

**class**

> command - parameter 

**Required parameters**

> varname 

> value 

> Added handling so that a third param called echo will echo the variable back. 

## variableslist [^^][185]

**Description**

> Handles variables list supplied in a file. 

**Class**

> command - loop 

**Optional preset variables**

> selvalue - used to set a value equals itself ie set ccw32=ccw32 from just ccw32\. Used for path tools 

> echovariableslist 

> echoeachvariablelistitem 

**Required parameters**

> list - a filename with name=value on each line of the file 

> checktype - for use with ifnotexist 

**Depends on**

> drivepath 

> nameext 

> ifnotexist 

## writeuifeedback [^^][186]

**Description**

> Produce a menu from a list to allow the user to change default list settings 

**Class**

> command - internal - menu 

**Usage**

> call :writeuifeedback list \[skiplines\] 

**Required parameters**

> list 

**Optional parameters**

> skiplines 

**Depends on**

> menuwriteoption 

## xarray [^^][187]

**Description**

> This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set. 

**Note**

> not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line. 

## xinclude [^^][188]

**Description**

> This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set. 

**Note**

> not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line. 

## xquery [^^][189]

**Description**

> Provides interface to xquery by saxon9.jar 

**Required preset variables**

> java 

> saxon9 

**Required parameters**

> scriptname 

**Optional parameters**

> allparam 

> infile 

> outfile 

**Func calls**

> inccount 

> infile 

> outfile 

> quoteinquote 

> before 

> after 

**created**

> 2013-08-20 

## xslt [^^][190]

**Description**

> Provides interface to xslt2 by saxon9.jar 

**Required preset variables**

> java 

> saxon9 

**Required parameters**

> scriptname 

**Optional parameters**

> allparam 

> infile 

> outfile 

**Func calls**

> inccount 

> infile 

> outfile 

> quoteinquote 

> before 

> after 

## xvarset [^^][191]

**Description**

> This is an XSLT instruction to process a paired set as param, DOS variables not allowed in set. 

**Note**

> not used by this batch command. The xvarset is a text file that is line separated and = separated. Only a pair can occur on any line. 



[0]: https://github.com/SILAsiaPub/vimod-pub
[1]: https://github.com/SILAsiaPub/vimod-pub-solo-bible-conc
[2]: https://github.com/SILAsiaPub/PLB-dict-Prince
[3]: https://github.com/SILAsiaPub/sfm-dict2web
[4]: https://github.com/SILAsiaPub/vimod-pub-solo-usfm-count-report
[5]: https://github.com/indiamcq/vimod-pub-demo-email
[6]: #aainfo
[7]: #after
[8]: #ampmhour
[9]: #appendtofile
[10]: #before
[11]: #cct
[12]: #checkdir
[13]: #checkifvimodfolder
[14]: #command
[15]: #command2file
[16]: #commonmenu
[17]: #copy
[18]: #date
[19]: #debugpause
[20]: #dirlist
[21]: #donothing
[22]: #drivepath
[23]: #echo
[24]: #echolog
[25]: #encoding
[26]: #ext
[27]: #externalfunctions
[28]: #file2uri
[29]: #funcdebug
[30]: #getfiledatetime
[31]: #getline
[32]: #html2xml
[33]: #ifdefined
[34]: #ifequal
[35]: #ifexist
[36]: #ifnotdefined
[37]: #ifnotequal
[38]: #ifnotexist
[39]: #inc
[40]: #inccount
[41]: #infile
[42]: #inputfile
[43]: #lookup
[44]: #loop
[45]: #loopcommand
[46]: #loopdir
[47]: #loopfiles
[48]: #loopfileset
[49]: #loopstring
[50]: #looptasks
[51]: #main                              
[52]: #manyparam
[53]: #manyparamcmd
[54]: #md5compare
[55]: #md5create
[56]: #menu
[57]: #menublank
[58]: #menueval
[59]: #menuvaluechooser
[60]: #menuvaluechooserevaluation
[61]: #menuvaluechooseroptions
[62]: #menuwriteoption
[63]: #name
[64]: #nameext
[65]: #outfile
[66]: #outputfile
[67]: #pause
[68]: #plugin
[69]: #projectvar
[70]: #projectxslt
[71]: #quoteinquote
[72]: #removeCommonAtStart
[73]: #removelet
[74]: #requiredparam
[75]: #resolve
[76]: #runloop
[77]: #serialtasks
[78]: #setdefaultoptions
[79]: #setup
[80]: #setvar
[81]: #setvarlist
[82]: #spaceremove
[83]: #spinoffproject
[84]: #start
[85]: #startfile
[86]: #tasklist
[87]: #testjava
[88]: #time
[89]: #userinputvar
[90]: #validatevar
[91]: #var
[92]: #variableslist
[93]: #writeuifeedback
[94]: #xarray
[95]: #xinclude
[96]: #xquery
[97]: #xslt
[98]: #xvarset
[99]: #back-aainfo
[100]: #back-after
[101]: #back-ampmhour
[102]: #back-appendtofile
[103]: #back-before
[104]: #back-cct
[105]: #back-checkdir
[106]: #back-checkifvimodfolder
[107]: #back-command
[108]: #back-command2file
[109]: #back-commonmenu
[110]: #back-copy
[111]: #back-date
[112]: #back-debugpause
[113]: #back-dirlist
[114]: #back-donothing
[115]: #back-drivepath
[116]: #back-echo
[117]: #back-echolog
[118]: #back-encoding
[119]: #back-ext
[120]: #back-externalfunctions
[121]: #back-file2uri
[122]: #back-funcdebug
[123]: #back-getfiledatetime
[124]: #back-getline
[125]: #back-html2xml
[126]: #back-ifdefined
[127]: #back-ifequal
[128]: #back-ifexist
[129]: #back-ifnotdefined
[130]: #back-ifnotequal
[131]: #back-ifnotexist
[132]: #back-inc
[133]: #back-inccount
[134]: #back-infile
[135]: #back-inputfile
[136]: #back-lookup
[137]: #back-loop
[138]: #back-loopcommand
[139]: #back-loopdir
[140]: #back-loopfiles
[141]: #back-loopfileset
[142]: #back-loopstring
[143]: #back-looptasks
[144]: #back-main                              
[145]: #back-manyparam
[146]: #back-manyparamcmd
[147]: #back-md5compare
[148]: #back-md5create
[149]: #back-menu
[150]: #back-menublank
[151]: #back-menueval
[152]: #back-menuvaluechooser
[153]: #back-menuvaluechooserevaluation
[154]: #back-menuvaluechooseroptions
[155]: #back-menuwriteoption
[156]: #back-name
[157]: #back-nameext
[158]: #back-outfile
[159]: #back-outputfile
[160]: #back-pause
[161]: #back-plugin
[162]: #back-projectvar
[163]: #back-projectxslt
[164]: #back-quoteinquote
[165]: #back-removeCommonAtStart
[166]: #back-removelet
[167]: #back-requiredparam
[168]: #back-resolve
[169]: #back-runloop
[170]: #back-serialtasks
[171]: #back-setdefaultoptions
[172]: #back-setup
[173]: #back-setvar
[174]: #back-setvarlist
[175]: #back-spaceremove
[176]: #back-spinoffproject
[177]: #back-start
[178]: #back-startfile
[179]: #back-tasklist
[180]: #back-testjava
[181]: #back-time
[182]: #back-userinputvar
[183]: #back-validatevar
[184]: #back-var
[185]: #back-variableslist
[186]: #back-writeuifeedback
[187]: #back-xarray
[188]: #back-xinclude
[189]: #back-xquery
[190]: #back-xslt
[191]: #back-xvarset