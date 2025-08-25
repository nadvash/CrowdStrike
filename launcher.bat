@echo off
setlocal

REM === Get the scan target path from argument ===
set "TargetScanPath=%~1"

REM === Define variables ===
set "TempDir=C:\Windows\Temp\Yara"
set "ArchivePath=C:\Windows\Temp\Yara_Bundle.zip"
set "RuleFileSource=C:\Windows\Temp\yara_rule.yar"
set "RuleFileDest=%TempDir%\yara_rule.yar"

REM === Create directory if it doesn't exist ===
if not exist "%TempDir%" (
    mkdir "%TempDir%"
)

REM === Move yara_rule.yar into the Yara folder (overwrite if exists) ===
if exist "%RuleFileSource%" (
    move /Y "%RuleFileSource%" "%RuleFileDest%"
)

REM === Extract archive ===
powershell -NoLogo -NoProfile -Command ^
    "Expand-Archive -Force -Path '%ArchivePath%' -DestinationPath '%TempDir%'"

REM === Run PowerShell script with target path ===
powershell -ExecutionPolicy Bypass -File "%TempDir%\Yara_Powershell.ps1" -targetPath "%TargetScanPath%"

REM === Delete the ZIP archive after execution ===
del /f /q "%ArchivePath%"

endlocal
