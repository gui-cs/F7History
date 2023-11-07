# Script for deploying module via github actions
# If -Version is not specified, it will use the output from gitversion 
# and remove the build number and add 1 to the revision number
param(
    [parameter(Mandatory = $false)]
    [String] 
    $Version
)

$ModuleName = "F7History"
if ($null -eq $Version -or "" -eq $Version) {
    $prevVersion = dotnet-gitversion /showvariable MajorMinorPatch
    $build = dotnet-gitversion /showvariable BuildMetaData
    "Got build from dotnet-gitversion: $build"
    $Version = "$($prevVersion).$($build)"
    "Got version from dotnet-gitversion: $Version"
}

