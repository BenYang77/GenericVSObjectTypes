:: https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/
@Echo OFF&Cls
Call :getToday
Set CurProjPath=R:\Infomation\CodeCenter\GenericVSObjectTypes\
Set originPath=https://github.com/BenYang77/GenericVSObjectTypes.git

Call :getCurCmdFilePath %CurProjPath%
%filedrive%&ECHO ProjectLocation  %filedrive:~0,2%%filepath%&CD %filepath%

Set Branch=master
CHOICE /C 123 /N /M "Please select branch 1:master 2:bugfix 3:pull-request-demo 4:cancel"
Set ErrLev=%errorlevel%
IF %ErrLev%==1 (Set Branch=master&GOTO NextLevel)
IF %ErrLev%==2 (Set Branch=bugfix&GOTO NextLevel)
IF %ErrLev%==3 (Set Branch=pull-request-demo&GOTO NextLevel)
GOTO Info00

:NextLevel
Echo.
Echo Git status:
Git status
Echo =========================================================================
Echo.
CHOICE /M "Do you want to change Branch:%Branch% for (git checkout %Branch%)?"
if %errorlevel%==1 (git checkout %Branch%)

ECHO Update project(DemoUnitTestProject1.git) to %originPath%
@SET /P purpose=Please write purpose for it: 
IF "%purpose%"=="" GOTO Error1 
echo %purpose%
@SET /P Reason=Please write Reason for it: 
IF "%Reason%"=="" GOTO Error2
echo %Reason%

ECHO Now it is updating to project! Purpose is %Purpose%.
CHOICE /M "Are you sure updating the project for Branch:%Branch%?"
if %errorlevel%==2 (goto Info01)

echo # DemoUnitTestProject %today% %time% >> README.md
echo ##  Purpose : %purpose% >> README.md
echo ###  Reason : %Reason%  >> README.md
echo. >> README.md
echo. >> README.md
Call :CallGit2Update %purpose%

goto :eof

:CallGit2Update 
git init
:: Under Code Add File
:: git add README.md

:: Under Code Add Projects
git add .

:: git commit -m "first commit"
:: git commit -m "second commit"
git commit -m "%today% commit. purpose ： %*"

:: git remote add origin https://gitforbinrueiyang.visualstudio.com/DemoUnitTestProject/DemoUnitTestProject%20Team/_git/DemoUnitTestProject
git remote add origin %originPath%
git remote -v
git push -u -f origin %Branch%
:: git push -u origin bugfix
EXIT /B 0

:getToday
:: adapted from http://stackoverflow.com/a/10945887/1810071
@ECHO OFF
for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined MyDate Set MyDate=%%x
for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do Set %%x
@Set fmonth=00%Month%
@Set fday=00%Day%
@Set today=%Year%%fmonth:~-2%%fday:~-2%
:: @Echo ======================================================================================================================
:: @Echo ==== %today% %time% ============================================================================================
:: @Echo ======================================================================================================================
@Set yyyyMM=%Year%%fmonth:~-2%
EXIT /B 0

:getCurCmdFilePath
@ECHO OFF
:: SetLOCAL
:: Set file=C:\Users\l72rugschiri\Desktop\fs.cfg
:: Ref https://ss64.com/nt/for.html
Set filePathStr=%1
FOR %%i IN (%filePathStr%) DO (
    :: D:\BctchScriptCmds\getSubString.cmd
	:: filedrive=C:
	:: filepath=\Users\l72rugschiri\Desktop\
	:: filename=fs
	:: fileextension=.cfg
     Set filedrive=%%~di 
     Set filepath=%%~pi
     Set filename=%%~ni
     Set fileextension=%%~xi
	 Cls
)
EXIT /B 0

:Info00
ECHO You did not choice Branch! Bye bye!!
pause
goto End

:Info01
ECHO You have canceled updating for the project branch:%branch%! Bye bye!!
pause
goto End

:Error1
ECHO You did not enter any purpose for it! Bye bye!!
pause
goto End

:Error2
ECHO You did not enter any reason for it! Bye bye!!
pause
goto End

:End
goto :eof