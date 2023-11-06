param(
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
            "Extracted version number from $ModulePath/$ModuleName.psd1: $Version"
        }
        else {
            throw "Version not found in $ModulePath/$ModuleName.psd1."
        }
    }
    else {
        "No previous version found. Assuming this is the first build."
        "Getting the Verison using dotnet-gitversion..."
        $prevVersion = dotnet-gitversion /showvariable MajorMinorPatch
        $Version = "$($prevVersion).$($build)"
    }
}

"Building Version: $Version"

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
        $ocgvVersion = "$($v.Major).$($v.Minor).$($v.Build).$($v.Revision)"
        "$ocgvModule v $ocgvVersion found in local repository; Updating RequiredVersion in $PsdPath"
        Update-ModuleManifest -Path $PsdPath -RequiredModules @(
            @{
                ModuleName = "PSReadline"; ModuleVersion = "2.1"
            },
            @{
                ModuleName = $ocgvModule; ModuleVersion = $ocgvVersion
            }
        ) -ErrorAction Stop
        # Ensure OCGV is installed and imported from local repo
        Install-Module $ocgvModule -MinimumVersion $ocgvVersion -Force -Verbose -SkipPublisherCheck
    } 
} 

if ($null -eq $ocgvVersion) {
    $module = (Find-Module $ocgvModule) | Select-Object -ExpandProperty Version | Sort-Object -Descending | Select-Object -First 1
    $v = [Version]::new($module)
    $ocgvVersion = "$($v.Major).$($v.Minor).$($v.Build)"
    "$ocgvModule v $ocgvVersion` found in PSGallery; Updating -RequiredModules in $PsdPath"
     Update-ModuleManifest -Path $PsdPath -RequiredModules @(
        @{
            ModuleName = "PSReadline"; ModuleVersion = "2.1"
        },
        @{
            ModuleName = $ocgvModule; ModuleVersion = $ocgvVersion
        }
    )  -ErrorAction Stop
} 

$OldModule = Get-Module $ModuleName -ErrorAction SilentlyContinue
if ($OldModule) {
    "Removing $ModuleName $($OldModule.Version)"
    Remove-Item $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    Remove-Module Microsoft.PowerShell.ConsoleGuiTools
    Uninstall-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
}

$localRepository = Get-PSRepository | Where-Object { $_.Name -eq 'local' }
if ($localRepository) {    
    $localRepositoryPath = $localRepository | Select-Object -ExpandProperty SourceLocation
    "  Un-publishing $ModuleName $($OldModule.Version) from local repository at $localRepositoryPath"
    Remove-Item "${localRepositoryPath}/${ModuleName}*.nupkg" -Recurse -Force -ErrorAction SilentlyContinue
}

"Building $ModuleName $Version to $ModulePath"
Build-Module -SemVer $Version -OutputDirectory ".${ModulePath}" -SourcePath ./Source -ErrorAction Stop

if ($localRepository) {    
    "  Removing  $ModuleName"
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    "  Publishing  $ModuleName to local repository at $localRepositoryPath"
    Publish-Module -Path $ModulePath -Repository 'local' -ErrorAction Stop
    "  Installing  $ModuleName to local repository at $localRepositoryPath"
    Install-Module -Name $ModuleName -Repository 'local' -Force -Verbose
    Import-Module $ModuleName -Force -Verbose
    "$ModuleName $(Get-Module $ModuleName | Select-Object -ExpandProperty Version) installed and imported."
}

