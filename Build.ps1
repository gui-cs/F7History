$ModuleName = "F7History"
$ModulePath = "./Output"
rm $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
$ModuleVersion = dotnet-gitversion /showvariable AssemblySemFileVer
Build-Module -SemVer $ModuleVersion 
$ModulePackage = "${ModulePath}" 
Publish-Module -Path $ModulePackage -Repository 'local'
