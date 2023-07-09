# Script to load the module from the repository root folder instead of the installed module.
# See also https://github.com/d365collaborative/d365fo.tools/wiki/Load-individual-files-or-dot-source-the-files
Set-PSFConfig d365fo.integrations.Import.IndividualFiles -Value $true
Set-PSFConfig d365fo.integrations.Import.DoDotSource -Value $true

Import-Module -Name .\d365fo.integrations -Verbose -Force