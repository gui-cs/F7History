#requires -Module PowerShellGet, @{ ModuleName = "Pester"; ModuleVersion = "4.10.1"; MaximumVersion = "4.999" }
using namespace Microsoft.PackageManagement.Provider.Utility
using namespace System.Management.Automation
param(
    [switch]$SkipScriptAnalyzer,
    [switch]$SkipCodeCoverage,
    [switch]$HideSuccess,
    [switch]$IncludeVSCodeMarker
)
Push-Location $PSScriptRoot
$ModuleName = "F7History"

# Disable default parameters during testing, just in case
$PSDefaultParameterValues += @{}
$PSDefaultParameterValues["Disabled"] = $true

# Find a built module in the Output dir
$FoundModule = Get-ChildItem .\Output\"$($ModuleName).psd1"

if (!$FoundModule) {
    throw "Can't find $($ModuleName).psd1 in output dir. Did you build the module?"
}

$Show = if ($HideSuccess) {
    "Fails"
} else {
    "All"
}

Remove-Module $ModuleName -ErrorAction Ignore -Force
$ModuleUnderTest = Import-Module $FoundModule.FullName -PassThru -Force -DisableNameChecking -Verbose:$false
Write-Host "Invoke-Pester for Module $($ModuleUnderTest) version $($ModuleUnderTest.Version)"

if (-not $SkipCodeCoverage) {
    # Get code coverage for the psm1 file to a coverage.xml that we can mess with later
    Invoke-Pester ./Tests -Show $Show -PesterOption @{
        IncludeVSCodeMarker = $IncludeVSCodeMarker
    } -CodeCoverage $ModuleUnderTest.Path -CodeCoverageOutputFile ./coverage.xml -PassThru |
        Convert-CodeCoverage -SourceRoot ./Source
} else {
    Invoke-Pester ./Tests -Show $Show -PesterOption @{ IncludeVSCodeMarker = $IncludeVSCodeMarker }
}

Write-Host
if (-not $SkipScriptAnalyzer) {
    Invoke-ScriptAnalyzer $ModuleUnderTest.Path
}
Pop-Location

# Re-enable default parameters after testing
$PSDefaultParameterValues["Disabled"] = $false
