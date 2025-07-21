param(
    [Parameter(Mandatory=$true)]
    [string]$ApiKey
)

$ErrorActionPreference = 'Stop'

$csproj = Join-Path $PSScriptRoot '..' 'ActionCenterListener.csproj'

# Read current version
[xml]$projXml = Get-Content $csproj
$versionNode = $projXml.SelectSingleNode("//Version")
if (-not $versionNode) {
    Write-Error 'No <Version> tag found in csproj.'
    exit 1
}
$version = $versionNode.InnerText

# Bump patch version
$parts = $version -split '\.'
if ($parts.Length -lt 3) { $parts += @(0) * (3 - $parts.Length) }
$parts[2] = [int]$parts[2] + 1
$newVersion = "$($parts[0]).$($parts[1]).$($parts[2])"
$versionNode.InnerText = $newVersion
$projXml.Save($csproj)
Write-Host "Bumped version: $version -> $newVersion"

# Build nupkg
Push-Location (Join-Path $PSScriptRoot '..')
dotnet pack --configuration Release

# Find nupkg
$nupkg = Get-ChildItem -Path 'bin/Release' -Filter 'ActionCenterListener.*.nupkg' | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $nupkg) {
    Write-Error 'No nupkg found.'
    exit 1
}

# Push to NuGet
Write-Host "Pushing $($nupkg.FullName) to NuGet..."
dotnet nuget push $nupkg.FullName --api-key $ApiKey --source https://api.nuget.org/v3/index.json --skip-duplicate
Pop-Location

# Open the NuGet package management page for the previous version in the default browser
$packageUrl = "https://www.nuget.org/packages/ActionCenterListener/$version/Manage"
Write-Host "Opening NuGet package management page for version $version..."
Start-Process $packageUrl
