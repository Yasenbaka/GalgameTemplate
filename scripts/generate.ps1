param(
    [Parameter(Mandatory = $false)]
    [string]$ManifestPath = "examples/minimal.project.toml",

    [Parameter(Mandatory = $false)]
    [string]$OutputRoot = "out",

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$SourceRoot = Join-Path $RepoRoot "src"
$ResolvedManifestPath = Join-Path $RepoRoot $ManifestPath
$ResolvedOutputRoot = Join-Path $RepoRoot $OutputRoot

if (-not (Test-Path -LiteralPath $ResolvedManifestPath)) {
    throw "Manifest file not found: $ResolvedManifestPath"
}

$env:PYTHONPATH = if ([string]::IsNullOrWhiteSpace($env:PYTHONPATH)) {
    $SourceRoot
} else {
    "$SourceRoot;$($env:PYTHONPATH)"
}

if ($Force) {
    python -m galgame_template.cli generate $ResolvedManifestPath --output-root $ResolvedOutputRoot --force
} else {
    python -m galgame_template.cli generate $ResolvedManifestPath --output-root $ResolvedOutputRoot
}

exit $LASTEXITCODE
