@echo off
SET THEFILE=c:\users\usuario\desktop\fod\practi~1\practi~3\progra~1\ej01.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  -s   -b base.$$$ -o c:\users\usuario\desktop\fod\practi~1\practi~3\progra~1\ej01.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
