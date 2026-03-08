# version-bump.ps1
# AI-Fluent Playbook - Version Bump and Capability Review Logger
#
# USAGE:
#   .\tools\version-bump.ps1 -NewVersion 1.1 -AIGeneration 'Claude Opus 5 Q3 2026' -Notes 'Appendix B refresh'
#   .\tools\version-bump.ps1 -CapabilityReviewOnly -AIGeneration 'Q3 2026 models' -Notes 'No version change'

param(
    [string]$NewVersion = '',
    [string]$AIGeneration = '',
    [string]$Notes = '',
    [string]$Reviewer = 'Tim Dickey',
    [switch]$CapabilityReviewOnly
)

$Date = (Get-Date -Format 'yyyy-MM-dd')
$Changelog = if (Test-Path '..\CHANGELOG.md') { '..\CHANGELOG.md' } else { 'CHANGELOG.md' }

if (-not (Test-Path $Changelog)) {
    Write-Host 'CHANGELOG.md not found. Run from repo root or tools/ directory.' -ForegroundColor Red
    exit 1
}

Write-Host 'AI-Fluent Playbook - Version Bump Utility' -ForegroundColor Cyan

if ($CapabilityReviewOnly) {
    $entry = "| $Date | $Reviewer | $AIGeneration | $Notes | Capability review - no version change |"
    (Get-Content $Changelog -Raw) -replace '(\| \(next\).*)', "$entry`n| (next) | (name) | (generation) | (sections) | (notes) |" |
        Out-File $Changelog -Encoding utf8
    Write-Host 'Capability review logged.' -ForegroundColor Green
} else {
    if (-not $NewVersion) { Write-Host 'NewVersion is required.' -ForegroundColor Red; exit 1 }
    $entry = "## [$NewVersion] - $Date`n`n### Changed`n- Capability review against: $AIGeneration`n- $Notes`n"
    (Get-Content $Changelog -Raw) -replace '## \[Unreleased\]', "## [Unreleased]`n`n$entry" |
        Out-File $Changelog -Encoding utf8
    Write-Host "Version $NewVersion added to CHANGELOG.md" -ForegroundColor Green
}

Write-Host 'Next: git add CHANGELOG.md, commit, tag, and push.' -ForegroundColor DarkGray