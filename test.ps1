# requires -Module PowerShellGet, @{ ModuleName = "Pester"; ModuleVersion = "5.5.0"; MaximumVersion = "5.0" }
using namespace Microsoft.PackageManagement.Provider.Utility
using namespace System.Management.Automation
param(
    [switch]$SkipScriptAnalyzer,
    [switch]$CodeCoverage,
    [switch]$HideSuccess,
    [switch]$IncludeVSCodeMarker
)


Push-Location $PSScriptRoot
$ModuleName = "F7History"

# Disable default parameters during testing, just in case
$PSDefaultParameterValues += @{}
$PSDefaultParameterValues["Disabled"] = $true

# Find a built module in the Output dir
$FoundModule = Get-ChildItem .\Output\"$($ModuleName)\$($ModuleName).psd1"
Write-Host "Testing $FoundModule..."

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

$MyOptions = @{
    Run = @{ # Run configuration.
        PassThru = $true # Return result object after finishing the test run.
    }
}

$config = New-PesterConfiguration -Hashtable $MyOptions
$config.Output.Verbosity = "Detailed"

if ($CodeCoverage) {
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.OutputPath = "./coverage.xml"
    # Get code coverage for the psm1 file to a coverage.xml that we can mess with later
    #Invoke-Pester -Confi
    #     IncludeVSCodeMarker = $IncludeVSCodeMarker
    # } -CodeCoverage $ModuleUnderTest.Path -CodeCoverageOutputFile ./coverage.xml -PassThru | Convert-CodeCoverage -SourceRoot ./Source
} 
Invoke-Pester -Configuration $config

Write-Host
if (-not $SkipScriptAnalyzer) {
    $path =  Split-Path $ModuleUnderTest.Path -Parent
    Write-Host "Invoke-ScriptAnalyzer for $path"
    Invoke-ScriptAnalyzer $path -Recurse -Settings PSGallery
}
Pop-Location

# Re-enable default parameters after testing
$PSDefaultParameterValues["Disabled"] = $false
