:: Go compiler for use with PSPad
:: Written by Ian McQuay
:: 2018-01-25
@echo off
set espeak=C:\Program Files (x86)\eSpeak\command_line\espeak.exe
go build %1
rem the next line causes the command window to stay open if there is an error

@if %errorlevel% gtr 0 (
  "%espeak%" "oh no"
  pause
) else (
  "%espeak%" "okay"
)
exit