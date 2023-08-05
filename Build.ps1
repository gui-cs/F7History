
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

$OldModule = Get-Module $ModuleName -ErrorAction SilentlyContinue
if ($OldModule) {
    "Removing $ModuleName $($OldModule.Version)"
    Remove-Item $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Module $ModuleName -Force -ErrorAction SilentlyContinue
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
    Publish-Module -Path $ModulePath -Repository 'local'
    "  Installing  $ModuleName to local repository at $localRepositoryPath"
    Install-Module -Name $ModuleName -Repository 'local' -Force
    Import-Module $ModuleName 
    "$ModuleName $(Get-Module $ModuleName | Select-Object -ExpandProperty Version) installed and imported."
}

