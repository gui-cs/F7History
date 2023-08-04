$BUILDCOUNT = $BUILDCOUNT + 1
$ModuleName = "F7History"
$ModulePath = "./Output"
$ModuleVersion = dotnet-gitversion /showvariable AssemblySemFileVer
"Building $ModuleName version $ModuleVersion to $ModulePath"

rm $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
Build-Module -SemVer $ModuleVersion 
$ModulePackage = "${ModulePath}" 
Publish-Module -Path $ModulePackage -Repository 'local'
