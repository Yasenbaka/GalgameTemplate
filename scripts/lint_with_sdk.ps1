param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = "out/Phase1Demo"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($env:RENPY_SDK_PATH)) {
    throw "RENPY_SDK_PATH is not set. Point it at a local Ren'Py SDK root before running lint_with_sdk.ps1."
}

$SdkPath = $env:RENPY_SDK_PATH
$PythonExe = Join-Path $SdkPath "lib/py3-windows-x86_64/python.exe"
$RenpyPy = Join-Path $SdkPath "renpy.py"

if (-not (Test-Path -LiteralPath $PythonExe)) {
    throw "Ren'Py SDK python executable not found: $PythonExe"
}

if (-not (Test-Path -LiteralPath $RenpyPy)) {
    throw "renpy.py not found in SDK path: $RenpyPy"
}

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$ResolvedProjectPath = Join-Path $RepoRoot $ProjectPath

if (-not (Test-Path -LiteralPath $ResolvedProjectPath)) {
    throw "Project directory '$ResolvedProjectPath' does not exist. Generate a scaffold first with scripts/generate.ps1."
}

& $PythonExe $RenpyPy $ResolvedProjectPath lint
exit $LASTEXITCODE
