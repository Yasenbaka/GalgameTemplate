param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = "out/Phase1Demo"
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

function Resolve-RenpySdkPath {
    if (-not [string]::IsNullOrWhiteSpace($env:RENPY_SDK_PATH)) {
        return $env:RENPY_SDK_PATH
    }

    $LocalSdkPathFile = Join-Path $RepoRoot "renpy-sdk-path.txt"
    if (Test-Path -LiteralPath $LocalSdkPathFile) {
        $ConfiguredPath = Get-Content -LiteralPath $LocalSdkPathFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -First 1
        if (-not [string]::IsNullOrWhiteSpace($ConfiguredPath)) {
            return $ConfiguredPath.Trim()
        }
    }

    $CandidateRoots = @(
        "D:\RenPy",
        "C:\RenPy",
        (Join-Path $env:USERPROFILE "Downloads")
    )

    foreach ($CandidateRoot in $CandidateRoots) {
        if (-not (Test-Path -LiteralPath $CandidateRoot)) {
            continue
        }

        $Candidate = Get-ChildItem -LiteralPath $CandidateRoot -Directory -Filter "renpy-*-sdk" -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending |
            Select-Object -First 1

        if ($null -ne $Candidate) {
            return $Candidate.FullName
        }
    }

    throw "Unable to locate a Ren'Py SDK automatically. Set RENPY_SDK_PATH, or create renpy-sdk-path.txt in the repo root based on renpy-sdk-path.example.txt."
}

$SdkPath = Resolve-RenpySdkPath
$PythonExe = Join-Path $SdkPath "lib/py3-windows-x86_64/python.exe"
$RenpyPy = Join-Path $SdkPath "renpy.py"

if (-not (Test-Path -LiteralPath $PythonExe)) {
    throw "Ren'Py SDK python executable not found: $PythonExe"
}

if (-not (Test-Path -LiteralPath $RenpyPy)) {
    throw "renpy.py not found in SDK path: $RenpyPy"
}

$DefaultProjectPath = Join-Path $RepoRoot "out/Phase1Demo"
$ResolvedProjectPath = Join-Path $RepoRoot $ProjectPath

if (-not (Test-Path -LiteralPath $ResolvedProjectPath)) {
    if ($ResolvedProjectPath -eq $DefaultProjectPath) {
        $GenerateScript = Join-Path $PSScriptRoot "generate.ps1"
        & $GenerateScript -ManifestPath "examples/minimal.project.toml" -OutputRoot "out"

        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    } else {
        throw "Project directory '$ResolvedProjectPath' does not exist. For non-default projects, generate it first before using run_with_sdk.ps1."
    }
}

& $PythonExe $RenpyPy $ResolvedProjectPath run
exit $LASTEXITCODE
