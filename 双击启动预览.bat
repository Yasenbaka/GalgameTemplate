@echo off
setlocal

set "REPO_ROOT=%~dp0"
pushd "%REPO_ROOT%" >nul

powershell.exe -ExecutionPolicy Bypass -File "%REPO_ROOT%scripts\run_with_sdk.ps1"
set "EXITCODE=%ERRORLEVEL%"

if not "%EXITCODE%"=="0" (
    echo.
    echo Launch failed.
    echo Configure the Ren'Py SDK in one of these ways:
    echo 1. Set RENPY_SDK_PATH
    echo 2. Create renpy-sdk-path.txt in the repo root based on renpy-sdk-path.example.txt
    echo.
    pause
)

popd >nul
exit /b %EXITCODE%
