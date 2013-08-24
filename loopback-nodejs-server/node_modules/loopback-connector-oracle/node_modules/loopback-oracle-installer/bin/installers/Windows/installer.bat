@echo off
pushd %CD%
cd %~dp0
if exist ../../../../instantclient (
  cd ../../../../instantclient
) else (
  cd ../../../node_modules/instantclient
)
set ORAPATH=%CD%\vc11;%CD%
@echo Oracle Path: %ORAPATH%
set NEWPATH=%ORAPATH%

for /F "tokens=3" %%i in ('reg query "HKEY_CURRENT_USER\Environment" /v PATH') do (
  set NEWPATH=%ORAPATH%;%%i
)
@echo New Path: %NEWPATH%
reg add HKEY_CURRENT_USER\Environment /v PATH /d "%NEWPATH%" /f
popd
