param(
    [switch]$SkipScriptAnalyzer,
    [parameter(Mandatory = $false)]
    [String] 
    $Version
)

$ModuleName = "F7History"
$ModulePath = "./Output/${ModuleName}"

# Assume this is the first build
$build = 0

if ($null -eq $Version -or "" -eq $Version) {
    $psd1Content = Get-Content $($ModulePath + "/$($ModuleName).psd1") -Raw -ErrorAction SilentlyContinue
    if ($psd1Content) {
        # Extract the ModuleVersion from the .psd1 content using regular expression
        if ($psd1Content -match "ModuleVersion\s+=\s+'(.*?)'") {
            $prevVersion = $Matches[1]
            $prevVersionParts = $prevVersion -split '\.'
            $build = [int]$prevVersionParts[3] + 1
            $Version = "{0}.{1}.{2}.{3}" -f $prevVersionParts[0], $prevVersionParts[1], $prevVersionParts[2], $build
            "Got version from $ModulePath/$ModuleName.psd1: $Version"
        }
        else {
            throw "Version not found in $ModulePath/$ModuleName.psd1."
        }
    }
    else {
        # No previous version found. Assuming this is the first build.
        $prevVersion = dotnet-gitversion /showvariable MajorMinorPatch
        $Version = "$($prevVersion).$($build)"
        "Got version from dotnet-gitversion: $Version"
    }
}

# Ensure we're using the correct version of ConsoleGuiTools
# If there's a local repository, use the latest version from there and set the RequiredVersion in the .psd1 file
# If there's NOT a local repo, use the latest version from the PowerShell Gallery and set the ModuleVersion in the .psd1 file
$PsdPath = "./Source/$($ModuleName).psd1"
$ocgvModule = "Microsoft.PowerShell.ConsoleGuiTools"
"Patching $PsdPath with correct $ocgvModule version"

# Find new version of ConsoleGuiTools in 'local' repository
$localRepository = Get-PSRepository | Where-Object { $_.Name -eq 'local' }
if ($localRepository) {
    $localRepositoryPath = $localRepository | Select-Object -ExpandProperty SourceLocation
    $v = Get-ChildItem "${localRepositoryPath}/${ocgvModule}*.nupkg" | Select-Object -ExpandProperty Name | Sort-Object -Descending | Select-Object -First 1
    if ($v -match "$ocgvModule.(.*?).nupkg") {
        $v = [Version]::new($Matches[1])
        "  $ocgvModule v$v found in local repository"
    } 
} 

if ($null -eq $ocgvVersion) {
    $module = (Find-Module $ocgvModule) | Select-Object -ExpandProperty Version | Sort-Object -Descending | Select-Object -First 1
    $v = [Version]::new($module)
    "  $ocgvModule v$v found in PSGallery"
} 

$ocgvVersion = "$($v.Major).$($v.Minor).$($v.Build).$($v.Revision)"
"  Installing $ocgvModule v$ocgvVersion to ensure it is loaded."
Install-Module $ocgvModule -MinimumVersion $ocgvVersion -Force -Verbose:($PSBoundParameters['Verbose'] -eq $true) -SkipPublisherCheck
"  Updating RequiredVersion for $ocgvModule v$ocgvVersion in $PsdPath"
Update-ModuleManifest -RequiredModules @(
    @{ModuleName = "PSReadline"; ModuleVersion = "2.1" }, 
    @{ModuleName = $ocgvModule; ModuleVersion = $ocgvVersion }
) -Path $PsdPath -ErrorAction Stop

if (-not $SkipScriptAnalyzer) {
    Write-Host "Invoke-ScriptAnalyzer with -Fixfor $PsdPath"
    Invoke-ScriptAnalyzer $PsdPath -Settings PSGallery -Fix -ErrorAction Stop
}

$OldModule = Get-Module $ModuleName -ErrorAction SilentlyContinue
if ($OldModule) {
    "Removing and uninstalling old version: $ModuleName $($OldModule.Version)"
    Remove-Item $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    Remove-Module Microsoft.PowerShell.ConsoleGuiTools
    Uninstall-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
}

$localRepository = Get-PSRepository | Where-Object { $_.Name -eq 'local' }
if ($localRepository) {    
    $localRepositoryPath = $localRepository | Select-Object -ExpandProperty SourceLocation
    "Un-publishing $ModuleName $($OldModule.Version) from local repository at $localRepositoryPath"
    Remove-Item "${localRepositoryPath}/${ModuleName}*.nupkg" -Recurse -Force -ErrorAction SilentlyContinue
}

"Building $ModuleName $Version to $ModulePath"
Build-Module -SemVer $Version -OutputDirectory ".${ModulePath}" -SourcePath ./Source -ErrorAction Stop

if ($localRepository) {    
    "Local repository found; importing for testing..."
    "  Removing $ModuleName"
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    "  Publishing $ModuleName to local repository at $localRepositoryPath"
    Publish-Module -Path $ModulePath -Repository 'local' -ErrorAction Stop
    "  Installing $ModuleName to local repository at $localRepositoryPath"
    Install-Module -Name $ModuleName -Repository 'local' -Force -Verbose:($PSBoundParameters['Verbose'] -eq $true)
    "  Importing $ModuleName"
    Import-Module $ModuleName -Force -Verbose:($PSBoundParameters['Verbose'] -eq $true)
    "$ModuleName $(Get-Module $ModuleName | Select-Object -ExpandProperty Version) installed and imported."
}

