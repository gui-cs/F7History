# Script for deploying module via github actions
# If -Version is not specified, it will use the output from gitversion MajorMinorPatch
# which is from the latest tag and add 1 to the patch number
# 
param(
    [parameter(Mandatory = $false)]
    [String] 
    $Version
)

$ModuleName = "F7History"
if ($null -eq $Version -or "" -eq $Version) {
    $Version = "v$(dotnet-gitversion /showvariable MajorMinorPatch)"
    "New version: $Version"
} else {
    # If no 'v` was prefixed, add it
    if ($Version -notmatch "^v") {
        $Version = "v$($Version)"
    }

    "Adding tag: $Version"
    git tag $Version
}

# Push the tag to upstream using atomic
git push --atomic upstream main $Version 
