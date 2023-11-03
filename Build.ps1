
$ModuleName = "F7History"
$ModulePath = "./Output/${ModuleName}"

# Assume this is the first build
$build = 0

$psd1Content = Get-Content $($ModulePath + "/$($ModuleName).psd1") -Raw -ErrorAction SilentlyContinue
if ($psd1Content) {
    # Extract the ModuleVersion from the .psd1 content using regular expression
    if ($psd1Content -match "ModuleVersion\s+=\s+'(.*?)'") {
        $prevVersion = $Matches[1]
        $prevVersionParts = $prevVersion -split '\.'
        $build = [int]$prevVersionParts[3] + 1
        $ModuleVersion = "{0}.{1}.{2}.{3}" -f $prevVersionParts[0], $prevVersionParts[1], $prevVersionParts[2], $build
    } else {
       throw "ModuleVersion not found in the old .psd1 file."
    }
} else {
    "No previous version found. Assuming this is the first build."
    # Get the ModuleVersion using dotnet-gitversion
    $prevVersion = dotnet-gitversion /showvariable MajorMinorPatch
    $ModuleVersion = "$($prevVersion).$($build)"
}

"New ModuleVersion: $ModuleVersion"

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
        $ocgvVersion = $Matches[1]
        "$ocgvModule v $ocgvVersion found in local repository; setting RequiredVersion in $PsdPath"
        Update-ModuleManifest -Path $PsdPath -RequiredModules @(
            @{
                ModuleName = "PSReadline"; ModuleVersion = "2.1"
            },
            @{
                ModuleName = $ocgvModule; RequiredVersion = $ocgvVersion
            }
        ) -ErrorAction Stop
     } 
} 

if ($null -eq $ocgvVersion) {
    $ocgvVersion = (Find-Module $ocgvModule).Version
    "$ocgvModule v $ocgvVersion` found in PSGallery; setting ModuleVersion in $PsdPath"
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

"Building $ModuleName $ModuleVersion to $ModulePath"
Build-Module -SemVer $ModuleVersion -OutputDirectory ".${ModulePath}" -SourcePath ./Source

if ($localRepository) {    
    "  Removing  $ModuleName"
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
    "  Publishing  $ModuleName to local repository at $localRepositoryPath"
    Publish-Module -Path $ModulePath -Repository 'local' -ErrorAction Stop
    "  Installing  $ModuleName to local repository at $localRepositoryPath"
    Install-Module -Name $ModuleName -Repository 'local' -Force -Verbose
    Import-Module $ModuleName 
    "$ModuleName $(Get-Module $ModuleName | Select-Object -ExpandProperty Version) installed and imported."
}

