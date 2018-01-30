:: Go compiler for use with PSPad
:: Written by Ian McQuay
:: 2018-01-25
@echo off
go build %1
rem the next line causes the command window to stay open if there is an error
@if %errorlevel% gtr 0 pause
